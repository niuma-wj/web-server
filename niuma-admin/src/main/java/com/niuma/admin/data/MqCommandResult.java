package com.niuma.admin.data;

import lombok.Data;

/**
 * RabbitMQ命令处理结果
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.19
 */
@Data
public class MqCommandResult {
    /**
     * 异步命令id
     */
    private String commandId;

    /**
     * 结果，0-成功，其他-失败
     */
    private Integer result;

    /**
     * 错误消息
     */
    private String message;
}
