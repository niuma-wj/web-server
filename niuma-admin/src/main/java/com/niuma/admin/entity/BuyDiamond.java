package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.niuma.common.utils.StringUtils;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 购买钻石记录实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.25
 */
@Data
@TableName("buy_diamond")
public class BuyDiamond {
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
     * 钻石数量
     */
    private Long diamond;

    /**
     * 花费金币数量
     */
    private Long gold;

    /**
     * 购买时间
     */
    private LocalDateTime time;
}
