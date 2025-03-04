package com.niuma.admin.service;

import com.niuma.common.core.domain.AjaxResult;

import java.io.IOException;

/**
 * 验证码服务接口
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
public interface ICaptchaService {
    /**
     * 生成验证码
     * @param type 验证码类型：0-根据配置，1-强制数学，2-强制字符
     * @return 响应结果，uuid-唯一标识，img-验证码图像base64编码
     */
    AjaxResult getCode(int type) throws IOException;
}
