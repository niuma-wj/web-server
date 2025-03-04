package com.niuma.common.core.domain.model;

import lombok.Data;

/**
 * 登录玩家信息
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
@Data
public class LoginPlayer {
    // 玩家id
    private String id;

    // 玩家名(登录账号)
    private String name;

    // 玩家昵称
    private String nickName;

    // 唯一标识（每次重新登录都会发生改变，用于退出登录将token失效）
    private String uuid;

    // 登录时间
    private Long loginTime;

    // 令牌过期时间
    private Long expireTime;
}
