package com.niuma.framework.web.exception;

import javax.servlet.http.HttpServletRequest;

import com.niuma.common.constant.ResultCodeEnum;
import com.niuma.common.exception.http.*;
import com.niuma.common.exception.user.UserPasswordNotMatchException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingPathVariableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import com.niuma.common.constant.HttpStatus;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.core.text.Convert;
import com.niuma.common.exception.DemoModeException;
import com.niuma.common.exception.ServiceException;
import com.niuma.common.utils.StringUtils;
import com.niuma.common.utils.html.EscapeUtil;

/**
 * 全局异常处理器
 * 
 * @author ruoyi
 */
@RestControllerAdvice
public class GlobalExceptionHandler
{
    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 权限校验异常
     */
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.FORBIDDEN)
    public AjaxResult handleAccessDeniedException(AccessDeniedException e, HttpServletRequest request)
    {
        String requestURI = request.getRequestURI();
        log.error("请求地址'{}',权限校验失败'{}'", requestURI, e.getMessage());
        return AjaxResult.error(ResultCodeEnum.FORBIDDEN.getCode(), "没有权限，请联系管理员授权");
    }

    /**
     * 请求方式不支持
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public AjaxResult handleHttpRequestMethodNotSupported(HttpRequestMethodNotSupportedException e,
            HttpServletRequest request)
    {
        String requestURI = request.getRequestURI();
        log.error("请求地址'{}',不支持'{}'请求", requestURI, e.getMethod());
        return AjaxResult.error(e.getMessage());
    }

    /**
     * 业务异常
     */
    @ExceptionHandler(ServiceException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR)
    public AjaxResult handleServiceException(ServiceException e, HttpServletRequest request)
    {
        log.error(e.getMessage(), e);
        String code = e.getCode();
        return StringUtils.isNotNull(code) ? AjaxResult.error(code, e.getMessage()) : AjaxResult.error(e.getMessage());
    }

    /**
     * 请求路径中缺少必需的路径变量
     */
    @ExceptionHandler(MissingPathVariableException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR)
    public AjaxResult handleMissingPathVariableException(MissingPathVariableException e, HttpServletRequest request)
    {
        String requestURI = request.getRequestURI();
        log.error("请求路径中缺少必需的路径变量'{}',发生系统异常.", requestURI, e);
        return AjaxResult.error(String.format("请求路径中缺少必需的路径变量[%s]", e.getVariableName()));
    }

    /**
     * 请求参数类型不匹配
     */
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public AjaxResult handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException e, HttpServletRequest request)
    {
        String requestURI = request.getRequestURI();
        String value = Convert.toStr(e.getValue());
        if (StringUtils.isNotEmpty(value))
        {
            value = EscapeUtil.clean(value);
        }
        log.error("请求参数类型不匹配'{}',发生系统异常.", requestURI, e);
        return AjaxResult.error(String.format("请求参数类型不匹配，参数[%s]要求类型为：'%s'，但输入值为：'%s'", e.getName(), e.getRequiredType().getName(), value));
    }

    /**
     * 拦截未知的运行时异常
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR)
    public AjaxResult handleRuntimeException(RuntimeException e, HttpServletRequest request)
    {
        String requestURI = request.getRequestURI();
        log.error("请求地址'{}',发生未知异常.", requestURI, e);
        return AjaxResult.error(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), e.getMessage());
    }

    /**
     * 系统异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR)
    public AjaxResult handleException(Exception e, HttpServletRequest request)
    {
        String requestURI = request.getRequestURI();
        log.error("请求地址'{}',发生系统异常.", requestURI, e);
        return AjaxResult.error(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), e.getMessage());
    }

    /**
     * 自定义验证异常
     */
    @ExceptionHandler(BindException.class)
    public AjaxResult handleBindException(BindException e)
    {
        log.error(e.getMessage(), e);
        String message = e.getAllErrors().get(0).getDefaultMessage();
        return AjaxResult.error(message);
    }

    /**
     * 自定义验证异常
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Object handleMethodArgumentNotValidException(MethodArgumentNotValidException e)
    {
        log.error(e.getMessage(), e);
        String message = e.getBindingResult().getFieldError().getDefaultMessage();
        return AjaxResult.error(message);
    }

    /**
     * 演示模式异常
     */
    @ExceptionHandler(DemoModeException.class)
    public AjaxResult handleDemoModeException(DemoModeException e)
    {
        return AjaxResult.error("演示模式，不允许操作");
    }

    /**
     * 登录账号密码不匹配
     * @param e
     * @return
     */
    @ExceptionHandler(UserPasswordNotMatchException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.NOT_FOUND)
    public AjaxResult handleUserPasswordNotMatchException(UserPasswordNotMatchException e) {
        return handleHttpException(e.getCode(), e.getMessage());
    }

    /**
     * 处理400异常
     * @author wujian
     * @email 393817707@qq.com
     * @date 2024.09.04
     */
    @ExceptionHandler(BadRequestException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.BAD_REQUEST)
    public AjaxResult handleBadRequestException(BadRequestException e) {
        return handleHttpException(e.getCode(), e.getMessage());
    }

    /**
     * 处理401异常
     * @author wujian
     * @email 393817707@qq.com
     * @date 2024.09.04
     */
    @ExceptionHandler(UnauthorizedException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.UNAUTHORIZED)
    public AjaxResult handleUnauthorizedException(UnauthorizedException e) {
        return handleHttpException(e.getCode(), e.getMessage());
    }

    /**
     * 处理403异常
     * @author wujian
     * @email 393817707@qq.com
     * @date 2024.09.04
     */
    @ExceptionHandler(ForbiddenException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.BAD_REQUEST)
    public AjaxResult handleForbiddenException(ForbiddenException e) {
        return handleHttpException(e.getCode(), e.getMessage());
    }

    /**
     * 处理404异常
     * @author wujian
     * @email 393817707@qq.com
     * @date 2024.09.04
     */
    @ExceptionHandler(NotFoundException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.NOT_FOUND)
    public AjaxResult handleNotFoundException(NotFoundException e) {
        return handleHttpException(e.getCode(), e.getMessage());
    }

    /**
     * 处理500异常
     * @author wujian
     * @email 393817707@qq.com
     * @date 2024.09.04
     */
    @ExceptionHandler(InternalServerException.class)
    @ResponseStatus(org.springframework.http.HttpStatus.NOT_FOUND)
    public AjaxResult handleInternalServerException(InternalServerException e) {
        log.error(e.getMessage(), e);
        return handleHttpException(e.getCode(), e.getMessage());
    }

    private AjaxResult handleHttpException(String code, String message) {
        AjaxResult result = new AjaxResult();
        if (StringUtils.isNotEmpty(code))
            result.put(AjaxResult.CODE_TAG, code);
        if (StringUtils.isNotEmpty(message))
            result.put(AjaxResult.MSG_TAG, message);
        return result;
    }
}
