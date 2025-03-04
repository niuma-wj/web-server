package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.dto.GameRoomDTO;
import com.niuma.admin.dto.LackeyRoundDTO;
import com.niuma.admin.dto.LackeyRoundPlayerDTO;
import com.niuma.admin.entity.GameLackey;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GameLackeyMapper extends BaseMapper<GameLackey> {
    /**
     * 判断指定number是否冲突
     * @param number 6位数编号
     * @return 0-不冲突，1-冲突
     */
    Integer hasNumber(@Param("number") String number);

    /**
     * 通过房间编号查询场地id
     * @param number 编号
     * @return 场地id
     */
    String getIdByNumber(@Param("number") String number);

    /**
     * 查询房间编号
     * @param venueId 场地id
     * @return 房间编号
     */
    String getNumber(@Param("venueId") String venueId);

    /**
     * 计算玩家参加的逮狗腿游戏记录数量
     * @param playerId 玩家id
     * @return 记录数量
     */
    Integer countRound(@Param("playerId") String playerId);

    /**
     * 分页查询逮狗腿游戏记录ID
     * @param playerId 玩家id
     * @param offset 起始偏移，从0开始
     * @param pageSize 页大小
     * @return 逮狗腿游戏记录ID列表
     */
    List<Long> getRoundIds(@Param("playerId") String playerId,
                           @Param("offset") Integer offset,
                           @Param("pageSize") Integer pageSize);

    /**
     * 查询逮狗腿单局游戏记录数据
     * @param roundId 单局游戏记录id
     * @return 游戏记录数据
     */
    LackeyRoundDTO getRoundInfo(@Param("roundId") Long roundId);

    /**
     * 查询单局逮狗腿游戏中所有玩家的输赢得分数据
     * @param roundId 单局游戏记录id
     * @return 所有玩家的输赢得分数据
     */
    List<LackeyRoundPlayerDTO> getRoundPlayers(@Param("roundId") Long roundId);

    /**
     * 计算房间数量
     * @param venueId 场地id，模糊查询
     * @param ownerId 房主id，模糊查询
     * @param number 房间编号，模糊查询
     * @param startTime 起始创建时间
     * @param endTime 截止创建时间
     * @return 麻将房间数量
     */
    Integer countRoom(@Param("venueId") String venueId,
                      @Param("ownerId") String ownerId,
                      @Param("number") String number,
                      @Param("startTime") String startTime,
                      @Param("endTime") String endTime);

    /**
     * 分页获取房间列表
     * @param venueId 场地id，模糊查询
     * @param ownerId 房主id，模糊查询
     * @param number 房间编号，模糊查询
     * @param startTime 起始创建时间
     * @param endTime 截止创建时间
     * @return 麻将房间数量
     */
    List<GameRoomDTO> getRooms(@Param("venueId") String venueId,
                               @Param("ownerId") String ownerId,
                               @Param("number") String number,
                               @Param("startTime") String startTime,
                               @Param("endTime") String endTime,
                               @Param("offset") Integer offset,
                               @Param("pageSize") Integer pageSize);
}
