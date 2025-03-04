package com.niuma.common.exception.http;

import com.niuma.common.constant.ICodeEnum;
import org.springframework.http.HttpStatus;

/**
 * 400异常
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.04
 */
public class BadRequestException extends HttpException {
    public BadRequestException() {
        super(HttpStatus.BAD_REQUEST);
    }

    public BadRequestException(String message) {
        super(HttpStatus.BAD_REQUEST, message);
    }

    public BadRequestException(String code, String message) {
        super(HttpStatus.BAD_REQUEST, code, message);
    }

    public BadRequestException(ICodeEnum code) {
        super(HttpStatus.BAD_REQUEST, code.getCode(), code.getDesc());
    }
}