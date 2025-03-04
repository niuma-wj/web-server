package com.niuma.admin.dto;

import lombok.Data;

/**
 * 兑换账号数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.03
 */
@Data
public class AccountDTO {
    // 支付宝账号
    private String alipayAccount;

    // 支付宝账号姓名
    private String alipayName;

    // 银行账号
    private String bankAccount;

    // 银行账号姓名
    private String bankName;
}
