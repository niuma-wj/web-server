package com.niuma.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.niuma.admin.data.CapitalAmount;
import com.niuma.admin.dto.AccountDTO;
import com.niuma.admin.entity.Capital;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CapitalMapper extends BaseMapper<Capital> {
    /**
     * 查询玩家金币数量
     * @param id 玩家id
     * @return 金币数量
     */
    Long getGold(@Param("id") String id);

    /**
     * 查询玩家钻石数量
     * @param id 玩家id
     * @return 钻石数量
     */
    Long getDiamond(@Param("id") String id);

    /**
     * 查询玩家的资产数量
     * @param id 玩家id
     * @return value1-金币数量，value2-version
     */
    CapitalAmount getCapital(@Param("id") String id);

    /**
     * 设置玩家的资产数量
     * @param id 玩家id
     * @param gold 金币数量
     * @param deposit 存款余额
     * @param diamond 钻石数量
     * @param version 版本号（用于乐观锁）
     * @return 更新数据库表行数
     */
    Integer setCapital(@Param("id") String id,
                       @Param("gold") Long gold,
                       @Param("deposit") Long deposit,
                       @Param("diamond") Long diamond,
                       @Param("version") Long version);

    /**
     * 查询银行密码
     * @param id 玩家id
     */
    String getBankPassword(@Param("id") String id);

    /**
     * 更新玩家银行密码
     * @param id 玩家id
     * @param password 银行密码
     */
    void updateBankPassword(@Param("id") String id, @Param("password") String password);

    /**
     * 查询兑换账号信息
     * @param id 玩家id
     * @return 兑换账号信息
     */
    AccountDTO getAccount(@Param("id") String id);

    /**
     * 设置支付宝账号
     * @param id 玩家id
     * @param account 支付宝账号
     * @param name 姓名
     */
    void setAlipayAccount(@Param("id") String id, @Param("account") String account, @Param("name") String name);

    /**
     * 设置银行账号
     * @param id 玩家id
     * @param account 银行账号
     * @param name 姓名
     */
    void setBankAccount(@Param("id") String id, @Param("account") String account, @Param("name") String name);
}
