package com.niuma.admin.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 麻将记录实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.18
 */
@Data
public class MahjongRecord {
    /**
     * 记录id
     */
    private Long id;

    /**
     * 场地id
     */
    private String venueId;

    /**
     * 牌局序号
     */
    private Integer roundNo;

    /**
     * 玩家id
     */
    private String playerId0;

    /**
     * 玩家id
     */
    private String playerId1;

    /**
     * 玩家id
     */
    private String playerId2;

    /**
     * 玩家id
     */
    private String playerId3;

    /**
     * 庄家座位号
     */
    private Integer banker;

    /**
     * 玩家得分
     */
    private Integer score0;

    /**
     * 玩家得分
     */
    private Integer score1;

    /**
     * 玩家得分
     */
    private Integer score2;

    /**
     * 玩家得分
     */
    private Integer score3;

    /**
     * 玩家获利金币数量
     */
    private Long winGold0;

    /**
     * 玩家获利金币数量
     */
    private Long winGold1;

    /**
     * 玩家获利金币数量
     */
    private Long winGold2;

    /**
     * 玩家获利金币数量
     */
    private Long winGold3;

    /**
     * 记录时间
     */
    private LocalDateTime time;
}
