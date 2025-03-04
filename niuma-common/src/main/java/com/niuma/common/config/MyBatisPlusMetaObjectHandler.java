package com.niuma.common.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.niuma.common.utils.SecurityUtils;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * MybatisPlus插入和更新时自动添加相应字段
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.05
 */
@Component
public class MyBatisPlusMetaObjectHandler implements MetaObjectHandler {
    public static final String CREATE_BY = "createBy";
    public static final String CREATE_TIME = "createTime";
    public static final String UPDATE_BY = "updateBy";
    public static final String UPDATE_TIME = "updateTime";

    // 插入时的填充策略
    @Override
    public void insertFill(MetaObject metaObject) {
        // 起始版本 3.3.0(推荐使用)
        LocalDateTime nowTime = LocalDateTime.now();
        this.setFieldValByName(CREATE_BY, SecurityUtils.getUsername(), metaObject);
        this.setFieldValByName(CREATE_TIME, nowTime, metaObject);
        this.setFieldValByName(UPDATE_BY, SecurityUtils.getUsername(), metaObject);
        this.setFieldValByName(UPDATE_TIME, nowTime, metaObject);
    }

    // 更新时的填充策略
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName(UPDATE_BY, SecurityUtils.getUsername(), metaObject);
        this.setFieldValByName(UPDATE_TIME, LocalDateTime.now(), metaObject);
    }
}
