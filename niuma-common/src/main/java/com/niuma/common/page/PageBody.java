package com.niuma.common.page;

import lombok.Data;

import javax.validation.constraints.NotNull;

/**
 * 分页请求体基类
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.07
 */
@Data
public class PageBody {
    // 请求页(从1开始)
    @NotNull(message = "请求页号不能为空")
    private Integer pageNum;

    // 页大小(每页最大显示记录数量)
    @NotNull(message = "页大小不能为空")
    private Integer pageSize;

    // 排序字段
    private String orderBy;

    // 是否升序
    private Integer asc;
}