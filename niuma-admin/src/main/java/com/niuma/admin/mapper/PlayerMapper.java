package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.dto.JuniorPlayerDTO;
import com.niuma.admin.dto.PlayerBaseDTO;
import com.niuma.admin.dto.PlayerDTO;
import com.niuma.admin.entity.Player;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlayerMapper extends BaseMapper<Player> {
    /**
     * 通过登录账号查询玩家id
     * @param name 登录账号
     * @return 玩家id
     */
    String getIdByName(@Param("name") String name);

    /**
     * 查询玩家昵称
     * @param id 玩家di
     * @return 玩家昵称
     */
    String getNickname(@Param("id") String id);

    /**
     * 更新登录记录
     * @param id 玩家id
     * @param ip 登录ip
     */
    void updateLogin(@Param("id") String id, @Param("ip") String ip);

    /**
     * 更新心跳时间戳
     * @param id 玩家id
     * @param timestamp 时间戳
     */
    void updateHeartbeat(@Param("id") String id, @Param("timestamp") Long timestamp);

    /**
     * 查询玩家的代理玩家id
     * @param id 玩家id
     * @return 代理玩家id
     */
    String getAgencyId(@Param("id") String id);

    /**
     * 更新代理玩家id
     * @param id 玩家id
     * @param agencyId 代理玩家id
     */
    void updateAgencyId(@Param("id") String id, @Param("agencyId") String agencyId);

    /**
     * 计算下级玩家数量
     * @param id 玩家id
     * @return 下级玩家数量
     */
    Integer countJuniorPlayer(@Param("id") String id);

    /**
     * 分页查询玩家的直接下级玩家
     * @param playerId 玩家id
     * @param offset 起始偏移，从0开始
     * @param pageSize 页大小
     * @return 直接下级玩家列表
     */
    List<JuniorPlayerDTO> getJuniorPlayers(@Param("playerId") String playerId,
                                           @Param("offset") Integer offset,
                                           @Param("pageSize") Integer pageSize);

    /**
     * 查询玩家基本信息
     * @param id 玩家id
     * @return 基本信息
     */
    PlayerBaseDTO getBaseInfo(@Param("id") String id);

    /**
     * 添加玩家
     * @param entity 玩家实体
     */
    void addPlayer(@Param("entity") Player entity);

    /**
     * 查询玩家头像图片链接数量
     * @return 数量
     */
    Integer countHeadImageUrls();

    /**
     * 查询头像图片链接
     * @param id 主键id
     * @return 头像图片链接
     */
    String getHeadImageUrl(@Param("id") Integer id);

    /**
     * 计算玩家数量
     * @param id 玩家id，模糊查询
     * @param nickname 玩家昵称，模糊查询
     * @param online 是否在线
     * @param heartbeat 心跳时间戳界限
     * @return 玩家数量
     */
    Integer countPlayer(@Param("id") String id,
                        @Param("nickname") String nickname,
                        @Param("online") Integer online,
                        @Param("heartbeat") Long heartbeat);

    /**
     * 分页查询玩家列表
     * @param id 玩家id，模糊查询
     * @param nickname 玩家昵称，模糊查询
     * @param online 是否在线
     * @param heartbeat 心跳时间戳界限
     * @param offset offset 起始偏移，从0开始
     * @param pageSize pageSize 页大小
     * @return 分页玩家数据
     */
    List<PlayerDTO> getPage(@Param("id") String id,
                            @Param("nickname") String nickname,
                            @Param("online") Integer online,
                            @Param("heartbeat") Long heartbeat,
                            @Param("offset") Integer offset,
                            @Param("pageSize") Integer pageSize);

    /**
     * 禁用或启动玩家账号
     * @param id 玩家id
     * @param banned 0-启用，1-禁用
     */
    void setBanned(@Param("id") String id, @Param("banned") Integer banned);
}
