package com.niuma.admin.data;

import lombok.Data;

/**
 * RabbitMQ命令基类
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.18
 */
@Data
public class MqCommand {
    /**
     * 异步命令id
     */
    private String commandId;

    /**
     * 发送Broker的路由键，用于目的Broker处理消息后返回
     */
    private String routingKey;
}
