package com.niuma.admin.controller.game;

import com.niuma.admin.dto.CollectRecordDTO;
import com.niuma.admin.dto.JuniorPlayerDTO;
import com.niuma.admin.dto.PlayerIdDTO;
import com.niuma.admin.dto.RewardDTO;
import com.niuma.admin.service.IAgencyService;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 代理相关控制器
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.15
 */
@RestController
@RequestMapping("/player/agency")
public class AgencyController {
    @Autowired
    private IAgencyService agencyService;

    /**
     * 绑定代理玩家
     * @param dto 请求体
     */
    @PostMapping("/bind")
    public AjaxResult bindAgency(@RequestBody @Validated PlayerIdDTO dto) {
        return this.agencyService.bindAgency(dto.getPlayerId());
    }

    /**
     * 获取玩家代理信息
     */
    @GetMapping("/get")
    public AjaxResult getAgency() {
        return this.agencyService.getAgency();
    }

    /**
     * 查询直接下级玩家列表
     * @param dto 请求体
     */
    @PostMapping("/junior")
    public PageResult<JuniorPlayerDTO> getJuniorPlayers(@RequestBody @Validated PageBody dto) {
        return this.agencyService.getJuniorPlayers(dto);
    }

    /**
     * 查询奖励列表
     * @param dto 请求体
     */
    @PostMapping("/reward")
    public PageResult<RewardDTO> getRewards(@RequestBody @Validated PageBody dto) {
        return this.agencyService.getRewards(dto);
    }

    /**
     * 领取代理奖励
     */
    @GetMapping("/collect")
    public AjaxResult collect() {
        return this.agencyService.collect();
    }

    /**
     * 查询领取奖励记录
     * @param dto 请求体
     */
    @PostMapping("/collect/record")
    public PageResult<CollectRecordDTO> collectRecord(@RequestBody @Validated PageBody dto) {
        return this.agencyService.collectRecord(dto);
    }

    /**
     * 添加下级代理
     * @param dto 请求体
     */
    @PostMapping("/add/junior")
    public AjaxResult addJunior(@RequestBody @Validated PlayerIdDTO dto) {
        return this.agencyService.addJunior(dto.getPlayerId());
    }
}
