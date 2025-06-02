package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.entity.Venue;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface VenueMapper extends BaseMapper<Venue> {
    /**
     * 获取游戏类型
     * @param id 场地id
     * @return 游戏类型
     */
    Integer getGameType(@Param("id") String id);

    /**
     * 获取场地所属的区域id
     * @param id 场地id
     * @return 区域id
     */
    Integer getDistrictId(@Param("id") String id);
}
