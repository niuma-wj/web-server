package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 玩家资产实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.01
 */
@Data
@TableName("capital")
public class Capital {
    /**
     *  玩家id
     */
    @TableId
    private String playerId;

    /**
     * 金币数量，系统中0.1元人民币对应100金币
     */
    private Long gold;

    /**
     * 金币存款
     */
    private Long deposit;

    /**
     * 钻石数量，系统中初始价为每25个金币购买1个钻石，即相当于0.025元人民币1枚钻石
     */
    private Long diamond;

    /**
     * 银行密码
     */
    private String password;

    /**
     * 支付宝账号
     */
    private String alipayAccount;

    /**
     * 支付宝账号姓名
     */
    private String alipayName;

    /**
     * 银行卡账号
     */
    private String bankAccount;

    /**
     * 银行卡账号姓名
     */
    private String bankName;

    /**
     * 因为玩家资产可能会被多个地方同时更新，为避免出现数据安全问题，使用乐观锁机制来做数据同步
     */
    private Long version;
}
