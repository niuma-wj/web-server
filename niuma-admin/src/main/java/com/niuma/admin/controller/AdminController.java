package com.niuma.admin.controller;

import com.niuma.admin.dto.GameRoomDTO;
import com.niuma.admin.dto.GameRoomReqDTO;
import com.niuma.admin.dto.PlayerDTO;
import com.niuma.admin.dto.PlayerReqDTO;
import com.niuma.admin.service.IGameService;
import com.niuma.admin.service.IPlayerService;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.dto.TextDTO;
import com.niuma.common.page.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 后台管理相关控制器
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.23
 */
@RestController
@RequestMapping("/admin")
public class AdminController {
    @Autowired
    private IPlayerService playerService;

    @Autowired
    private IGameService gameService;

    /**
     * 分页获取玩家列表
     * @param dto 请求体
     * @return 分页玩家数据
     */
    @PostMapping("/player/page")
    @PreAuthorize("@ss.hasPermi('niuma:player')")
    public PageResult<PlayerDTO> getPlayer(@RequestBody PlayerReqDTO dto) {
        return this.playerService.getPlayer(dto);
    }

    /**
     * 禁用或启用玩家
     * @param playerId 玩家id
     * @return 响应结果
     */
    @PostMapping("/player/ban/{playerId}")
    @PreAuthorize("@ss.hasPermi('niuma:player')")
    public AjaxResult banPlayer(@PathVariable("playerId") String playerId) {
        this.playerService.banPlayer(playerId);
        return AjaxResult.successEx();
    }

    /**
     * 查询麻将房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    @PostMapping("/mahjong/page")
    @PreAuthorize("@ss.hasPermi('niuma:mahjong')")
    public PageResult<GameRoomDTO> getMahjong(@RequestBody GameRoomReqDTO dto) {
        return this.gameService.getMahjong(dto);
    }

    /**
     * 查询比鸡房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    @PostMapping("/bi-ji/page")
    @PreAuthorize("@ss.hasPermi('niuma:biji')")
    public PageResult<GameRoomDTO> getBiJi(@RequestBody GameRoomReqDTO dto) {
        return this.gameService.getBiJi(dto);
    }

    /**
     * 查询逮狗腿房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    @PostMapping("/lackey/page")
    @PreAuthorize("@ss.hasPermi('niuma:lackey')")
    public PageResult<GameRoomDTO> getLackey(@RequestBody GameRoomReqDTO dto) {
        return this.gameService.getLackey(dto);
    }

    /**
     * 查询百人牛牛房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    @PostMapping("/niu100/page")
    @PreAuthorize("@ss.hasPermi('niuma:niu100')")
    public PageResult<GameRoomDTO> getNiu100(@RequestBody GameRoomReqDTO dto) {
        return this.gameService.getNiu100(dto);
    }

    /**
     * 创建机器人
     * @param dto 机器人昵称列表，以英文逗号分隔
     * @return
     */
    @PostMapping("/robot/create")
    public AjaxResult createRobots(@RequestBody TextDTO dto) {
        return this.playerService.createRobots(dto.getText());
    }
}
