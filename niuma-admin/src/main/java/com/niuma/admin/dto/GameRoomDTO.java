package com.niuma.admin.dto;


import lombok.Data;

/**
 * 游戏房数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.25
 */
@Data
public class GameRoomDTO {
    /**
     * 场地id
     */
    private String venueId;

    /**
     * 房主id
     */
    private String ownerId;

    /**
     * 房主昵称
     */
    private String ownerName;

    /**
     * 编号
     */
    private String number;

    /**
     * 模式
     */
    private Integer mode;

    /**
     * 底注
     */
    private Integer diZhu;

    /**
     * 规则
     */
    private Integer rule;

    /**
     * 房间等级
     */
    private Integer level;

    /**
     * 是否为公开房
     */
    private Integer isPublic;

    /**
     * 奖池押金
     */
    private Long deposit;

    /**
     * 状态
     */
    private Integer status;

    /**
     * 创建时间
     */
    private String createTime;
}
