package com.niuma.admin.factory;

import com.niuma.admin.entity.PlayerLoginLog;
import com.niuma.admin.service.IPlayerLoginLogService;
import com.niuma.common.utils.LogUtils;
import com.niuma.common.utils.ip.AddressUtils;
import com.niuma.common.utils.ip.IpUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.TimerTask;

/**
 * 玩家相关异步操作任务构造工厂
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
@Component
@Slf4j
public class PlayerAsyncFactory {
    @Autowired
    private IPlayerLoginLogService playerLoginLogService;

    /**
     * 异步记录玩家登录日志
     * @param playerId 玩家id
     * @param nickname 玩家昵称
     * @return 异步任务
     */
    public TimerTask recordPlayerLogin(String playerId, String nickname) {
        String ip = IpUtils.getIpAddr();
        IPlayerLoginLogService service = this.playerLoginLogService;
        return new TimerTask() {
            @Override
            public void run() {
                String address = AddressUtils.getRealAddressByIP(ip);
                StringBuilder s = new StringBuilder();
                s.append(LogUtils.getBlock(playerId));
                s.append(LogUtils.getBlock(nickname));
                s.append(LogUtils.getBlock(ip));
                s.append(address);
                // 打印信息到日志
                log.info(s.toString());
                // 封装对象
                PlayerLoginLog entity = new PlayerLoginLog();
                entity.setPlayerId(playerId);
                entity.setNickname(nickname);
                entity.setLoginIp(ip);
                entity.setLoginLocation(address);
                entity.setLoginTime(LocalDateTime.now());
                // 插入数据
                service.save(entity);
            }
        };
    }
}
