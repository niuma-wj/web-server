package com.niuma.admin.dto;

import com.niuma.common.page.PageBody;
import lombok.Data;

/**
 * 玩家列表查询请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.24
 */
@Data
public class PlayerReqDTO extends PageBody {
    /**
     * 玩家Id，模糊查询
     */
    private String playerId;

    /**
     * 玩家昵称，模糊查询
     */
    private String nickname;

    /**
     * 是否在线
     */
    private Integer online;
}
