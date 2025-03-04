package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 逮狗腿游戏实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.27
 */
@Data
@TableName("game_lackey")
public class GameLackey {
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
     * 房间等级
     */
    private Integer level;

    /**
     * 模式，0-扣钻模式，1-扣利模式
     */
    private Integer mode;

    /**
     * 底注
     */
    private Integer diZhu;
}