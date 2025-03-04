package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 百人牛牛游戏实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.19
 */
@Data
@TableName("game_niu_niu_100")
public class GameNiu100 {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 场地id
     */
    private String venueId;

    /**
     * 6位数编号，方便玩家输入编号进入游戏房
     */
    private String number;

    /**
     * 奖池押金
     */
    private Long deposit;

    /**
     * 是否为公开房
     */
    private Integer isPublic;

    /**
     * 庄家(房主)玩家id
     */
    private String bankerId;
}
