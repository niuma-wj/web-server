package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 玩家id数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.16
 */
@Data
public class PlayerIdDTO {
    @NotBlank(message = "玩家id不能为空")
    private String playerId;
}
