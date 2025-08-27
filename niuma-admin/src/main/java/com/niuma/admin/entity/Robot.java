package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 玩家实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.03
 */
@Data
@TableName("robot")
public class Robot {
    // 主键
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    // 玩家id
    private String playerId;
}
