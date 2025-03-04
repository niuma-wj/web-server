package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 转账请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.09
 */
@Data
public class TransferDTO {
    // 银行密码
    private String password;

    @NotBlank(message = "目标玩家ID不能为空")
    private String playerId;

    // 转账数量
    @NotNull(message = "转账数量不能为空")
    private Long amount;
}
