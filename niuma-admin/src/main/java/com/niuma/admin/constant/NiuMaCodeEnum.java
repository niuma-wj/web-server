package com.niuma.admin.constant;

import com.niuma.common.constant.ICodeEnum;

/**
 * 游戏错误码枚举类型
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.04
 */
public enum NiuMaCodeEnum implements ICodeEnum {
    PLAYER_NOT_EXIST("00100001", "Player account not exist"),
    PLAYER_LOGINED("00100002", "Player already logined"),
    PLAYER_BAD_CREDENTIALS("00100002", "Player account or password error"),
    PLAYER_ENTER_CONFLICT("00100003", "Player is entering one venue, please try again later"),
    PLAYER_ENTER_FREQUENTLY("00100004", "Player entering too frequent, current request is denied"),
    PLAYER_STATUS_ERROR("00100005", "Player has been banned or deleted"),
    SERVER_LIST_EMPTY("00110001", "There is no available server in the system currently"),
    SERVER_INACCESSIBLE("00110002", "The specified server is inaccessible"),
    DEFERRED_COMMAND_FAILED("00110003", "Deferred command failed"),
    VENUE_NOT_EXIST("00120001", "Venue not exist"),
    GAME_TYPE_ERROR("00120002", "Game type error"),
    GAME_STATUS_ERROR("00120003", "Game status error"),
    BANK_PASSWORD_ERROR("00120004", "Bank password error"),
    CAPITAL_AMOUNT_ERROR("00120005", "Capital amount error"),
    DEPOSIT_BALANCE_ERROR("00120006", "Insufficient deposit balance"),
    GOLD_INSUFFICIENT_ERROR("00120007", "Gold insufficient"),
    DIAMOND_INSUFFICIENT_ERROR("00120008", "Diamond insufficient"),
    EXCHANGE_AMOUNT_ERROR("00120009", "The amount to be exchanged must be greater than 50 and a multiple of 50"),
    ACCOUNT_TYPE_ERROR("00120010", "Account type error"),
    ACCOUNT_NOT_BIND("00120011", "No account has been bound"),
    TRANSFER_ERROR("00120012", "Transfer error"),
    AGENCY_ERROR("00120013", "Agency error"),
    REWARD_ERROR("00120014", "Reward error"),
    DIAMOND_PACK_INDEX_ERROR("00120015", "Diamond pack index error"),
    MAHJONG_RECORD_NOT_EXIST("00130001", "Mahjong record not exist"),
    DISTRICT_NOT_EXIST("00130002", "District not exist"),
    PLAYER_REGISTER_ERROR("00130003", "Player register error"),
    ;

    private final String code;
    private final String desc;

    NiuMaCodeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    @Override
    public String getCode() {
        return this.code;
    }

    @Override
    public String getDesc() {
        return this.desc;
    }
}
