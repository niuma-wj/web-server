package com.niuma.framework.security.filter;

import com.niuma.common.core.domain.model.LoginPlayer;
import com.niuma.common.exception.http.UnauthorizedException;
import com.niuma.common.utils.PlayerSecurityUtils;
import com.niuma.common.utils.StringUtils;
import com.niuma.framework.web.service.PlayerTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 玩家鉴权过滤器
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
@Component
public class PlayerAuthenticationTokenFilter extends OncePerRequestFilter {
    @Autowired
    private PlayerTokenService playerTokenService;

    private final PathMatcher PATH_MATCHER = new AntPathMatcher();

    private final String PLAYER_URI = "/player/**";

    private final String PLAYER_LOGIN = "/player/login";

    private final String PLAYER_LOGOUT = "/player/logout";

    private final String PLAYER_REGISTER = "/player/register";

    private final String PLAYER_CAPTCHA = "/player/captcha-image";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        PlayerSecurityUtils.setLoginPlayer(null);
        String path = request.getRequestURI();
        if (PLAYER_LOGIN.equals(path) || PLAYER_CAPTCHA.equals(path) || PLAYER_REGISTER.equals(path) || !(PATH_MATCHER.match(PLAYER_URI, path))) {
            // 玩家登录、请求登录验证码、注册，或者非玩家资源直接通过
            filterChain.doFilter(request, response);
            return;
        }
        LoginPlayer loginPlayer = this.playerTokenService.getLoginPlayer(request);
        if (StringUtils.isNull(loginPlayer)) {
            // 响应无访问权限
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(StringUtils.format("请求访问：{}，认证失败，无法访问系统资源", path));
            return;
        }
        if (!PLAYER_LOGOUT.equals(path))
            this.playerTokenService.verifyToken(loginPlayer);
        PlayerSecurityUtils.setLoginPlayer(loginPlayer);
        filterChain.doFilter(request, response);
    }
}
