package com.niuma.common.utils.http;

/**
 * Http请求结果
 */
public class HttpResult {
    // 响应状态码
    private int code = 200;

    // 响应体文本
    private String body;

    public void setCode(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getBody() {
        return body;
    }
}
