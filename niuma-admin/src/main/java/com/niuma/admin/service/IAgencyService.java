package com.niuma.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.niuma.admin.dto.CollectRecordDTO;
import com.niuma.admin.dto.JuniorPlayerDTO;
import com.niuma.admin.dto.RewardDTO;
import com.niuma.admin.entity.Agency;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;

/**
 * 代理相关服务接口
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.15
 */
public interface IAgencyService extends IService<Agency> {
    AjaxResult bindAgency(String playerId);

    AjaxResult getAgency();

    PageResult<JuniorPlayerDTO> getJuniorPlayers(PageBody dto);

    PageResult<RewardDTO> getRewards(PageBody dto);

    AjaxResult collect();

    PageResult<CollectRecordDTO> collectRecord(PageBody dto);

    AjaxResult addJunior(String playerId);
}
