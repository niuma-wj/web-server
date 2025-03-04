package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.niuma.common.core.domain.MyBaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 玩家实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.03
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("player")
public class Player extends MyBaseEntity {
    // 玩家id
    @TableId
    private String id;

    // 登录账号
    private String name;

    // 登录密码
    private String password;

    // 玩家昵称
    private String nickname;

    // 手机号
    private String phone;

    // 玩家性别(0-未知 1-男 2-女)
    private Integer sex;

    // 玩家头像
    private String avatar;

    // 上级代理玩家id
    private String agencyId;

    // 最后登录IP
    private String loginIp;

    // 最后登录时间
    private LocalDateTime loginDate;

    // 账号封禁标志(0未封禁 1-已封禁)
    private Integer banned;

    // 删除标志(0未删除 1-已删除)
    private Integer delFlag;
}
