package com.niuma.admin.rabbit;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.niuma.admin.data.MqMessage;
import com.niuma.admin.service.IGameService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;

@Component
@Slf4j
public class RabbitReceiver {
    @Autowired
    private IGameService gameService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 声明一个独占的消息队列，队列名称全局唯一，且在服务关闭后自动删除
     */
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(value = "${rabbitmq.game.queue}", durable = "false", autoDelete = "true",
                    arguments = {
                            @Argument(name = "x-queue-type", value = "classic")
                    }),
            exchange = @Exchange(value = "${rabbitmq.game.exchange}"),
            key = "${rabbitmq.game.routingKey}"
    ))
    @RabbitHandler
    public void consumeGame(@Payload Message message) {
        MqMessage tmp = null;
        try {
            String json = new String(message.getBody(), StandardCharsets.UTF_8.name());
            tmp = this.objectMapper.readValue(json, MqMessage.class);
        } catch (Exception ex) {
            log.error("转换JSON字符串 -> 对象异常: {}", ex.getMessage());
            return;
        }
        gameService.consume(tmp);
    }
}
