package com.niuma.common.exception.http;

import com.niuma.common.constant.ICodeEnum;
import org.springframework.http.HttpStatus;

/**
 * 404异常
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.04
 */
public class NotFoundException extends HttpException {
    public NotFoundException() {
        super(HttpStatus.NOT_FOUND);
    }

    public NotFoundException(String message) {
        super(HttpStatus.NOT_FOUND, message);
    }

    public NotFoundException(String code, String message) {
        super(HttpStatus.NOT_FOUND, code, message);
    }

    public NotFoundException(ICodeEnum code) {
        super(HttpStatus.NOT_FOUND, code.getCode(), code.getDesc());
    }
}
