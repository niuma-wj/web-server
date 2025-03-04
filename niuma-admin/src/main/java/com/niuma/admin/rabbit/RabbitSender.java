package com.niuma.admin.rabbit;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.niuma.admin.utils.JsonUtils;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Component
public class RabbitSender {
    @Resource
    private AmqpTemplate amqpTemplate;

    @Autowired
    private JsonUtils jsonUtils;

    /**
     * 发送消息
     * @param exchange 交换机名称
     * @param routingKey 路由键
     * @param msg 消息
     */
    public void sendMsg(String exchange, String routingKey, String msg) {
        this.amqpTemplate.convertAndSend(exchange, routingKey, msg);
    }

    /**
     * 发送消息
     * @param exchange 交换机名称
     * @param routingKey 路由键
     * @param obj 消息对象
     * @param <T> 消息对象类型
     */
    public <T> void sendObject(String exchange, String routingKey, T obj) {
        String msg = this.jsonUtils.convertToStr(obj);
        this.sendMsg(exchange, routingKey, msg);
    }
}
