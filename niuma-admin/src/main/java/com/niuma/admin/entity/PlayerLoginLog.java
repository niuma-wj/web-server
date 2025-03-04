package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.niuma.common.core.domain.BaseEntity;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 玩家登录日志实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.05
 */
@Data
@TableName("player_login_log")
public class PlayerLoginLog {
    // 主键
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    // 玩家id
    private String playerId;

    // 玩家昵称
    private String nickname;

    // 登录ip
    private String loginIp;

    // 登录地址
    private String loginLocation;

    // 登录时间
    private LocalDateTime loginTime;
}
