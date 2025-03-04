package com.niuma.admin.dto;

import lombok.Data;

/**
 * 逮狗腿单局记录中玩家的输赢得分数据数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.08
 */
@Data
public class LackeyRoundPlayerDTO {
    /**
     * 玩家id
     */
    private String playerId;

    /**
     * 玩家昵称
     */
    private String nickname;

    /**
     * 头像图片链接地址
     */
    private String headImgUrl;

    /**
     * 是否明牌，0-否，1-是
     */
    private Integer showCard;

    /**
     * 输赢分
     */
    private Float score;

    /**
     * 喜钱分
     */
    private Integer xiQian;

    /**
     * 输赢金币数量
     */
    private Integer winGold;
}
