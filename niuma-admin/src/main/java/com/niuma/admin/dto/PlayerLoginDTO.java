package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 玩家登录请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
@Data
public class PlayerLoginDTO {
    // 玩家名
    @NotBlank(message = "账号不能为空")
    private String name;

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
