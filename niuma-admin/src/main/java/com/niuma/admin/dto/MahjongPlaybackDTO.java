package com.niuma.admin.dto;

import lombok.Data;

import java.util.List;

/**
 * 麻将游戏回放数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.18
 */
@Data
public class MahjongPlaybackDTO {
    /**
     * 场地id
     */
    private String venueId;

    /**
     * 房间编号
     */
    private String number;

    /**
     * 模式，0-扣钻模式，1-扣利模式
     */
    private Integer mode;

    /**
     * 底注
     */
    private Integer diZhu;

    /**
     * 玩法配置
     */
    private Integer config;

    /**
     * 局序号
     */
    private Integer roundNo;

    /**
     * 庄家座位号
     */
    private Integer banker;

    /**
     * 玩家列表
     */
    private List<PlayerBaseDTO> players;

    /**
     * 回放数据打包成base64
     */
    private String base64;

    /**
     * 结算时间
     */
    private String time;
}
