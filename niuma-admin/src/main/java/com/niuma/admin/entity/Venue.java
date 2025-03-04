package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 场地实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.18
 */
@Data
@TableName("venue")
public class Venue {
    /**
     * 场地id
     */
    @TableId
    private String id;

    /**
     * 所有者(创建者)玩家id
     */
    private String ownerId;

    /**
     * 游戏类型
     */
    private Integer gameType;

    /**
     * 场地状态
     * 0-正常，1-场地已锁定，2-游戏已结束，3-游戏异常中止，只有正常状态的场地游戏可以加载并运行游戏逻辑
     */
    private Integer status;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}
