package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 比鸡游戏实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.12.27
 */
@Data
@TableName("game_bi_ji")
public class GameBiJi {
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
     * 是否公开房间
     */
    private Integer isPublic;
}
