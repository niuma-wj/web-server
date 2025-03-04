package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 转账实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.09
 */
@Data
@TableName("transfer")
public class Transfer {
    // 主键
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    // 转账玩家id
    private String srcPlayerId;

    // 目标玩家id
    private String dstPlayerId;

    // 转账数量
    private Long amount;

    // 转账时间
    private LocalDateTime time;
}
