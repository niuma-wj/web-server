package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.dto.CollectRecordDTO;
import com.niuma.admin.dto.RewardDTO;
import com.niuma.admin.entity.Agency;
import com.niuma.common.dto.IntPairDTO;
import com.niuma.common.dto.LongPairDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AgencyMapper extends BaseMapper<Agency> {
    /**
     * 判断玩家是否为代理玩家
     * @param playerId 玩家id
     * @return 是否为代理玩家，1-是，0-否
     */
    Integer isAgency(@Param("playerId") String playerId);

    /**
     * 查询玩家的代理等级
     * @param playerId
     * @return 代理等级
     */
    Integer getLevel(@Param("playerId") String playerId);

    /**
     * 查询下级玩家数量
     * @param playerId 玩家id
     * @return 下级玩家数量
     */
    Integer getJuniorCount(@Param("playerId") String playerId);

    /**
     * 下级玩家人数加1
     * @param playerId 玩家id
     */
    void juniorCountAddOne(@Param("playerId") String playerId);

    /**
     * 查询玩家当前未领取奖励
     * @param playerId 玩家id
     * @return 当前未领取奖励
     */
    Long getCurrentReward(@Param("playerId") String playerId);

    /**
     * 查询玩家累积获得超线收益(间接代理奖励)
     * @param playerId 玩家id
     * @return 累计间接代理奖励
     */
    Long getIndirectReward(@Param("playerId") String playerId);

    /**
     * 查询代理等级和下级玩家数
     * @param playerId 玩家id
     * @return 代理等级和下级玩家数
     */
    IntPairDTO getLevelAndJuniorCount(@Param("playerId") String playerId);

    /**
     * 计算下级玩家为指定玩家贡献的奖励总和
     * @param playerId 玩家id
     * @param juniorId 下级玩家id
     * @return 贡献的奖励总和
     */
    Long getTotalReward(@Param("playerId") String playerId, @Param("juniorId") String juniorId);

    /**
     * 计算玩家获得的奖励数量
     * @param playerId 玩家id
     * @return 奖励数量
     */
    Integer countReward(@Param("playerId") String playerId);

    /**
     * 分页查询玩家获得的奖励
     * @param playerId 玩家id
     * @param offset 起始偏移，从0开始
     * @param pageSize 页大小
     * @return 玩家获得的奖励列表
     */
    List<RewardDTO> getRewards(@Param("playerId") String playerId,
                               @Param("offset") Integer offset,
                               @Param("pageSize") Integer pageSize);

    /**
     * 查询当前全部未领取的奖励
     * @param playerId 玩家id
     * @return 当前未领取奖励列表
     */
    List<LongPairDTO> getCurrentRewards(@Param("playerId") String playerId);

    /**
     * 领取奖励
     * @param ids 奖励id列表
     * @param collectId 领取记录id
     */
    void collectRewards(@Param("ids") List<Long> ids, @Param("collectId") Long collectId);

    /**
     * 增加累计领取奖励
     * @param playerId 玩家id
     * @param totalReward 领取奖励
     */
    void addTotalReward(@Param("playerId") String playerId, @Param("totalReward") Long totalReward);

    /**
     * 查询玩家累积领取奖励
     * @param playerId 玩家id
     * @return 累计领取奖励
     */
    Long getTotalReward1(@Param("playerId") String playerId);

    /**
     * 查询玩家的领取奖励记录数量
     * @param playerId 玩家id
     * @return 领取奖励记录数量
     */
    Integer countCollect(@Param("playerId") String playerId);

    /**
     * 分页查询玩家领取奖励记录
     * @param playerId 玩家id
     * @param offset 起始偏移，从0开始
     * @param pageSize 页大小
     * @return 领取奖励记录列表
     */
    List<CollectRecordDTO> getCollectRecord(@Param("playerId") String playerId,
                                            @Param("offset") Integer offset,
                                            @Param("pageSize") Integer pageSize);
}
