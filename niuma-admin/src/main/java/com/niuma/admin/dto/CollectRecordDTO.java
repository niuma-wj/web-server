package com.niuma.admin.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 领取奖励记录数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.17
 */
@Data
public class CollectRecordDTO {
    // 领取数量
    private Long amount;

    // 领取时间
    private LocalDateTime time;
}
