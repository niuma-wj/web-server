package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 设置银行密码请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.01
 */
@Data
public class BankPwdDTO {
    private String oldPassword;

    @NotBlank(message = "新密码不能为空")
    private String newPassword;
}
