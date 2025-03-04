package com.niuma.admin.dto;

import lombok.Data;

import java.util.List;

/**
 * 逮狗腿单局记录数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.08
 */
@Data
public class LackeyRoundDTO {
    /**
     * 场地id
     */
    private String venueId;

    /**
     * 房间编号
     */
    private String number;

    /**
     * 房间等级
     */
    private Integer level;

    /**
     * 底注
     */
    private Integer diZhu;

    /**
     * 倍率
     */
    private Integer beiLv;

    /**
     * 局号数
     */
    private Integer roundNo;

    /**
     * 地主座位号
     */
    private Integer landlord;

    /**
     * 狗腿座位号
     */
    private Integer lackey;

    /**
     * 本局结算时间
     */
    private String time;

    /**
     * 所有玩家输赢得分数据
     */
    private List<LackeyRoundPlayerDTO> players;
}
