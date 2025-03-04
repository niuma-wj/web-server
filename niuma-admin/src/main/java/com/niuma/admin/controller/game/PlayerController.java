package com.niuma.admin.controller.game;

import com.niuma.admin.dto.*;
import com.niuma.admin.service.ICaptchaService;
import com.niuma.admin.service.IPlayerService;
import com.niuma.common.annotation.Log;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.enums.BusinessType;
import com.niuma.common.enums.OperatorType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

/**
 * 玩家相关控制器
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
@RestController
@RequestMapping("/player")
public class PlayerController {
    @Autowired
    private ICaptchaService captchaService;

    @Autowired
    private IPlayerService playerService;

    /**
     * 生成验证码
     */
    @GetMapping("/captcha-image")
    public AjaxResult getCode() throws IOException {
        return this.captchaService.getCode(2);
    }

    /**
     * 登录
     * @param dto 登录信息
     */
    @PostMapping("/login")
    public AjaxResult login(@RequestBody @Validated PlayerLoginDTO dto) {
        return this.playerService.login(dto);
    }



    /**
     * 登出
     */
    @PostMapping("/logout")
    public AjaxResult logout() {
        return this.playerService.logout();
    }

    /**
     * 注册
     * @param dto 注册信息
     */
    @PostMapping("/register")
    public AjaxResult register(@RequestBody @Validated RegisterDTO dto) {
        return this.playerService.register(dto);
    }

    /**
     * 刷新消息密钥
     */
    @GetMapping("/message/secret")
    public AjaxResult refreshMessageSecret() {
        return this.playerService.refreshMessageSecret();
    }

    /**
     * 心跳，该接口可用于更新玩家的最近活动时间，也可以用于验证token是否仍有效
     */
    @GetMapping("/heartbeat")
    public AjaxResult heartbeat() {
        this.playerService.heartbeat();
        return AjaxResult.success();
    }

    /**
     * 获取玩家基本信息
     */
    @GetMapping("/info")
    public AjaxResult getInfo() {
        return this.playerService.getInfo();
    }

    /**
     * 获取玩家个人详细数据
     */
    @GetMapping("/personal/data")
    public AjaxResult getPersonalData() {
        return this.playerService.getPersonalData();
    }

    /**
     * 玩家上传定位信息
     * @param dto
     * @return
     */
    @PostMapping("/location")
    public AjaxResult location(@RequestBody @Validated LocationDTO dto) {
        return this.playerService.location(dto);
    }
}
