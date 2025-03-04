package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 代理实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.01
 */
@Data
@TableName("agency")
public class Agency {
    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 代理玩家id
     */
    private String playerId;

    /**
     * 本代理玩家的上级代理玩家id
     */
    private String superiorId;

    /**
     * 代理等级，只有1、2、3级
     */
    private Integer level;

    /**
     * 下级玩家人数
     */
    private Integer juniorCount;

    /**
     * 累计已领取奖励
     */
    private Long totalReward;
}
