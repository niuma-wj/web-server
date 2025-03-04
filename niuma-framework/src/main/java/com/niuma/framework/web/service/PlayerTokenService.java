package com.niuma.framework.web.service;

import com.niuma.common.constant.CacheConstants;
import com.niuma.common.constant.Constants;
import com.niuma.common.core.domain.model.LoginPlayer;
import com.niuma.common.core.redis.RedisCache;
import com.niuma.common.utils.StringUtils;
import com.niuma.common.utils.uuid.IdUtils;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 玩家令牌认证服务
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
@Component
public class PlayerTokenService {
    private static final Logger log = LoggerFactory.getLogger(PlayerTokenService.class);

    // 令牌请求Header头
    private final String header = "PLAYER-AUTHORIZATION";

    // 令牌秘钥
    @Value("${token.secret}")
    private String secret;

    // 令牌有效期（默认30分钟）
    @Value("${token.expireTime}")
    private int expireTime;

    @Autowired
    private RedisCache redisCache;

    /**
     * 通过token获取登录玩家
     * @param request 请求
     * @return 登录玩家实体
     */
    public LoginPlayer getLoginPlayer(HttpServletRequest request) {
        // 获取请求携带的令牌
        LoginPlayer player = null;
        String token = getToken(request);
        if (StringUtils.isNotEmpty(token)) {
            try {
                Claims claims = parseToken(token);
                // 解析对应的权限以及玩家信息
                String id = (String) claims.get(Constants.PLAYER_ID_KEY);
                String uuid = (String) claims.get(Constants.PLAYER_UUID_KEY);
                String playerKey = getPlayerKey(id);
                player = this.redisCache.getCacheObject(playerKey);
                if (player != null) {
                    if (!uuid.equals(player.getUuid())) {
                        // uuid不匹配，说明本次请求携带的token已经过期
                        player = null;
                    }
                }
            } catch (Exception e) {
                log.error("获取玩家信息异常'{}'", e.getMessage());
            }
        }
        return player;
    }

    /**
     * 设置玩家身份信息
     */
    public void setLoginPlayer(LoginPlayer loginPlayer) {
        if (StringUtils.isNotNull(loginPlayer) && StringUtils.isNotEmpty(loginPlayer.getUuid())) {
            refreshToken(loginPlayer);
            setActive(loginPlayer.getId());
        }
    }

    /**
     * 删除玩家身份信息
     */
    public void delLoginPlayer(String playerId) {
        if (StringUtils.isNotEmpty(playerId)) {
            String key = getPlayerKey(playerId);
            this.redisCache.deleteObject(key);
            key = getActiveKey(playerId);
            this.redisCache.deleteObject(key);
        }
    }

    /**
     * 创建令牌
     *
     * @param loginPlayer 玩家信息
     * @return 令牌
     */
    public String createToken(LoginPlayer loginPlayer) {
        Map<String, Object> claims = new HashMap<>();
        claims.put(Constants.PLAYER_ID_KEY, loginPlayer.getId());
        claims.put(Constants.PLAYER_UUID_KEY, loginPlayer.getUuid());
        String token = Jwts.builder()
                .setClaims(claims)
                .signWith(SignatureAlgorithm.HS512, this.secret).compact();
        return token;
    }

    /**
     * 验证令牌有效期，相差不足20分钟，自动刷新缓存
     *
     * @param loginPlayer 玩家信息
     * @return 令牌
     */
    public void verifyToken(LoginPlayer loginPlayer) {
        long expireTime = loginPlayer.getExpireTime();
        long currentTime = System.currentTimeMillis();
        final long MILLIS_MINUTE_TWENTY = 20 * 60 * 1000L;
        if (expireTime - currentTime <= MILLIS_MINUTE_TWENTY)
            refreshToken(loginPlayer);
        setActive(loginPlayer.getId());
    }

    /**
     * 刷新令牌有效期
     *
     * @param loginPlayer 登录信息
     */
    private void refreshToken(LoginPlayer loginPlayer) {
        final long MILLIS_MINUTE = 60 * 1000L;
        loginPlayer.setLoginTime(System.currentTimeMillis());
        loginPlayer.setExpireTime(loginPlayer.getLoginTime() + this.expireTime * MILLIS_MINUTE);
        String key = getPlayerKey(loginPlayer.getId());
        this.redisCache.setCacheObject(key, loginPlayer, this.expireTime, TimeUnit.MINUTES);
    }

    /**
     * 从令牌中获取数据声明
     *
     * @param token 令牌
     * @return 数据声明
     */
    private Claims parseToken(String token) {
        return Jwts.parser()
                .setSigningKey(this.secret)
                .parseClaimsJws(token)
                .getBody();
    }

    /**
     * 获取请求token
     *
     * @param request
     * @return token
     */
    private String getToken(HttpServletRequest request) {
        String token = request.getHeader(this.header);
        if (StringUtils.isNotEmpty(token) && token.startsWith(Constants.TOKEN_PREFIX)) {
            token = token.replace(Constants.TOKEN_PREFIX, "");
        }
        return token;
    }

    private String getPlayerKey(String playerId) {
        return CacheConstants.LOGIN_PLAYER_KEY + playerId;
    }

    private String getActiveKey(String playerId) {
        return CacheConstants.PLAYER_ACTIVE_KEY + playerId;
    }

    /**
     * 更新玩家活动时间
     * @param playerId 玩家id
     */
    private void setActive(String playerId) {
        Long timestamp = System.currentTimeMillis();
        timestamp /= 1000L;
        String key = getActiveKey(playerId);
        this.redisCache.setCacheObject(key, timestamp, 30, TimeUnit.SECONDS);
    }
}
