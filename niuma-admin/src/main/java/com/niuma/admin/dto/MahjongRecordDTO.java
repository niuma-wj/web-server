package com.niuma.admin.dto;

import lombok.Data;

import java.util.List;

/**
 * 麻将游戏记录数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.18
 */
@Data
public class MahjongRecordDTO {
    /**
     * 记录id
     */
    private Long id;

    /**
     * 场地id
     */
    private String venueId;

    /**
     * 房间编号
     */
    private String number;

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
     * 各玩家得分
     */
    private List<Integer> scores;

    /**
     * 各玩家赢的金币数量
     */
    private List<Long> winGolds;

    /**
     * 结算时间
     */
    private String time;
}
