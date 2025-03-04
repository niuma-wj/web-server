package com.niuma.admin.dto;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * 玩家上传定位信息
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.21
 */
@Data
public class LocationDTO {
    @NotNull(message = "纬度不能为空")
    private Double latitude;

    @NotNull(message = "经度不能为空")
    private Double longitude;

    @NotNull(message = "海拔不能为空")
    private Double altitude;
}
