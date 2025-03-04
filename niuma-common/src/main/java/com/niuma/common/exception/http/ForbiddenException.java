package com.niuma.common.exception.http;

import com.niuma.common.constant.ICodeEnum;
import org.springframework.http.HttpStatus;

/**
 * 403异常
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.04
 */
public class ForbiddenException extends HttpException {
    public ForbiddenException() {
        super(HttpStatus.FORBIDDEN);
    }

    public ForbiddenException(String message) {
        super(HttpStatus.FORBIDDEN, message);
    }

    public ForbiddenException(String code, String message) {
        super(HttpStatus.FORBIDDEN, code, message);
    }

    public ForbiddenException(ICodeEnum code) {
        super(HttpStatus.FORBIDDEN, code.getCode(), code.getDesc());
    }
}