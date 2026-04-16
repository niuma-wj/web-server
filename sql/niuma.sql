-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 103.54.45.68    Database: niuma
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agency`
--

DROP TABLE IF EXISTS `agency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agency` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `player_id` varchar(32) NOT NULL COMMENT '玩家id',
  `superior_id` varchar(32) DEFAULT NULL COMMENT '上级代理玩家id',
  `level` int NOT NULL COMMENT '代理等级',
  `junior_count` int NOT NULL DEFAULT '0' COMMENT '下级玩家((包含下级代理的下级玩家)数量',
  `total_reward` bigint DEFAULT '0' COMMENT '累计已领取奖励',
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_index` (`player_id`),
  KEY `superior_index` (`superior_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agency`
--

LOCK TABLES `agency` WRITE;
/*!40000 ALTER TABLE `agency` DISABLE KEYS */;
/*!40000 ALTER TABLE `agency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agency_collect`
--

DROP TABLE IF EXISTS `agency_collect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agency_collect` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` varchar(32) NOT NULL COMMENT '玩家id',
  `amount` bigint NOT NULL COMMENT '领取数量',
  `time` datetime NOT NULL COMMENT '领取时间',
  PRIMARY KEY (`id`),
  KEY `player_index` (`player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代理奖励领取记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agency_collect`
--

LOCK TABLES `agency_collect` WRITE;
/*!40000 ALTER TABLE `agency_collect` DISABLE KEYS */;
/*!40000 ALTER TABLE `agency_collect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agency_reward`
--

DROP TABLE IF EXISTS `agency_reward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agency_reward` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` varchar(32) NOT NULL COMMENT '获得奖励玩家id',
  `amount` bigint NOT NULL COMMENT '奖励数量',
  `junior_id` varchar(32) DEFAULT NULL COMMENT '产生本次奖励的直接下级玩家id(代理或者非代理)',
  `indirect` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为间接代理奖励(收益)',
  `venue_id` varchar(32) NOT NULL COMMENT '产生奖励的场地id',
  `remark` varchar(256) DEFAULT NULL COMMENT '备注',
  `collect_id` bigint DEFAULT NULL COMMENT '领取记录id',
  `time` datetime NOT NULL COMMENT '产生奖励的时间',
  PRIMARY KEY (`id`),
  KEY `player_index` (`player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代理奖励表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agency_reward`
--

LOCK TABLES `agency_reward` WRITE;
/*!40000 ALTER TABLE `agency_reward` DISABLE KEYS */;
/*!40000 ALTER TABLE `agency_reward` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buy_diamond`
--

DROP TABLE IF EXISTS `buy_diamond`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buy_diamond` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` varchar(32) NOT NULL COMMENT '玩家id',
  `diamond` bigint NOT NULL COMMENT '购买钻石数量',
  `gold` bigint NOT NULL COMMENT '花费金币数量',
  `time` datetime DEFAULT NULL COMMENT '购买时间',
  PRIMARY KEY (`id`),
  KEY `player_index` (`player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购买钻石记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buy_diamond`
--

LOCK TABLES `buy_diamond` WRITE;
/*!40000 ALTER TABLE `buy_diamond` DISABLE KEYS */;
/*!40000 ALTER TABLE `buy_diamond` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `capital`
--

DROP TABLE IF EXISTS `capital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capital` (
  `player_id` varchar(16) NOT NULL COMMENT '玩家id',
  `gold` bigint NOT NULL DEFAULT '0' COMMENT '金币数量，系统中0.1元人民币对应100金币',
  `deposit` bigint NOT NULL DEFAULT '0' COMMENT '银行金币存款',
  `diamond` bigint NOT NULL DEFAULT '0' COMMENT '砖石数量，系统中初始价为每25个金币购买1个钻石，即相当于0.025元人民币1枚钻石',
  `password` varchar(100) DEFAULT NULL COMMENT '银行密码',
  `alipay_account` varchar(100) DEFAULT NULL COMMENT '支付宝账号',
  `alipay_name` varchar(45) DEFAULT NULL COMMENT '支付宝账号姓名',
  `bank_account` varchar(100) DEFAULT NULL COMMENT '银行卡账号',
  `bank_name` varchar(45) DEFAULT NULL COMMENT '银行卡账号姓名',
  `version` bigint DEFAULT '0' COMMENT '因为玩家资产可能会被多个地方同时更新，为避免出现数据安全问题，使用乐观锁机制来做数据同步',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='玩家资产表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `capital`
--

LOCK TABLES `capital` WRITE;
/*!40000 ALTER TABLE `capital` DISABLE KEYS */;
/*!40000 ALTER TABLE `capital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cash_pledge`
--

DROP TABLE IF EXISTS `cash_pledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cash_pledge` (
  `player_id` varchar(32) NOT NULL COMMENT '玩家id',
  `venue_id` varchar(32) NOT NULL COMMENT '场地id',
  `amount` bigint NOT NULL COMMENT '押金数额',
  `time` datetime NOT NULL COMMENT '最后修改时间',
  UNIQUE KEY `main_index` (`player_id`,`venue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='押金表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cash_pledge`
--

LOCK TABLES `cash_pledge` WRITE;
/*!40000 ALTER TABLE `cash_pledge` DISABLE KEYS */;
/*!40000 ALTER TABLE `cash_pledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `district`
--

DROP TABLE IF EXISTS `district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `district` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '区域id',
  `name` varchar(45) NOT NULL COMMENT '区域名称',
  `gold_need` int NOT NULL COMMENT '进入区域所需的最小金币数量',
  `diamond_need` int NOT NULL COMMENT '进入区域所需的最小钻石数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='区域表，区域内包含任意多个场地，例如逮狗腿游戏中的新手房';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `district`
--

LOCK TABLES `district` WRITE;
/*!40000 ALTER TABLE `district` DISABLE KEYS */;
INSERT INTO `district` VALUES (1,'逮狗腿新手房',1500,2),(2,'逮狗腿初级房',3000,2),(3,'逮狗腿高级房',7500,0),(4,'逮狗腿大师房',15000,0),(5,'掼蛋初级房',0,2),(6,'掼蛋中级房',0,2),(7,'掼蛋高级房',0,2),(8,'掼蛋大师房',0,2);
/*!40000 ALTER TABLE `district` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange`
--

DROP TABLE IF EXISTS `exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` varchar(45) NOT NULL COMMENT '玩家id',
  `amount` bigint NOT NULL COMMENT '兑换数量',
  `account` varchar(100) NOT NULL COMMENT '兑换账号',
  `account_name` varchar(45) NOT NULL COMMENT '兑换账号姓名',
  `account_type` int NOT NULL COMMENT '兑换账号类型',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态，0-审核中，1-兑换成功，2-兑换失败',
  `order_number` varchar(100) DEFAULT NULL COMMENT '兑换订单号',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  `dispose_time` datetime DEFAULT NULL COMMENT '处理时间',
  `dispose_by` varchar(64) DEFAULT NULL COMMENT '处理用户id',
  PRIMARY KEY (`id`),
  KEY `player_index` (`player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange`
--

LOCK TABLES `exchange` WRITE;
/*!40000 ALTER TABLE `exchange` DISABLE KEYS */;
/*!40000 ALTER TABLE `exchange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_bi_ji`
--

DROP TABLE IF EXISTS `game_bi_ji`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_bi_ji` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `number` varchar(16) NOT NULL COMMENT '6位数编号，方便玩家输入编号进入游戏房',
  `mode` int NOT NULL COMMENT '模式，0-扣钻模式，1-扣利模式',
  `di_zhu` int NOT NULL COMMENT '底注',
  `is_public` tinyint DEFAULT '0' COMMENT '是否为公开房间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `venue_id_UNIQUE` (`venue_id`),
  KEY `number_index` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='比鸡游戏房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_bi_ji`
--

LOCK TABLES `game_bi_ji` WRITE;
/*!40000 ALTER TABLE `game_bi_ji` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_bi_ji` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_dumb`
--

DROP TABLE IF EXISTS `game_dumb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_dumb` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(16) NOT NULL COMMENT '场地id，对应venue表id字段',
  `name` varchar(45) NOT NULL COMMENT '名称',
  `max_players` int NOT NULL COMMENT '人数限制',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='空游戏';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_dumb`
--

LOCK TABLES `game_dumb` WRITE;
/*!40000 ALTER TABLE `game_dumb` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_dumb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_fault`
--

DROP TABLE IF EXISTS `game_fault`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_fault` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(32) NOT NULL COMMENT '场地id',
  `server_id` varchar(32) NOT NULL COMMENT '服务器id',
  `processed` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已处理，0-未处理，1-已处理',
  `time` varchar(45) NOT NULL COMMENT '记录时间',
  PRIMARY KEY (`id`),
  KEY `fault_index` (`venue_id`,`server_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='游戏故障记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_fault`
--

LOCK TABLES `game_fault` WRITE;
/*!40000 ALTER TABLE `game_fault` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_fault` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_guan_dan`
--

DROP TABLE IF EXISTS `game_guan_dan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_guan_dan` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `number` varchar(16) NOT NULL COMMENT '房间号',
  `level` int DEFAULT '0' COMMENT '房间等级，0-好友房，1-练习房，2-初级房，3-中级房，4-高级房，5-大师房',
  PRIMARY KEY (`id`),
  UNIQUE KEY `venue_id_UNIQUE` (`venue_id`),
  KEY `number_index` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='掼蛋游戏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_guan_dan`
--

LOCK TABLES `game_guan_dan` WRITE;
/*!40000 ALTER TABLE `game_guan_dan` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_guan_dan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_guan_dan_round`
--

DROP TABLE IF EXISTS `game_guan_dan_round`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_guan_dan_round` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `round_no` int NOT NULL COMMENT '局号',
  `player_id_0` varchar(16) NOT NULL COMMENT '座位0玩家id',
  `player_id_1` varchar(16) NOT NULL COMMENT '座位1玩家id',
  `player_id_2` varchar(16) NOT NULL COMMENT '座位2玩家id',
  `player_id_3` varchar(16) NOT NULL COMMENT '座位3玩家id',
  `out_order_0` int NOT NULL COMMENT '座位0玩家的出完牌次序，头游为1，依次类推',
  `out_order_1` int NOT NULL COMMENT '座位1玩家的出完牌次序，头游为1，依次类推',
  `out_order_2` int NOT NULL COMMENT '座位2玩家的出完牌次序，头游为1，依次类推',
  `out_order_3` int NOT NULL COMMENT '座位3玩家的出完牌次序，头游为1，依次类推',
  `grade_point_red` int NOT NULL COMMENT '本局红方（0、2座位玩家为红方）级牌牌值(点数)，1-A，2-2....11-J，12-Q，13-K',
  `grade_point_blue` int NOT NULL COMMENT '本局蓝方（1、3座位玩家为蓝方）级牌牌值(点数)，1-A，2-2....11-J，12-Q，13-K',
  `time` datetime NOT NULL COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='掼蛋游戏牌局记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_guan_dan_round`
--

LOCK TABLES `game_guan_dan_round` WRITE;
/*!40000 ALTER TABLE `game_guan_dan_round` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_guan_dan_round` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_lackey`
--

DROP TABLE IF EXISTS `game_lackey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_lackey` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `number` varchar(16) NOT NULL COMMENT '6位数编号，方便玩家输入编号进入游戏房',
  `level` int NOT NULL COMMENT '房间等级',
  `mode` int NOT NULL COMMENT '模式，0-扣钻模式，1-扣利模式',
  `di_zhu` int NOT NULL COMMENT '底注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `venue_id_UNIQUE` (`venue_id`),
  KEY `number_index` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='逮狗腿游戏房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_lackey`
--

LOCK TABLES `game_lackey` WRITE;
/*!40000 ALTER TABLE `game_lackey` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_lackey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_lackey_round`
--

DROP TABLE IF EXISTS `game_lackey_round`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_lackey_round` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `round_no` int NOT NULL COMMENT '局号数',
  `bei_lv` int DEFAULT '1' COMMENT '倍率',
  `landlord` int NOT NULL COMMENT '地主座位号',
  `lackey` int NOT NULL COMMENT '狗腿座位号',
  `time` datetime NOT NULL COMMENT '记录时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_index` (`venue_id`,`round_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='逮狗腿游戏一局记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_lackey_round`
--

LOCK TABLES `game_lackey_round` WRITE;
/*!40000 ALTER TABLE `game_lackey_round` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_lackey_round` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_lackey_round_player`
--

DROP TABLE IF EXISTS `game_lackey_round_player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_lackey_round_player` (
  `round_id` bigint NOT NULL COMMENT '局记录id，对应game_lackey_round表id字段',
  `player_id` varchar(16) NOT NULL COMMENT '玩家id',
  `seat` int DEFAULT NULL COMMENT '座位号',
  `show_card` tinyint DEFAULT '0' COMMENT '是否明牌',
  `score` float DEFAULT NULL COMMENT '得分',
  `xi_qian` int DEFAULT NULL COMMENT '喜钱数量',
  `win_gold` int DEFAULT NULL COMMENT '输赢金币数量',
  UNIQUE KEY `main_index` (`round_id`,`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='逮狗腿游戏中的玩家输赢记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_lackey_round_player`
--

LOCK TABLES `game_lackey_round_player` WRITE;
/*!40000 ALTER TABLE `game_lackey_round_player` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_lackey_round_player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_mahjong`
--

DROP TABLE IF EXISTS `game_mahjong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_mahjong` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `number` varchar(16) NOT NULL COMMENT '6位数编号，方便玩家输入编号进入游戏房',
  `mode` int NOT NULL COMMENT '模式，0-扣钻模式，1-扣利模式',
  `di_zhu` int NOT NULL COMMENT '底注',
  `rule` int NOT NULL COMMENT '玩法规则',
  PRIMARY KEY (`id`),
  UNIQUE KEY `venue_id_UNIQUE` (`venue_id`),
  KEY `number_index` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='麻将游戏房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_mahjong`
--

LOCK TABLES `game_mahjong` WRITE;
/*!40000 ALTER TABLE `game_mahjong` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_mahjong` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_mahjong_record`
--

DROP TABLE IF EXISTS `game_mahjong_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_mahjong_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `round_no` int NOT NULL COMMENT '局号数',
  `player_id0` varchar(16) DEFAULT NULL COMMENT '座位0玩家id',
  `player_id1` varchar(16) DEFAULT NULL COMMENT '座位2玩家id',
  `player_id2` varchar(16) DEFAULT NULL COMMENT '座位0玩家id',
  `player_id3` varchar(16) DEFAULT NULL COMMENT '座位3玩家id',
  `banker` int DEFAULT NULL COMMENT '庄家座位号',
  `score0` int DEFAULT NULL COMMENT '玩家0得分',
  `score1` int DEFAULT NULL COMMENT '玩家1得分',
  `score2` int DEFAULT NULL COMMENT '玩家2得分',
  `score3` int DEFAULT NULL COMMENT '玩家3得分',
  `win_gold0` int DEFAULT NULL COMMENT '玩家0本局输赢的金币数量',
  `win_gold1` int DEFAULT NULL COMMENT '玩家1本局输赢的金币数量',
  `win_gold2` int DEFAULT NULL COMMENT '玩家2本局输赢的金币数量',
  `win_gold3` int DEFAULT NULL COMMENT '玩家3本局输赢的金币数量',
  `playback` longtext COMMENT '回放数据，messagepack序列化内容用zlib压缩再打包成base64',
  `time` datetime DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_index` (`venue_id`,`round_no`),
  KEY `venue_index` (`venue_id`),
  KEY `player_index0` (`player_id0`),
  KEY `player_index1` (`player_id1`),
  KEY `player_index2` (`player_id2`),
  KEY `player_index3` (`player_id3`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='麻将游戏记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_mahjong_record`
--

LOCK TABLES `game_mahjong_record` WRITE;
/*!40000 ALTER TABLE `game_mahjong_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_mahjong_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_niu_niu_100`
--

DROP TABLE IF EXISTS `game_niu_niu_100`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_niu_niu_100` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `venue_id` varchar(16) NOT NULL COMMENT '场地id',
  `number` varchar(16) NOT NULL COMMENT '房间编号',
  `deposit` bigint NOT NULL DEFAULT '0' COMMENT '资金池总数',
  `is_public` tinyint NOT NULL DEFAULT '0' COMMENT '是否为公开房',
  `banker_id` varchar(16) NOT NULL COMMENT '庄家玩家id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `venue_id_UNIQUE` (`venue_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='百人牛牛房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_niu_niu_100`
--

LOCK TABLES `game_niu_niu_100` WRITE;
/*!40000 ALTER TABLE `game_niu_niu_100` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_niu_niu_100` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_scoreboard`
--

DROP TABLE IF EXISTS `game_scoreboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_scoreboard` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` varchar(32) NOT NULL COMMENT '玩家id',
  `game_type` int NOT NULL COMMENT '游戏类型',
  `win_num` int DEFAULT '0' COMMENT '赢局次数',
  `lose_num` int DEFAULT '0' COMMENT '输局次数',
  `draw_num` int DEFAULT '0' COMMENT '平局次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_index` (`player_id`,`game_type`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='游戏计分牌，记录玩家在各种游戏的输赢及平局次数';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_scoreboard`
--

LOCK TABLES `game_scoreboard` WRITE;
/*!40000 ALTER TABLE `game_scoreboard` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_scoreboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player` (
  `id` varchar(32) NOT NULL COMMENT '玩家id',
  `name` varchar(45) DEFAULT NULL COMMENT '登录账号',
  `password` varchar(100) DEFAULT NULL COMMENT '登录密码',
  `nickname` varchar(45) DEFAULT NULL COMMENT '玩家昵称',
  `phone` varchar(45) DEFAULT NULL COMMENT '手机号',
  `sex` tinyint DEFAULT '0' COMMENT '玩家性别(0-未知 1-男 2-女)',
  `avatar` varchar(255) DEFAULT NULL COMMENT '玩家头像',
  `agency_id` varchar(32) DEFAULT NULL COMMENT '代理玩家id，所有代理等级为1的玩家的agency_id字段都为0000000000，即系统账户',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `heartbeat` bigint DEFAULT NULL COMMENT '最近的心跳时间戳，超过30秒无心跳则认为玩家离线',
  `banned` tinyint DEFAULT '0' COMMENT '是否被封禁',
  `del_flag` tinyint DEFAULT '0' COMMENT '删除标志(0未删除 1-已删除)',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `agency_index` (`agency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='玩家表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player`
--

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` VALUES ('07uEi4R679','Arobot_0030','$2a$10$9/bDkyoeVJkHYV.eUEGUGOwPm4WUFnAw0haShkCT8nqr6kzxDqW4e','泡沫の夏','17374314400',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head004.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('0nu8h9vP24','Arobot_0040','$2a$10$12hz2dx5gcPpq.pCiwmmDe1mkviP/BhSQR7RomLlvmT9Y2tN.BSbm','零式','15185424817',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head006.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('0sAWhM1JfA','Arobot_0028','$2a$10$7Pdpz5lAzhZcddmabbbO/eEbnyPdsnNKiC1B7c/.oXsKq4ii12ANy','時計仕掛けの夢','16619939311',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head007.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('3ey066326Z','Arobot_0036','$2a$10$8qVKPsNKyGhfhyYAlCWoBeifiEoWxgRYzU1MOAgqz3sQsmZqeaeaW','竹取物語','15871733478',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head023.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('3r6wXXHP32','Arobot_0010','$2a$10$6E5aACYJPdElfA.05JalGuaG5e26dPQUeWQIlQOuZOp42mPkvIcSS','落樱成诗','18659514894',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head024.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('3Y49n03uKB','Arobot_0038','$2a$10$vNqeqJMmro8RcyyGkmGDRuHMoy2q8rmX4e80JDuPauGLwNIpy5eVW','花鳥風月','13975139977',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head025.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('4KWuFcqKJs','Arobot_0002','$2a$10$dKitIp/g.HPdIPkBPnkwB.IVAK8AiwOwSQOrAfWB11gFNaZxW6QZ2','墨染流年','16315835220',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head033.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:33','admin','2025-08-27 10:02:33'),('530z5udoz1','Arobot_0029','$2a$10$vQArwbjkCxOtMcvsehpkFO4mVUhlwjudOJdqUxPoQrV.a/kL6wpYm','銀河鉄道夜行','16000897360',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head035.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('5YV4mU6Ojg','Arobot_0035','$2a$10$CsvOCJfytEfvyGo9vuyMQebrAD/8eGxaKib6XI3foTt834VcYxsYO','幻夜','18178082922',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head043.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('6lZc3bSb19','Arobot_0006','$2a$10$C3p8YKO9VK5qY3oqcq6bV.caJdrZwTy6k/iGui4urgXiG7NXUCUF.','鹤归孤山','17623920377',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head048.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('6pR94a24ac','Arobot_0024','$2a$10$0.hJxFA.LjtetbWH.3yFQuyb5FwJHF6x6aJIybZ30yDxj395dGeVC','雪ミルク','19088109939',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head049.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('8QC442A8uK','Arobot_0011','$2a$10$COMhCFG65jofx..iT.OZHu8PZXdN8gI28lvn6382zjBEuLbh9Ndf2','风吟Windy','18742922667',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head056.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('9pBpd70J44','Arobot_0014','$2a$10$Z5WaMnEOc3/545qd6rJe6e.bMsydIRhbNvHExaxLH2o1sJXw81npy','星尘Stardust','19534950644',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head060.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('a3x6A3M374','Arobot_0032','$2a$10$nKNBScw60vvhtXKAlqnLcuhINnEnHuFo.q.o8EEpXh04KFPe9JL5y','禅意Zen','16069906142',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head064.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('a3ZqKcr6s4','Arobot_0048','$2a$10$aZOzS8HBY5.kVo6dyWfx8.KldWMlYWkIECDh.a70oQv5Y2picXJOC','数据の花','14384367838',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head065.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('A6G9sls4ND','Arobot_0034','$2a$10$dmfkYDK495SRJoGSlrXRVeDut1bN4DaYdECjebcdkaqUYUyrq42kW','云端的猫','17001354792',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head066.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('b3qqPqM7Bs','Arobot_0050','$2a$10$fdupeiMjQSCMNeeQVqDjvOubc50QjRpiaAzBalIQkz.Lc7vHJeRLa','未来詩人Futurist','13722473198',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head069.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:39','admin','2025-08-27 10:02:39'),('bpmXwdqcpu','Arobot_0039','$2a$10$SHJGuOmj.oFelpCQpANbfu1qfWVT4kVfCpx4a.KZmzru3P0g5s0ri','江户川','18415671516',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head070.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('c3ABsj7p92','Arobot_0031','$2a$10$qLIOy1G8CxMubFhKJozr1OEXKVOVYpPnEAx9pOxp/RVSNMxO1cTzG','浮世绘','18564957859',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head072.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('caW2d9z2rX','Arobot_0041','$2a$10$38r0Er3vGgWxSOaqS9uRI.3/7Oke2Qez2OsPoAVPXzq6cijveBwnG','量子の猫','14889485049',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head073.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('CBppY465VJ','Arobot_0013','$2a$10$5JbKe4eusRZqgKOzpp7CaOT4jkWzD7esk1cB7C7GiDG7MKEaeEk6e','月影Moonlight','17826906162',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head074.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('ckmb5E4794','Arobot_0020','$2a$10$ZWz5vyDXUCgbMPRjmznYx.Dp21y4dYJcVwKIRPXKWoqcPE.bqPeX2','清茶GreenTea','16200931453',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head076.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('Ei7sT8S5Mq','Arobot_0001','$2a$10$GwHvTDb3sOmhBvcAxXhP3OdiV5XU03k1I0ARnN./VwPXJpptXEnji','星河入梦','16088755802',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head078.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:33','admin','2025-08-27 10:02:33'),('fDPK10VM6z','Arobot_0004','$2a$10$3w4o1LDZWjmXWO20cSnWauKYFkm65TBssi5.26.tSRg4ZmfZr/1Lu','竹影摇窗','14172519177',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head079.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('iAGt38va5J','Arobot_0045','$2a$10$WuNMPAAx3CZLeznqUsHJ2eO3Ea6BDzOPP0IySSdum73sEoIe4dnJG','霓虹忍者','19698807889',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head006.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('IOteggSF6k','Arobot_0026','$2a$10$.F1BhoQSIymtmNao9h0ggu7Loff3orlwWmabx.tWEc29NrnVY8yOu','蜜柑日和','13094039927',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head010.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('irI1s9S9H1','Arobot_0017','$2a$10$0mRzjESokLVy59jBHcXlT.ATmSG1MpWig5GTqJn.Ev1Q/QXQheVIi','夜莺Nightingale','13310059520',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head011.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('JC6k0dA8oy','Arobot_0018','$2a$10$toQ4qLwQi7F3PqHztIaNKeG45HAzAUAecqF1CkDYvhGigat1SrASm','流光Luminous','17571859650',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head013.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('kDqTXzcUp2','Arobot_0022','$2a$10$mTqYSa7T4aWShxIl/CI69u4OJrM/fNTLdvNQu93uC5KPUKtd/UQv2','月見草彡','18662376373',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head015.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('LkyD1Ky3S4','Arobot_0019','$2a$10$h7c5QnEMFRYDl4d1knKSN.21OA0Zm3PSjn/5QR4UW/Z5ODeTeAYfK','墨羽Ink','16287762134',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head019.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('M6Pi6hGCQ3','Arobot_0037','$2a$10$CLii63aJ253KqQ7TqmFr/eeC3CGLuYsSdi5J5B9wWv2DoXI5Er2qy','雷神Raijin','13851288180',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head026.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('M9xAJ7Sxp9','Arobot_0016','$2a$10$ePxDEpPiWStiOt32vgGT7eU4BcTOopLJsTEXpvDZMBIfgvuRBgrpK','云歌Cloudy','18556334648',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head027.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('NkAKa3r8qB','Arobot_0049','$2a$10$nbNcm.wSvhXGZL/o.3yTE.lTZ0MeBcgLWo.pR9fw9yow2o9j3h0fq','虚構推理','17442965350',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head033.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:39','admin','2025-08-27 10:02:39'),('OkTu1Sv2d1','Arobot_0033','$2a$10$/KrWWaLIZBmF/UJtYFPZvud/vj5AWhFYWRRRp4WQ5tgja9gaz.3gG','和風Wafuu','16706112964',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head038.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:37','admin','2025-08-27 10:02:37'),('oqd2Z5Lh3i','Arobot_0003','$2a$10$kdIpg841vsXfWYBCGsuqfekUWXFhwVKHT64X7byWGW9a0nlHPHXv2','青瓷若雪','19114719958',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head039.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('Qlc7jmiueJ','Arobot_0046','$2a$10$LT9A6j6HZ2q2jAVrzbeMkuw.bXow1oSS0LJKUZt4W69Vw979QFs1e','电子狐','14328748120',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head048.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('rwL6A0Wb5D','Arobot_0025','$2a$10$RZXTqPIpF7HwZKY3EUg7HOntoGAmq38Y98nZrIJORjXlX01hEnPT6','星野彡','14543975631',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head054.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('s7BY3JfwoE','Arobot_0009','$2a$10$NDeTK4ztYmmqeiyzr7Lk1etbvXtPbNjW2X5rZN2BCt7zsiGKW4KnK','疏影横斜','19521565562',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head056.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('sOYdlizDwL','Arobot_0021','$2a$10$eKysTJR6d4Fo1HZAuTRu.OptPbBJx8cEFYNN8xg8LxLUKxLk/8P4m','桜の詩','17662899375',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head057.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('TF07K6jLeT','Arobot_0015','$2a$10$/HnxXFg/5dwolIl1cNBw6ujPlvgq0THm5nk/CLAjZqyLEM0e2mxNe','花间Floral','13902970919',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head062.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('u2NM39kU5W','Arobot_0044','$2a$10$89zHYq8AP1qEw4WvMCdMKOrUln2r4g9TDHy1698cdcfQzPIuGldHS','蒸汽波少女','19245744459',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head067.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('X320MOL8s0','Arobot_0007','$2a$10$.TQz1JlXBjX9gpf40NF.ReEcRkevgCXxkywlzDIi6Hgi1CO6PdvEW','烟雨江南','19826720303',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head078.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('x6C5Uh8KmE','Arobot_0043','$2a$10$9SoThAe8sCrfoc.Qp4CdCOBzUyY4r5O9PwygNQZeUXDACEjJxgrsm','像素熊猫','18756930427',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head079.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('X773Ew1DhZ','Arobot_0042','$2a$10$dAgFGsLzPdhMiIo8n9qIMOk1n6L/lCoKih4VDM4w22XXyT/F6MJ.S','赛博樱花','16420346617',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head080.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('yE3y4oqM16','Arobot_0005','$2a$10$8V/044FgvnIIq79IJfH9OOuG3OPIEvnrgBkemrVj6LJvHDzFZFavG','云栖松涧','15817900017',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head084.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('YTX3XFMMOX','Arobot_0023','$2a$10$pmLPYRvGrMtgb4Wxovp2Cu8p7KL0lxqGhImYKiY4O/qH3QTn42cYy','風鈴','19184577361',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head001.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36'),('yxi400hBcD','Arobot_0008','$2a$10$fkNQBSR/pe72c7P8Y2s2ieuQOwu9.mOC..tlIFJJdP7IZECqZtEW2','枫桥夜泊','14903773712',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head002.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:34','admin','2025-08-27 10:02:34'),('ZCCDKQkxWi','Arobot_0012','$2a$10$gXlyWqcTlpxczDlP/idNuuku3B723ZuhbmHSbazku7yDtdjtxvhlq','雪舞Snow','15473949807',1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head003.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:35','admin','2025-08-27 10:02:35'),('zqcwFfDx0E','Arobot_0047','$2a$10$um6zHjoOgZw1U1gfJYWSWuza13.IUAQn.r4uxnVXc/Ff1FKTrh/x6','机械蝴蝶','16548608847',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head004.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:38','admin','2025-08-27 10:02:38'),('ZQj5yn3U1t','Arobot_0027','$2a$10$D1s1NPmOeZqo8NJzaA9HtOPG/KM5nuuFC7v6ofqSyf0RUzpId0sfe','電波☆少女','14953933071',2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head005.jpg',NULL,'',NULL,NULL,0,0,'admin','2025-08-27 10:02:36','admin','2025-08-27 10:02:36');
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_head_image_url`
--

DROP TABLE IF EXISTS `player_head_image_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player_head_image_url` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `url` varchar(255) NOT NULL COMMENT '图片链接',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='玩家头像图片链接表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_head_image_url`
--

LOCK TABLES `player_head_image_url` WRITE;
/*!40000 ALTER TABLE `player_head_image_url` DISABLE KEYS */;
INSERT INTO `player_head_image_url` VALUES (1,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head001.jpg'),(2,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head002.jpg'),(3,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head003.jpg'),(4,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head004.jpg'),(5,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head005.jpg'),(6,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head006.jpg'),(7,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head007.jpg'),(8,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head008.jpg'),(9,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head009.jpg'),(10,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head010.jpg'),(11,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head011.jpg'),(12,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head012.jpg'),(13,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head013.jpg'),(14,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head014.jpg'),(15,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head015.jpg'),(16,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head016.jpg'),(17,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head017.jpg'),(18,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head018.jpg'),(19,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head019.jpg'),(20,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head020.jpg'),(21,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head021.jpg'),(22,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head022.jpg'),(23,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head023.jpg'),(24,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head024.jpg'),(25,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head025.jpg'),(26,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head026.jpg'),(27,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head027.jpg'),(28,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head028.jpg'),(29,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head029.jpg'),(30,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head030.jpg'),(31,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head031.jpg'),(32,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head032.jpg'),(33,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head033.jpg'),(34,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head034.jpg'),(35,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head035.jpg'),(36,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head036.jpg'),(37,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head037.jpg'),(38,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head038.jpg'),(39,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head039.jpg'),(40,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head040.jpg'),(41,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head041.jpg'),(42,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head042.jpg'),(43,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head043.jpg'),(44,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head044.jpg'),(45,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head045.jpg'),(46,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head046.jpg'),(47,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head047.jpg'),(48,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head048.jpg'),(49,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head049.jpg'),(50,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head050.jpg'),(51,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head051.jpg'),(52,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head052.jpg'),(53,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head053.jpg'),(54,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head054.jpg'),(55,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head055.jpg'),(56,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head056.jpg'),(57,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head057.jpg'),(58,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head058.jpg'),(59,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head059.jpg'),(60,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head060.jpg'),(61,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head061.jpg'),(62,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head062.jpg'),(63,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head063.jpg'),(64,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head064.jpg'),(65,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head065.jpg'),(66,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head066.jpg'),(67,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head067.jpg'),(68,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head068.jpg'),(69,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head069.jpg'),(70,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head070.jpg'),(71,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head071.jpg'),(72,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head072.jpg'),(73,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head073.jpg'),(74,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head074.jpg'),(75,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head075.jpg'),(76,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head076.jpg'),(77,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head077.jpg'),(78,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head078.jpg'),(79,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head079.jpg'),(80,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head080.jpg'),(81,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head081.jpg'),(82,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head082.jpg'),(83,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head083.jpg'),(84,'https://gzyx.oss-cn-shenzhen.aliyuncs.com/avatar/head084.jpg');
/*!40000 ALTER TABLE `player_head_image_url` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_login_log`
--

DROP TABLE IF EXISTS `player_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` varchar(50) DEFAULT '' COMMENT '玩家id',
  `nickname` varchar(128) DEFAULT '' COMMENT '玩家昵称',
  `login_ip` varchar(50) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=967 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='玩家登录日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_login_log`
--

LOCK TABLES `player_login_log` WRITE;
/*!40000 ALTER TABLE `player_login_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_login_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) NOT NULL COMMENT '状态',
  `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) NOT NULL COMMENT '任务组名',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `robot`
--

DROP TABLE IF EXISTS `robot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `robot` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` varchar(32) DEFAULT NULL COMMENT '玩家id表，对应player表id字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='机器人表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `robot`
--

LOCK TABLES `robot` WRITE;
/*!40000 ALTER TABLE `robot` DISABLE KEYS */;
INSERT INTO `robot` VALUES (1,'Ei7sT8S5Mq'),(2,'4KWuFcqKJs'),(3,'oqd2Z5Lh3i'),(4,'fDPK10VM6z'),(5,'yE3y4oqM16'),(6,'6lZc3bSb19'),(7,'X320MOL8s0'),(8,'yxi400hBcD'),(9,'s7BY3JfwoE'),(10,'3r6wXXHP32'),(11,'8QC442A8uK'),(12,'ZCCDKQkxWi'),(13,'CBppY465VJ'),(14,'9pBpd70J44'),(15,'TF07K6jLeT'),(16,'M9xAJ7Sxp9'),(17,'irI1s9S9H1'),(18,'JC6k0dA8oy'),(19,'LkyD1Ky3S4'),(20,'ckmb5E4794'),(21,'sOYdlizDwL'),(22,'kDqTXzcUp2'),(23,'YTX3XFMMOX'),(24,'6pR94a24ac'),(25,'rwL6A0Wb5D'),(26,'IOteggSF6k'),(27,'ZQj5yn3U1t'),(28,'0sAWhM1JfA'),(29,'530z5udoz1'),(30,'07uEi4R679'),(31,'c3ABsj7p92'),(32,'a3x6A3M374'),(33,'OkTu1Sv2d1'),(34,'A6G9sls4ND'),(35,'5YV4mU6Ojg'),(36,'3ey066326Z'),(37,'M6Pi6hGCQ3'),(38,'3Y49n03uKB'),(39,'bpmXwdqcpu'),(40,'0nu8h9vP24'),(41,'caW2d9z2rX'),(42,'X773Ew1DhZ'),(43,'x6C5Uh8KmE'),(44,'u2NM39kU5W'),(45,'iAGt38va5J'),(46,'Qlc7jmiueJ'),(47,'zqcwFfDx0E'),(48,'a3ZqKcr6s4'),(49,'NkAKa3r8qB'),(50,'b3qqPqM7Bs');
/*!40000 ALTER TABLE `robot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2024-08-30 17:22:40','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2024-08-30 17:22:40','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2024-08-30 17:22:40','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2024-08-30 17:22:40','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2024-08-30 17:22:40','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2024-08-30 17:22:40','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','若依科技',0,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2024-08-30 17:22:39','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2024-08-30 17:22:40','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2024-08-30 17:22:40','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2024-08-30 17:22:40','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2024-08-30 17:22:40','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2024-08-30 17:22:40','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2024-08-30 17:22:40','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2024-08-30 17:22:40','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2024-08-30 17:22:40','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2024-08-30 17:22:40','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2024-08-30 17:22:40','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2024-08-30 17:22:40','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2024-08-30 17:22:40','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2024-08-30 17:22:40','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2024-08-30 17:22:40','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2024-08-30 17:22:40','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2024-08-30 17:22:40','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2024-08-30 17:22:40','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2024-08-30 17:22:40','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2024-08-30 17:22:40','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2024-08-30 17:22:40','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2024-08-30 17:22:40','',NULL,'停用状态');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2024-08-30 17:22:40','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2024-08-30 17:22:40','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2024-08-30 17:22:40','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2024-08-30 17:22:40','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2024-08-30 17:22:40','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2024-08-30 17:22:40','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2024-08-30 17:22:40','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2024-08-30 17:22:40','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2024-08-30 17:22:40','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2024-08-30 17:22:40','',NULL,'登录状态列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2024-08-30 17:22:40','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2024-08-30 17:22:40','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2024-08-30 17:22:40','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'游戏管理',0,1,'niuma',NULL,NULL,'',1,0,'M','0','0',NULL,'guide','admin','2024-08-30 17:22:39','',NULL,''),(2,'系统管理',0,2,'system',NULL,'','',1,0,'M','0','0','','system','admin','2024-08-30 17:22:39','',NULL,'系统管理目录'),(3,'系统监控',0,3,'monitor',NULL,'','',1,0,'M','1','0','','monitor','admin','2024-08-30 17:22:39','',NULL,'系统监控目录'),(4,'系统工具',0,4,'tool',NULL,'','',1,0,'M','1','0','','tool','admin','2024-08-30 17:22:39','',NULL,'系统工具目录'),(5,'若依官网',0,5,'http://ruoyi.vip',NULL,'','',0,0,'M','1','0','','guide','admin','2024-08-30 17:22:39','',NULL,'若依官网地址'),(100,'用户管理',2,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2024-08-30 17:22:39','',NULL,'用户管理菜单'),(101,'角色管理',2,2,'role','system/role/index','','',1,0,'C','0','1','system:role:list','peoples','admin','2024-08-30 17:22:39','',NULL,'角色管理菜单'),(102,'菜单管理',2,3,'menu','system/menu/index','','',1,0,'C','0','1','system:menu:list','tree-table','admin','2024-08-30 17:22:39','',NULL,'菜单管理菜单'),(103,'部门管理',2,4,'dept','system/dept/index','','',1,0,'C','0','1','system:dept:list','tree','admin','2024-08-30 17:22:39','',NULL,'部门管理菜单'),(104,'岗位管理',2,5,'post','system/post/index','','',1,0,'C','0','1','system:post:list','post','admin','2024-08-30 17:22:39','',NULL,'岗位管理菜单'),(105,'字典管理',2,6,'dict','system/dict/index','','',1,0,'C','0','1','system:dict:list','dict','admin','2024-08-30 17:22:39','',NULL,'字典管理菜单'),(106,'参数设置',2,7,'config','system/config/index','','',1,0,'C','0','1','system:config:list','edit','admin','2024-08-30 17:22:39','',NULL,'参数设置菜单'),(107,'通知公告',2,8,'notice','system/notice/index','','',1,0,'C','0','1','system:notice:list','message','admin','2024-08-30 17:22:39','',NULL,'通知公告菜单'),(108,'日志管理',2,9,'log','','','',1,0,'M','0','0','','log','admin','2024-08-30 17:22:39','',NULL,'日志管理菜单'),(109,'在线用户',3,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2024-08-30 17:22:39','',NULL,'在线用户菜单'),(110,'定时任务',3,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2024-08-30 17:22:39','',NULL,'定时任务菜单'),(111,'数据监控',3,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2024-08-30 17:22:39','',NULL,'数据监控菜单'),(112,'服务监控',3,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2024-08-30 17:22:39','',NULL,'服务监控菜单'),(113,'缓存监控',3,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2024-08-30 17:22:39','',NULL,'缓存监控菜单'),(114,'缓存列表',3,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2024-08-30 17:22:39','',NULL,'缓存列表菜单'),(115,'表单构建',4,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2024-08-30 17:22:39','',NULL,'表单构建菜单'),(116,'代码生成',4,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2024-08-30 17:22:39','',NULL,'代码生成菜单'),(117,'系统接口',4,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2024-08-30 17:22:39','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2024-08-30 17:22:39','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2024-08-30 17:22:39','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2024-08-30 17:22:39','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2024-08-30 17:22:39','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2024-08-30 17:22:39','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2024-08-30 17:22:39','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2024-08-30 17:22:39','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2024-08-30 17:22:39','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2024-08-30 17:22:39','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2024-08-30 17:22:39','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2024-08-30 17:22:39','',NULL,''),(1200,'玩家管理',1,1,'player','niuma/player/index',NULL,'',1,0,'C','0','0','niuma:player','user','admin','2024-08-30 17:22:39','',NULL,''),(1201,'标准麻将',1,2,'mahjong','niuma/mahjong/index',NULL,'',1,0,'C','0','0','niuma:mahjong','people','admin','2024-08-30 17:22:39','',NULL,''),(1202,'六安比鸡',1,3,'biji','niuma/biji/index',NULL,'',1,0,'C','0','0','niuma:biji','people','admin','2024-08-30 17:22:39','',NULL,''),(1203,'逮狗腿',1,4,'lackey','niuma/lackey/index',NULL,'',1,0,'C','0','0','niuma:lackey','people','admin','2024-08-30 17:22:39','',NULL,''),(1204,'百人牛牛',1,5,'niu100','niuma/niu100/index',NULL,'',1,0,'C','0','0','niuma:niu100','people','admin','2024-08-30 17:22:39','',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2024-08-30 17:22:40','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2024-08-30 17:22:40','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (101,'个人信息',2,'com.niuma.admin.controller.system.SysProfileController.updatePwd()','PUT',1,'admin','研发部门','/system/user/profile/updatePwd','113.12.65.33','XX XX','{}','{\"msg\":\"操作成功\",\"code\":\"00000000\"}',0,NULL,'2026-04-01 09:39:21',318);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2024-08-30 17:22:39','',NULL,''),(2,'se','项目经理',2,'0','admin','2024-08-30 17:22:39','',NULL,''),(3,'hr','人力资源',3,'0','admin','2024-08-30 17:22:39','',NULL,''),(4,'user','普通员工',4,'0','admin','2024-08-30 17:22:39','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2024-08-30 17:22:39','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'0','0','admin','2024-08-30 17:22:39','',NULL,'普通角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,1),(2,2),(2,3),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$AiiL0Nr7voP8IjcmDthAJ.dmn2i2/JWzhEG7wPfOTxgP6GGTc6Tru','0','0','113.12.65.33','2026-04-01 17:39:33','admin','2024-08-30 17:22:39','','2026-04-01 09:39:33','管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','2','127.0.0.1','2024-08-30 17:22:39','admin','2024-08-30 17:22:39','',NULL,'测试员');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `id` int NOT NULL AUTO_INCREMENT,
  `field1` varchar(45) DEFAULT NULL,
  `field2` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test`
--

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer`
--

DROP TABLE IF EXISTS `transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `src_player_id` varchar(45) NOT NULL COMMENT '转账玩家id',
  `dst_player_id` varchar(45) NOT NULL COMMENT '目标玩家id',
  `amount` bigint NOT NULL COMMENT '转账数量',
  `time` datetime NOT NULL COMMENT '转账时间',
  PRIMARY KEY (`id`),
  KEY `src_player_index` (`src_player_id`),
  KEY `dst_player_index` (`dst_player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='转账记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer`
--

LOCK TABLES `transfer` WRITE;
/*!40000 ALTER TABLE `transfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venue`
--

DROP TABLE IF EXISTS `venue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venue` (
  `id` varchar(16) NOT NULL COMMENT '场地id',
  `owner_id` varchar(16) NOT NULL COMMENT '所有者(创建者)玩家id',
  `district_id` int DEFAULT NULL COMMENT '场地所属区域id，对应district表id字段',
  `game_type` int NOT NULL COMMENT '游戏类型',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态，0-正常，1-场地已锁定，2-游戏已结束，3-游戏异常中止，只有正常状态的场地游戏可以加载并运行游戏逻辑',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='场地列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venue`
--

LOCK TABLES `venue` WRITE;
/*!40000 ALTER TABLE `venue` DISABLE KEYS */;
/*!40000 ALTER TABLE `venue` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-01 17:40:29
