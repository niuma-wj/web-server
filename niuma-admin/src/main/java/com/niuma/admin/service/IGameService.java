package com.niuma.admin.service;

import com.niuma.admin.data.MqMessage;
import com.niuma.admin.dto.*;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;
import org.springframework.http.ResponseEntity;
import org.springframework.web.context.request.async.DeferredResult;

/**
 * 游戏相关服务接口
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.02
 */
public interface IGameService {
    /**
     * 创建空游戏
     * @param result result 异步延迟响应结果
     */
    void createDumbGame(DeferredResult<ResponseEntity<AjaxResult>> result);

    /**
     * 创建游戏
     * @param result 异步延迟响应结果
     * @param dto 请求体
     */
    void createGame(DeferredResult<ResponseEntity<AjaxResult>> result, CreateGameDTO dto);

    /**
     * 进入游戏
     * @param dto 请求体
     */
    void enter(DeferredResult<ResponseEntity<AjaxResult>> result, EnterDTO dto);

    /**
     * 通过编号进入游戏
     * @param dto 请求体
     */
    void enterNumber(DeferredResult<ResponseEntity<AjaxResult>> result, EnterNumberDTO dto);

    /**
     * 进入区域
     * @param districtId 区域id
     */
    void enterDistrict(DeferredResult<ResponseEntity<AjaxResult>> result, Integer districtId);

    /**
     * 查询区域内当前玩家数量
     * @param districtId 区域id
     */
    AjaxResult getDistrictPlayerCount(Integer districtId);

    /**
     * 消费RabbitMQ消息
     * @param msg 消息
     */
    void consume(MqMessage msg);

    /**
     * 查询麻将游戏记录
     * @param dto 请求体
     */
    PageResult<MahjongRecordDTO> getMahjongRecord(PageBody dto);

    /**
     * 查询麻将游戏回放
     * @param id 游戏记录id
     */
    AjaxResult getMahjongPlayback(Long id);

    /**
     * 查询比鸡游戏公开房列表
     */
    AjaxResult getBiJiPublicRooms();

    /**
     * 查询逮狗腿游戏记录
     * @param dto 请求体
     * @return 分页数据
     */
    PageResult<LackeyRoundDTO> getLackeyRecord(PageBody dto);

    /**
     * 查询比鸡游戏公开房列表
     */
    AjaxResult getNiu100PublicRooms();

    /**
     * 查询麻将房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    PageResult<GameRoomDTO> getMahjong(GameRoomReqDTO dto);

    /**
     * 查询比鸡房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    PageResult<GameRoomDTO> getBiJi(GameRoomReqDTO dto);

    /**
     * 查询逮狗腿房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    PageResult<GameRoomDTO> getLackey(GameRoomReqDTO dto);

    /**
     * 查询百人牛牛房间列表
     * @param dto 请求体
     * @return 分页房间数据
     */
    PageResult<GameRoomDTO> getNiu100(GameRoomReqDTO dto);
}
