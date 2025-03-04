package com.niuma.admin.constant;

/**
 * 游戏相关Redis键名
 * @author wujian
 * @email 393817707@qq.com
 * @date 2024.09.14
 */
public final class NiuMaRedisKeys {
    private NiuMaRedisKeys() {}

    /**
     * 玩家进入场地锁，后根玩家id
     * 当玩家进入或创建一个场地时(例如进入游戏房)，需要获得全局锁，以避免在分布式系统中，同一个
     * 玩家同时进入多个不同的场地。
     */
    public final static String PLAYER_ENTER_LOCK = "player_enter_lock:";

    /**
     * 玩家进入场地数据，后根玩家id
     */
    public final static String PLAYER_ENTER_DATA = "player_enter_data:";

    /**
     * 玩家当前所在的场地id，后根玩家id
     */
    public final static String PLAYER_CURRENT_VENUE = "player_current_venue:";

    /**
     * 玩家当前被授权进入的场地id。后根玩家id
     */
    public final static String PLAYER_AUTHORIZED_VENUE = "player_authorized_venue:";

    /**
     * 玩家消息密钥。后根玩家id
     * 玩家与游戏服务器进行消息通信时，通过该密钥进行md5加密签名（玩家+'&'+timestamp+'&'+nonce），
     * 已验证玩家合法性及防止重放攻击
     */
    public final static String PLAYER_MESSAGE_SECRET = "player_message_secret:";

    /**
     * 场地当前所在的服务器id，后跟场地id
     * 每个服务器实例都有唯一id，该id同时作为RabbitMQ定向消息路由键
     */
    public final static String VENUE_SERVER_MAP = "venue_server_map:";

    /**
     * 场地服务器集合
     * 该集合实际上是分布式系统的服务器注册表，该集合中包含了当前分布式系统中全部游戏服务器id
     */
    public final static String VENUE_SERVER_SET = "venue_server_set";

    /**
     * 场地分配锁，后加场地id
     * 将场地分配给服务器前先上全局锁，以免不同线程同一时刻将同一场地分配到不同服务器
     */
    public final static String VENUE_ASSIGN_LOCK = "venue_assign_lock:";

    /**
     * 服务器当前玩家数量，后加服务器id
     */
    public final static String SERVER_PLAYER_COUNT = "server_player_count:";

    /**
     * 服务器访问地址，后加服务器id
     * 数据格式为ip:port，例如192.168.1.100:10086
     */
    public final static String SERVER_ACCESS_ADDRESS = "server_access_address:";

    /**
     * 场地服务器保活时间，后加服务器id
     * 值为unix时间戳，单位秒，定时更新该数值以进行服务器保活
     */
    public final static String SERVER_KEEP_ALIVE = "server_keep_alive:";

    /**
     *  场地内当前玩家数量，后加场地id
     */
    public final static String VENUE_PLAYER_COUNT = "venue_player_count:";

    /**
     * 区域内的场地登记表，后加区域id
     * key-场地id，value-刷新时间，超过30秒不刷新认为该场地无效（例如后台停机维护之后留存在Redis中的数据）
     */
    public final static String DISTRICT_VENUE_REGISTER = "district_venue_register_";

    /**
     * 区域内玩家人数未满的场地哈希表，后加区域id
     * key-场地id，value-玩家人数
     */
    public final static String DISTRICT_NOT_FULL_VENUES = "district_not_full_venues_";

    /**
     * 区域内玩家进入过的场地哈希表，{0}-区域id，{1}-玩家id
     * 用于记录玩家进入的场地轨迹，以便为玩家切换区域内场地提供依据
     * key-场地id，value-离开时刻的unix时间戳
     */
    public final static String DISTRICT_PLAYER_TRACK = "district_{0}_player_track:{1}";

    /**
     * 区域内场地的授权时间哈希表，{0}-区域id，{1}-场地id
     * 当一个玩家被授权进入某个区域内场地时，记录该玩家及时间
     * key-玩家id，value-授权时刻的unix时间戳
     */
    public final static String DISTRICT_AUTHORIZED_TIMES = "district_{0}_authorized_times:{1}";

    /**
     * 区域内场地的授权时间哈希表锁，{0}-区域id，{1}-场地id
     * 在访问哈希表前先上锁，以解决不同线程之间的数据同步问题
     */
    public final static String DISTRICT_AUTHORIZED_LOCK = "district_{0}_authorized_lock:{1}";

    /**
     * 区域内场地的玩家数量，后加区域id
     */
    public final static String DISTRICT_PLAYER_COUNT = "district_player_count_";
}
