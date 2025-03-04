package com.niuma.admin.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 奖励数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.17
 */
@Data
public class RewardDTO {
    // 下级玩家或代理id
    private String juniorId;

    // 金额
    private Long amount;

    // 领取记录id，为null表示未领取
    private Long collectId;

    // 说明
    private String remark;

    // 时间
    private LocalDateTime time;
}
