package com.niuma.admin.controller.common;

import java.io.IOException;
import javax.servlet.http.HttpServletResponse;

import com.niuma.admin.service.ICaptchaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.niuma.common.core.domain.AjaxResult;

/**
 * 验证码操作处理
 * 
 * @author ruoyi
 */
@RestController
public class CaptchaController {
    @Autowired
    private ICaptchaService captchaService;

    /**
     * 生成验证码
     */
    @GetMapping("/captchaImage")
    public AjaxResult getCode(HttpServletResponse response) throws IOException {
        return this.captchaService.getCode(0);
    }
}
