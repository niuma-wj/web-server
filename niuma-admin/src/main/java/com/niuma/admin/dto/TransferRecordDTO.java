package com.niuma.admin.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 转账记录数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.09
 */
@Data
public class TransferRecordDTO {
    // 目标玩家id
    private String dstPlayerId;

    // 目标玩家昵称
    private String dstNickname;

    // 转账数量
    private Long amount;

    // 转账数量
    private LocalDateTime time;
}
