package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.dto.ExchangeRecordDTO;
import com.niuma.admin.entity.Exchange;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExchangeMapper extends BaseMapper<Exchange> {
    /**
     * 获取兑换记录数量
     * @param playerId 玩家id
     * @return 兑换记录数量
     */
    Integer countRecord(@Param("playerId") String playerId);

    /**
     * 分页获取兑换记录
     * @param playerId 玩家id
     * @param offset 起始偏移，从0开始
     * @param pageSize 页大小
     * @return 兑换记录列表
     */
    List<ExchangeRecordDTO> getPage(@Param("playerId") String playerId,
                                    @Param("offset") Integer offset,
                                    @Param("pageSize") Integer pageSize);
}
