package com.niuma.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 区域实体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.11
 */
@Data
@TableName("district")
public class District {
    /**
     *  区域id
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 区域名称
     */
    private String name;

    /**
     * 进入区域需要的最小金币数量
     */
    private Long goldNeed;

    /**
     * 进入区域需要的最小钻石数量
     */
    private Long diamondNeed;
}
