package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 玩家进入游戏请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.10.30
 */
@Data
public class EnterDTO {
    @NotBlank(message = "场地ID不能为空")
    private String venueId;

    @NotNull(message = "游戏类型不能为空")
    private Integer gameType;
}
