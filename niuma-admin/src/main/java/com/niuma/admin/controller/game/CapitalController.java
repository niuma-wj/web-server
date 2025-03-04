package com.niuma.admin.controller.game;

import com.niuma.admin.dto.*;
import com.niuma.admin.service.ICapitalService;
import com.niuma.common.core.domain.AjaxResult;
import com.niuma.common.page.PageBody;
import com.niuma.common.page.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 玩家资产相关控制器
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.11.03
 */
@RestController
@RequestMapping("/player/capital")
public class CapitalController {
    @Autowired
    private ICapitalService capitalService;

    /**
     * 获取玩家资产
     */
    @GetMapping("/get")
    public AjaxResult getCapital() {
        return this.capitalService.getCapital();
    }

    /**
     * 修改银行(保险箱)密码
     * @param dto 请求体
     */
    @PostMapping("/bank/password")
    //@Log(businessType = BusinessType.UPDATE, operatorType = OperatorType.OTHER, isSaveRequestData = false, isSaveResponseData = false)
    public AjaxResult bankPassword(@RequestBody @Validated BankPwdDTO dto) {
        return this.capitalService.bankPassword(dto);
    }

    /**
     * 从银行取出金币
     * @param dto 请求体
     */
    @PostMapping("/debit")
    //@Log(businessType = BusinessType.UPDATE, operatorType = OperatorType.OTHER)
    public AjaxResult debit(@RequestBody @Validated AmountDTO dto) {
        return this.capitalService.debitOrDeposit(dto, true);
    }

    /**
     * 向银行存入金币
     * @param dto 请求体
     */
    @PostMapping("/deposit")
    //@Log(businessType = BusinessType.UPDATE, operatorType = OperatorType.OTHER)
    public AjaxResult deposit(@RequestBody @Validated AmountDTO dto) {
        return this.capitalService.debitOrDeposit(dto, false);
    }

    /**
     * 查询账户
     */
    @GetMapping("/account")
    public AjaxResult getAccount() {
        return this.capitalService.getAccount();
    }

    /**
     * 绑定兑换账号
     * @param dto 请求体
     */
    @PostMapping("/bind/account")
    public AjaxResult bindAccount(@RequestBody @Validated BindAccountDTO dto) {
        return this.capitalService.bindAccount(dto);
    }

    /**
     * 兑换
     * @param dto 请求体
     */
    @PostMapping("/exchange")
    public AjaxResult exchange(@RequestBody @Validated ExchangeDTO dto) {
        return this.capitalService.exchange(dto);
    }

    /**
     * 查询兑换记录
     * @param dto 请求体
     */
    @PostMapping("/exchange/record")
    public PageResult<ExchangeRecordDTO> exchangeRecord(@RequestBody @Validated PageBody dto) {
        return this.capitalService.exchangeRecord(dto);
    }

    /**
     * 转账
     * @param dto 请求体
     */
    @PostMapping("/transfer")
    public AjaxResult transfer(@RequestBody @Validated TransferDTO dto) {
        return this.capitalService.transfer(dto);
    }

    /**
     * 查询转账记录
     * @param dto 请求体
     */
    @PostMapping("/transfer/record")
    public PageResult<TransferRecordDTO> transferRecord(@RequestBody @Validated PageBody dto) {
        return this.capitalService.transferRecord(dto);
    }

    /**
     * 查询玩家累积转账金额
     */
    @GetMapping("/transfer/acc")
    public AjaxResult transferAcc() {
        return this.capitalService.transferAcc();
    }

    /**
     * 购买钻石
     * @param index 数量索引，索引-数量：1-10，2-50，3-100，4-200，5-500，6-1000
     */
    @GetMapping("/diamond/buy/{index}")
    public AjaxResult buyDiamond(@PathVariable("index") Integer index) {
        return this.capitalService.buyDiamond(index);
    }
}
