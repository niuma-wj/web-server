package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 麻将游戏实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.20
 */
@Data
@TableName("game_mahjong")
public class GameMahjong {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 场地id
     */
    private String venueId;

    /**
     * 6位数编号，方便玩家输入编号进入游戏房
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
     * 玩法规则
     */
    private Integer rule;
}
