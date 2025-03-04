package com.niuma.admin.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.niuma.admin.constant.NiuMaCodeEnum;
import com.niuma.admin.constant.NiuMaConstants;
import com.niuma.admin.constant.NiuMaRedisKeys;
import com.niuma.admin.data.*;
import com.niuma.admin.dto.*;
import com.niuma.admin.entity.*;
import com.niuma.admin.mapper.*;
import com.niuma.admin.rabbit.RabbitSender;
import com.niuma.admin.service.IGameService;
import com.niuma.admin.utils.JsonUtils;
import com.niuma.common.constant.ResultCodeEnum;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.core.domain.model.LoginPlayer;
import com.niuma.common.core.redis.RedisCache;
import com.niuma.common.core.redis.RedisPrimitive;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;
import com.niuma.common.exception.http.*;
import com.niuma.common.utils.CommonUtils;
import com.niuma.common.utils.PlayerSecurityUtils;
import com.niuma.common.utils.StringUtils;
import com.niuma.common.utils.sign.Base64;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.async.DeferredResult;

import javax.annotation.Resource;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@Service
@Slf4j
public class GameServiceImpl implements IGameService {
    /**
     * 用于Java内部数据类型的缓存
     */
    @Autowired
    private RedisCache redisCache;

    /**
     * 用于支持跨平台的数据缓存
     */
    @Autowired
    private RedisPrimitive redisPrimitive;

    @Autowired
    private RabbitSender rabbitSender;

    @Value("${rabbitmq.game.exchange}")
    private String gameExchange;

    @Value("${rabbitmq.game.routingKey}")
    private String gameRoutingKey;

    @Autowired
    private JsonUtils jsonUtils;

    @Resource
    private VenueMapper venueMapper;

    @Autowired
    private CapitalMapper capitalMapper;

    @Resource
    private GameDumbMapper gameDumbMapper;

    @Resource
    private GameMahjongMapper mahjongMapper;

    @Resource
    private GameBiJiMapper biJiMapper;

    @Resource
    private GameLackeyMapper lackeyMapper;

    @Resource
    private GameNiu100Mapper niu100Mapper;

    @Resource
    private GameFaultMapper gameFaultMapper;

    @Resource
    private PlayerMapper playerMapper;

    @Resource
    private DistrictMapper districtMapper;

    // 异步命令映射表
    private Map<String, MqCommandDeferred> commandDeferredMap = new HashMap<>();

    // 异步命令按创建时间先后的排序序列
    private LinkedList<String> commandDeferredSequence = new LinkedList<>();

    // 线程锁
    private Lock lock = new ReentrantLock();

    @FunctionalInterface
    private interface BeforeEnterCallback {
        void invoke(String playerId, String venueId);
    }

    /**
     * 进入(创建)场地前检查
     * @param playerId 玩家id
     * @param venueId 目标场地id
     * @return 异步动作
     */
    private MqCommandDeferred checkBeforeEnter(String playerId, String venueId, BeforeEnterCallback callback) {
        if (StringUtils.isEmpty(playerId))
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), "Current login player is null, this is unexpected");
        String lockKey = NiuMaRedisKeys.PLAYER_ENTER_LOCK + playerId;
        Long ret = this.redisPrimitive.incr(lockKey, 1L);
        if (ret == null)
            throw new InternalServerException(ResultCodeEnum.REDIS_ACCESS_ERROR);
        if (!ret.equals(1L))
            throw new ForbiddenException(NiuMaCodeEnum.PLAYER_ENTER_CONFLICT);
        this.redisPrimitive.expire(lockKey, 5L, TimeUnit.SECONDS);
        boolean test = false;
        String enterKey = NiuMaRedisKeys.PLAYER_ENTER_DATA + playerId;
        PlayerEnter enterData = this.redisCache.getCacheObject(enterKey);
        if (enterData != null) {
            if ((venueId != null) && venueId.equals(enterData.getAuthorizedVenue()))
                test = true;
            if (!test) {
                Long nowTime = System.currentTimeMillis();
                Long delta = nowTime - enterData.getAuthorizedTime();
                if (delta < 1000L) {
                    // 太过频繁请求进入不同的场地
                    this.redisPrimitive.delete(lockKey);
                    throw new ForbiddenException(NiuMaCodeEnum.PLAYER_ENTER_FREQUENTLY);
                }
            }
        }
        if (!test) {
            String venueKey = NiuMaRedisKeys.PLAYER_CURRENT_VENUE + playerId;
            String currentVenue = this.redisPrimitive.get(venueKey);
            if (currentVenue != null) {
                if ((venueId == null) || !(venueId.equals(currentVenue))) {
                    // 异步离开玩家当前所在场地
                    MqCommandDeferred actionDeferred = this.leaveCurrentVenue(playerId, currentVenue);
                    if (actionDeferred != null) {
                        return actionDeferred;
                    }
                }
            }
        }
        try {
            // 可以直接创建或者进入指定场地
            if (callback != null)
                callback.invoke(playerId, venueId);
        } catch (Exception ex) {
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), ex.getMessage());
        } finally {
            this.redisPrimitive.delete(lockKey);
        }
        return null;
    }

    /**
     * 离开玩家当前所在场地
     * @param playerId 玩家id
     * @param currentVenue 当前所在场地id
     * @return 异步动作
     */
    private MqCommandDeferred leaveCurrentVenue(String playerId, String currentVenue) {
        // 查询当前场地所在的服务器ID
        String redisKey = NiuMaRedisKeys.VENUE_SERVER_MAP + currentVenue;
        String routingKey = this.redisPrimitive.get(redisKey);
        if (StringUtils.isEmpty(routingKey))
            return null;
        // 查询服务器是否在线
        redisKey = NiuMaRedisKeys.SERVER_KEEP_ALIVE + routingKey;
        boolean test = false;
        Long timestamp = this.redisPrimitive.getLong(redisKey);
        if (timestamp != null) {
            Long nowTime = System.currentTimeMillis();
            nowTime /= 1000L;
            Long delta = nowTime - timestamp;
            if (delta > 30L)
                test = true;   // 最近30秒都没有更新，说明服务器可能离线了
        } else
            test = true;
        if (test) {
            // 记录游戏故障，以便后续在后台手动解决故障
            Integer count = this.gameFaultMapper.hasGameFault(currentVenue, routingKey);
            if (!CommonUtils.predicate(count)) {
                GameFault gameFault = new GameFault();
                gameFault.setVenueId(currentVenue);
                gameFault.setServerId(routingKey);
                gameFault.setProcessed(0);
                gameFault.setTime(LocalDateTime.now());
                this.gameFaultMapper.insert(gameFault);
            }
            log.error("Player(id: {}) try leave current venue(id: {}) which on server(id: {}), but the server if offline.", playerId, currentVenue, routingKey);
            throw new InternalServerException(NiuMaCodeEnum.SERVER_INACCESSIBLE);
        }
        MqCommandDeferred actionDeferred = createCommandDeferred(playerId);
        // 发送MQ消息通知玩家离开当前场地
        MqLeaveVenue cmd = new MqLeaveVenue();
        cmd.setPlayerId(playerId);
        cmd.setVenueId(currentVenue);
        cmd.setCommandId(actionDeferred.getCommandId());
        cmd.setRoutingKey(this.gameRoutingKey);
        String json = this.jsonUtils.convertToStr(cmd);
        String base64 = Base64.encode(json.getBytes());
        MqMessage msg = new MqMessage();
        msg.setMsgType("MsgLeaveVenue");
        msg.setMsgPack(base64);
        this.rabbitSender.sendObject(this.gameExchange, routingKey, msg);
        return actionDeferred;
    }

    private boolean hasCommand(String commandId) {
        boolean ret = false;
        try {
            this.lock.lock();
            ret = this.commandDeferredMap.containsKey(commandId);
        } finally {
            this.lock.unlock();
        }
        return ret;
    }

    private static class CommandTester implements CommonUtils.DuplicateTester {
        private GameServiceImpl service;

        public CommandTester(GameServiceImpl service) {
            this.service = service;
        }

        @Override
        public boolean testDuplicate(String code) {
            return this.service.hasCommand(code);
        }
    }

    private MqCommandDeferred createCommandDeferred(String playerId) {
        String commandId = CommonUtils.generateRandomCode(10, CommonUtils.CODE_ALL, new CommandTester(this));
        if (StringUtils.isEmpty(commandId))
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), "Generate command id failed");
        MqCommandDeferred cmd = new MqCommandDeferred(playerId, commandId);
        try {
            this.lock.lock();
            this.commandDeferredMap.put(commandId, cmd);
            this.commandDeferredSequence.add(commandId);
        } finally {
            this.lock.unlock();
        }
        return cmd;
    }

    private static class VenueTester implements CommonUtils.DuplicateTester {
        private VenueMapper mapper;

        public VenueTester(VenueMapper mapper) {
            this.mapper = mapper;
        }

        @Override
        public boolean testDuplicate(String code) {
            LambdaQueryWrapper<Venue> query = Wrappers.lambdaQuery();
            query.eq(Venue::getId, code);
            Integer count = this.mapper.selectCount(query);
            return CommonUtils.predicate(count);
        }
    }

    private static class MahjongNumberTester implements CommonUtils.DuplicateTester {
        private GameMahjongMapper mapper;

        public MahjongNumberTester(GameMahjongMapper mapper) {
            this.mapper = mapper;
        }

        @Override
        public boolean testDuplicate(String code) {
            Integer count = this.mapper.hasNumber(code);
            return CommonUtils.predicate(count);
        }
    }

    private static class BiJiNumberTester implements CommonUtils.DuplicateTester {
        private GameBiJiMapper mapper;

        public BiJiNumberTester(GameBiJiMapper mapper) {
            this.mapper = mapper;
        }

        @Override
        public boolean testDuplicate(String code) {
            Integer count = this.mapper.hasNumber(code);
            return CommonUtils.predicate(count);
        }
    }

    private static class LackeyNumberTester implements CommonUtils.DuplicateTester {
        private GameLackeyMapper mapper;

        public LackeyNumberTester(GameLackeyMapper mapper) {
            this.mapper = mapper;
        }

        @Override
        public boolean testDuplicate(String code) {
            Integer count = this.mapper.hasNumber(code);
            return CommonUtils.predicate(count);
        }
    }

    private static class Niu100NumberTester implements CommonUtils.DuplicateTester {
        private GameNiu100Mapper mapper;

        public Niu100NumberTester(GameNiu100Mapper mapper) {
            this.mapper = mapper;
        }

        @Override
        public boolean testDuplicate(String code) {
            Integer count = this.mapper.hasNumber(code);
            return CommonUtils.predicate(count);
        }
    }

    /**
     * 生成场地id
     * @return 场地id
     */
    private String generateVenueId() {
        String venueId = CommonUtils.generateRandomCode(10, CommonUtils.CODE_ALL, new VenueTester(this.venueMapper));
        if (StringUtils.isEmpty(venueId))
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), "Generate venue id failed");
        return venueId;
    }

    /**
     * 生成6位数编号
     * @param tester 重复测试器
     * @return 6位数编号
     */
    private String generateNumber(CommonUtils.DuplicateTester tester) {
        String number = CommonUtils.generateRandomCode(6, CommonUtils.CODE_NUMBER, tester);
        if (StringUtils.isEmpty(number))
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), "Generate number failed");
        return number;
    }

    public String createGame(Integer gameType, String playerId, String base64) {
        String json = null;
        if (StringUtils.isNotEmpty(base64)) {
            java.util.Base64.Decoder decoder = java.util.Base64.getDecoder();
            byte[] buf = decoder.decode(base64);
            if (buf != null)
                json = new String(buf);
        }
        GameMahjong mahjong = null;
        GameBiJi biJi = null;
        GameLackey lackey = null;
        GameNiu100 niu100 = null;
        if (gameType.equals(NiuMaConstants.GAME_TYPE_MAHJONG))
            mahjong = checkCreateMahjong(playerId, json);
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_BI_JI))
            biJi = checkCreateBiJi(playerId, json);
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_LACKEY))
            lackey = checkCreateLackey(playerId, json);
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_NIU_NIU_100))
            niu100 = checkCreateNiu100(playerId, json);
        String venueId = null;
        try {
            venueId = generateVenueId();
            Venue entity = new Venue();
            entity.setId(venueId);
            entity.setOwnerId(playerId);
            entity.setGameType(gameType);
            entity.setStatus(0);
            entity.setCreateTime(LocalDateTime.now());
            this.venueMapper.insert(entity);
            if (gameType.equals(NiuMaConstants.GAME_TYPE_DUMB))
                createDumbGame(venueId);
            else if (gameType.equals(NiuMaConstants.GAME_TYPE_MAHJONG))
                CreateMahjong(mahjong, venueId);
            else if (gameType.equals(NiuMaConstants.GAME_TYPE_BI_JI))
                CreateBiJi(biJi, venueId);
            else if (gameType.equals(NiuMaConstants.GAME_TYPE_LACKEY))
                CreateLackey(lackey, venueId);
            else if (gameType.equals(NiuMaConstants.GAME_TYPE_NIU_NIU_100))
                CreateNiu100(niu100, venueId);
        } catch (Exception ex) {
            if (StringUtils.isNotEmpty(venueId)) {
                LambdaQueryWrapper<Venue> query = Wrappers.lambdaQuery();
                query.eq(Venue::getId, venueId);
                this.venueMapper.delete(query);
            }
            if (ex instanceof HttpException)
                throw ex;
            else
                throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), ex.getMessage());
        }
        return venueId;
    }

    private void createDumbGame(String venueId) {
        GameDumb game = new GameDumb();
        game.setVenueId(venueId);
        game.setName("DumbGame");
        game.setMaxPlayers(3);
        this.gameDumbMapper.insert(game);
    }

    private GameMahjong checkCreateMahjong(String playerId, String json) {
        JSONObject jsonObject = JSONObject.parseObject(json);
        if (jsonObject == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameters missing");
        Integer mode = jsonObject.getInteger("mode");
        Integer diZhu = jsonObject.getInteger("diZhu");
        Integer rule = jsonObject.getInteger("rule");
        if (mode == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"mode\" missing");
        if (diZhu == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"diZhu\" missing");
        if (rule == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"rule\" missing");
        if (mode < 0 || mode > 1)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Value of parameter \"mode\" error");
        if (diZhu < 0 || diZhu > 4)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Value of parameter \"diZhu\" error");
        if (mode.equals(1) && diZhu.equals(4))
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "When mode is 1, diZhu can't be 4");
        Integer[] diZhuList0 = new Integer[] { 500, 600, 800, 1000, 0 };
        Integer[] diZhuList1 = new Integer[] { 2000, 2500, 3000, 4000, 5000 };
        if (mode.equals(0))
            diZhu = diZhuList0[diZhu];
        else
            diZhu = diZhuList1[diZhu];
        // 押金为底注的50倍，检查玩家是否有足够金币
        Integer cashPledge = diZhu * 50;
        Long gold = this.capitalMapper.getGold(playerId);
        if (gold == null)
            gold = 0L;
        if (gold < cashPledge)
            throw new ForbiddenException(NiuMaCodeEnum.GOLD_INSUFFICIENT_ERROR.getCode(), "金币不足，最低需要50倍底注数量金币");
        if (mode.equals(0)) {
            // 扣钻模式
            Long diamond = this.capitalMapper.getDiamond(playerId);
            if ((diamond == null) || (diamond < 4L))
                throw new ForbiddenException(NiuMaCodeEnum.DIAMOND_INSUFFICIENT_ERROR.getCode(), "钻石不足，最低需要4枚钻石");
        }
        String number = this.generateNumber(new MahjongNumberTester(this.mahjongMapper));
        GameMahjong entity = new GameMahjong();
        entity.setNumber(number);
        entity.setMode(mode);
        entity.setDiZhu(diZhu);
        entity.setRule(rule);
        return entity;
    }

    private void CreateMahjong(GameMahjong entity, String venueId) {
        entity.setVenueId(venueId);
        this.mahjongMapper.insert(entity);
    }

    private GameBiJi checkCreateBiJi(String playerId, String json) {
        JSONObject jsonObject = JSONObject.parseObject(json);
        if (jsonObject == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameters missing");
        Integer mode = jsonObject.getInteger("mode");
        Integer diZhu = jsonObject.getInteger("diZhu");
        Integer isPublic = jsonObject.getInteger("isPublic");
        if (mode == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"mode\" missing");
        if (diZhu == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"diZhu\" missing");
        if (isPublic == null)
            isPublic = 0;
        if (mode < 0 || mode > 1)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Value of parameter \"mode\" error");
        if (diZhu < 0 || diZhu > 7)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Value of parameter \"diZhu\" error");
        Integer[][] diZhuList = { { 100, 200, 300, 400, 500, 600, 800, 0 }, { 1000, 1200, 1500, 2000, 2500, 3000, 3500, 4000 } };
        diZhu = diZhuList[mode][diZhu];
        // 押金为底注的10倍，检查玩家是否有足够金币
        Integer cashPledge = diZhu * 10;
        Long gold = this.capitalMapper.getGold(playerId);
        if (gold == null)
            gold = 0L;
        if (gold < cashPledge)
            throw new ForbiddenException(NiuMaCodeEnum.GOLD_INSUFFICIENT_ERROR.getCode(), "金币不足，最低需底注10倍数量金币");
        if (mode.equals(0)) {
            // 扣钻模式
            Long diamond = this.capitalMapper.getDiamond(playerId);
            if ((diamond == null) || (diamond < 1L))
                throw new ForbiddenException(NiuMaCodeEnum.DIAMOND_INSUFFICIENT_ERROR.getCode(), "钻石不足，最低需要1枚钻石");
        }
        String number = this.generateNumber(new BiJiNumberTester(this.biJiMapper));
        GameBiJi entity = new GameBiJi();
        entity.setNumber(number);
        entity.setMode(mode);
        entity.setDiZhu(diZhu);
        entity.setIsPublic(isPublic);
        return entity;
    }

    private void CreateBiJi(GameBiJi entity, String venueId) {
        entity.setVenueId(venueId);
        this.biJiMapper.insert(entity);
    }

    private enum LackeyRoomLevel {
        Invalid,	// 无效
        Friend,		// 好友房
        Beginner,	// 新手房
        Moderate,	// 初级房
        Advanced,	// 高级房
        Master		// 大师房
    };

    private GameLackey checkCreateLackey(String playerId, String json) {
        JSONObject jsonObject = JSONObject.parseObject(json);
        if (jsonObject == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameters missing");
        Integer mode = jsonObject.getInteger("mode");
        Integer diZhu = jsonObject.getInteger("diZhu");
        if (mode == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"mode\" missing");
        if (diZhu == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"diZhu\" missing");
        if (mode < 0 || mode > 1)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Value of parameter \"mode\" error");
        if (diZhu < 0 || diZhu > 8)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Value of parameter \"diZhu\" error");
        Integer[][] diZhuList = { { 100, 200, 300, 400, 500, 600, 700, 800, 0 }, { 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000 } };
        diZhu = diZhuList[mode][diZhu];
        // 押金为底注的15倍，检查玩家是否有足够金币
        Integer cashPledge = diZhu * 15;
        Long gold = this.capitalMapper.getGold(playerId);
        if (gold == null)
            gold = 0L;
        if (gold < cashPledge)
            throw new ForbiddenException(NiuMaCodeEnum.GOLD_INSUFFICIENT_ERROR.getCode(), "金币不足，需底注15倍底注数量金币");
        if (mode.equals(0)) {
            // 扣钻模式
            Long diamond = this.capitalMapper.getDiamond(playerId);
            if ((diamond == null) || (diamond < 2L))
                throw new ForbiddenException(NiuMaCodeEnum.DIAMOND_INSUFFICIENT_ERROR.getCode(), "钻石不足，最低需要2枚钻石");
        }
        String number = this.generateNumber(new LackeyNumberTester(this.lackeyMapper));
        GameLackey entity = new GameLackey();
        entity.setNumber(number);
        entity.setLevel(LackeyRoomLevel.Friend.ordinal());
        entity.setMode(mode);
        entity.setDiZhu(diZhu);
        return entity;
    }

    private void CreateLackey(GameLackey entity, String venueId) {
        entity.setVenueId(venueId);
        this.lackeyMapper.insert(entity);
    }

    private GameNiu100 checkCreateNiu100(String playerId, String json) {
        JSONObject jsonObject = JSONObject.parseObject(json);
        if (jsonObject == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameters missing");
        Long deposit = jsonObject.getLong("deposit");
        Integer isPublic = jsonObject.getInteger("isPublic");
        if (deposit == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"deposit\" missing");
        if (isPublic == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "Required parameter \"isPublic\" missing");
        if (deposit < 200000L)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "最低奖池押金数20万金币");
        CapitalAmount amount = this.capitalMapper.getCapital(playerId);
        Long gold = null;
        if (amount != null)
            gold = amount.getGold();
        if (gold == null)
            gold = 0L;
        if (gold < deposit)
            throw new ForbiddenException(NiuMaCodeEnum.GOLD_INSUFFICIENT_ERROR.getCode(), "金币不足");
        gold -= deposit;
        Integer count = this.capitalMapper.setCapital(playerId, gold, null, null, amount.getVersion());
        if ((count == null) || (count < 1))
            throw new InternalServerException(ResultCodeEnum.SERVICE_UNAVAILABLE);
        String number = this.generateNumber(new Niu100NumberTester(this.niu100Mapper));
        log.info("玩家(ID：{})创建百人牛牛游戏(房号：{})，奖池押金：{}", playerId, number, deposit);
        GameNiu100 entity = new GameNiu100();
        entity.setNumber(number);
        entity.setDeposit(deposit);
        entity.setIsPublic(isPublic);
        entity.setBankerId(playerId);
        return entity;
    }

    private void CreateNiu100(GameNiu100 entity, String venueId) {
        entity.setVenueId(venueId);
        this.niu100Mapper.insert(entity);
    }

    @Override
    public void createDumbGame(DeferredResult<ResponseEntity<AjaxResult>> result) {
        CreateGameDTO dto = new CreateGameDTO();
        dto.setGameType(NiuMaConstants.GAME_TYPE_DUMB);
        this.createGame(result, dto);
    }

    @Override
    public void createGame(DeferredResult<ResponseEntity<AjaxResult> > result, CreateGameDTO dto) {
        try {
            Integer gameType = dto.getGameType();
            if (!(gameType.equals(NiuMaConstants.GAME_TYPE_DUMB) ||
                    gameType.equals(NiuMaConstants.GAME_TYPE_MAHJONG) ||
                    gameType.equals(NiuMaConstants.GAME_TYPE_NIU_NIU_100) ||
                    gameType.equals(NiuMaConstants.GAME_TYPE_BI_JI) ||
                    gameType.equals(NiuMaConstants.GAME_TYPE_LACKEY)))
                throw new ForbiddenException(NiuMaCodeEnum.GAME_TYPE_ERROR.getCode(), "Unsupported game type");
            LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
            String playerId = null;
            if (player != null)
                playerId = player.getId();
            MqCommandDeferred actionDeferred = this.checkBeforeEnter(playerId, null, (playerIdIn, venueIdIn) -> {
                // 创建游戏
                String venueId = createGame(dto.getGameType(), playerIdIn, dto.getBase64());
                // 响应进入新创建的场地
                responseEnterVenue(result, playerIdIn, venueId);
            });
            if (actionDeferred != null) {
                // 等待服务器处理离开场地命令
                actionDeferred.setAction(NiuMaConstants.ACTION_CREATE_GAME);
                actionDeferred.setGameType(gameType);
                actionDeferred.setBase64(dto.getBase64());
                actionDeferred.setResult(result);
            }
        } catch (HttpException ex) {
            AjaxResult ajax = new AjaxResult();
            if (StringUtils.isNotEmpty(ex.getCode()))
                ajax.put(AjaxResult.CODE_TAG, ex.getCode());
            if (StringUtils.isNotEmpty(ex.getMessage()))
                ajax.put(AjaxResult.MSG_TAG, ex.getMessage());
            result.setResult(new ResponseEntity<>(ajax, ex.getStatus()));
        }
    }

    /**
     * 阻塞获取Redis锁
     * @param lockKey 锁键名
     */
    private void blockRedisLock(String lockKey) {
        Long lock = null;
        int count = 0;
        while (true) {
            lock = this.redisPrimitive.incr(lockKey, 1L);
            if (lock == null)
                throw new InternalServerException(ResultCodeEnum.REDIS_ACCESS_ERROR);
            if (lock.equals(1L))
                break;
            else {
                if (count > 9) {
                    String errMsg = "Get redis lock error: try count over limit";
                    log.error(errMsg);
                    throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), errMsg);
                }
                count++;
                try {
                    Thread.sleep(100L);
                } catch (Exception ex) {
                    log.error("Thread sleep error: {}", ex.getMessage());
                    throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), ex.getMessage());
                }
            }
        }
        this.redisPrimitive.expire(lockKey, 1L, TimeUnit.SECONDS);
    }

    private String assignVenue2Server(String venueId) {
        String lockKey = NiuMaRedisKeys.VENUE_ASSIGN_LOCK + venueId;
        blockRedisLock(lockKey);
        String mapKey = NiuMaRedisKeys.VENUE_SERVER_MAP + venueId;
        String serverId = this.redisPrimitive.get(mapKey);
        if (StringUtils.isNotEmpty(serverId)) {
            this.redisPrimitive.delete(lockKey);
            return serverId;
        }
        Set<String> serverIds = this.redisPrimitive.getSet(NiuMaRedisKeys.VENUE_SERVER_SET);
        if ((serverIds != null) && !serverIds.isEmpty()) {
            Integer minCount = -1;
            Integer playerCount = 0;
            Long nowTime = System.currentTimeMillis();
            Long timestamp = null;
            Long delta = 0L;
            nowTime /= 1000L;
            for (String tmp : serverIds) {
                String redisKey = NiuMaRedisKeys.SERVER_KEEP_ALIVE + tmp;
                timestamp = this.redisPrimitive.getLong(redisKey);
                if (timestamp == null)
                    continue;
                delta = nowTime - timestamp;
                if (delta > 30L)
                    continue;   // 最近30秒都没有更新，说明服务器可能离线了
                redisKey = NiuMaRedisKeys.SERVER_PLAYER_COUNT + tmp;
                playerCount = this.redisPrimitive.getInt(redisKey);
                if (playerCount == null)
                    playerCount = 0;
                if ((minCount < 0) || (minCount > playerCount)) {
                    serverId = tmp;
                    minCount = playerCount;
                }
            }
            if (StringUtils.isNotEmpty(serverId))
                this.redisPrimitive.set(mapKey, serverId);
        }
        this.redisPrimitive.delete(lockKey);
        return serverId;
    }

    /**
     * 从Redis中获取服务器地址
     * @param serverId 服务器id
     * @return 服务器地址
     */
    private String getServerAddress(String serverId) {
        String redisKey = NiuMaRedisKeys.SERVER_ACCESS_ADDRESS + serverId;
        String address = this.redisPrimitive.get(redisKey);
        if (StringUtils.isEmpty(address)) {
            String errMsg = String.format("Can not find the access address of server with id: %s", serverId);
            throw new InternalServerException(NiuMaCodeEnum.SERVER_INACCESSIBLE.getCode(), errMsg);
        }
        return address;
    }

    private void responseEnterVenue(DeferredResult<ResponseEntity<AjaxResult> > result, String playerId, String venueId) {
        // 分配游戏到服务器
        String serverId = assignVenue2Server(venueId);
        if (StringUtils.isEmpty(serverId))
            throw new InternalServerException(NiuMaCodeEnum.SERVER_LIST_EMPTY);
        // 设置当前授权进入的场地
        String redisKey = NiuMaRedisKeys.PLAYER_ENTER_DATA + playerId;
        PlayerEnter enterData = new PlayerEnter();
        enterData.setAuthorizedTime(System.currentTimeMillis());
        enterData.setAuthorizedVenue(venueId);
        this.redisCache.setCacheObject(redisKey, enterData);
        redisKey = NiuMaRedisKeys.PLAYER_AUTHORIZED_VENUE + playerId;
        this.redisPrimitive.set(redisKey, venueId);
        // 返回响应HTTP请求
        String address = getServerAddress(serverId);
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("address", address);
        ajax.put("venueId", venueId);
        result.setResult(ResponseEntity.ok(ajax));
    }

    @Override
    public void enter(DeferredResult<ResponseEntity<AjaxResult>> result, EnterDTO dto) {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        String playerId = null;
        if (player != null)
            playerId = player.getId();
        try {
            Venue entity = this.venueMapper.selectById(dto.getVenueId());
            if (entity == null)
                throw new NotFoundException(NiuMaCodeEnum.VENUE_NOT_EXIST);
            if (!dto.getGameType().equals(entity.getGameType()))
                throw new ForbiddenException(NiuMaCodeEnum.GAME_TYPE_ERROR);
            if (!entity.getStatus().equals(0))
                throw new ForbiddenException(NiuMaCodeEnum.GAME_STATUS_ERROR);
            MqCommandDeferred actionDeferred = this.checkBeforeEnter(playerId, dto.getVenueId(), (playerIdIn, venueIdIn) -> {
                // 响应进入指定场地
                responseEnterVenue(result, playerIdIn, venueIdIn);
            });
            if (actionDeferred != null) {
                // 等待服务器处理离开场地命令
                actionDeferred.setAction(NiuMaConstants.ACTION_ENTER_GAME);
                // 离开成功后进入指定场地
                actionDeferred.setVenueId(dto.getVenueId());
                actionDeferred.setGameType(dto.getGameType());
                actionDeferred.setResult(result);
            }
        } catch (HttpException ex) {
            AjaxResult ajax = new AjaxResult();
            if (StringUtils.isNotEmpty(ex.getCode()))
                ajax.put(AjaxResult.CODE_TAG, ex.getCode());
            if (StringUtils.isNotEmpty(ex.getMessage()))
                ajax.put(AjaxResult.MSG_TAG, ex.getMessage());
            result.setResult(new ResponseEntity<>(ajax, ex.getStatus()));
        }
    }

    @Override
    public void enterNumber(DeferredResult<ResponseEntity<AjaxResult>> result, EnterNumberDTO dto) {
        String venueId = null;
        Integer gameType = dto.getGameType();
        if (gameType.equals(NiuMaConstants.GAME_TYPE_MAHJONG))
            venueId = this.mahjongMapper.getIdByNumber(dto.getNumber());
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_BI_JI))
            venueId = this.biJiMapper.getIdByNumber(dto.getNumber());
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_LACKEY))
            venueId = this.lackeyMapper.getIdByNumber(dto.getNumber());
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_NIU_NIU_100))
            venueId = this.niu100Mapper.getIdByNumber(dto.getNumber());
        if (StringUtils.isEmpty(venueId)) {
            AjaxResult ajax = new AjaxResult();
            ajax.put(AjaxResult.CODE_TAG, NiuMaCodeEnum.VENUE_NOT_EXIST.getCode());
            ajax.put(AjaxResult.MSG_TAG, NiuMaCodeEnum.VENUE_NOT_EXIST.getDesc());
            result.setResult(new ResponseEntity<>(ajax, HttpStatus.NOT_FOUND));
            return;
        }
        EnterDTO tmp = new EnterDTO();
        tmp.setVenueId(venueId);
        tmp.setGameType(gameType);
        this.enter(result, tmp);
    }

    private int getDistrictPlayerLimit(Integer districtId) {
        int ret = 0;
        if (districtId.equals(NiuMaConstants.DISTRICT_LACKEY_BEGINNER) ||
            districtId.equals(NiuMaConstants.DISTRICT_LACKEY_MODERATE) ||
            districtId.equals(NiuMaConstants.DISTRICT_LACKEY_ADVANCED) ||
            districtId.equals(NiuMaConstants.DISTRICT_LACKEY_MASTER))
            ret = 6;
        return ret;
    }

    private void responseEnterDistrict(DeferredResult<ResponseEntity<AjaxResult> > result, String playerId, Integer districtId) {
        try {
            this.responseEnterDistrictImpl(result, playerId, districtId);
        } catch (Exception ex) {
            log.error("Response enter district error: {}", ex.getMessage());
            AjaxResult ajax = AjaxResult.error(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), ex.getMessage());
            result.setResult(new ResponseEntity<>(ajax, HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    private void responseEnterDistrictImpl(DeferredResult<ResponseEntity<AjaxResult> > result, String playerId, Integer districtId) {
        /**
         * 分配场地策略：
         * a、从Redis中获取指定区域(districtId)的未满场地列表NFL，并按玩家人数从多到少排列，划分NFL中玩家数量大于的前部分为NFL1，玩家数量为0的后部分为NFL2
         * b、从Redis中获取当前玩家5分钟内进入过的场地轨迹记录表TM(超过5分钟的轨迹点删除)
         * c、从头到尾遍历NFL1中的每个场地，以便获得一个授权场地AV：
         * c1、若场地在TM中则跳过
         * c2、否则从Redis中读取该场地的授权时间表ATL，并删除超过10秒钟的授权记录
         * c3、若当前玩家包含在该场地的ATL中，则可再次授权当前玩家进入该场地，该场地即为授权场地AV
         * c4、否则判断授权人数是否已满，若已满则检测下一个场地，跳到步骤c1，
         * c5、否则可授权当前玩家进入该场地，该场地即为授权场地AV
         * d、若能获得授权场地AV，退出函数并响应返回AV所在的服务器地址
         * e、否则清空TM（只要授权玩家数量为0的场地就清空轨迹记录），若NFL2为空，则新建一个场地并加入到NFL2
         * f、从NFL2中获取第一个场地作为授权场地AV
         * g、退出函数并响应返回AV所在的服务器地址
         */
        String notFullKey = NiuMaRedisKeys.DISTRICT_NOT_FULL_VENUES + districtId.toString();
        Map<String, String> notFullMap = this.redisPrimitive.getMap(notFullKey);
        List<String> notFullVenues = null;
        int emptyIndex = -1;
        if ((notFullMap != null) && !notFullMap.isEmpty()) {
            notFullVenues = new ArrayList<>(notFullMap.size());
            notFullVenues.addAll(notFullMap.keySet());
            Collections.sort(notFullVenues, new Comparator<String>() {
                @Override
                public int compare(String o1, String o2) {
                    try {
                        Integer count1 = Integer.parseInt(notFullMap.get(o1));
                        Integer count2 = Integer.parseInt(notFullMap.get(o2));
                        if (count1 < count2)
                            return 1;
                        else if (count1 > count2)
                            return -1;
                        else
                            return 0;
                    } catch (NumberFormatException ex) {
                        return 0;
                    }
                }
            });
            Integer count = 0;
            for (int i = 0; i < notFullVenues.size(); i++) {
                try {
                    String venueId = notFullVenues.get(i);
                    count = Integer.parseInt(notFullMap.get(venueId));
                } catch (NumberFormatException ex) {
                    continue;
                }
                if (count.equals(0)) {
                    emptyIndex = i;
                    break;
                }
            }
        }
        Long nowTime = System.currentTimeMillis();
        Long delta = 0L;
        Long tmpTime = 0L;
        List<String> removeKeys = new ArrayList<>();
        String trackKey = NiuMaRedisKeys.DISTRICT_PLAYER_TRACK;
        trackKey = trackKey.replace("{0}", districtId.toString());
        trackKey = trackKey.replace("{1}", playerId);
        Map<String, String> trackMap = this.redisPrimitive.getMap(trackKey);
        if (trackMap != null) {
            for (Map.Entry<String, String> entry : trackMap.entrySet()) {
                try {
                    tmpTime = Long.parseLong(entry.getValue());
                } catch (NumberFormatException ex) {
                    removeKeys.add(entry.getKey());
                    continue;
                }
                delta = nowTime - tmpTime;
                // 超过5分钟
                if (delta > 300000L)
                    removeKeys.add(entry.getKey());
            }
            for (String venueId : removeKeys) {
                this.redisPrimitive.hDelete(trackKey, venueId);
                trackMap.remove(venueId);
            }
        }
        String authorizedVenueId = null;
        if (notFullVenues != null) {
            int maxPlayerNum = this.getDistrictPlayerLimit(districtId);
            int loop = 0;
            boolean test = false;
            Integer count = 0;
            Long lock = 0L;
            String venueId = null;
            String authorizedKey = null;
            String lockKey = null;
            Map<String, String> authorizedMap = null;
            for (int i = 0; i < notFullVenues.size(); i++) {
                venueId = notFullVenues.get(i);
                if (((emptyIndex < 0) || (i < emptyIndex)) && (trackMap != null) && trackMap.containsKey(venueId))
                    continue;
                lockKey = NiuMaRedisKeys.DISTRICT_AUTHORIZED_LOCK;
                lockKey = lockKey.replace("{0}", districtId.toString());
                lockKey = lockKey.replace("{1}", venueId);
                loop = 0;
                test = false;
                do {
                    lock = this.redisPrimitive.incr(lockKey, 1L);
                    if (lock.equals(1L))
                        break;
                    try {
                        Thread.sleep(100L);
                    } catch (Exception ex) {
                        log.error("Thread sleep error: {}", ex.getMessage());
                    }
                    loop++;
                    if (loop > 99) {
                        test = true;
                        break;
                    }
                } while (true);
                if (test)
                    continue;
                this.redisPrimitive.expire(lockKey, 2L);
                authorizedKey = NiuMaRedisKeys.DISTRICT_AUTHORIZED_TIMES;
                authorizedKey = authorizedKey.replace("{0}", districtId.toString());
                authorizedKey = authorizedKey.replace("{1}", venueId);
                authorizedMap = this.redisPrimitive.getMap(authorizedKey);
                if (authorizedMap != null) {
                    removeKeys.clear();
                    for (Map.Entry<String, String> entry : authorizedMap.entrySet()) {
                        try {
                            tmpTime = Long.parseLong(entry.getValue());
                        } catch (NumberFormatException ex) {
                            removeKeys.add(entry.getKey());
                            continue;
                        }
                        delta = nowTime - tmpTime;
                        // 超过10秒钟
                        if (delta > 10000L)
                            removeKeys.add(entry.getKey());
                    }
                    for (String tmpKey : removeKeys) {
                        this.redisPrimitive.hDelete(authorizedKey, tmpKey);
                        authorizedMap.remove(tmpKey);
                    }
                }
                if ((authorizedMap == null) || authorizedMap.containsKey(playerId) || (authorizedMap.size() < maxPlayerNum)) {
                    // 无授权记录，可授权
                    // 已授权，可再次授权
                    // 授权人数未满可授权
                    authorizedVenueId = venueId;
                    this.redisPrimitive.hSet(authorizedKey, playerId, nowTime.toString());
                    this.redisPrimitive.delete(lockKey);
                    if ((emptyIndex > -1) && (i >= emptyIndex)) {
                        // 清空轨迹记录
                        this.redisPrimitive.delete(trackKey);
                    }
                    break;
                }
                this.redisPrimitive.delete(lockKey);
            }
        }
        if (StringUtils.isNotEmpty(authorizedVenueId)) {
            this.responseEnterVenue(result, playerId, authorizedVenueId);
            return;
        }
        // 清空轨迹记录
        this.redisPrimitive.delete(trackKey);
        // 创建新的区域内场地
        authorizedVenueId = this.createDistrictVenue(districtId);
        String registerKey = NiuMaRedisKeys.DISTRICT_VENUE_REGISTER + districtId.toString();
        this.redisPrimitive.hSet(registerKey, authorizedVenueId, nowTime.toString());
        this.redisPrimitive.hSet(notFullKey, authorizedVenueId, "0");
        String authorizedKey = NiuMaRedisKeys.DISTRICT_AUTHORIZED_TIMES;
        authorizedKey = authorizedKey.replace("{0}", districtId.toString());
        authorizedKey = authorizedKey.replace("{1}", authorizedVenueId);
        this.redisPrimitive.hSet(authorizedKey, playerId, nowTime.toString());
        this.responseEnterVenue(result, playerId, authorizedVenueId);
    }

    private String createDistrictVenue(Integer districtId) {
        String venueId = null;
        Venue venue = new Venue();
        venue.setOwnerId("0000000000");
        venue.setStatus(0);
        venue.setCreateTime(LocalDateTime.now());
        if (districtId.equals(NiuMaConstants.DISTRICT_LACKEY_BEGINNER) ||
            districtId.equals(NiuMaConstants.DISTRICT_LACKEY_MODERATE) ||
            districtId.equals(NiuMaConstants.DISTRICT_LACKEY_ADVANCED) ||
            districtId.equals(NiuMaConstants.DISTRICT_LACKEY_MASTER)) {
            venueId = generateVenueId();
            venue.setId(venueId);
            venue.setGameType(NiuMaConstants.GAME_TYPE_LACKEY);
            this.venueMapper.insert(venue);
            String number = "dist-" + districtId.toString();
            GameLackey entity = new GameLackey();
            entity.setNumber(number);
            entity.setVenueId(venueId);
            if (districtId.equals(NiuMaConstants.DISTRICT_LACKEY_BEGINNER)) {
                entity.setLevel(LackeyRoomLevel.Beginner.ordinal());
                entity.setMode(0);
                entity.setDiZhu(100);
            } else if (districtId.equals(NiuMaConstants.DISTRICT_LACKEY_MODERATE)) {
                entity.setLevel(LackeyRoomLevel.Moderate.ordinal());
                entity.setMode(0);
                entity.setDiZhu(200);
            } else if (districtId.equals(NiuMaConstants.DISTRICT_LACKEY_ADVANCED)) {
                entity.setLevel(LackeyRoomLevel.Advanced.ordinal());
                entity.setMode(1);
                entity.setDiZhu(500);
            } else if (districtId.equals(NiuMaConstants.DISTRICT_LACKEY_MASTER)) {
                entity.setLevel(LackeyRoomLevel.Master.ordinal());
                entity.setMode(1);
                entity.setDiZhu(1000);
            }
            this.lackeyMapper.insert(entity);
        }
        return venueId;
    }

    @Override
    public void enterDistrict(DeferredResult<ResponseEntity<AjaxResult>> result, Integer districtId) {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        District entity = this.districtMapper.selectById(districtId);
        if (entity == null) {
            AjaxResult ajax = new AjaxResult();
            ajax.put(AjaxResult.CODE_TAG, NiuMaCodeEnum.DISTRICT_NOT_EXIST.getCode());
            ajax.put(AjaxResult.MSG_TAG, "指定区域不存在");
            result.setResult(new ResponseEntity<>(ajax, HttpStatus.NOT_FOUND));
            return;
        }
        if (entity.getGoldNeed() > 0L) {
            Long gold = this.capitalMapper.getGold(player.getId());
            if ((gold == null) || (gold < entity.getGoldNeed())) {
                StringBuilder sb = new StringBuilder();
                sb.append("金币不足，最低需要");
                sb.append(entity.getGoldNeed());
                sb.append("金币");
                throw new ForbiddenException(NiuMaCodeEnum.GOLD_INSUFFICIENT_ERROR.getCode(), sb.toString());
            }
        }
        if (entity.getDiamondNeed() > 0L) {
            // 扣钻模式
            Long diamond = this.capitalMapper.getDiamond(player.getId());
            if ((diamond == null) || (diamond < entity.getDiamondNeed())) {
                StringBuilder sb = new StringBuilder();
                sb.append("钻石不足，最低需要");
                sb.append(entity.getDiamondNeed());
                sb.append("枚钻石");
                throw new ForbiddenException(NiuMaCodeEnum.DIAMOND_INSUFFICIENT_ERROR.getCode(), sb.toString());
            }
        }
        String venueId = districtId.toString();
        MqCommandDeferred actionDeferred = this.checkBeforeEnter(player.getId(), venueId, (playerIdIn, venueIdIn) -> {
            // 响应进入指定区域
            responseEnterDistrict(result, playerIdIn, districtId);
        });
        if (actionDeferred != null) {
            // 等待服务器处理离开场地命令
            actionDeferred.setAction(NiuMaConstants.ACTION_ENTER_DISTRICT);
            // 离开成功后进入指定区域
            actionDeferred.setVenueId(venueId);
            actionDeferred.setResult(result);
        }
    }

    @Override
    public AjaxResult getDistrictPlayerCount(Integer districtId) {
        LambdaQueryWrapper<District> query = Wrappers.lambdaQuery();
        query.eq(District::getId, districtId);
        Integer count = this.districtMapper.selectCount(query);
        if (count == null || count < 1)
            throw new NotFoundException(NiuMaCodeEnum.DISTRICT_NOT_EXIST.getCode(), "指定区域不存在");
        String countKey = NiuMaRedisKeys.DISTRICT_PLAYER_COUNT + districtId.toString();
        Map<String, String> countMap = this.redisPrimitive.getMap(countKey);
        boolean test = false;
        Long nowTime = System.currentTimeMillis();
        Long tmpTime = 0L;
        Long delta = 0L;
        Integer playerCount = 0;
        if (countMap != null) {
            String time = this.redisPrimitive.hGet(countKey, "time");
            if (StringUtils.isNotEmpty(time)) {
                try {
                    tmpTime = Long.parseLong(time);
                    delta = nowTime - tmpTime;
                    if (delta < 5000L)  // 每5秒全局统计更新一次
                        test = true;
                } catch (NumberFormatException ex) {}
            }
            if (test) {
                String text = this.redisPrimitive.hGet(countKey, "playerCount");
                if (StringUtils.isNotEmpty(time)) {
                    try {
                        playerCount = Integer.parseInt(text);
                        AjaxResult ajax = AjaxResult.successEx();
                        ajax.put("playerCount", playerCount);
                        return ajax;
                    } catch (NumberFormatException ex) {}
                }
            }
        }
        String registerKey = NiuMaRedisKeys.DISTRICT_VENUE_REGISTER + districtId.toString();
        Map<String, String> registerMap = this.redisPrimitive.getMap(registerKey);
        if (registerMap != null) {
            for (Map.Entry<String, String> entry : registerMap.entrySet()) {
                test = false;
                try {
                    tmpTime = Long.parseLong(entry.getValue());
                    delta = nowTime - tmpTime;
                    if (delta > 30000L)
                        test = true;    // 超30秒不刷新
                } catch (Exception ex) {
                    test = true;
                }
                if (test)
                    this.redisPrimitive.hDelete(registerKey, entry.getKey());
                else {
                    String tmpKey = NiuMaRedisKeys.VENUE_PLAYER_COUNT + entry.getKey();
                    String text = this.redisPrimitive.get(tmpKey);
                    try {
                        count = Integer.parseInt(text);
                        playerCount += count;
                    } catch (NumberFormatException ex) { }
                }
            }
        }
        this.redisPrimitive.hSet(countKey, "playerCount", playerCount.toString());
        this.redisPrimitive.hSet(countKey, "time", nowTime.toString());
                AjaxResult ajax = AjaxResult.successEx();
        ajax.put("playerCount", playerCount);
        return ajax;
    }

    @Override
    public void consume(MqMessage msg) {
        String json = null;
        try {
            json = new String(Base64.decode(msg.getMsgPack()), StandardCharsets.UTF_8.name());
        } catch (UnsupportedEncodingException ex) {
            log.error("Parse message error: {}", ex.getMessage());
            return;
        }
        if (msg.getMsgType().equals("CommandResult")) {
            MqCommandResult result = this.jsonUtils.convertToObj(json, MqCommandResult.class);
            handleCommandResult(result);
        }
    }

    private void handleCommandResult(MqCommandResult result) {
        MqCommandDeferred cmd = getCommandDeferred(result.getCommandId());
        if (cmd == null)
            return;
        // 异步命令完成，释放进入场地锁
        String lockKey = NiuMaRedisKeys.PLAYER_ENTER_LOCK + cmd.getPlayerId();
        this.redisPrimitive.delete(lockKey);
        DeferredResult<ResponseEntity<AjaxResult> > deferredResult = cmd.getResult();
        if ((result.getResult() != null) && !(result.getResult().equals(0))) {
            // 返回错误
            AjaxResult ajax = new AjaxResult();
            ajax.put(AjaxResult.CODE_TAG, NiuMaCodeEnum.DEFERRED_COMMAND_FAILED.getCode());
            if (StringUtils.isNotEmpty(result.getMessage()))
                ajax.put(AjaxResult.MSG_TAG, result.getMessage());
            deferredResult.setResult(new ResponseEntity<>(ajax, HttpStatus.INTERNAL_SERVER_ERROR));
            return;
        }
        int action = cmd.getAction();
        if (action == NiuMaConstants.ACTION_CREATE_GAME) {
            try {
                // 创建游戏
                String venueId = createGame(cmd.getGameType(), cmd.getPlayerId(), cmd.getBase64());
                // 响应进入新创建的场地
                responseEnterVenue(deferredResult, cmd.getPlayerId(), venueId);
            } catch (HttpException ex) {
                AjaxResult ajax = new AjaxResult();
                if (StringUtils.isNotEmpty(ex.getCode()))
                    ajax.put(AjaxResult.CODE_TAG, ex.getCode());
                if (StringUtils.isNotEmpty(ex.getMessage()))
                    ajax.put(AjaxResult.MSG_TAG, ex.getMessage());
                deferredResult.setResult(new ResponseEntity<>(ajax, ex.getStatus()));
            }
        } else if (action == NiuMaConstants.ACTION_ENTER_GAME) {
            String playerId = cmd.getPlayerId();
            String venueId = cmd.getVenueId();
            // 响应进入指定场地
            responseEnterVenue(deferredResult, playerId, venueId);
        } else if (action == NiuMaConstants.ACTION_ENTER_DISTRICT) {
            String playerId = cmd.getPlayerId();
            Integer districtId = null;
            try {
                districtId = Integer.parseInt(cmd.getVenueId());
            } catch (NumberFormatException ex) {
                AjaxResult ajax = AjaxResult.error(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), ex.getMessage());
                deferredResult.setResult(new ResponseEntity<>(ajax, HttpStatus.INTERNAL_SERVER_ERROR));
                return;
            }
            // 响应进入指定区域
            responseEnterDistrict(deferredResult, playerId, districtId);
        }
    }

    private MqCommandDeferred getCommandDeferred(String commandId) {
        MqCommandDeferred cmd = null;
        try {
            this.lock.lock();
            if (this.commandDeferredMap.containsKey(commandId)) {
                cmd = this.commandDeferredMap.get(commandId);
                this.commandDeferredMap.remove(commandId);
            }
        } finally {
            this.lock.unlock();
        }
        return cmd;
    }

    /**
     * 每100毫秒秒执行一次
     */
    @Scheduled(fixedRate = 100)
    public void fixedRateTask() {
        MqCommandDeferred cmd = this.getTimeoutCommandDeferred();
        if (cmd == null)
            return;
        AjaxResult ajax = new AjaxResult();
        ajax.put(AjaxResult.CODE_TAG, NiuMaCodeEnum.DEFERRED_COMMAND_FAILED.getCode());
        ajax.put(AjaxResult.MSG_TAG, "Deferred command timeout");
        DeferredResult<ResponseEntity<AjaxResult> > deferredResult = cmd.getResult();
        deferredResult.setResult(new ResponseEntity<>(ajax, HttpStatus.INTERNAL_SERVER_ERROR));
    }

    private MqCommandDeferred getTimeoutCommandDeferred() {
        MqCommandDeferred cmd = null;
        try {
            this.lock.lock();
            while (!(this.commandDeferredMap.isEmpty() || this.commandDeferredSequence.isEmpty())) {
                String commandId = this.commandDeferredSequence.getFirst();
                cmd = this.commandDeferredMap.get(commandId);
                if (cmd == null) {
                    this.commandDeferredSequence.pop();
                    continue;
                }
                Long nowTime = System.currentTimeMillis();
                Long delta = nowTime - cmd.getCreateTime();
                if (delta > 3000L) {
                    // 若超过3秒仍未返回，则认为命令超时
                    this.commandDeferredMap.remove(commandId);
                    this.commandDeferredSequence.pop();
                } else {
                    // 最先创建的异步命令尚未超时，直接返回null
                    cmd = null;
                }
                break;
            }
        } finally {
            this.lock.unlock();
        }
        return cmd;
    }

    @Override
    public PageResult<MahjongRecordDTO> getMahjongRecord(PageBody dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        PageResult<MahjongRecordDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.mahjongMapper.countRecord(player.getId());
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<MahjongRecord> records = this.mahjongMapper.getRecords(player.getId(), offset, dto.getPageSize());
        if ((records == null) || records.isEmpty())
            return result;
        List<MahjongRecordDTO> dtos = new ArrayList<>();
        Map<String, String> numberMap = new HashMap<>();
        Map<String, PlayerBaseDTO> playerMap = new HashMap<>();
        List<String> playerIds = new ArrayList<>();
        List<PlayerBaseDTO> playerInfos = null;
        List<Integer> scores = null;
        List<Long> winGolds = null;
        String number = null;
        PlayerBaseDTO pbd = null;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd HH:mm:ss");
        for (MahjongRecord record : records) {
            MahjongRecordDTO tmp = new MahjongRecordDTO();
            tmp.setId(record.getId());
            tmp.setVenueId(record.getVenueId());
            if (numberMap.containsKey(record.getVenueId()))
                number = numberMap.get(record.getVenueId());
            else {
                number = this.mahjongMapper.getNumber(record.getVenueId());
                numberMap.put(record.getVenueId(), number);
            }
            tmp.setNumber(number);
            tmp.setRoundNo(record.getRoundNo());
            tmp.setBanker(record.getBanker());
            playerIds.clear();
            playerIds.add(record.getPlayerId0());
            playerIds.add(record.getPlayerId1());
            playerIds.add(record.getPlayerId2());
            playerIds.add(record.getPlayerId3());
            playerInfos = new ArrayList<>();
            for (String playerId : playerIds) {
                if (playerMap.containsKey(playerId))
                    pbd = playerMap.get(playerId);
                else {
                    pbd = this.playerMapper.getBaseInfo(playerId);
                    playerMap.put(playerId, pbd);
                }
                playerInfos.add(pbd);
            }
            tmp.setPlayers(playerInfos);
            scores = new ArrayList<>();
            scores.add(record.getScore0());
            scores.add(record.getScore1());
            scores.add(record.getScore2());
            scores.add(record.getScore3());
            tmp.setScores(scores);
            winGolds = new ArrayList<>();
            winGolds.add(record.getWinGold0());
            winGolds.add(record.getWinGold1());
            winGolds.add(record.getWinGold2());
            winGolds.add(record.getWinGold3());
            tmp.setWinGolds(winGolds);
            if (record.getTime() != null)
                tmp.setTime(record.getTime().format(formatter));
            dtos.add(tmp);
        }
        result.setRecords(dtos);
        return result;
    }

    @Override
    public AjaxResult getMahjongPlayback(Long id) {
        if (id == null)
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "游戏记录id不能为空");
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        MahjongRecord record = this.mahjongMapper.getRecord(id);
        if (record == null)
            throw new NotFoundException(NiuMaCodeEnum.MAHJONG_RECORD_NOT_EXIST);
        LambdaQueryWrapper<GameMahjong> query = Wrappers.lambdaQuery();
        query.eq(GameMahjong::getVenueId, record.getVenueId());
        GameMahjong entity = this.mahjongMapper.selectOne(query);
        if (entity == null)
            throw new NotFoundException(NiuMaCodeEnum.MAHJONG_RECORD_NOT_EXIST);
        String playerId = player.getId();
        if (!(playerId.equals(record.getPlayerId0()) ||
              playerId.equals(record.getPlayerId1()) ||
              playerId.equals(record.getPlayerId2()) ||
              playerId.equals(record.getPlayerId3())))
            throw new ForbiddenException(ResultCodeEnum.FORBIDDEN.getCode(), "No permission to access the specified record");
        MahjongPlaybackDTO dto = new MahjongPlaybackDTO();
        dto.setVenueId(record.getVenueId());
        dto.setNumber(entity.getNumber());
        dto.setMode(entity.getMode());
        dto.setDiZhu(entity.getDiZhu());
        dto.setConfig(entity.getRule());
        dto.setRoundNo(record.getRoundNo());
        dto.setBanker(record.getBanker());
        List<String> playerIds = new ArrayList<>();
        playerIds.add(record.getPlayerId0());
        playerIds.add(record.getPlayerId1());
        playerIds.add(record.getPlayerId2());
        playerIds.add(record.getPlayerId3());
        List<PlayerBaseDTO> playerInfos = new ArrayList<>();
        for (String tmpId : playerIds) {
            PlayerBaseDTO pbd = this.playerMapper.getBaseInfo(tmpId);
            playerInfos.add(pbd);
        }
        dto.setPlayers(playerInfos);
        String playback = this.mahjongMapper.getPlayback(id);
        dto.setBase64(playback);
        if (record.getTime() != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd HH:mm");
            dto.setTime(record.getTime().format(formatter));
        }
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("data", dto);
        return ajax;
    }

    @Override
    public AjaxResult getBiJiPublicRooms() {
        List<RoomItemDTO> items = this.biJiMapper.getPublicRooms();
        return this.getPublicRooms(items, 6);
    }

    @Override
    public PageResult<LackeyRoundDTO> getLackeyRecord(PageBody dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        PageResult<LackeyRoundDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.lackeyMapper.countRound(player.getId());
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<Long> roundIds = this.lackeyMapper.getRoundIds(player.getId(), offset, dto.getPageSize());
        if (roundIds == null || roundIds.isEmpty())
            return result;
        List<LackeyRoundDTO> records = new ArrayList<>(roundIds.size());
        for (Long roundId : roundIds) {
            LackeyRoundDTO item = this.lackeyMapper.getRoundInfo(roundId);
            if (item == null)
                continue;
            String time = item.getTime();
            if (StringUtils.isNotEmpty(time)) {
                int pos1 = time.indexOf('-');
                int pos2 = time.lastIndexOf(':');
                if (pos1 != -1 && pos2 != -1) {
                    time = time.substring(pos1 + 1, pos2);
                    item.setTime(time);
                }
            }
            List<LackeyRoundPlayerDTO> players = this.lackeyMapper.getRoundPlayers(roundId);
            item.setPlayers(players);
            records.add(item);
        }
        result.setRecords(records);
        return result;
    }

    @Override
    public AjaxResult getNiu100PublicRooms() {
        List<RoomItemDTO> items = this.niu100Mapper.getPublicRooms();
        return this.getPublicRooms(items, null);
    }

    private AjaxResult getPublicRooms(List<RoomItemDTO> items, Integer maxPlayerNums) {
        AjaxResult ajax = AjaxResult.successEx();
        if (items != null) {
            Map<String, PlayerBaseDTO> playerMap = new HashMap<>();
            for (RoomItemDTO item : items) {
                PlayerBaseDTO info = playerMap.get(item.getOwnerId());
                if (info == null) {
                    info = this.playerMapper.getBaseInfo(item.getOwnerId());
                    playerMap.put(item.getOwnerId(), info);
                }
                item.setOwnerName(info.getNickname());
                item.setOwnerHeadUrl(info.getHeadUrl());
                String redisKey = NiuMaRedisKeys.VENUE_PLAYER_COUNT + item.getVenueId();
                Integer playerCount = this.redisPrimitive.getInt(redisKey);
                if (playerCount == null)
                    playerCount = 0;
                item.setPlayerCount(playerCount);
                item.setMaxPlayerNums(maxPlayerNums);
            }
            // 按人数降序排序
            Collections.sort(items, new Comparator<RoomItemDTO>() {
                @Override
                public int compare(RoomItemDTO item1, RoomItemDTO item2) {
                    return Integer.compare(item2.getPlayerCount(), item1.getPlayerCount());
                }
            });
        }
        else
            items = new ArrayList<>();
        ajax.put("items", items);
        return ajax;
    }

    @Override
    public PageResult<GameRoomDTO> getMahjong(GameRoomReqDTO dto) {
        return this.getRooms(dto, NiuMaConstants.GAME_TYPE_MAHJONG);
    }

    @Override
    public PageResult<GameRoomDTO> getBiJi(GameRoomReqDTO dto) {
        return this.getRooms(dto, NiuMaConstants.GAME_TYPE_BI_JI);
    }

    @Override
    public PageResult<GameRoomDTO> getLackey(GameRoomReqDTO dto) {
        return this.getRooms(dto, NiuMaConstants.GAME_TYPE_LACKEY);
    }

    @Override
    public PageResult<GameRoomDTO> getNiu100(GameRoomReqDTO dto) {
        return this.getRooms(dto, NiuMaConstants.GAME_TYPE_NIU_NIU_100);
    }

    private PageResult<GameRoomDTO> getRooms(GameRoomReqDTO dto, Integer gameType) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        String venueId = CommonUtils.processKeyword(dto.getVenueId());
        String ownerId = CommonUtils.processKeyword(dto.getOwnerId());
        String number = CommonUtils.processKeyword(dto.getNumber());
        String startTime = null;
        String endTime = null;
        if (StringUtils.isNotEmpty(dto.getCreateTimeStart()))
            startTime = dto.getCreateTimeStart();
        if (StringUtils.isNotEmpty(dto.getCreateTimeEnd()))
            endTime = dto.getCreateTimeEnd();
        PageResult<GameRoomDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = 0;
        if (gameType.equals(NiuMaConstants.GAME_TYPE_MAHJONG))
            totalNum = this.mahjongMapper.countRoom(venueId, ownerId, number, startTime, endTime);
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_BI_JI))
            totalNum = this.biJiMapper.countRoom(venueId, ownerId, number, startTime, endTime);
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_LACKEY))
            totalNum = this.lackeyMapper.countRoom(venueId, ownerId, number, startTime, endTime);
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_NIU_NIU_100))
            totalNum = this.niu100Mapper.countRoom(venueId, ownerId, number, startTime, endTime);
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<GameRoomDTO> records = null;
        if (gameType.equals(NiuMaConstants.GAME_TYPE_MAHJONG))
            records = this.mahjongMapper.getRooms(venueId, ownerId, number, startTime, endTime, offset, dto.getPageSize());
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_BI_JI))
            records = this.biJiMapper.getRooms(venueId, ownerId, number, startTime, endTime, offset, dto.getPageSize());
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_LACKEY))
            records = this.lackeyMapper.getRooms(venueId, ownerId, number, startTime, endTime, offset, dto.getPageSize());
        else if (gameType.equals(NiuMaConstants.GAME_TYPE_NIU_NIU_100))
            records = this.niu100Mapper.getRooms(venueId, ownerId, number, startTime, endTime, offset, dto.getPageSize());
        if (records != null) {
            Map<String, String> ownerMap = new HashMap<>();
            for (GameRoomDTO item : records) {
                String ownerName = null;
                if (ownerMap.containsKey(item.getOwnerId()))
                    ownerName = ownerMap.get(item.getOwnerId());
                else {
                    ownerName = this.playerMapper.getNickname(item.getOwnerId());
                    if (StringUtils.isNotEmpty(ownerName))
                        ownerMap.put(item.getOwnerId(), ownerName);
                }
                item.setOwnerName(ownerName);
            }
        }
        result.setRecords(records);
        return result;
    }
}
