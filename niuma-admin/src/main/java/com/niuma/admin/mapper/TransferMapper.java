package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.dto.TransferRecordDTO;
import com.niuma.admin.entity.Transfer;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransferMapper extends BaseMapper<Transfer> {
    /**
     * 计算玩家累积转账数量
     * @param playerId 玩家id
     * @return 累计转账数量
     */
    Long getAccAmount(@Param("playerId") String playerId);

    /**
     * 计算玩家的转账记录数量
     * @param playerId 玩家id
     * @return 转账记录数量
     */
    Integer countRecord(@Param("playerId") String playerId);

    /**
     * 分页请求转账记录
     * @param playerId 玩家id
     * @param offset 起始偏移，从1开始
     * @param pageSize 分页大小
     * @return 转账记录列表
     */
    List<TransferRecordDTO> getPage(@Param("playerId") String playerId,
                                    @Param("offset") Integer offset,
                                    @Param("pageSize") Integer pageSize);
}
