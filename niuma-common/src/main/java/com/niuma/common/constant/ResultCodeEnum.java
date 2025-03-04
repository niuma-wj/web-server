package com.niuma.common.constant;

/**
 * 响应结果代码枚举类型
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.04
 */
public enum ResultCodeEnum implements ICodeEnum {
    SUCCESS("00000000", "Success"),
    BAD_REQUEST("00000400", "Bad Request error"),
    UNAUTHORIZED("00000401", "Unauthorized"),
    FORBIDDEN("00000403", "Request forbidden error"),
    NOT_FOUND("00000404", "Resource not found"),
    INTERNAL_SERVER_ERROR("00000500", "Internal server error"),
    SERVICE_UNAVAILABLE("00000503", "Service unavailable"),
    WARN("00000601", "warn"),
    REDIS_ACCESS_ERROR("00001001", "Redis access error"),
    PAGE_NUM_ERROR("00001002", "Page number must be greater than 0"),
    PAGE_SIZE_ERROR("00001003", "Page size must be greater than 0"),
    HTTP_ACCESS_ERROR("00001004", "Http access error"),
    ;

    private final String code;
    private final String desc;

    ResultCodeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    @Override
    public String getCode() {
        return this.code;
    }

    @Override
    public String getDesc() {
        return this.desc;
    }
}
