package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 玩家注册请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.21
 */
@Data
public class RegisterDTO {
    // 账号
    @NotBlank(message = "账号不能为空")
    private String name;

    // 昵称
    @NotBlank(message = "昵称不能为空")
    private String nickname;

    // 玩家性别(0-未知 1-男 2-女)
    private Integer sex;

    // 密码
    @NotBlank(message = "密码不能为空")
    private String password;

    // 验证码
    @NotBlank(message = "验证码不能为空")
    private String code;

    // 唯一标识
    @NotBlank(message = "唯一标识不能为空")
    private String uuid;
}
