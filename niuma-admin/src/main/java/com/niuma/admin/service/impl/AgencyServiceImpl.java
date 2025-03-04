package com.niuma.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.niuma.admin.constant.NiuMaCodeEnum;
import com.niuma.admin.dto.CollectRecordDTO;
import com.niuma.admin.dto.JuniorPlayerDTO;
import com.niuma.admin.dto.RewardDTO;
import com.niuma.admin.entity.Agency;
import com.niuma.admin.entity.AgencyCollect;
import com.niuma.admin.entity.Capital;
import com.niuma.admin.entity.Player;
import com.niuma.admin.mapper.AgencyCollectMapper;
import com.niuma.admin.mapper.AgencyMapper;
import com.niuma.admin.mapper.CapitalMapper;
import com.niuma.admin.mapper.PlayerMapper;
import com.niuma.admin.service.IAgencyService;
import com.niuma.common.constant.ResultCodeEnum;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.core.domain.model.LoginPlayer;
import com.niuma.common.dto.IntPairDTO;
import com.niuma.common.dto.LongPairDTO;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;
import com.niuma.common.exception.http.BadRequestException;
import com.niuma.common.exception.http.ForbiddenException;
import com.niuma.common.exception.http.InternalServerException;
import com.niuma.common.exception.http.NotFoundException;
import com.niuma.common.utils.CommonUtils;
import com.niuma.common.utils.PlayerSecurityUtils;
import com.niuma.common.utils.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
public class AgencyServiceImpl extends ServiceImpl<AgencyMapper, Agency> implements IAgencyService {
    @Autowired
    private PlayerMapper playerMapper;

    @Autowired
    private CapitalMapper capitalMapper;

    @Autowired
    private AgencyCollectMapper agencyCollectMapper;

    @Override
    @Transactional
    public AjaxResult bindAgency(String playerId) {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        if (playerId.equals(player.getId()))
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "You can't bind yourself as superior agency");
        String agencyId = this.playerMapper.getAgencyId(player.getId());
        if (StringUtils.isNotEmpty(agencyId))
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "You has already bound to an superior agency");
        Player entity = this.playerMapper.selectById(playerId);
        if (entity == null)
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_NOT_EXIST);
        if (CommonUtils.predicate(entity.getBanned()) || CommonUtils.predicate(entity.getDelFlag()))
            throw new ForbiddenException(NiuMaCodeEnum.PLAYER_STATUS_ERROR);
        Integer isAgency = this.baseMapper.isAgency(playerId);
        if (!CommonUtils.predicate(isAgency))
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "The specified player is not agency");
        this.playerMapper.updateAgencyId(player.getId(), playerId);
        agencyId = playerId;
        while (StringUtils.isNotEmpty(agencyId)) {
            this.baseMapper.juniorCountAddOne(agencyId);
            agencyId = this.playerMapper.getAgencyId(agencyId);
        }
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("agencyId", playerId);
        ajax.put("agencyName", entity.getNickname());
        return ajax;
    }

    @Override
    public AjaxResult getAgency() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        LambdaQueryWrapper<Agency> query = Wrappers.lambdaQuery();
        query.eq(Agency::getPlayerId, player.getId());
        Agency entity = this.baseMapper.selectOne(query);
        if (entity == null)
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "Current player is not agency");
        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("level", entity.getLevel());
        ajax.put("superiorId", entity.getSuperiorId());
        ajax.put("juniorCount", entity.getJuniorCount());
        ajax.put("totalReward", entity.getTotalReward());
        Long reward = this.baseMapper.getIndirectReward(player.getId());
        if (reward == null)
            reward = 0L;
        ajax.put("indirectReward", reward);
        reward = this.baseMapper.getCurrentReward(player.getId());
        if (reward == null)
            reward = 0L;
        ajax.put("currentReward", reward);
        return ajax;
    }

    @Override
    public PageResult<JuniorPlayerDTO> getJuniorPlayers(PageBody dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        PageResult<JuniorPlayerDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.playerMapper.countJuniorPlayer(player.getId());
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<JuniorPlayerDTO> records = this.playerMapper.getJuniorPlayers(player.getId(), offset, dto.getPageSize());
        if (records != null) {
            Integer level = 0;
            Integer juniorCount = 0;
            Long totalReward = 0L;
            for (JuniorPlayerDTO record : records) {
                IntPairDTO pair = this.baseMapper.getLevelAndJuniorCount(record.getPlayerId());
                if (pair != null) {
                    level = pair.getValue1();
                    juniorCount = pair.getValue2();
                } else {
                    level = 0;
                    juniorCount = 0;
                }
                record.setLevel(level);
                record.setJuniorCount(juniorCount);
                totalReward = this.baseMapper.getTotalReward(player.getId(), record.getPlayerId());
                if (totalReward == null)
                    totalReward = 0L;
                record.setTotalReward(totalReward);
            }
        }
        result.setRecords(records);
        return result;
    }

    @Override
    public PageResult<RewardDTO> getRewards(PageBody dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        PageResult<RewardDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.baseMapper.countReward(player.getId());
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<RewardDTO> records = this.baseMapper.getRewards(player.getId(), offset, dto.getPageSize());
        result.setRecords(records);
        return result;
    }

    @Override
    @Transactional
    public AjaxResult collect() {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        List<LongPairDTO> rewards = this.baseMapper.getCurrentRewards(player.getId());
        if (rewards == null || rewards.isEmpty())
            throw new ForbiddenException(NiuMaCodeEnum.REWARD_ERROR.getCode(), "You have no reward now");
        Long total = 0L;
        List<Long> ids = new ArrayList<>(rewards.size());
        for (LongPairDTO pair : rewards) {
            ids.add(pair.getValue1());
            total += pair.getValue2();
        }
        Capital capital = this.capitalMapper.selectById(player.getId());
        Long deposit = capital.getDeposit();
        deposit += total;
        Integer count = this.capitalMapper.setCapital(player.getId(), null, deposit, null, capital.getVersion());
        if ((count == null) || (count < 1))
            throw new InternalServerException(ResultCodeEnum.SERVICE_UNAVAILABLE);
        // 添加领取记录
        AgencyCollect entity = new AgencyCollect();
        entity.setPlayerId(player.getId());
        entity.setAmount(total);
        entity.setTime(LocalDateTime.now());
        this.agencyCollectMapper.insert(entity);
        this.baseMapper.collectRewards(ids, entity.getId());
        this.baseMapper.addTotalReward(player.getId(), total);

        AjaxResult ajax = AjaxResult.successEx();
        ajax.put("amount", total);
        ajax.put("deposit", deposit);
        total = this.baseMapper.getTotalReward1(player.getId());
        ajax.put("totalReward", total);
        return ajax;
    }

    @Override
    public PageResult<CollectRecordDTO> collectRecord(PageBody dto) {
        if (dto.getPageNum() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_NUM_ERROR);
        if (dto.getPageSize() < 1)
            throw new BadRequestException(ResultCodeEnum.PAGE_SIZE_ERROR);
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        PageResult<CollectRecordDTO> result = new PageResult<>();
        result.setCodeEnum(ResultCodeEnum.SUCCESS);
        result.setPageNum(dto.getPageNum());
        Integer totalNum = this.baseMapper.countCollect(player.getId());
        Integer offset = (dto.getPageNum() - 1) * dto.getPageSize();
        result.setTotal(totalNum);
        if (offset >= totalNum)
            return result;
        List<CollectRecordDTO> records = this.baseMapper.getCollectRecord(player.getId(), offset, dto.getPageSize());
        result.setRecords(records);
        return result;
    }

    @Override
    public AjaxResult addJunior(String playerId) {
        LoginPlayer player = PlayerSecurityUtils.getLoginPlayer();
        if (player == null)
            throw new InternalServerException("Current login player is null, this is unexpected");
        if (playerId.equals(player.getId()))
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "You can not add yourself as junior agency");
        LambdaQueryWrapper<Agency> query = Wrappers.lambdaQuery();
        query.eq(Agency::getPlayerId, player.getId());
        Agency agency = this.baseMapper.selectOne(query);
        if (agency == null)
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "You are not an agency");
        if (agency.getLevel().equals(3))
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "The third level agency can not add junior agency");
        Integer isAgency = this.baseMapper.isAgency(playerId);
        if (CommonUtils.predicate(isAgency))
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "The specified player is already an agency");
        Player entity = this.playerMapper.selectById(playerId);
        if (entity == null)
            throw new NotFoundException(NiuMaCodeEnum.PLAYER_NOT_EXIST);
        if (CommonUtils.predicate(entity.getBanned()) || CommonUtils.predicate(entity.getDelFlag()))
            throw new ForbiddenException(NiuMaCodeEnum.PLAYER_STATUS_ERROR);
        if (!(player.getId().equals(entity.getAgencyId())))
            throw new ForbiddenException(NiuMaCodeEnum.AGENCY_ERROR.getCode(), "You are not the superior agency of the specified player");
        Agency tmp = new Agency();
        tmp.setPlayerId(playerId);
        tmp.setSuperiorId(player.getId());
        tmp.setLevel(agency.getLevel() + 1);
        this.baseMapper.insert(tmp);
        return AjaxResult.successEx();
    }
}
