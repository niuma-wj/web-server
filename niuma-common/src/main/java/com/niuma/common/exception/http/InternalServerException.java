package com.niuma.common.exception.http;

import com.niuma.common.constant.ICodeEnum;
import org.springframework.http.HttpStatus;

/**
 * 500异常
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.04
 */
public class InternalServerException extends HttpException {
    public InternalServerException() {
        super(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    public InternalServerException(String message) {
        super(HttpStatus.INTERNAL_SERVER_ERROR, message);
    }

    public InternalServerException(String code, String message) {
        super(HttpStatus.INTERNAL_SERVER_ERROR, code, message);
    }

    public InternalServerException(ICodeEnum code) {
        super(HttpStatus.INTERNAL_SERVER_ERROR, code.getCode(), code.getDesc());
    }
}
