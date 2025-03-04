package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.dto.GameRoomDTO;
import com.niuma.admin.entity.GameMahjong;
import com.niuma.admin.entity.MahjongRecord;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GameMahjongMapper extends BaseMapper<GameMahjong> {
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
     * 获取房间编号
     * @param venueId 场地id
     * @return 房间编号
     */
    String getNumber(@Param("venueId") String venueId);

    /**
     * 查询玩家参与的麻将游戏记录数量
     * @param playerId 玩家id
     * @return 记录数量
     */
    Integer countRecord(@Param("playerId") String playerId);

    /**
     * 分页查询麻将游戏记录
     * @param playerId 玩家id
     * @param offset 起始偏移，从0开始
     * @param pageSize 页大小
     * @return 麻将游戏记录列表
     */
    List<MahjongRecord> getRecords(@Param("playerId") String playerId,
                                   @Param("offset") Integer offset,
                                   @Param("pageSize") Integer pageSize);

    /**
     * 查询麻将游戏记录
     * @param id 记录id
     * @return 麻将游戏记录
     */
    MahjongRecord getRecord(@Param("id") Long id);

    /**
     * 查询麻将游戏回放数据
     * @param id 记录id
     * @return 回放数据
     */
    String getPlayback(@Param("id") Long id);

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
