package com.niuma.admin.data;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 离开当前场地MQ消息
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.18
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class MqLeaveVenue extends MqCommand {
    /**
     * 玩家id
     */
    private String playerId;

    /**
     * 场地id
     */
    private String venueId;
}
