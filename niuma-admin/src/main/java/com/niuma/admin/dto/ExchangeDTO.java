package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * 兑换请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.04
 */
@Data
public class ExchangeDTO {
    // 银行密码
    private String password;

    // 兑换数量
    @NotNull(message = "兑换数量不能为空")
    private Long amount;

    // 对话方式，0-支付宝，1-银行
    @NotNull(message = "兑换方式不能为空")
    private Integer type;
}
