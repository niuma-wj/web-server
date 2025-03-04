package com.niuma.common.page;

import com.niuma.common.constant.ICodeEnum;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 分页数据结果数据传输对象
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.07
 */
@Data
public class PageResult<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    /** 状态码 */
    private String code;

    /** 消息 */
    private String msg;

    /** 请求页(从1开始) */
    private int pageNum = 1;

    /** 总记录数 */
    private int total = 0;

    /** 列表数据 */
    private List<T> records;

    public PageResult() {}

    /**
     * @param records 列表数据
     * @param pageNum 页号
     * @param total 总记录数
     */
    public PageResult(List<T> records, int pageNum, int total) {
        this.records = records;
        this.pageNum = pageNum;
        this.total = total;
    }

    public void setCodeEnum(ICodeEnum codeEnum) {
        this.code = codeEnum.getCode();
        this.msg = codeEnum.getDesc();
    }
}
