package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.entity.GameFault;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface GameFaultMapper extends BaseMapper<GameFault> {
    /**
     * 查询是否存在游戏故障
     * @param venueId 场地id
     * @param serverId 服务器id
     * @return 0-不存在，否则存在
     */
    Integer hasGameFault(@Param("venueId") String venueId, @Param("serverId") String serverId);
}
