package com.niuma.admin.data;

import lombok.Data;

/**
 * MQ队列消息体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.18
 */
@Data
public class MqMessage {
    /**
     * 消息体类型
     */
    private String msgType;

    /**
     * 消息体Json字符串（UTF-8编码）的base64编码
     */
    private String msgPack;
}
