package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.entity.GameGuanDan;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface GameGuanDanMapper extends BaseMapper<GameGuanDan> {
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
}
