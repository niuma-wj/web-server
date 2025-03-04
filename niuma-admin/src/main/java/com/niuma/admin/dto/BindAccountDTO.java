package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 绑定账号请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.03
 */
@Data
public class BindAccountDTO {
    // 银行密码
    private String password;

    @NotBlank(message = "账号不能为空")
    private String account;

    @NotBlank(message = "姓名不能为空")
    private String name;

    // 账号类型0-支付宝，1-银行卡
    @NotNull(message = "账号类型不能为空")
    private Integer type;
}
