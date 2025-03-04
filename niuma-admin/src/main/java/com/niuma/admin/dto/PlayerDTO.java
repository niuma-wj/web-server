package com.niuma.admin.dto;

import lombok.Data;

/**
 * 玩家数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.23
 */
@Data
public class PlayerDTO extends PlayerBaseDTO {
    /**
     * 联系电话
     */
    private String phone;

    /**
     * 玩家性别(0-未知 1-男 2-女)
     */
    private Integer sex;

    /**
     * 代理玩家id
     */
    private String agencyId;

    /**
     * 代理玩家，格式："玩家昵称(玩家id)"
     */
    private String agency;

    /**
     * 当前所在的游戏房间，格式："游戏类型(房间编号)"，如："标准麻将(123456)"
     */
    private String gameRoom;

    /**
     * 最近登录ip
     */
    private String loginIp;

    /**
     * 最近登录时间
     */
    private String loginDate;

    /**
     * 最近心跳时间戳，超过30秒无心跳认为离线
     */
    private Long heartbeat;

    /**
     * 是否在线
     */
    private Integer online;

    /**
     * 是否被禁用
     */
    private Integer banned;
}
