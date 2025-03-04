package com.niuma.admin.data;

import com.niuma.common.core.domain.AjaxResult;
import org.springframework.http.ResponseEntity;
import org.springframework.web.context.request.async.DeferredResult;

/**
 * 异步命令
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.18
 */
public class MqCommandDeferred {
    public MqCommandDeferred(String playerId, String commandId) {
        this.playerId = playerId;
        this.commandId = commandId;
        this.createTime = System.currentTimeMillis();
    }

    /**
     * 玩家id
     */
    private final String playerId;

    /**
     * 异步命令id
     */
    private final String commandId;

    /**
     * 场地id
     */
    private String venueId;

    /**
     * 动作类型
     */
    private int action;

    /**
     * 游戏类型
     */
    private int gameType;

    /**
     * 创建游戏数据，解码出来是json字符串
     */
    private String base64;

    /**
     * 异步响应结果
     */
    private DeferredResult<ResponseEntity<AjaxResult> > result;

    /**
     * 创建时间，Unix时间戳，毫秒
     */
    private final Long createTime;

    public String getPlayerId() {
        return this.playerId;
    }

    public String getCommandId() {
        return this.commandId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId;
    }

    public String getVenueId() {
        return this.venueId;
    }

    public void setAction(int action) {
        this.action = action;
    }

    public int getAction() {
        return this.action;
    }

    public void setGameType(int gameType) {
        this.gameType = gameType;
    }

    public int getGameType() {
        return this.gameType;
    }

    public void setBase64(String base64) {
        this.base64 = base64;
    }

    public String getBase64() {
        return this.base64;
    }

    public void setResult(DeferredResult<ResponseEntity<AjaxResult> > result) {
        this.result = result;
    }

    public DeferredResult<ResponseEntity<AjaxResult> > getResult() {
        return this.result;
    }

    public Long getCreateTime() {
        return this.createTime;
    }
}
