package com.niuma.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.niuma.admin.dto.*;
import com.niuma.admin.entity.Player;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.page.PageResult;

/**
 * 玩家相关服务接口
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
public interface IPlayerService extends IService<Player> {
    /**
     * 登录
     * @param dto
     */
    AjaxResult login(PlayerLoginDTO dto);

    /**
     * 登出
     */
    AjaxResult logout();

    /**
     * 注册
     * @param dto
     */
    AjaxResult register(RegisterDTO dto);

    /**
     * 刷新玩家消息密钥
     */
    AjaxResult refreshMessageSecret();

    /**
     * 玩家心跳
     */
    void heartbeat();

    AjaxResult getInfo();

    AjaxResult getPersonalData();

    AjaxResult location(LocationDTO dto);

    /**
     * 分页获取玩家数据
     * @param dto 请求体
     * @return 分页玩家数据
     */
    PageResult<PlayerDTO> getPlayer(PlayerReqDTO dto);

    /**
     * 禁用或启用玩家
     * @param playerId 玩家id
     */
    void banPlayer(String playerId);
}
