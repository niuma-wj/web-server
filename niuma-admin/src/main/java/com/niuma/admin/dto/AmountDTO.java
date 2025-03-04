package com.niuma.admin.dto;

import lombok.Data;
import javax.validation.constraints.NotNull;

/**
 * 数额请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.03
 */
@Data
public class AmountDTO {
    // 银行密码
    private String password;

    @NotNull(message = "数量不能为空")
    private Long amount;
}
