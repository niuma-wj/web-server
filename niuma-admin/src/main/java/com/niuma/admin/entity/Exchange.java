package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 兑换记录实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.04
 */
@Data
@TableName("exchange")
public class Exchange {
    // 主键
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    // 玩家id
    private String playerId;

    // 数量
    private Long amount;

    // 兑换账号
    private String account;

    // 兑换账号姓名
    private String accountName;

    // 兑换账号类型
    private Integer accountType;

    // 状态，0-审核中，1-兑换成功，2-兑换失败
    private Integer status;

    // 申请时间
    private LocalDateTime applyTime;

    // 处理时间
    private LocalDateTime disposeTime;
}
