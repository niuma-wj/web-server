package com.niuma.admin.utils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.niuma.common.constant.ResultCodeEnum;
import com.niuma.common.exception.http.InternalServerException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class JsonUtils {
    private final ObjectMapper objectMapper = new ObjectMapper();

    public <T> String convertToStr(T obj) {
        try {
            return this.objectMapper.writeValueAsString(obj);
        } catch (JsonProcessingException ex) {
            log.error("Convert object -> JSON string error: {}", ex.getMessage(), ex);
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), "Convert object -> JSON string error");
        }
    }

    public <T> T convertToObj(String json, Class<T> clazz) {
        try {
            return this.objectMapper.readValue(json, clazz);
        } catch (JsonProcessingException ex) {
            log.error("Convert JSON string -> object error: {}", ex.getMessage(), ex);
            throw new InternalServerException(ResultCodeEnum.INTERNAL_SERVER_ERROR.getCode(), "Convert JSON string -> object error");
        }
    }
}
