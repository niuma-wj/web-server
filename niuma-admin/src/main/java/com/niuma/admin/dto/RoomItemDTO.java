package com.niuma.admin.dto;

import lombok.Data;

/**
 * 公开房数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.31
 */
@Data
public class RoomItemDTO {
    /**
     * 场地id
     */
    private String venueId;

    /**
     * 房间编号
     */
    private String number;

    /**
     * 游戏类型
     */
    private Integer gameType;

    /**
     * 创建者ID
     */
    private String ownerId;

    /**
     * 创建者昵称
     */
    private String ownerName;

    /**
     * 创建者头像图片链接地址
     */
    private String ownerHeadUrl;

    /**
     * 模式
     */
    private Integer mode;

    /**
     * 底注
     */
    private Integer diZhu;

    /**
     * 奖池押金
     */
    private Long deposit;

    /**
     * 玩家数量
     */
    private Integer playerCount;

    /**
     * 最大玩家数量
     */
    private Integer maxPlayerNums;

    /**
     * 额外信息json打包成base64
     */
    private String base64;
}
