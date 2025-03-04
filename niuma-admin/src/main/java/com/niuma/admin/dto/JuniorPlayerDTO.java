package com.niuma.admin.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 下级玩家数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.16
 */
@Data
public class JuniorPlayerDTO {
    // 玩家id
    private String playerId;

    // 玩家昵称
    private String nickname;

    // 代理等级
    private Integer level;

    // 下级玩家人数
    private Integer juniorCount;

    // 累计产生奖励总数
    private Long totalReward;

    // 最近登录时间
    private LocalDateTime loginTime;
}
