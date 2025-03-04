package com.niuma.admin.dto;

import lombok.Data;

/**
 * 玩家基本信息数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.18
 */
@Data
public class PlayerBaseDTO {
    /**
     * 玩家Id
     */
    private String playerId;

    /**
     * 玩家昵称
     */
    private String nickname;

    /**
     * 头像图片url
     */
    private String headUrl;
}
