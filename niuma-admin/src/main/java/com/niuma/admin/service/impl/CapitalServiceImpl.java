package com.niuma.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.niuma.admin.constant.NiuMaCodeEnum;
import com.niuma.admin.dto.*;
import com.niuma.admin.entity.*;
import com.niuma.admin.mapper.*;
import com.niuma.admin.service.ICapitalService;
import com.niuma.common.constant.ResultCodeEnum;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.core.domain.model.LoginPlayer;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;
import com.niuma.common.exception.http.*;
import com.niuma.common.utils.AesUtil;
import com.niuma.common.utils.CommonUtils;
import com.niuma.common.utils.PlayerSecurityUtils;
import com.niuma.common.utils.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class CapitalServiceImpl extends ServiceImpl<CapitalMapper, Capital> implements ICapitalService {
    @Autowired
    private ExchangeMapper exchangeMapper;

    @Autowired
    private PlayerMapper playerMapper;

    @Autowired
    private TransferMapper transferMapper;

    @Autowired
    private BuyDiamondMapper buyDiamondMapper;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Override
    public AjaxResult getCapital() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Capital entity = this.getCapital(player.getId());
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("gold", entity.getGold());
        ajax.put("deposit", entity.getDeposit());
        ajax.put("diamond", entity.getDiamond());
        return ajax;
    }

    @Override
    public Capital getCapital(String playerId) {
        Capital entity = this.baseMapper.selectById(playerId);
        if (entity == null)
            entity = this.initCapital(playerId);
        return entity;
    }

    private void initCapital1(String playerId) {
        LambdaQueryWrapper<Capital> query = Wrappers.lambdaQuery();
        query.eq(Capital::getPlayerId, playerId);
        Integer count = this.baseMapper.selectCount(query);
        if (count == null || count.equals(0))
            this.initCapital(playerId);
    }

    private Capital initCapital(String playerId) {
        Capital entity = new Capital();
        entity.setPlayerId(playerId);
        entity.setGold(0L);
        entity.setDeposit(0L);
        entity.setDiamond(0L);
        this.baseMapper.insert(entity);
        return entity;
    }

    @Override
    public AjaxResult bankPassword(BankPwdDTO dto) {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        String oldPassword = AesUtil.decrypt(dto.getOldPassword());
        String newPassword = AesUtil.decrypt(dto.getNewPassword());
        if (StringUtils.isNotEmpty(newPassword))
            newPassword = StringUtils.trim(newPassword);
        if (StringUtils.isEmpty(newPassword))
            throw new BadRequestException(NiuMaCodeEnum.BANK_PASSWORD_ERROR.getCode(), "New password error");
        String bankPassword = this.baseMapper.getBankPassword(player.getId());
        if (StringUtils.isNotEmpty(bankPassword)) {
            if (StringUtils.isEmpty(oldPassword))
                throw new UnauthorizedException(NiuMaCodeEnum.BANK_PASSWORD_ERROR);
            if (!this.bCryptPasswordEncoder.matches(oldPassword, bankPassword))
                throw new UnauthorizedException(NiuMaCodeEnum.BANK_PASSWORD_ERROR);
        }
        initCapital1(player.getId());
        newPassword = this.bCryptPasswordEncoder.encode(newPassword);
        this.baseMapper.updateBankPassword(player.getId(), newPassword);
        return AjaxResult.successEx();
    }

    private void checkPassword(String inputPwd, String bankPwd) {
        if (StringUtils.isEmpty(bankPwd)) {
            if (StringUtils.isNotEmpty(inputPwd))
                throw new ForbiddenException(NiuMaCodeEnum.BANK_PASSWORD_ERROR);
        } else {
            String password = AesUtil.decrypt(inputPwd);
            if (StringUtils.isEmpty(password))
                throw new ForbiddenException(NiuMaCodeEnum.BANK_PASSWORD_ERROR);
            if (!this.bCryptPasswordEncoder.matches(password, bankPwd))
                throw new ForbiddenException(NiuMaCodeEnum.BANK_PASSWORD_ERROR);
        }
    }

    @Override
    public AjaxResult debitOrDeposit(AmountDTO dto, boolean isDebit) {
        Long amount = dto.getAmount();
        if (amount == 0 || amount < 0)
            throw new BadRequestException(NiuMaCodeEnum.CAPITAL_AMOUNT_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Capital entity = this.getCapital(player.getId());
        if (isDebit) {
            // 取出需要验证密码
            this.checkPassword(dto.getPassword(), entity.getPassword());
        }
        Long gold = entity.getGold();
        if (gold == null)
            gold = 0L;
        Long deposit = entity.getDeposit();
        if (deposit == null)
            deposit = 0L;
        if (isDebit) {
            if (deposit < amount)
                throw new ForbiddenException(NiuMaCodeEnum.DEPOSIT_BALANCE_ERROR);
            gold += amount;
            deposit -= amount;
        } else {
            if (gold < amount)
                throw new ForbiddenException(NiuMaCodeEnum.GOLD_INSUFFICIENT_ERROR);
            gold -= amount;
            deposit += amount;
        }
        Integer count = this.baseMapper.setCapital(player.getId(), gold, deposit, null, entity.getVersion());
        if ((count == null) || count.equals(0)) {
            // 更新失败，返回系统忙
            throw new InternalServerException(ResultCodeEnum.SERVICE_UNAVAILABLE);
        }
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("gold", gold);
        ajax.put("deposit", deposit);
        return ajax;
    }

    @Override
    public AjaxResult getAccount() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        AjaxResult ajax = AjaxResult.successEx();
        AccountDTO dto = this.baseMapper.getAccount(player.getId());
        if (dto != null) {
            if (StringUtils.isNotEmpty(dto.getAlipayAccount()))
                ajax.put("alipayAccount", dto.getAlipayAccount());
            if (StringUtils.isNotEmpty(dto.getAlipayName()))
                ajax.put("alipayName", dto.getAlipayName());
            if (StringUtils.isNotEmpty(dto.getBankAccount()))
                ajax.put("bankAccount", dto.getBankAccount());
            if (StringUtils.isNotEmpty(dto.getBankName()))
                ajax.put("bankName", dto.getBankName());
        }
        return ajax;
    }

    @Override
    public AjaxResult bindAccount(BindAccountDTO dto) {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Integer type = dto.getType();
        if ((type == null) || !(type.equals(0) || type.equals(1)))
            throw new BadRequestException(NiuMaCodeEnum.ACCOUNT_TYPE_ERROR);
        String bankPassword = this.baseMapper.getBankPassword(player.getId());
        this.checkPassword(dto.getPassword(), bankPassword);
        initCapital1(player.getId());
        AjaxResult ajax = AjaxResult.successEx();
        if (type.equals(0)) {
            this.baseMapper.setAlipayAccount(player.getId(), dto.getAccount(), dto.getName());
            ajax.put("alipayAccount", dto.getAccount());
        }
        else {
            this.baseMapper.setBankAccount(player.getId(), dto.getAccount(), dto.getName());
            ajax.put("bankAccount", dto.getAccount());
        }
        return ajax;
    }

    @Override
    @Transactional
    public AjaxResult exchange(ExchangeDTO dto) {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Integer type = dto.getType();
        if ((type == null) || !(type.equals(0) || type.equals(1)))
            throw new BadRequestException(NiuMaCodeEnum.ACCOUNT_TYPE_ERROR);
        Capital entity = this.getCapital(player.getId());
        this.checkPassword(dto.getPassword(), entity.getPassword());
        AccountDTO account = this.baseMapper.getAccount(player.getId());
        if (account == null)
            throw new ForbiddenException(NiuMaCodeEnum.ACCOUNT_NOT_BIND);
        if (type.equals(0)) {
            if (StringUtils.isEmpty(account.getAlipayAccount()))
                throw new ForbiddenException(NiuMaCodeEnum.ACCOUNT_NOT_BIND);
        } else if (StringUtils.isEmpty(account.getBankAccount()))
            throw new ForbiddenException(NiuMaCodeEnum.ACCOUNT_NOT_BIND);
        long remainder = dto.getAmount() % 50L;
        if ((remainder != 0L) || (dto.getAmount() < 50L))
            throw new BadRequestException(NiuMaCodeEnum.EXCHANGE_AMOUNT_ERROR);
        Long deposit = entity.getDeposit();
        if (deposit == null)
            deposit = 0L;
        if (deposit < dto.getAmount())
            throw new ForbiddenException(NiuMaCodeEnum.DEPOSIT_BALANCE_ERROR);
        deposit -= dto.getAmount();
        Integer count = this.baseMapper.setCapital(player.getId(), null, deposit, null, entity.getVersion());
        if ((count == null) || (count < 1))
            throw new InternalServerException(ResultCodeEnum.SERVICE_UNAVAILABLE);
        // 添加兑换记录
        Exchange tmp = new Exchange();
        tmp.setPlayerId(player.getId());
        tmp.setAmount(dto.getAmount());
        tmp.setAccountType(dto.getType());
        if (type.equals(0)) {
            tmp.setAccount(account.getAlipayAccount());
            tmp.setAccountName(account.getAlipayName());
        } else {
            tmp.setAccount(account.getBankAccount());
            tmp.setAccountName(account.getBankName());
        }
        tmp.setStatus(0);
        tmp.setApplyTime(LocalDateTime.now());
        this.exchangeMapper.insert(tmp);
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("deposit", deposit);
        return ajax;
    }

    @Override
    public PageResult<ExchangeRecordDTO> exchangeRecord(PageBody dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        PageResult<ExchangeRecordDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.exchangeMapper.countRecord(player.getId());
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<ExchangeRecordDTO> records = this.exchangeMapper.getPage(player.getId(), offset, dto.getPageSize());
        result.setRecords(records);
        return result;
    }

    @Override
    @Transactional
    public AjaxResult transfer(TransferDTO dto) {
        if (dto.getAmount() < 1)
            throw new BadRequestException(NiuMaCodeEnum.CAPITAL_AMOUNT_ERROR.getCode(), "Transfer amount must be greater than 0");
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        if (dto.getPlayerId().equals(player.getId()))
            throw new ForbiddenException(NiuMaCodeEnum.TRANSFER_ERROR.getCode(), "Can't transfer to yourself");
        Capital capital1 = this.getCapital(player.getId());
        this.checkPassword(dto.getPassword(), capital1.getPassword());
        Long deposit = capital1.getDeposit();
        if (deposit == null)
            deposit = 0L;
        if (deposit < dto.getAmount())
            throw new ForbiddenException(NiuMaCodeEnum.DEPOSIT_BALANCE_ERROR);
        Player dstPlayer = this.playerMapper.selectById(dto.getPlayerId());
        if (dstPlayer == null)
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_NOT_EXIST);
        if (CommonUtils.predicate(dstPlayer.getBanned()) || CommonUtils.predicate(dstPlayer.getDelFlag()))
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_STATUS_ERROR);
        deposit -= dto.getAmount();
        Integer count = this.baseMapper.setCapital(player.getId(), null, deposit, null, capital1.getVersion());
        if ((count == null) || (count < 1))
            throw new InternalServerException(ResultCodeEnum.SERVICE_UNAVAILABLE);
        this.initCapital1(dto.getPlayerId());
        Capital capital2 = this.getCapital(dto.getPlayerId());
        deposit = capital2.getDeposit() + dto.getAmount();
        this.baseMapper.setCapital(dto.getPlayerId(), null, deposit, null, capital2.getVersion());
        if ((count == null) || (count < 1))
            throw new InternalServerException(ResultCodeEnum.SERVICE_UNAVAILABLE);
        // 添加转账记录
        Transfer tmp = new Transfer();
        tmp.setSrcPlayerId(player.getId());
        tmp.setDstPlayerId(dto.getPlayerId());
        tmp.setAmount(dto.getAmount());
        tmp.setTime(LocalDateTime.now());
        this.transferMapper.insert(tmp);

        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("deposit", deposit);
        Long accAmount = this.transferMapper.getAccAmount(player.getId());
        if (accAmount == null)
            accAmount = 0L;
        ajax.put("accAmount", accAmount);
        return ajax;
    }

    @Override
    public PageResult<TransferRecordDTO> transferRecord(PageBody dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        PageResult<TransferRecordDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.transferMapper.countRecord(player.getId());
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<TransferRecordDTO> records = this.transferMapper.getPage(player.getId(), offset, dto.getPageSize());
        if (records != null) {
            String nickname = null;
            Map<String, String> tmpMap = new HashMap<>();
            for (TransferRecordDTO record : records) {
                if (tmpMap.containsKey(record.getDstPlayerId()))
                    nickname = tmpMap.get(record.getDstPlayerId());
                else {
                    nickname = this.playerMapper.getNickname(record.getDstPlayerId());
                    tmpMap.put(record.getDstPlayerId(), nickname);
                }
                record.setDstNickname(nickname);
            }
        }
        result.setRecords(records);
        return result;
    }

    @Override
    public AjaxResult transferAcc() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        AjaxResult ajax = AjaxResult.successEx();
        Long accAmount = this.transferMapper.getAccAmount(player.getId());
        if (accAmount == null)
            accAmount = 0L;
        ajax.put("accAmount", accAmount);
        return ajax;
    }

    @Override
    @Transactional
    public AjaxResult buyDiamond(Integer index) {
        if (index == null)
            throw new BadRequestException(NiuMaCodeEnum.DIAMOND_PACK_INDEX_ERROR.getCode(), "Diamond pack index can't be null");
        if (index < 1 || index > 6)
            throw new BadRequestException(NiuMaCodeEnum.DIAMOND_PACK_INDEX_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        Long[] diamonds = new Long[] { 50L, 100L, 200L, 300L, 400L, 500L };
        Long[] golds = new Long[] { 1250L, 2400L, 4600L, 6600L, 8400L, 10000L };
        index -= 1;
        Capital entity = this.getCapital(player.getId());
        Long gold = entity.getGold();
        if (gold < golds[index])
            throw new ForbiddenException(NiuMaCodeEnum.GOLD_INSUFFICIENT_ERROR);
        gold -= golds[index];
        Long diamond = entity.getDiamond() + diamonds[index];
        Integer count = this.baseMapper.setCapital(player.getId(), gold, null, diamond, entity.getVersion());
        if ((count == null) || (count < 1))
            throw new InternalServerException(ResultCodeEnum.SERVICE_UNAVAILABLE);
        // 添加购买钻石记录
        BuyDiamond tmp = new BuyDiamond();
        tmp.setPlayerId(player.getId());
        tmp.setDiamond(diamonds[index]);
        tmp.setGold(golds[index]);
        tmp.setTime(LocalDateTime.now());
        this.buyDiamondMapper.insert(tmp);

        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("gold", gold);
        ajax.put("diamond", diamond);
        return ajax;
    }
}
