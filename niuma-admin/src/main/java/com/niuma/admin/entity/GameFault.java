package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 游戏故障实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.21
 */
@Data
@TableName("game_fault")
public class GameFault {
    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 场地id
     */
    private String venueId;

    /**
     * 服务器id
     */
    private String serverId;

    /**
     * 是否已处理
     */
    private Integer processed;

    /**
     * 记录故障时间
     */
    private LocalDateTime time;
}
