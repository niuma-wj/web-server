package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 代理玩家领取奖励记录实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.17
 */
@Data
@TableName("agency_collect")
public class AgencyCollect {
    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 玩家id
     */
    private String playerId;

    /**
     * 领取数量
     */
    private Long amount;

    /**
     * 领取时间
     */
    private LocalDateTime time;
}
