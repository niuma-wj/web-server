package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 空游戏实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.18
 */
@Data
@TableName("game_dumb")
public class GameDumb {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 场地id
     */
    private String venueId;

    /**
     * 名称
     */
    private String name;

    /**
     * 人数限制
     */
    private Integer maxPlayers;
}
