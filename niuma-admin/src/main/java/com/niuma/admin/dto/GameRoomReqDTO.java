package com.niuma.admin.dto;

import com.niuma.common.page.PageBody;
import lombok.Data;

/**
 * 房间列表查询请求体
 * @author wujian
 * @email 393817707@qq.com
 * @date 2025.02.25
 */
@Data
public class GameRoomReqDTO extends PageBody {
    /**
     * 场地id，模糊查询
     */
    private String venueId;

    /**
     * 房主id，模糊查询
     */
    private String ownerId;

    /**
     * 编号，模糊查询
     */
    private String number;

    /**
     * 起始创建时间
     */
    private String createTimeStart;

    /**
     * 截止创建时间
     */
    private String createTimeEnd;
}
