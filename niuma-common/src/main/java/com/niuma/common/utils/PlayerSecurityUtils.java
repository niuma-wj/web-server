package com.niuma.common.utils;

import com.niuma.common.core.domain.model.LoginPlayer;

public class PlayerSecurityUtils {
    private static final ThreadLocal<LoginPlayer> loginPlayer = new ThreadLocal();

    public static LoginPlayer getLoginPlayer() {
        LoginPlayer player = loginPlayer.get();
        return player;
    }

    public static void setLoginPlayer(LoginPlayer player) {
        loginPlayer.set(player);
    }
}