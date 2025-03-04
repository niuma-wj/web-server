package com.niuma.common.exception.http;

import com.niuma.common.constant.ICodeEnum;
import org.springframework.http.HttpStatus;

/**
 * 401异常
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.04
 */
public class UnauthorizedException extends HttpException {
    public UnauthorizedException() {
        super(HttpStatus.UNAUTHORIZED);
    }

    public UnauthorizedException(String message) {
        super(HttpStatus.UNAUTHORIZED, message);
    }

    public UnauthorizedException(String code, String message) {
        super(HttpStatus.UNAUTHORIZED, code, message);
    }

    public UnauthorizedException(ICodeEnum code) {
        super(HttpStatus.UNAUTHORIZED, code.getCode(), code.getDesc());
    }
}
