package com.niuma.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.niuma.admin.dto.*;
import com.niuma.admin.entity.Capital;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;

/**
 * 玩家资产相关服务接口
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.03
 */
public interface ICapitalService extends IService<Capital> {
    AjaxResult getCapital();

    Capital getCapital(String playerId);

    AjaxResult bankPassword(BankPwdDTO dto);

    /**
     * 从银行取出或向银行存入
     * @param dto 请求体
     * @param isDebit true-取出，false-存入
     */
    AjaxResult debitOrDeposit(AmountDTO dto, boolean isDebit);

    AjaxResult getAccount();

    AjaxResult bindAccount(BindAccountDTO dto);

    AjaxResult exchange(ExchangeDTO dto);

    PageResult<ExchangeRecordDTO> exchangeRecord(PageBody dto);

    AjaxResult transfer(TransferDTO dto);

    PageResult<TransferRecordDTO> transferRecord(PageBody dto);

    AjaxResult transferAcc();

    AjaxResult buyDiamond(Integer index);
}
