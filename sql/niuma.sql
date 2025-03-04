-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: niuma
-- ------------------------------------------------------
-- Server version	8.0.36

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
INSERT INTO `agency` VALUES (1,'GHCsk3q0uW',NULL,1,1,160),(2,'MY8p0z7q00','GHCsk3q0uW',2,0,0);
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
INSERT INTO `agency_collect` VALUES (1,'GHCsk3q0uW',141,'2024-11-17 14:44:07'),(2,'GHCsk3q0uW',8,'2024-11-17 14:57:45'),(3,'GHCsk3q0uW',11,'2024-11-17 15:00:40');
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代理奖励表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agency_reward`
--

LOCK TABLES `agency_reward` WRITE;
/*!40000 ALTER TABLE `agency_reward` DISABLE KEYS */;
INSERT INTO `agency_reward` VALUES (1,'GHCsk3q0uW',10,'MY8p0z7q00',0,'1nr5I779iH','测试',1,'2024-11-17 13:08:42'),(2,'GHCsk3q0uW',12,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(3,'GHCsk3q0uW',8,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(4,'GHCsk3q0uW',9,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(5,'GHCsk3q0uW',6,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(6,'GHCsk3q0uW',11,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(7,'GHCsk3q0uW',13,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(8,'GHCsk3q0uW',16,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(9,'GHCsk3q0uW',4,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(10,'GHCsk3q0uW',5,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(11,'GHCsk3q0uW',2,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(12,'GHCsk3q0uW',1,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(13,'GHCsk3q0uW',3,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(14,'GHCsk3q0uW',7,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(15,'GHCsk3q0uW',10,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(16,'GHCsk3q0uW',11,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(17,'GHCsk3q0uW',13,'MY8p0z7q00',0,'47KJ5qdIMc','测试',1,'2024-11-17 13:25:27'),(18,'GHCsk3q0uW',8,'MY8p0z7q00',0,'47KJ5qdIMc','测试',2,'2024-11-17 14:56:38'),(19,'GHCsk3q0uW',11,'MY8p0z7q00',0,'47KJ5qdIMc','测试',3,'2024-11-17 14:59:24'),(20,'0000000000',0,'GHCsk3q0uW',0,'4H96j7K72Q','玩家(Id:GHCsk3q0uW)在游戏(类型: 1023)中获利5000金币',NULL,'2025-02-20 16:41:39'),(21,'GHCsk3q0uW',0,'MY8p0z7q00',0,'4H96j7K72Q','玩家(Id:MY8p0z7q00)在游戏(类型: 1023)中获利7900金币',NULL,'2025-02-20 16:46:13'),(22,'GHCsk3q0uW',0,'MY8p0z7q00',0,'4H96j7K72Q','玩家(Id:MY8p0z7q00)在游戏(类型: 1023)中获利900金币',NULL,'2025-02-20 17:10:57');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购买钻石记录';
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
INSERT INTO `capital` VALUES ('1T2hb8aj0e',598500,120,974,NULL,NULL,NULL,NULL,NULL,14),('52A6Ov794x',1000000,0,1000,NULL,NULL,NULL,NULL,NULL,1),('6EtExZE9S4',1000000,0,1000,NULL,NULL,NULL,NULL,NULL,1),('bStUmPhnV4',193500,1000,152,NULL,NULL,NULL,NULL,NULL,64),('GHCsk3q0uW',72895000,9110,68,'$2a$10$YJqk72cUnvVyFFtrazil8eWt9XIGAgFxZiLG3QwL8lopP3Z2aCdoO','blackbutterfly66@hotmail.com','wujian','12345678','fuck',144),('MY8p0z7q00',42331,11,52,NULL,NULL,NULL,NULL,NULL,102),('X1ph176VVB',297900,2000,252,NULL,NULL,NULL,NULL,NULL,33);
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
INSERT INTO `cash_pledge` VALUES ('1T2hb8aj0e','PX7kp3tY32',1800,'2025-02-07 17:56:22'),('bStUmPhnV4','PX7kp3tY32',2300,'2025-02-07 17:56:22'),('bStUmPhnV4','X1RpTph6vM',5000,'2024-12-24 12:28:38'),('GHCsk3q0uW','DcDKWsURh8',10000,'2024-12-31 11:55:12'),('GHCsk3q0uW','PX7kp3tY32',1700,'2025-02-07 17:56:22'),('GHCsk3q0uW','X1RpTph6vM',5000,'2024-12-16 14:49:16'),('MY8p0z7q00','DcDKWsURh8',21860,'2024-12-31 11:54:04'),('MY8p0z7q00','PX7kp3tY32',1650,'2025-02-07 17:56:22'),('MY8p0z7q00','X1RpTph6vM',5000,'2024-12-16 15:49:28'),('X1ph176VVB','PX7kp3tY32',1650,'2025-02-07 17:56:22');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='区域表，区域内包含任意多个场地，例如逮狗腿游戏中的新手房';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `district`
--

LOCK TABLES `district` WRITE;
/*!40000 ALTER TABLE `district` DISABLE KEYS */;
INSERT INTO `district` VALUES (1,'逮狗腿新手房',1500,2),(2,'逮狗腿初级房',3000,2),(3,'逮狗腿高级房',7500,0),(4,'逮狗腿大师房',15000,0);
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
INSERT INTO `exchange` VALUES (1,'GHCsk3q0uW',100,'fuck','fuck',0,0,NULL,'2024-11-04 17:11:35',NULL,NULL),(3,'GHCsk3q0uW',100,'12345678','fuck',1,0,NULL,'2024-11-09 11:50:53',NULL,NULL),(4,'GHCsk3q0uW',150,'blackbutterfly66@hotmail.com','wujian',0,2,NULL,'2024-11-09 11:51:08',NULL,NULL),(5,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:17',NULL,NULL),(6,'GHCsk3q0uW',200,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:23',NULL,NULL),(7,'GHCsk3q0uW',100,'blackbutterfly66@hotmail.com','wujian',0,2,NULL,'2024-11-09 11:51:27',NULL,NULL),(8,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:34',NULL,NULL),(9,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:37',NULL,NULL),(10,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,1,'fuck123456','2024-11-09 11:51:38',NULL,NULL),(11,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:40',NULL,NULL),(12,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:42',NULL,NULL),(13,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,1,'hhhggaaa33','2024-11-09 11:51:43',NULL,NULL),(14,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:45',NULL,NULL),(15,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:51',NULL,NULL),(16,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,0,NULL,'2024-11-09 11:51:53',NULL,NULL),(17,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,2,NULL,'2024-11-09 11:51:54',NULL,NULL),(18,'GHCsk3q0uW',50,'blackbutterfly66@hotmail.com','wujian',0,1,'u80','2024-11-09 11:51:56',NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='比鸡游戏房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_bi_ji`
--

LOCK TABLES `game_bi_ji` WRITE;
/*!40000 ALTER TABLE `game_bi_ji` DISABLE KEYS */;
INSERT INTO `game_bi_ji` VALUES (1,'22Bi84rTsq','404164',1,1000,1),(2,'DcDKWsURh8','873246',1,1000,1),(3,'V27H841KFh','292618',0,100,1),(4,'xZ8UQUCeQ7','325324',0,100,1);
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
INSERT INTO `game_dumb` VALUES (1,'1nr5I779iH','DumbGame',3),(2,'47KJ5qdIMc','DumbGame',3),(3,'9hIa350FsU','DumbGame',3),(4,'C0gFoS5Q6m','DumbGame',3),(5,'d9ZJS6e4oH','DumbGame',3),(6,'Qr3K5u492V','DumbGame',3),(7,'qR8ltaH22t','DumbGame',3),(8,'W3puJ7Q32s','DumbGame',3),(9,'XoGmwf8z8u','DumbGame',3),(10,'z8q8I7S8w4','DumbGame',3),(11,'Zjv75Y6aj5','DumbGame',3);
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
INSERT INTO `game_fault` VALUES (1,'PX7kp3tY32','game_server_001',0,'2025-02-12 15:21:57.045');
/*!40000 ALTER TABLE `game_fault` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='逮狗腿游戏房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_lackey`
--

LOCK TABLES `game_lackey` WRITE;
/*!40000 ALTER TABLE `game_lackey` DISABLE KEYS */;
INSERT INTO `game_lackey` VALUES (1,'PX7kp3tY32','278269',1,0,100),(2,'i6e69tDx4x','300177',1,0,100),(3,'4Rwt693Dw6','dist-1',2,0,100),(4,'bQQ0wNyF4p','dist-3',4,1,500),(5,'5kOUhZSP7Q','dist-1',2,0,100),(6,'9P653iJ6qr','dist-1',2,0,100);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='逮狗腿游戏一局记录';
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='麻将游戏房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_mahjong`
--

LOCK TABLES `game_mahjong` WRITE;
/*!40000 ALTER TABLE `game_mahjong` DISABLE KEYS */;
INSERT INTO `game_mahjong` VALUES (1,'oF804b1yYm','037836',0,100,2),(2,'I581n4rOG4','742798',0,100,2),(3,'8wsi0F9HOL','389379',0,100,2),(4,'X1RpTph6vM','706074',0,100,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='麻将游戏记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_mahjong_record`
--

LOCK TABLES `game_mahjong_record` WRITE;
/*!40000 ALTER TABLE `game_mahjong_record` DISABLE KEYS */;
INSERT INTO `game_mahjong_record` VALUES (1,'oF804b1yYm',1,'GHCsk3q0uW','MY8p0z7q00','X1ph176VVB','bStUmPhnV4',0,1,0,-1,0,100,0,-100,0,NULL,'2024-11-18 11:50:10'),(2,'oF804b1yYm',2,'GHCsk3q0uW','MY8p0z7q00','X1ph176VVB','bStUmPhnV4',0,0,1,0,-1,0,100,0,-100,NULL,'2024-11-18 11:42:23'),(3,'oF804b1yYm',3,'GHCsk3q0uW','MY8p0z7q00','X1ph176VVB','bStUmPhnV4',0,-1,1,0,0,-100,100,0,0,NULL,'2024-11-18 11:31:46'),(4,'oF804b1yYm',4,'GHCsk3q0uW','MY8p0z7q00','X1ph176VVB','bStUmPhnV4',0,0,-1,1,0,0,-100,100,0,NULL,'2024-11-18 11:22:06'),(5,'oF804b1yYm',5,'GHCsk3q0uW','MY8p0z7q00','X1ph176VVB','bStUmPhnV4',0,0,0,1,-1,0,0,100,-100,'eJztmVlzFFUYhnt6hslCZIkRI0uAAAEEWcMiS9iJCEUhhkWKJUNmZIIhCdMdIEJFDJtaloqkyiqrvKFIWPSHeNE33vtb0OnvJdb7fek5VIWivOEmVf28z3dy+syZM6dP3/09X8j1FPId3T2FYOS34Yfd+apHYfli+HF/LgwLpd7UWO/ApfOFkh9n1clZOs5qHNl7yVlVnK3Qmc//b31ylomzLclZNs7O6yzN/6/Lkd3QWfWLzIuzrxxZdFOHNSq8p8Pa8VCGu9YxbIuSs5o4e98xbCuTM2nzA0e2MTmbEmeHkodN/t/p5Ew+irOO7JLOMjxql3U2hbNQZ1nOhip8TDLYUx2DvdAx2Ksdg7bZMQ8/dGTbkjOZh8eSB03m/QlHdio5kw+wmJzJ/Q04BvSqI4uGK8x7Ge2MYyV5KzmTu5jmyGYkZ3KH7yRnMtrvOrLZjtVpgWNWbHV8unuTM6k7kvxJyGy6kJxVx9l1nVWND/aTrmKuv0yCkZ/vjIaD/YXgge95T3NdYXdf74F88KDa8/4Ic6ULhfBIT26wUEo9w1W86g+Nxo0GD162/FX6XrmWxuTetJnepKk3ndSbTsdCPZkFvsLg1JvueNSdFdSdZY4F17UYV/p9S+5Nk+mNT71ZTb2Z7BJfaSW7/193MtydhuWVZ06I7oy8bEWe7OJypUJ2P3nkmh0j10Aj1+BYCSazgjxGF4K/vZ9uPYo7lnoU9PSFnujTgXxC0TBrKWEbWAO6zpYvaDtbQNE91tLCDrIGNASUEZRh5BOKbnJjU4QtYw3oEltZQXVsAS1kC3vKJWwpBAu7y3q2gFZw92sY+YRCtmoZ+YSK/B+xH4jusqYZvDphR1lTCBZ+07JsAV1mC79u59gCWs39n87IJ7SI28KvYQNbCqGtmRMtoL3cVr2gFrYUgvW2oEG2FIKF79gVoOxExFaK21IIFr6T0R3WNIM3S9gO1oDWs4Vv8Sy2gDay1SgoYEshWHiqaWQL6AJb2F3MYWs2T3RYcwT1saUQrLmCSmwpBGueoE62FMKsaJpoAdVwW/MFnWRrPg8hLOySmthSCBZ22MfZAlrAVrOguWwpBAuPRpvYUgjWYkEX2VII1hJBX7ClEKwWQTvZauEpB2upoHVsKQQLe4l+thSCtVzQYbaAMmxh7zGPLYVgYReymC2FYGFX0cYW0DG2sL+IbrGmGbxVwuazphAs7EiWsqUQrDWCmtlSCNZaQQW2FIK1TtAnbCkEC2cPB9gCOsRWK+77NmuawdsgbCZrG/inHxYewFexpRCsTYK62VIIFp5Lo69Z0wwenlHXsKYQLJy2rGVLIVh4IjrD1lZeQGDhybedLYVgbRe0my2FYLUJamWrjb+osHYI6mBLIVg7BeXZUgjWLkE5thSCtVvQLrYUgrVH0GdsKQQLz5J72AKaytY+QfvYUgjWfkFpoBpB7UBj5X1sX6m8jf1oeKwfO+jRoLyFDr3x6zSu/fFrD9eZ8esUrrMmrzZ5rWm/zrQ/zdTPMPX1pr7B1M8y9Y2mfrapn2vyJpMvMO03m/YXm/oWU7/M1K809atM/RpTv87Ut5r6jaZ+s6nfYuq3mfo2U7/T1O829XtN/X5Tb+fPx6b+kKk/bOqPmPqjpr7D1B839SdN/SlTf9rUnzX1nab+vKnPm/rPTX3R1F809T2mvtfU95v6kqkPTf0VU3/N1H9p6m+Y+iFTH900DUTDpoXotmkiumvb+Ma28Z1t43vbxg8W/Pjkandve19PPhiJ/vzrn83y51lQCMPyQ2ihN/z2YXEgNSrLljdWHDiRGwxGUp7nPSkOfBoOxkcT8dWzF1f7rgUj5UtvLOjqK5Uz/7n/vFzVUV774sf7tKyCEx7vU0+Lud4Xr0d+eZXXI65XIHMcWavO1Jm86xXI9uSsSm4i67gJ1wuJAzobP1pLxdlBR+Z6QXDGkVV6efBrHNYld1SOiac7stdxYN/myPYkZ9Wvcph/zjUwr+NsfaYja3RMX9fZuuv8/HDyDfovOz8/XmFA35yRvzkjf3NG/n+dkf8L8Lu5jQ==','2024-11-18 11:13:39');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='百人牛牛房间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_niu_niu_100`
--

LOCK TABLES `game_niu_niu_100` WRITE;
/*!40000 ALTER TABLE `game_niu_niu_100` DISABLE KEYS */;
INSERT INTO `game_niu_niu_100` VALUES (1,'4H96j7K72Q','240725',200000,1,'GHCsk3q0uW');
/*!40000 ALTER TABLE `game_niu_niu_100` ENABLE KEYS */;
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
INSERT INTO `player` VALUES ('0000000000','system','123','系统账户','13000000001',1,'https://img1.baidu.com/it/u=135208876,3661679439&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500',NULL,'',NULL,NULL,0,0,'1','2024-11-18 11:50:10','1','2024-11-18 11:50:10'),('1T2hb8aj0e','test04','$2a$10$wnt2yChtpt1Dp.VsUN..GuQxQhmHkXnm4kO3oZlM2cc/4FmZx2Dby','哈哈哈','13000000001',2,'https://img0.baidu.com/it/u=2734228536,2142226880&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500',NULL,'192.168.6.220','2025-02-07 17:40:21',NULL,0,0,'1','2025-02-07 09:12:41','1','2025-02-07 09:12:41'),('52A6Ov794x','wujian123','$2a$10$A03tn4Lax5aJ9C35DsIDbeunBkHG8ejZdOu05zbh5L75jn8ECemNq','大帅哥',NULL,1,'https://img1.baidu.com/it/u=719838411,1769667498&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200',NULL,'192.168.6.220','2025-02-21 17:26:01',NULL,0,0,'','2025-02-21 17:25:11','',NULL),('6EtExZE9S4','wujian321','$2a$10$hBgEUC/u9vT2n/OP8r0D0.Zr3cI/Wv9roVeH86ElPsBrF.xiG/zR6','超级帅',NULL,2,'https://img2.baidu.com/it/u=1824345149,1911120526&fm=253&fmt=auto?w=560&h=560',NULL,'192.168.6.220','2025-02-21 17:55:01',NULL,0,0,'','2025-02-21 17:54:38','','2025-02-21 17:54:38'),('bStUmPhnV4','test02','$2a$10$wnt2yChtpt1Dp.VsUN..GuQxQhmHkXnm4kO3oZlM2cc/4FmZx2Dby','很赚钱','13000000001',2,'https://img0.baidu.com/it/u=3430786044,814387293&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800',NULL,'192.168.6.220','2025-02-13 10:19:54',NULL,0,0,'1','2024-11-14 09:55:39','1','2024-11-16 18:05:50'),('GHCsk3q0uW','test','$2a$10$wnt2yChtpt1Dp.VsUN..GuQxQhmHkXnm4kO3oZlM2cc/4FmZx2Dby','测试','13000000001',1,'https://img0.baidu.com/it/u=1008951549,1654888911&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800','0000000000','192.168.6.220','2025-02-28 17:58:27',1740736767,0,0,'1','2024-09-04 17:54:46','1','2024-09-04 17:54:46'),('MY8p0z7q00','test01','$2a$10$wnt2yChtpt1Dp.VsUN..GuQxQhmHkXnm4kO3oZlM2cc/4FmZx2Dby','测试01','13000000001',1,'https://img2.baidu.com/it/u=4113075832,3609938507&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800','GHCsk3q0uW','192.168.6.220','2025-02-20 16:18:20',NULL,0,0,'1','2024-11-14 09:55:39','1','2024-11-16 18:05:50'),('X1ph176VVB','test03','$2a$10$wnt2yChtpt1Dp.VsUN..GuQxQhmHkXnm4kO3oZlM2cc/4FmZx2Dby','叙利亚','13000000001',2,'https://img2.baidu.com/it/u=3793196658,2571329912&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800',NULL,'192.168.6.220','2025-02-07 17:40:00',NULL,0,0,'1','2024-11-14 09:55:39','1','2024-11-16 18:05:50');
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='玩家头像图片链接表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_head_image_url`
--

LOCK TABLES `player_head_image_url` WRITE;
/*!40000 ALTER TABLE `player_head_image_url` DISABLE KEYS */;
INSERT INTO `player_head_image_url` VALUES (1,'https://img2.baidu.com/it/u=2004973992,3189555268&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),(2,'https://img1.baidu.com/it/u=3504537842,4093548755&fm=253&fmt=auto?w=380&h=380'),(3,'https://img0.baidu.com/it/u=3422754130,3433799279&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'),(4,'https://img2.baidu.com/it/u=1960153582,477579336&fm=253&fmt=auto?w=190&h=190'),(5,'https://img2.baidu.com/it/u=266424191,2007566015&fm=253&fmt=auto?w=200&h=200'),(6,'https://img2.baidu.com/it/u=2305598593,2797748699&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400'),(7,'https://img2.baidu.com/it/u=4062166,1746891740&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),(8,'https://img1.baidu.com/it/u=3065823812,3421730458&fm=253&fmt=auto?w=200&h=200'),(9,'https://img1.baidu.com/it/u=719838411,1769667498&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200'),(10,'https://img2.baidu.com/it/u=2824634646,780660851&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'),(11,'https://img2.baidu.com/it/u=3810255237,267353189&fm=253&fmt=auto?w=200&h=200'),(12,'https://img2.baidu.com/it/u=3143085682,2369085578&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),(13,'https://img0.baidu.com/it/u=2905224039,221289900&fm=253&fmt=auto?w=190&h=190'),(14,'https://img2.baidu.com/it/u=3083421324,807898421&fm=253&fmt=auto?w=190&h=190'),(15,'https://img2.baidu.com/it/u=1824345149,1911120526&fm=253&fmt=auto?w=560&h=560'),(16,'https://img2.baidu.com/it/u=1642331509,2885619576&fm=253&fmt=auto?w=380&h=380'),(17,'https://img0.baidu.com/it/u=2164970106,1560271903&fm=253&fmt=auto&app=138&f=JPEG?w=466&h=500'),(18,'https://img0.baidu.com/it/u=2046248124,2154759334&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400'),(19,'https://img0.baidu.com/it/u=3489792590,1132218596&fm=253&fmt=auto&app=138&f=JPEG?w=300&h=300'),(20,'https://img0.baidu.com/it/u=2724276852,121347606&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),(21,'https://img0.baidu.com/it/u=2849727690,2372839000&fm=253&fmt=auto?w=200&h=200'),(22,'https://img1.baidu.com/it/u=3633759417,4050918485&fm=253&fmt=auto?w=200&h=200'),(23,'https://img2.baidu.com/it/u=1198020951,253516340&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),(24,'https://img0.baidu.com/it/u=1564764337,1455263407&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400'),(25,'https://img0.baidu.com/it/u=2233152071,1751475565&fm=253&fmt=auto?w=200&h=200'),(26,'https://img1.baidu.com/it/u=3980222731,1953389757&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400'),(27,'https://img1.baidu.com/it/u=827476700,1368177613&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),(28,'https://img1.baidu.com/it/u=670030227,2794332894&fm=253&fmt=auto&app=138&f=JPEG?w=342&h=342'),(29,'https://img1.baidu.com/it/u=4187702584,1556137923&fm=253&fmt=auto?w=200&h=200'),(30,'https://img0.baidu.com/it/u=1961738631,1283276695&fm=253&fmt=auto&app=138&f=JPEG?w=250&h=250'),(31,'https://img0.baidu.com/it/u=554125092,2785715895&fm=253&fmt=auto&app=138&f=JPEG?w=233&h=190'),(32,'https://img1.baidu.com/it/u=151309900,1900689304&fm=253&fmt=auto?w=200&h=200'),(33,'https://img2.baidu.com/it/u=4216910686,1106860226&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=400'),(34,'https://img1.baidu.com/it/u=3642489562,3834049763&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500'),(35,'https://img2.baidu.com/it/u=1679751877,1808275553&fm=253&fmt=auto&app=138&f=JPEG?w=360&h=360'),(36,'https://img0.baidu.com/it/u=362181920,647819021&fm=253&fmt=auto&app=120&f=JPEG?w=200&h=200');
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
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='玩家登录日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_login_log`
--

LOCK TABLES `player_login_log` WRITE;
/*!40000 ALTER TABLE `player_login_log` DISABLE KEYS */;
INSERT INTO `player_login_log` VALUES (1,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-09-05 16:18:13'),(2,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-09-05 16:44:09'),(3,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-23 17:43:57'),(4,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-23 17:48:48'),(5,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-23 17:57:40'),(6,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-30 09:40:36'),(7,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-30 10:38:24'),(8,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-30 15:59:59'),(9,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-30 17:42:24'),(10,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-10-31 09:12:04'),(11,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 08:49:36'),(12,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 09:36:15'),(13,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 10:44:46'),(14,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 11:29:48'),(15,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 11:37:23'),(16,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 11:37:43'),(17,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 11:39:30'),(18,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 11:39:53'),(19,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-01 17:47:58'),(20,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-03 11:30:39'),(21,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-03 12:01:40'),(22,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-03 15:18:27'),(23,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-04 08:40:02'),(24,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-04 10:23:01'),(25,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-04 16:56:25'),(26,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-09 11:23:28'),(27,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-09 15:03:12'),(28,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-11-14 09:59:50'),(29,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-14 10:00:25'),(30,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-15 11:29:04'),(31,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-15 14:58:04'),(32,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-16 10:07:25'),(33,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-16 16:28:32'),(34,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-16 18:01:05'),(35,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-11-16 18:05:38'),(36,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-16 18:12:14'),(37,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-17 12:44:18'),(38,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-17 14:43:54'),(39,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-17 15:00:30'),(40,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-17 16:06:10'),(41,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-18 11:26:36'),(42,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-18 15:07:08'),(43,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-18 16:38:53'),(44,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-20 10:35:50'),(45,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-21 08:48:36'),(46,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-11-21 17:16:04'),(47,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-11 10:54:14'),(48,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-12 09:33:21'),(49,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-12 14:42:38'),(50,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-12 17:30:42'),(51,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-12 17:41:25'),(52,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-12 17:46:33'),(53,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-12 17:52:23'),(54,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-12 18:01:15'),(55,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 09:01:04'),(56,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 09:18:08'),(57,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 09:19:23'),(58,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-13 09:35:35'),(59,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 09:36:07'),(60,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 09:37:28'),(61,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 09:38:27'),(62,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 10:06:49'),(63,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 10:12:02'),(64,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 10:13:04'),(65,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-13 11:20:26'),(66,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 11:20:49'),(67,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 11:24:14'),(68,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 11:34:24'),(69,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 11:38:59'),(70,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 11:39:40'),(71,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 11:40:20'),(72,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-13 15:19:00'),(73,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 15:20:21'),(74,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 15:20:55'),(75,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 15:22:10'),(76,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-13 16:21:11'),(77,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 16:22:29'),(78,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 16:23:06'),(79,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 16:23:49'),(80,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 16:40:22'),(81,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 16:55:23'),(82,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 16:57:50'),(83,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 16:58:18'),(84,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 17:06:49'),(85,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 17:09:19'),(86,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 17:11:12'),(87,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-13 17:37:57'),(88,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-13 17:39:27'),(89,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-13 17:40:44'),(90,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-16 09:05:26'),(91,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 09:16:00'),(92,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-16 09:16:30'),(93,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-16 09:17:03'),(94,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 09:19:03'),(95,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-16 10:58:31'),(96,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 10:59:06'),(97,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-16 11:04:34'),(98,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-16 11:05:01'),(99,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 11:20:22'),(100,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-16 11:20:50'),(101,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-16 11:21:15'),(102,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 11:27:06'),(103,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-16 11:27:39'),(104,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-16 11:28:08'),(105,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 11:33:33'),(106,'bStUmPhnV4','很赚钱','127.0.0.1','内网IP','2024-12-16 11:34:11'),(107,'X1ph176VVB','叙利亚','127.0.0.1','内网IP','2024-12-16 11:34:46'),(108,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-16 14:49:08'),(109,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-16 15:47:38'),(110,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 15:49:08'),(111,'MY8p0z7q00','测试01','127.0.0.1','内网IP','2024-12-16 15:59:29'),(112,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-18 09:57:09'),(113,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-18 14:58:04'),(114,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-19 09:05:27'),(115,'GHCsk3q0uW','测试','127.0.0.1','内网IP','2024-12-19 09:36:03'),(116,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-23 10:39:28'),(117,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2024-12-23 10:41:16'),(118,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-23 11:04:16'),(119,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2024-12-23 11:08:22'),(120,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-23 11:23:55'),(121,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2024-12-23 11:26:31'),(122,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2024-12-23 11:32:48'),(123,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2024-12-23 11:36:34'),(124,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2024-12-23 11:56:46'),(125,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-23 15:39:32'),(126,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2024-12-23 16:15:52'),(127,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-23 17:00:37'),(128,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-23 17:23:47'),(129,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-23 17:35:09'),(130,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-23 18:03:47'),(131,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-23 18:19:56'),(132,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-23 18:30:15'),(133,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-23 18:38:09'),(134,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-23 18:43:52'),(135,'GHCsk3q0uW','测试','192.168.6.208','内网IP','2024-12-24 09:51:43'),(136,'GHCsk3q0uW','测试','192.168.6.208','内网IP','2024-12-24 10:22:26'),(137,'GHCsk3q0uW','测试','192.168.6.208','内网IP','2024-12-24 11:24:53'),(138,'GHCsk3q0uW','测试','192.168.6.208','内网IP','2024-12-24 11:55:49'),(139,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-24 12:25:25'),(140,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2024-12-24 12:28:28'),(141,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-24 12:55:35'),(142,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-27 08:44:06'),(143,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-27 10:31:37'),(144,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-27 17:07:39'),(145,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-30 09:36:28'),(146,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-30 09:37:13'),(147,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-30 11:09:36'),(148,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-30 11:11:22'),(149,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-30 12:34:44'),(150,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-30 12:35:33'),(151,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-30 14:38:31'),(152,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-30 14:39:15'),(153,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-30 16:47:06'),(154,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-30 16:51:16'),(155,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-30 17:42:58'),(156,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2024-12-31 10:53:26'),(157,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-31 11:47:09'),(158,'MY8p0z7q00','测试01','192.168.6.208','内网IP','2024-12-31 12:37:45'),(159,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-07 09:32:03'),(160,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 09:49:40'),(161,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 09:53:30'),(162,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 09:54:00'),(163,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 09:54:45'),(164,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 10:12:11'),(165,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 10:13:22'),(166,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 10:13:57'),(167,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 10:16:01'),(168,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 10:45:49'),(169,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 10:46:42'),(170,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 10:48:07'),(171,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 10:48:43'),(172,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 10:56:01'),(173,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 10:56:31'),(174,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 10:56:57'),(175,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 10:57:24'),(176,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 11:16:59'),(177,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 11:17:27'),(178,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 11:17:52'),(179,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 11:18:21'),(180,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 11:25:59'),(181,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 11:26:41'),(182,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 11:27:04'),(183,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 11:27:38'),(184,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-07 15:06:37'),(185,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 15:06:51'),(186,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 15:20:09'),(187,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 15:22:26'),(188,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 15:22:55'),(189,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 15:23:18'),(190,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-07 17:39:08'),(191,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-07 17:39:37'),(192,'X1ph176VVB','叙利亚','192.168.6.220','内网IP','2025-02-07 17:40:01'),(193,'1T2hb8aj0e','哈哈哈','192.168.6.220','内网IP','2025-02-07 17:40:22'),(194,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-12 15:12:34'),(195,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-13 09:00:57'),(196,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-13 09:43:27'),(197,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-13 09:53:46'),(198,'bStUmPhnV4','很赚钱','192.168.6.220','内网IP','2025-02-13 10:19:55'),(199,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-19 11:15:27'),(200,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-20 11:25:49'),(201,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-20 14:46:52'),(202,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-20 15:48:40'),(203,'MY8p0z7q00','测试01','192.168.6.220','内网IP','2025-02-20 16:18:21'),(204,'52A6Ov794x','大帅哥','192.168.6.220','内网IP','2025-02-21 17:26:02'),(205,'6EtExZE9S4','超级帅','192.168.6.220','内网IP','2025-02-21 17:55:02'),(206,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-28 10:21:50'),(207,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-28 14:49:17'),(208,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-28 15:35:14'),(209,'GHCsk3q0uW','测试','192.168.6.220','内网IP','2025-02-28 17:58:27');
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
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','192.168.1.2','内网IP','Chrome 12','Windows 10','0','登录成功','2024-08-30 17:23:50'),(101,'admin','127.0.0.1','内网IP','Chrome 12','Windows 10','0','退出成功','2024-08-30 17:31:09'),(102,'admin','127.0.0.1','内网IP','Chrome 12','Windows 10','0','登录成功','2024-08-30 17:31:13'),(103,'fuck','127.0.0.1','内网IP','Chrome 12','Windows 10','1','用户不存在/密码错误','2024-09-04 15:26:18'),(104,'fuck','127.0.0.1','内网IP','Chrome 12','Windows 10','1','用户不存在/密码错误','2024-09-04 15:27:01'),(105,'fuck','127.0.0.1','内网IP','Chrome 12','Windows 10','1','验证码已失效','2024-09-04 16:55:04'),(106,'fuck','127.0.0.1','内网IP','Chrome 12','Windows 10','1','用户不存在/密码错误','2024-09-04 17:54:13'),(107,'fuck','127.0.0.1','内网IP','Chrome 12','Windows 10','1','用户不存在/密码错误','2024-09-04 17:54:33'),(108,'admin','127.0.0.1','内网IP','Chrome 12','Windows 10','0','登录成功','2024-09-04 17:54:45'),(109,'admin','127.0.0.1','内网IP','Chrome 12','Windows 10','1','验证码错误','2024-09-05 16:14:35'),(110,'admin','127.0.0.1','内网IP','Chrome 12','Windows 10','1','验证码错误','2024-09-05 16:14:39'),(111,'admin','127.0.0.1','内网IP','Chrome 12','Windows 10','0','登录成功','2024-09-05 16:14:52'),(112,NULL,'127.0.0.1','内网IP','Chrome 13','Windows 10','1','* 必须填写','2024-11-13 16:29:52'),(113,NULL,'127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码错误','2024-11-13 16:30:42'),(114,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-02-24 16:24:44'),(115,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-02-25 10:33:43'),(116,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-03 16:32:49'),(117,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','退出成功','2025-03-03 16:33:11'),(118,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-03 16:37:18'),(119,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','退出成功','2025-03-03 16:40:26'),(120,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-03 16:40:43'),(121,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','退出成功','2025-03-03 16:53:43'),(122,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-03 16:53:48'),(123,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-04 10:02:13');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
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
INSERT INTO `sys_menu` VALUES (1,'游戏管理',0,1,'niuma',NULL,NULL,'',1,0,'M','0','0',NULL,'guide','admin','2024-08-30 17:22:39','',NULL,''),(2,'系统管理',0,2,'system',NULL,'','',1,0,'M','0','0','','system','admin','2024-08-30 17:22:39','',NULL,'系统管理目录'),(3,'系统监控',0,3,'monitor',NULL,'','',1,0,'M','1','0','','monitor','admin','2024-08-30 17:22:39','',NULL,'系统监控目录'),(4,'系统工具',0,4,'tool',NULL,'','',1,0,'M','1','0','','tool','admin','2024-08-30 17:22:39','',NULL,'系统工具目录'),(5,'若依官网',0,5,'http://ruoyi.vip',NULL,'','',0,0,'M','1','0','','guide','admin','2024-08-30 17:22:39','',NULL,'若依官网地址'),(100,'用户管理',2,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2024-08-30 17:22:39','',NULL,'用户管理菜单'),(101,'角色管理',2,2,'role','system/role/index','','',1,0,'C','0','1','system:role:list','peoples','admin','2024-08-30 17:22:39','',NULL,'角色管理菜单'),(102,'菜单管理',2,3,'menu','system/menu/index','','',1,0,'C','0','1','system:menu:list','tree-table','admin','2024-08-30 17:22:39','',NULL,'菜单管理菜单'),(103,'部门管理',2,4,'dept','system/dept/index','','',1,0,'C','0','1','system:dept:list','tree','admin','2024-08-30 17:22:39','',NULL,'部门管理菜单'),(104,'岗位管理',2,5,'post','system/post/index','','',1,0,'C','0','1','system:post:list','post','admin','2024-08-30 17:22:39','',NULL,'岗位管理菜单'),(105,'字典管理',2,6,'dict','system/dict/index','','',1,0,'C','0','1','system:dict:list','dict','admin','2024-08-30 17:22:39','',NULL,'字典管理菜单'),(106,'参数设置',2,7,'config','system/config/index','','',1,0,'C','0','1','system:config:list','edit','admin','2024-08-30 17:22:39','',NULL,'参数设置菜单'),(107,'通知公告',2,8,'notice','system/notice/index','','',1,0,'C','0','1','system:notice:list','message','admin','2024-08-30 17:22:39','',NULL,'通知公告菜单'),(108,'日志管理',2,9,'log','','','',1,0,'M','0','0','','log','admin','2024-08-30 17:22:39','',NULL,'日志管理菜单'),(109,'在线用户',3,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2024-08-30 17:22:39','',NULL,'在线用户菜单'),(110,'定时任务',3,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2024-08-30 17:22:39','',NULL,'定时任务菜单'),(111,'数据监控',3,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2024-08-30 17:22:39','',NULL,'数据监控菜单'),(112,'服务监控',3,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2024-08-30 17:22:39','',NULL,'服务监控菜单'),(113,'缓存监控',3,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2024-08-30 17:22:39','',NULL,'缓存监控菜单'),(114,'缓存列表',3,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2024-08-30 17:22:39','',NULL,'缓存列表菜单'),(115,'表单构建',4,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2024-08-30 17:22:39','',NULL,'表单构建菜单'),(116,'代码生成',4,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2024-08-30 17:22:39','',NULL,'代码生成菜单'),(117,'系统接口',4,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2024-08-30 17:22:39','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2024-08-30 17:22:39','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2024-08-30 17:22:39','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2024-08-30 17:22:39','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2024-08-30 17:22:39','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2024-08-30 17:22:39','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2024-08-30 17:22:39','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2024-08-30 17:22:39','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2024-08-30 17:22:39','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2024-08-30 17:22:39','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2024-08-30 17:22:39','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2024-08-30 17:22:39','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2024-08-30 17:22:39','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2024-08-30 17:22:39','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2024-08-30 17:22:39','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2024-08-30 17:22:39','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2024-08-30 17:22:39','',NULL,''),(1200,'玩家管理',1,1,'player','niuma/player/index',NULL,'',1,0,'C','0','0','niuma:player','user','admin','2024-08-30 17:22:39','',NULL,''),(1201,'标准麻将',1,1,'mahjong','niuma/mahjong/index',NULL,'',1,0,'C','0','0','niuma:mahjong','people','admin','2024-08-30 17:22:39','',NULL,''),(1202,'六安比鸡',1,1,'biji','niuma/biji/index',NULL,'',1,0,'C','0','0','niuma:biji','people','admin','2024-08-30 17:22:39','',NULL,''),(1203,'逮狗腿',1,1,'lackey','niuma/lackey/index',NULL,'',1,0,'C','0','0','niuma:lackey','people','admin','2024-08-30 17:22:39','',NULL,''),(1204,'百人牛牛',1,1,'niu100','niuma/niu100/index',NULL,'',1,0,'C','0','0','niuma:niu100','people','admin','2024-08-30 17:22:39','',NULL,'');
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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'用户管理',3,'com.niuma.admin.controller.system.SysUserController.remove()','DELETE',1,'admin','研发部门','/system/user/2','127.0.0.1','内网IP','{}','{\"msg\":\"操作成功\",\"code\":\"00000000\"}',0,NULL,'2025-03-04 10:02:29',48);
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
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$PpeuNOjjZhm.qtRT2DH7E.jzcBlEzhHXubHR.zXbAPtTjz58D65mG','0','0','127.0.0.1','2025-03-04 10:02:14','admin','2024-08-30 17:22:39','','2025-03-04 10:02:13','管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','2','127.0.0.1','2024-08-30 17:22:39','admin','2024-08-30 17:22:39','',NULL,'测试员');
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
INSERT INTO `test` VALUES (1,'sdas','basdabb'),(2,'aaa','bbb'),(3,'sdas','basdabb'),(4,'aaa','bbb'),(6,'aaa','bbb'),(7,'sdas','basdabb'),(8,'aaa','bbb'),(9,'sdas','basdabb'),(10,'wujian1','powerful');
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
INSERT INTO `transfer` VALUES (1,'GHCsk3q0uW','MY8p0z7q00',5,'2024-11-15 11:50:09'),(2,'GHCsk3q0uW','MY8p0z7q00',6,'2024-11-15 11:55:16');
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
INSERT INTO `venue` VALUES ('1nr5I779iH','GHCsk3q0uW',1,0,'2024-10-31 17:40:25'),('22Bi84rTsq','GHCsk3q0uW',1027,2,'2024-12-30 09:37:27'),('47KJ5qdIMc','GHCsk3q0uW',1,0,'2024-10-30 10:34:17'),('4H96j7K72Q','GHCsk3q0uW',1023,0,'2025-02-19 11:34:39'),('4Rwt693Dw6','0000000000',1028,0,'2025-02-12 15:32:16'),('5kOUhZSP7Q','0000000000',1028,0,'2025-02-13 10:19:13'),('8wsi0F9HOL','GHCsk3q0uW',1021,2,'2024-12-16 11:26:46'),('9hIa350FsU','GHCsk3q0uW',1,0,'2024-10-30 16:09:46'),('9P653iJ6qr','0000000000',1028,0,'2025-02-13 10:20:02'),('bQQ0wNyF4p','0000000000',1028,0,'2025-02-12 16:02:57'),('C0gFoS5Q6m','GHCsk3q0uW',1,0,'2024-10-30 11:53:54'),('d9ZJS6e4oH','GHCsk3q0uW',1,0,'2024-10-30 10:45:05'),('DcDKWsURh8','GHCsk3q0uW',1027,0,'2024-12-30 11:18:00'),('I581n4rOG4','GHCsk3q0uW',1021,2,'2024-12-16 11:19:54'),('i6e69tDx4x','GHCsk3q0uW',1028,2,'2025-02-07 09:37:49'),('oF804b1yYm','GHCsk3q0uW',1021,2,'2024-12-11 11:09:52'),('PX7kp3tY32','GHCsk3q0uW',1028,0,'2025-02-07 09:32:16'),('Qr3K5u492V','GHCsk3q0uW',1,0,'2024-10-30 10:46:25'),('qR8ltaH22t','GHCsk3q0uW',1,0,'2024-10-30 10:26:57'),('V27H841KFh','GHCsk3q0uW',1027,2,'2025-02-28 10:23:57'),('W3puJ7Q32s','GHCsk3q0uW',1,0,'2024-10-30 10:43:53'),('X1RpTph6vM','GHCsk3q0uW',1021,0,'2024-12-16 14:49:15'),('XoGmwf8z8u','GHCsk3q0uW',1,0,'2024-10-30 10:31:25'),('xZ8UQUCeQ7','GHCsk3q0uW',1027,2,'2025-02-28 14:49:23'),('z8q8I7S8w4','GHCsk3q0uW',1,0,'2024-10-30 10:38:24'),('Zjv75Y6aj5','GHCsk3q0uW',1,0,'2024-10-30 10:45:29');
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

-- Dump completed on 2025-03-04 10:06:43
