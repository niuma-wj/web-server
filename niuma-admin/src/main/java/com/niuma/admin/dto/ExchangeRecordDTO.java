package com.niuma.admin.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 兑换记录数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.07
 */
@Data
public class ExchangeRecordDTO {
    // 兑换数量
    private Long amount;

    // 兑换账户
    private String account;

    // 兑换账户名
    private String accountName;

    // 账户类型（0-支付宝，1-银行）
    private Integer accountType;

    // 状态，0-审核中，1-兑换成功，2-兑换失败
    private Integer status;

    // 状态，0-审核中，1-兑换成功，2-兑换失败
    private String orderNumber;

    // 申请时间
    private LocalDateTime applyTime;

    // 处理时间
    private LocalDateTime disposeTime;
}
