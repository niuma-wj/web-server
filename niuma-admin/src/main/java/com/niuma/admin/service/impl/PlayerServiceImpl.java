package com.niuma.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.niuma.admin.constant.NiuMaCodeEnum;
import com.niuma.admin.constant.NiuMaConstants;
import com.niuma.admin.constant.NiuMaRedisKeys;
import com.niuma.admin.dto.*;
import com.niuma.admin.entity.Capital;
import com.niuma.admin.entity.Player;
import com.niuma.admin.factory.PlayerAsyncFactory;
import com.niuma.admin.mapper.*;
import com.niuma.admin.service.ICapitalService;
import com.niuma.admin.service.IPlayerService;
import com.niuma.common.constant.CacheConstants;
import com.niuma.common.constant.Constants;
import com.niuma.common.constant.ResultCodeEnum;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.core.domain.model.LoginPlayer;
import com.niuma.common.core.redis.RedisCache;
import com.niuma.common.core.redis.RedisPrimitive;
import com.niuma.common.page.PageResult;
import com.niuma.common.exception.http.*;
import com.niuma.common.exception.user.*;
import com.niuma.common.utils.AesUtil;
import com.niuma.common.utils.CommonUtils;
import com.niuma.common.utils.PlayerSecurityUtils;
import com.niuma.common.utils.StringUtils;
import com.niuma.common.utils.ip.IpUtils;
import com.niuma.framework.manager.AsyncManager;
import com.niuma.framework.web.service.PlayerTokenService;
import com.niuma.system.service.ISysConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Random;

@Service
@Slf4j
public class PlayerServiceImpl extends ServiceImpl<PlayerMapper, Player> implements IPlayerService {
    @Autowired
    private PlayerTokenService playerTokenService;

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
    private ISysConfigService configService;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    private PlayerAsyncFactory playerAsyncFactory;

    @Autowired
    private ICapitalService capitalService;

    @Autowired
    private AgencyMapper agencyMapper;

    @Resource
    private VenueMapper venueMapper;

    @Resource
    private GameMahjongMapper mahjongMapper;

    @Resource
    private GameBiJiMapper biJiMapper;

    @Resource
    private GameLackeyMapper lackeyMapper;

    @Resource
    private GameNiu100Mapper niu100Mapper;

    @Override
    public AjaxResult login(PlayerLoginDTO dto) {
        String name = AesUtil.decrypt(dto.getName());
        String password = AesUtil.decrypt(dto.getPassword());
        if (StringUtils.isEmpty(name) || StringUtils.isEmpty(password))
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "账号或密码错误");
        String id = this.baseMapper.getIdByName(name);
        if (StringUtils.isEmpty(id))
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_NOT_EXIST);
        String redisKey = CacheConstants.PLAYER_ACTIVE_KEY + id;
        Long activeTime = this.redisCache.getCacheObject(redisKey);
        if (activeTime != null) {
            Long timestamp = System.currentTimeMillis();
            timestamp /= 1000L;
            Long delta = timestamp - activeTime;
            if (delta < 30L)
                throw new ForbiddenException(NiuMaCodeEnum.PLAYER_LOGINED);
        }
        // 校验验证码
        this.validateCaptcha(dto.getCode(), dto.getUuid());
        // 验证密码
        LambdaQueryWrapper<Player> query = Wrappers.lambdaQuery();
        query.eq(Player::getName, name);
        Player entity = this.getOne(query);
        if ((entity == null) || CommonUtils.predicate(entity.getDelFlag()))
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_NOT_EXIST);
        if (!this.bCryptPasswordEncoder.matches(password, entity.getPassword()))
            throw new UnauthorizedException(NiuMaCodeEnum.PLAYER_BAD_CREDENTIALS);
        // 生成token
        LoginPlayer player = new LoginPlayer();
        player.setId(id);
        player.setName(name);
        player.setNickName(entity.getNickname());
        player.setUuid(dto.getUuid());
        this.playerTokenService.setLoginPlayer(player);
        String token = Constants.TOKEN_PREFIX + this.playerTokenService.createToken(player);
        this.baseMapper.updateLogin(id, IpUtils.getIpAddr());
        AsyncManager.me().execute(this.playerAsyncFactory.recordPlayerLogin(id, entity.getNickname()));
        // 生成消息密钥
        /*String secret = CommonUtils.generatePassword(6);
        String redisKey = NiuMaRedisKeys.PLAYER_MESSAGE_SECRET + player.getId();
        this.redisPrimitive.set(redisKey, secret);*/
        // 设置响应字段
        AjaxResult ajax = AjaxResult.successEx();
        //ajax.put("secret", secret);
        ajax.put("token", token);
        return ajax;
    }

    /**
     * 校验验证码
     *
     * @param code 验证码
     * @param uuid 唯一标识
     * @return 结果
     */
    private void validateCaptcha(String code, String uuid) {
        boolean captchaEnabled = this.configService.selectCaptchaEnabled();
        if (captchaEnabled) {
            String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + StringUtils.nvl(uuid, "");
            String captcha = this.redisCache.getCacheObject(verifyKey);
            if (captcha == null)
                throw new CaptchaExpireException();
            this.redisCache.deleteObject(verifyKey);
            if (!code.equalsIgnoreCase(captcha))
                throw new CaptchaException();
        }
    }

    @Override
    public AjaxResult logout() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        this.playerTokenService.delLoginPlayer(player.getId());
        String redisKey = NiuMaRedisKeys.PLAYER_MESSAGE_SECRET + player.getId();
        this.redisPrimitive.delete(redisKey);
        redisKey = CacheConstants.PLAYER_ACTIVE_KEY + player.getId();
        this.redisCache.deleteObject(redisKey);
        return AjaxResult.successEx();
    }

    private static class PlayerTester implements CommonUtils.DuplicateTester {
        private PlayerMapper mapper;

        public PlayerTester(PlayerMapper mapper) {
            this.mapper = mapper;
        }

        @Override
        public boolean testDuplicate(String code) {
            LambdaQueryWrapper<Player> query = Wrappers.lambdaQuery();
            query.eq(Player::getId, code);
            Integer count = this.mapper.selectCount(query);
            return CommonUtils.predicate(count);
        }
    }

    private String generatePlayerId() {
        String playerId = CommonUtils.generateRandomCode(10, CommonUtils.CODE_ALL, new PlayerTester(this.baseMapper));
        if (StringUtils.isEmpty(playerId))
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), "Generate player id failed");
        return playerId;
    }

    @Override
    public AjaxResult register(RegisterDTO dto) {
        String name = AesUtil.decrypt(dto.getName());
        String password = AesUtil.decrypt(dto.getPassword());
        if (StringUtils.isEmpty(name) || StringUtils.isEmpty(password))
            throw new BadRequestException(ResultCodeEnum.BAD_REQUEST.getCode(), "账号或密码错误");
        if (dto.getSex() == null)
            dto.setSex(0);
        String id = this.baseMapper.getIdByName(name);
        if (StringUtils.isNotEmpty(id))
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_REGISTER_ERROR.getCode(), "账号已存在");
        log.info("Player register, name: {}, password: {}, nickname: {}", name, password, dto.getNickname());
        password = this.bCryptPasswordEncoder.encode(password);
        Player entity = new Player();
        entity.setId(generatePlayerId());
        entity.setName(name);
        entity.setPassword(password);
        entity.setNickname(dto.getNickname());
        entity.setSex(dto.getSex());
        // 随机分配一个头像
        Integer count = this.baseMapper.countHeadImageUrls();
        Random rand = new Random();
        Integer imgId = rand.nextInt(count);
        imgId += 1;
        String url = this.baseMapper.getHeadImageUrl(imgId);
        entity.setAvatar(url);
        this.baseMapper.addPlayer(entity);
        // 添加资产
        Capital capital = new Capital();
        capital.setPlayerId(entity.getId());
        capital.setGold(1000000L);
        capital.setDiamond(1000L);
        capital.setVersion(1L);
        this.capitalService.save(capital);
        return AjaxResult.successEx();
    }

    @Override
    public AjaxResult refreshMessageSecret() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        String secret = CommonUtils.generatePassword(6);
        String redisKey = NiuMaRedisKeys.PLAYER_MESSAGE_SECRET + player.getId();
        this.redisPrimitive.set(redisKey, secret);
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("secret", secret);
        return ajax;
    }

    @Override
    public void heartbeat() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Long nowTime = System.currentTimeMillis();
        nowTime /= 1000L;
        this.baseMapper.updateHeartbeat(player.getId(), nowTime);
    }

    @Override
    public AjaxResult getInfo() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Player entity = this.baseMapper.selectById(player.getId());
        if (entity == null)
            throw new InternalServerException("Current player entity is null, this is unexpected");
        Capital capital = this.capitalService.getCapital(player.getId());
        // 生成消息密钥
        String secret = CommonUtils.generatePassword(6);
        String redisKey = NiuMaRedisKeys.PLAYER_MESSAGE_SECRET + player.getId();
        this.redisPrimitive.set(redisKey, secret);
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("secret", secret);
        ajax.put("playerId", player.getId());
        ajax.put("name", entity.getName());
        ajax.put("nickname", entity.getNickname());
        ajax.put("phone", entity.getPhone());
        ajax.put("sex", entity.getSex());
        ajax.put("avatar", entity.getAvatar());
        ajax.put("agencyId", entity.getAgencyId());
        ajax.put("gold", capital.getGold());
        ajax.put("deposit", capital.getDeposit());
        ajax.put("diamond", capital.getDiamond());
        Integer isAgency =  this.agencyMapper.isAgency(player.getId());
        ajax.put("isAgency", isAgency);
        return ajax;
    }

    @Override
    public AjaxResult getPersonalData() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Player entity = this.baseMapper.selectById(player.getId());
        if (entity == null)
            throw new InternalServerException("Current player entity is null, this is unexpected");
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("loginIp", entity.getLoginIp());
        ajax.put("loginDate", entity.getLoginDate());
        if (StringUtils.isNotEmpty(entity.getAgencyId())) {
            ajax.put("agencyId", entity.getAgencyId());
            String nickname = this.baseMapper.getNickname(entity.getAgencyId());
            ajax.put("agencyName", nickname);
        }
        return ajax;
    }

    @Override
    public AjaxResult location(LocationDTO dto) {
        return AjaxResult.successEx();
    }

    @Override
    public PageResult<PlayerDTO> getPlayer(PlayerReqDTO dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        String playerId = CommonUtils.processKeyword(dto.getPlayerId());
        String nickname = CommonUtils.processKeyword(dto.getNickname());
        Integer online = dto.getOnline();
        Long heartbeat = System.currentTimeMillis();
        heartbeat /= 1000L;
        // 30秒之前为界限
        heartbeat -= 30L;
        if (online != null) {
            if (CommonUtils.predicate(online))
                online = 1;
            else
                online = 0;
        }
        PageResult<PlayerDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.baseMapper.countPlayer(playerId, nickname, online, heartbeat);
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<PlayerDTO> records = this.baseMapper.getPage(playerId, nickname, online, heartbeat, offset, dto.getPageSize());
        if (records != null) {
            String redisKey = null;
            String gameRoom = null;
            String number = null;
            Integer gameType = null;
            for (PlayerDTO item : records) {
                redisKey = NiuMaRedisKeys.PLAYER_CURRENT_VENUE + item.getPlayerId();
                String venueId = this.redisPrimitive.get(redisKey);
                if (StringUtils.isNotEmpty(venueId))
                    gameType = this.venueMapper.getGameType(venueId);
                else
                    gameType = null;
                if (gameType != null) {
                    if (gameType.equals(NiuMaConstants.GAME_TYPE_MAHJONG)) {
                        gameRoom = "标准麻将(";
                        number = this.mahjongMapper.getNumber(venueId);
                    }
                    else if (gameType.equals(NiuMaConstants.GAME_TYPE_BI_JI)) {
                        gameRoom = "六安比鸡(";
                        number = this.biJiMapper.getNumber(venueId);
                    }
                    else if (gameType.equals(NiuMaConstants.GAME_TYPE_LACKEY)) {
                        gameRoom = "逮狗腿(";
                        number = this.lackeyMapper.getNumber(venueId);
                    }
                    else if (gameType.equals(NiuMaConstants.GAME_TYPE_NIU_NIU_100)) {
                        gameRoom = "百人牛牛(";
                        number = this.niu100Mapper.getNumber(venueId);
                    }
                    if (StringUtils.isNotEmpty(number)) {
                        gameRoom = gameRoom + number + ")";
                        item.setGameRoom(gameRoom);
                    }
                }
                if (online == null) {
                    if ((item.getHeartbeat() == null) || (item.getHeartbeat() < heartbeat))
                        item.setOnline(0);
                    else
                        item.setOnline(1);
                } else {
                    item.setOnline(online);
                }
                if (StringUtils.isNotEmpty(item.getAgencyId())) {
                    nickname = this.baseMapper.getNickname(item.getAgencyId());
                    if (nickname != null) {
                        nickname = nickname + "(" + item.getAgencyId() + ")";
                        item.setAgency(nickname);
                    }
                }
            }
        }
        result.setRecords(records);
        return result;
    }

    @Override
    public void banPlayer(String playerId) {
        Player entity = this.baseMapper.selectById(playerId);
        if (entity == null)
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_NOT_EXIST.getCode(), "指定玩家不存在");
        if (CommonUtils.predicate(entity.getBanned()))
            this.baseMapper.setBanned(playerId, 0);
        else {
            this.baseMapper.setBanned(playerId, 1);
            this.playerTokenService.delLoginPlayer(playerId);
            String redisKey = NiuMaRedisKeys.PLAYER_MESSAGE_SECRET + playerId;
            this.redisPrimitive.delete(redisKey);
            redisKey = CacheConstants.PLAYER_ACTIVE_KEY + playerId;
            this.redisCache.deleteObject(redisKey);
        }
    }
}
