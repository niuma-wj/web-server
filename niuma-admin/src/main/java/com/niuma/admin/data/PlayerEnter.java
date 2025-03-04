package com.niuma.admin.data;

import lombok.Data;

/**
 * 玩家进入场地数据
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.18
 */
@Data
public class PlayerEnter {
    // 授权时间(Unix时间戳，毫秒)
    private Long authorizedTime;

    // 授权的场地id
    private String authorizedVenue;
}
