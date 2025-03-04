package com.niuma.common.exception.http;

import org.springframework.http.HttpStatus;

public class HttpException extends RuntimeException {
    public HttpException(HttpStatus status) {
        this.status = status;
        this.code = null;
    }

    public HttpException(HttpStatus status, String message) {
        super(message);
        this.status = status;
        this.code = null;
    }

    public HttpException(HttpStatus status, String code, String message) {
        super(message);
        this.status = status;
        this.code = code;
    }

    /**
     *  HTTP响应状态
     */
    private final HttpStatus status;

    /**
     * 逻辑错误码
     */
    private final String code;

    public HttpStatus getStatus() {
        return this.status;
    }

    public String getCode() {
        return this.code;
    }
}
