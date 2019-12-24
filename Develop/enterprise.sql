/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 8.0.18 : Database - enterprise
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`enterprise` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `enterprise`;

/*Table structure for table `app_configs` */

DROP TABLE IF EXISTS `app_configs`;

CREATE TABLE `app_configs` (
  `app_id` int(11) NOT NULL AUTO_INCREMENT,
  `config_key` int(11) NOT NULL,
  `config_value` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `app_ios_push_certs` */

DROP TABLE IF EXISTS `app_ios_push_certs`;

CREATE TABLE `app_ios_push_certs` (
  `cert_id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `bundle_id` int(11) NOT NULL,
  `cert_type` int(11) NOT NULL,
  `cert_memo` int(11) NOT NULL,
  `uploaded` int(11) NOT NULL,
  `expired` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`cert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `app_keys` */

DROP TABLE IF EXISTS `app_keys`;

CREATE TABLE `app_keys` (
  `app_id` int(11) NOT NULL,
  `app_key` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `app_secret` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` int(11) NOT NULL,
  `refresher` int(11) NOT NULL,
  `refreshed_at` int(11) NOT NULL,
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `apps` */

DROP TABLE IF EXISTS `apps`;

CREATE TABLE `apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_id` int(11) NOT NULL,
  `api_hash` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` int(4) NOT NULL DEFAULT '0',
  `channel` int(4) NOT NULL COMMENT '渠道类型 1官网2vivo3oppo4华为5小米6.应用宝7.360 8.app store',
  `force_update` tinyint(1) NOT NULL,
  `down_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `api_id` (`api_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='apps';

/*Table structure for table `auth_keys` */

DROP TABLE IF EXISTS `auth_keys`;

CREATE TABLE `auth_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL COMMENT 'auth_id',
  `body` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'auth_key，原始数据为256的二进制数据，存储时转换成base64格式',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_key_id` (`auth_key_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_op_logs` */

DROP TABLE IF EXISTS `auth_op_logs`;

CREATE TABLE `auth_op_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `ip` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `op_type` int(11) NOT NULL DEFAULT '1',
  `log_text` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_phone_transactions` */

DROP TABLE IF EXISTS `auth_phone_transactions`;

CREATE TABLE `auth_phone_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `phone_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code_expired` int(11) NOT NULL DEFAULT '0',
  `transaction_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sent_code_type` tinyint(4) NOT NULL DEFAULT '0',
  `flash_call_pattern` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `next_code_type` tinyint(4) NOT NULL DEFAULT '0',
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `api_id` int(11) NOT NULL,
  `api_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT '0',
  `created_time` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_hash` (`transaction_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_salts` */

DROP TABLE IF EXISTS `auth_salts`;

CREATE TABLE `auth_salts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `salt` bigint(20) NOT NULL,
  `valid_since` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `auth` (`auth_key_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_seq_updates` */

DROP TABLE IF EXISTS `auth_seq_updates`;

CREATE TABLE `auth_seq_updates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `auth_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `seq` int(11) NOT NULL DEFAULT '0',
  `update_type` int(11) NOT NULL DEFAULT '0',
  `update_data` blob NOT NULL,
  `date2` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_id` (`auth_id`,`user_id`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_updates_state` */

DROP TABLE IF EXISTS `auth_updates_state`;

CREATE TABLE `auth_updates_state` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pts` int(11) NOT NULL DEFAULT '0',
  `pts2` int(11) NOT NULL DEFAULT '0',
  `qts` int(11) NOT NULL DEFAULT '0',
  `qts2` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '-1',
  `seq2` int(11) NOT NULL DEFAULT '-1',
  `date` int(11) NOT NULL,
  `date2` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_key_id` (`auth_key_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_users` */

DROP TABLE IF EXISTS `auth_users`;

CREATE TABLE `auth_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `hash` bigint(20) NOT NULL DEFAULT '0',
  `layer` int(11) NOT NULL DEFAULT '0',
  `device_model` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `system_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `api_id` int(11) NOT NULL DEFAULT '0',
  `app_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `app_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_created` int(11) NOT NULL DEFAULT '0',
  `date_actived` int(11) NOT NULL DEFAULT '0',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `country` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_key_id` (`auth_key_id`,`user_id`),
  KEY `auth_key_id_2` (`auth_key_id`,`user_id`,`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auths` */

DROP TABLE IF EXISTS `auths`;

CREATE TABLE `auths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `layer` int(11) NOT NULL DEFAULT '0',
  `api_id` int(11) NOT NULL,
  `device_model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `system_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `app_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `system_lang_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `lang_pack` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `lang_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `client_ip` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_key_id` (`auth_key_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `banned` */

DROP TABLE IF EXISTS `banned`;

CREATE TABLE `banned` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `banned_time` bigint(20) NOT NULL,
  `expires` bigint(20) NOT NULL DEFAULT '0',
  `banned_reason` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `log` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `bot_commands` */

DROP TABLE IF EXISTS `bot_commands`;

CREATE TABLE `bot_commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bot_id` int(11) NOT NULL,
  `command` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `bot_id` (`bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `bots` */

DROP TABLE IF EXISTS `bots`;

CREATE TABLE `bots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bot_id` int(11) NOT NULL,
  `bot_type` tinyint(4) NOT NULL DEFAULT '0',
  `creator_user_id` int(11) NOT NULL DEFAULT '0',
  `token` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bot_chat_history` tinyint(4) NOT NULL DEFAULT '0',
  `bot_nochats` tinyint(4) NOT NULL DEFAULT '1',
  `verified` tinyint(4) NOT NULL DEFAULT '0',
  `bot_inline_geo` tinyint(4) NOT NULL DEFAULT '0',
  `bot_info_version` int(11) NOT NULL DEFAULT '1',
  `bot_inline_placeholder` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bot_id` (`bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channel_admin_logs` */

DROP TABLE IF EXISTS `channel_admin_logs`;

CREATE TABLE `channel_admin_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `admin_user_id` int(11) NOT NULL,
  `event` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channel_media_unread` */

DROP TABLE IF EXISTS `channel_media_unread`;

CREATE TABLE `channel_media_unread` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `channel_message_id` int(11) NOT NULL,
  `media_unread` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channel_messages` */

DROP TABLE IF EXISTS `channel_messages`;

CREATE TABLE `channel_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `channel_message_id` int(11) NOT NULL,
  `sender_user_id` int(11) NOT NULL,
  `random_id` bigint(20) NOT NULL,
  `pts` int(11) NOT NULL DEFAULT '0',
  `message_data_id` bigint(20) NOT NULL,
  `message_type` tinyint(4) NOT NULL DEFAULT '0',
  `message_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `media_type` tinyint(4) NOT NULL DEFAULT '-1',
  `has_media_unread` tinyint(4) NOT NULL DEFAULT '0',
  `edit_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `edit_date` int(11) NOT NULL DEFAULT '0',
  `views` int(11) NOT NULL DEFAULT '1',
  `date` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sender_user_id` (`sender_user_id`,`random_id`),
  UNIQUE KEY `channel_id` (`channel_id`,`channel_message_id`),
  UNIQUE KEY `message_data_id` (`message_data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channel_participants` */

DROP TABLE IF EXISTS `channel_participants`;

CREATE TABLE `channel_participants` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_creator` tinyint(4) NOT NULL DEFAULT '0',
  `is_pinned` tinyint(4) NOT NULL DEFAULT '0',
  `read_inbox_max_id` int(11) NOT NULL DEFAULT '0',
  `read_outbox_max_id` int(11) DEFAULT '0',
  `unread_count` int(11) NOT NULL DEFAULT '0',
  `unread_mentions_count` int(11) NOT NULL DEFAULT '0',
  `unread_mark` tinyint(4) NOT NULL DEFAULT '0',
  `draft_type` tinyint(4) NOT NULL DEFAULT '0',
  `draft_message_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `inviter_user_id` int(11) NOT NULL DEFAULT '0',
  `promoted_by` int(11) NOT NULL DEFAULT '0',
  `admin_rights` int(11) NOT NULL DEFAULT '0',
  `hidden_prehistory` tinyint(4) NOT NULL DEFAULT '0',
  `hidden_prehistory_message_id` int(11) NOT NULL DEFAULT '0',
  `kicked_by` int(11) NOT NULL DEFAULT '0',
  `banned_rights` int(11) NOT NULL DEFAULT '0',
  `banned_until_date` int(11) NOT NULL DEFAULT '0',
  `migrated_from_max_id` int(11) NOT NULL DEFAULT '0',
  `available_min_id` int(11) NOT NULL DEFAULT '0',
  `available_min_pts` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `date2` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_id` (`channel_id`,`user_id`),
  KEY `chat_id` (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channel_pts_updates` */

DROP TABLE IF EXISTS `channel_pts_updates`;

CREATE TABLE `channel_pts_updates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `pts` int(11) NOT NULL,
  `pts_count` int(11) NOT NULL,
  `update_type` tinyint(4) NOT NULL DEFAULT '0',
  `new_message_id` int(11) NOT NULL DEFAULT '0',
  `update_data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date2` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channel_unread_mentions` */

DROP TABLE IF EXISTS `channel_unread_mentions`;

CREATE TABLE `channel_unread_mentions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `peer_type` tinyint(4) NOT NULL,
  `peer_id` int(11) NOT NULL,
  `mentioned_message_id` int(11) NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`,`mentioned_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channel_updates_state` */

DROP TABLE IF EXISTS `channel_updates_state`;

CREATE TABLE `channel_updates_state` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `pts` int(11) NOT NULL DEFAULT '0',
  `pts2` int(11) NOT NULL DEFAULT '0',
  `date` int(11) NOT NULL,
  `date2` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `channels` */

DROP TABLE IF EXISTS `channels`;

CREATE TABLE `channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_user_id` int(11) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `random_id` bigint(20) NOT NULL,
  `top_message` int(11) NOT NULL DEFAULT '0',
  `pinned_msg_id` int(11) NOT NULL DEFAULT '0',
  `date2` int(11) NOT NULL DEFAULT '0',
  `pts` int(11) NOT NULL DEFAULT '0',
  `participants_count` int(11) NOT NULL DEFAULT '0',
  `admins_count` int(11) NOT NULL DEFAULT '0',
  `kicked_count` int(11) NOT NULL DEFAULT '0',
  `banned_count` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `about` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `photo_id` bigint(20) NOT NULL DEFAULT '0',
  `public` tinyint(4) NOT NULL DEFAULT '0',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `link` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `broadcast` tinyint(4) NOT NULL DEFAULT '0',
  `verified` tinyint(4) NOT NULL DEFAULT '0',
  `megagroup` tinyint(4) NOT NULL DEFAULT '0',
  `democracy` tinyint(4) NOT NULL DEFAULT '0',
  `signatures` tinyint(4) NOT NULL DEFAULT '0',
  `admins_enabled` tinyint(4) NOT NULL DEFAULT '0',
  `default_banned_rights` int(11) NOT NULL DEFAULT '0',
  `migrated_from_chat_id` int(11) NOT NULL DEFAULT '0',
  `pre_history_hidden` tinyint(4) NOT NULL DEFAULT '0',
  `deactivated` tinyint(4) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '1',
  `date` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `creator_user_id_3` (`creator_user_id`,`access_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `chat_participants` */

DROP TABLE IF EXISTS `chat_participants`;

CREATE TABLE `chat_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `participant_type` tinyint(4) DEFAULT '0',
  `is_pinned` tinyint(4) NOT NULL DEFAULT '0',
  `top_message` int(11) NOT NULL DEFAULT '0',
  `pinned_msg_id` int(11) NOT NULL DEFAULT '0',
  `read_inbox_max_id` int(11) NOT NULL DEFAULT '0',
  `read_outbox_max_id` int(11) NOT NULL DEFAULT '0',
  `unread_count` int(11) NOT NULL DEFAULT '0',
  `unread_mentions_count` int(11) NOT NULL DEFAULT '0',
  `unread_mark` tinyint(4) NOT NULL DEFAULT '0',
  `draft_type` tinyint(4) NOT NULL DEFAULT '0',
  `draft_message_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `inviter_user_id` int(11) NOT NULL DEFAULT '0',
  `invited_at` int(11) NOT NULL DEFAULT '0',
  `kicked_at` int(11) NOT NULL DEFAULT '0',
  `left_at` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `date2` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chat_id_2` (`chat_id`,`user_id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `chat_unread_mentions` */

DROP TABLE IF EXISTS `chat_unread_mentions`;

CREATE TABLE `chat_unread_mentions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `peer_type` tinyint(4) NOT NULL,
  `peer_id` int(11) NOT NULL,
  `mentioned_message_id` int(11) NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`,`mentioned_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `chats` */

DROP TABLE IF EXISTS `chats`;

CREATE TABLE `chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_user_id` int(11) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `random_id` bigint(20) NOT NULL,
  `participant_count` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `about` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `link` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `photo_id` bigint(20) NOT NULL DEFAULT '0',
  `admins_enabled` tinyint(4) NOT NULL DEFAULT '0',
  `default_banned_rights` int(11) NOT NULL DEFAULT '0',
  `migrated_to_id` int(11) NOT NULL DEFAULT '0',
  `migrated_to_access_hash` bigint(20) NOT NULL DEFAULT '0',
  `deactivated` tinyint(4) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '1',
  `date` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `conversations` */

DROP TABLE IF EXISTS `conversations`;

CREATE TABLE `conversations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `peer_type` tinyint(4) NOT NULL,
  `peer_id` int(11) NOT NULL,
  `is_pinned` tinyint(4) NOT NULL DEFAULT '0',
  `top_message` int(11) NOT NULL DEFAULT '0',
  `read_inbox_max_id` int(11) NOT NULL DEFAULT '0',
  `read_outbox_max_id` int(11) NOT NULL DEFAULT '0',
  `unread_count` int(11) NOT NULL DEFAULT '0',
  `unread_mentions_count` int(11) NOT NULL DEFAULT '0',
  `unread_mark` tinyint(4) NOT NULL DEFAULT '0',
  `draft_type` tinyint(4) NOT NULL DEFAULT '0',
  `draft_message_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date2` int(11) NOT NULL,
  `version` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `devices` */

DROP TABLE IF EXISTS `devices`;

CREATE TABLE `devices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token_type` tinyint(4) NOT NULL,
  `token` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `app_sandbox` tinyint(4) NOT NULL DEFAULT '0',
  `secret` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `other_uids` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_key_id` (`auth_key_id`,`user_id`,`token_type`)
) ENGINE=InnoDB AUTO_INCREMENT=1735 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `documents` */

DROP TABLE IF EXISTS `documents`;

CREATE TABLE `documents` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `document_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `dc_id` int(11) NOT NULL,
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int(11) NOT NULL,
  `uploaded_file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ext` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `thumb_id` bigint(20) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `attributes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `encrypted_files` */

DROP TABLE IF EXISTS `encrypted_files`;

CREATE TABLE `encrypted_files` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `encrypted_file_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `dc_id` int(11) NOT NULL,
  `file_size` int(11) NOT NULL,
  `key_fingerprint` int(11) NOT NULL,
  `md5_checksum` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `file_parts` */

DROP TABLE IF EXISTS `file_parts`;

CREATE TABLE `file_parts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `creator_id` bigint(20) NOT NULL DEFAULT '0',
  `creator_user_id` int(11) NOT NULL DEFAULT '0',
  `file_id` bigint(20) NOT NULL DEFAULT '0',
  `file_part_id` bigint(20) NOT NULL,
  `file_part` int(11) NOT NULL DEFAULT '0',
  `is_big_file` tinyint(4) NOT NULL DEFAULT '0',
  `file_total_parts` int(11) NOT NULL DEFAULT '0',
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` bigint(20) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `files` */

DROP TABLE IF EXISTS `files`;

CREATE TABLE `files` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `creator_id` bigint(20) NOT NULL DEFAULT '0',
  `creator_user_id` int(11) NOT NULL DEFAULT '0',
  `file_part_id` bigint(20) NOT NULL DEFAULT '0',
  `file_parts` int(11) NOT NULL DEFAULT '0',
  `file_size` bigint(20) NOT NULL,
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ext` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_big_file` tinyint(4) NOT NULL DEFAULT '0',
  `md5_checksum` char(33) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `upload_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `imported_contacts` */

DROP TABLE IF EXISTS `imported_contacts`;

CREATE TABLE `imported_contacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `imported_user_id` int(11) NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `user_id_2` (`user_id`,`imported_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `message_boxes` */

DROP TABLE IF EXISTS `message_boxes`;

CREATE TABLE `message_boxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user_message_box_id` int(11) NOT NULL,
  `dialog_id` bigint(20) NOT NULL DEFAULT '0',
  `dialog_message_id` int(11) NOT NULL,
  `message_data_id` bigint(20) NOT NULL,
  `pts` int(11) NOT NULL DEFAULT '0',
  `pts_count` int(11) NOT NULL DEFAULT '1',
  `message_box_type` tinyint(4) NOT NULL,
  `reply_to_msg_id` int(11) NOT NULL DEFAULT '0',
  `mentioned` tinyint(4) NOT NULL DEFAULT '0',
  `media_unread` tinyint(4) NOT NULL DEFAULT '0',
  `message_filter_type` tinyint(4) NOT NULL DEFAULT '0',
  `date2` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`message_data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `message_datas` */

DROP TABLE IF EXISTS `message_datas`;

CREATE TABLE `message_datas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `message_data_id` bigint(20) NOT NULL,
  `dialog_id` bigint(20) NOT NULL,
  `dialog_message_id` int(11) NOT NULL DEFAULT '0',
  `sender_user_id` int(11) NOT NULL,
  `peer_type` tinyint(4) NOT NULL,
  `peer_id` int(11) NOT NULL,
  `random_id` bigint(20) NOT NULL,
  `message_type` tinyint(4) NOT NULL DEFAULT '0',
  `message_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `media_unread` tinyint(4) NOT NULL DEFAULT '0',
  `has_media_unread` tinyint(4) NOT NULL DEFAULT '0',
  `date` int(11) NOT NULL DEFAULT '0',
  `edit_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `edit_date` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dialog_id` (`dialog_id`,`dialog_message_id`),
  UNIQUE KEY `sender_user_id` (`sender_user_id`,`random_id`),
  UNIQUE KEY `message_data_id` (`message_data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `messages` */

DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user_message_box_id` int(11) NOT NULL,
  `dialog_id` bigint(20) NOT NULL DEFAULT '0',
  `dialog_message_id` int(11) NOT NULL,
  `sender_user_id` int(11) NOT NULL,
  `peer_type` tinyint(4) NOT NULL,
  `peer_id` int(11) NOT NULL,
  `random_id` bigint(20) NOT NULL DEFAULT '0',
  `message_type` tinyint(4) NOT NULL DEFAULT '0',
  `message_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_data_id` bigint(20) NOT NULL,
  `pts` int(11) NOT NULL DEFAULT '0',
  `pts_count` int(11) NOT NULL DEFAULT '1',
  `message_box_type` tinyint(4) NOT NULL,
  `reply_to_msg_id` int(11) NOT NULL DEFAULT '0',
  `mentioned` tinyint(4) NOT NULL DEFAULT '0',
  `media_unread` tinyint(4) NOT NULL DEFAULT '0',
  `has_media_unread` tinyint(4) NOT NULL DEFAULT '0',
  `date2` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`message_data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `orgs` */

DROP TABLE IF EXISTS `orgs`;

CREATE TABLE `orgs` (
  `org_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `passwd` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `org_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mail` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`org_id`),
  UNIQUE KEY `account_name` (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `phone_books` */

DROP TABLE IF EXISTS `phone_books`;

CREATE TABLE `phone_books` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `auth_key_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_key_id` (`auth_key_id`,`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9069 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `phone_call_sessions` */

DROP TABLE IF EXISTS `phone_call_sessions`;

CREATE TABLE `phone_call_sessions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `access_hash` bigint(20) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `admin_auth_key_id` bigint(20) NOT NULL DEFAULT '0',
  `participant_auth_key_id` bigint(20) NOT NULL DEFAULT '0',
  `random_id` bigint(20) NOT NULL,
  `admin_protocol` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `participant_protocol` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `g_a_hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `g_a` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `g_b` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `key_fingerprint` bigint(20) NOT NULL DEFAULT '0',
  `connections` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_debug_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `participant_debug_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_rating` int(11) NOT NULL DEFAULT '0',
  `admin_comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `participant_rating` int(11) NOT NULL DEFAULT '0',
  `participant_comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date` int(11) NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_auth_key_id` (`admin_auth_key_id`,`random_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `phones` */

DROP TABLE IF EXISTS `phones`;

CREATE TABLE `phones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `region` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CN',
  `region_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '86',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `photo_datas` */

DROP TABLE IF EXISTS `photo_datas`;

CREATE TABLE `photo_datas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `photo_id` bigint(20) NOT NULL,
  `photo_type` tinyint(4) NOT NULL,
  `dc_id` int(11) NOT NULL,
  `volume_id` bigint(20) NOT NULL,
  `local_id` int(11) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `file_size` int(11) NOT NULL DEFAULT '0',
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ext` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `photos` */

DROP TABLE IF EXISTS `photos`;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `photo_id` int(11) NOT NULL,
  `has_stickers` int(11) NOT NULL DEFAULT '0',
  `access_hash` int(11) NOT NULL,
  `date` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `poll_answer_voters` */

DROP TABLE IF EXISTS `poll_answer_voters`;

CREATE TABLE `poll_answer_voters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `poll_id` bigint(20) NOT NULL,
  `vote_user_id` int(11) NOT NULL,
  `option_id` tinyint(4) NOT NULL,
  `chosen` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `poll_id` (`poll_id`,`vote_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `polls` */

DROP TABLE IF EXISTS `polls`;

CREATE TABLE `polls` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `poll_id` bigint(20) NOT NULL,
  `creator` int(11) NOT NULL,
  `question` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `closed` tinyint(4) NOT NULL DEFAULT '0',
  `text0` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `option0` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `voters0` int(11) NOT NULL DEFAULT '0',
  `text1` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option1` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters1` int(11) NOT NULL DEFAULT '0',
  `text2` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option2` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters2` int(11) NOT NULL DEFAULT '0',
  `text3` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option3` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `voters3` int(11) NOT NULL DEFAULT '0',
  `text4` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option4` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters4` int(11) NOT NULL DEFAULT '0',
  `text5` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option5` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters5` int(11) NOT NULL DEFAULT '0',
  `text6` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option6` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters6` int(11) NOT NULL DEFAULT '0',
  `text7` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option7` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters7` int(11) NOT NULL DEFAULT '0',
  `text8` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option8` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters8` int(11) NOT NULL DEFAULT '0',
  `text9` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `option9` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `voters9` int(11) NOT NULL DEFAULT '0',
  `date2` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `poll_id` (`poll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `popular_contacts` */

DROP TABLE IF EXISTS `popular_contacts`;

CREATE TABLE `popular_contacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `importers` int(11) NOT NULL DEFAULT '1',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `predefined_users` */

DROP TABLE IF EXISTS `predefined_users`;

CREATE TABLE `predefined_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `push_credentials` */

DROP TABLE IF EXISTS `push_credentials`;

CREATE TABLE `push_credentials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token_type` tinyint(4) NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `auth_id` (`auth_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `reports` */

DROP TABLE IF EXISTS `reports`;

CREATE TABLE `reports` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `report_type` tinyint(4) NOT NULL DEFAULT '0',
  `peer_type` tinyint(4) NOT NULL DEFAULT '0',
  `peer_id` int(11) NOT NULL DEFAULT '0',
  `message_sender_user_id` int(11) NOT NULL DEFAULT '0',
  `message_id` int(11) NOT NULL DEFAULT '0',
  `reason` tinyint(4) NOT NULL DEFAULT '0',
  `text` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `secret_chat_messages` */

DROP TABLE IF EXISTS `secret_chat_messages`;

CREATE TABLE `secret_chat_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender_user_id` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `peer_id` int(11) NOT NULL,
  `random_id` bigint(20) NOT NULL,
  `message_type` tinyint(4) NOT NULL DEFAULT '0',
  `message_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date2` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `secret_chat_qts_updates` */

DROP TABLE IF EXISTS `secret_chat_qts_updates`;

CREATE TABLE `secret_chat_qts_updates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `auth_key_id` bigint(20) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `qts` int(11) NOT NULL,
  `chat_message_id` bigint(20) NOT NULL,
  `date2` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `secret_chats` */

DROP TABLE IF EXISTS `secret_chats`;

CREATE TABLE `secret_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `access_hash` bigint(20) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `admin_auth_key_id` bigint(20) NOT NULL DEFAULT '0',
  `participant_auth_key_id` bigint(20) NOT NULL DEFAULT '0',
  `random_id` int(11) NOT NULL,
  `g_a` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `g_b` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `key_fingerprint` bigint(20) NOT NULL DEFAULT '0',
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `date` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sticker_packs` */

DROP TABLE IF EXISTS `sticker_packs`;

CREATE TABLE `sticker_packs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sticker_set_id` bigint(20) NOT NULL,
  `emoticon` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_id` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sticker_sets` */

DROP TABLE IF EXISTS `sticker_sets`;

CREATE TABLE `sticker_sets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sticker_set_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `hash` int(11) NOT NULL DEFAULT '0',
  `official` tinyint(4) NOT NULL DEFAULT '0',
  `mask` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sticker_set_id` (`sticker_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `tmp_passwords` */

DROP TABLE IF EXISTS `tmp_passwords`;

CREATE TABLE `tmp_passwords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `password_hash` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `period` int(11) NOT NULL,
  `tmp_password` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valid_until` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `unregistered_contacts` */

DROP TABLE IF EXISTS `unregistered_contacts`;

CREATE TABLE `unregistered_contacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `importer_user_id` int(11) NOT NULL,
  `import_first_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `import_last_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `imported` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`,`importer_user_id`),
  KEY `phone_2` (`phone`,`importer_user_id`,`imported`)
) ENGINE=InnoDB AUTO_INCREMENT=8984 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_blocks` */

DROP TABLE IF EXISTS `user_blocks`;

CREATE TABLE `user_blocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `block_id` int(11) NOT NULL DEFAULT '0',
  `date` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`block_id`),
  KEY `user_id_2` (`user_id`,`block_id`,`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_contacts` */

DROP TABLE IF EXISTS `user_contacts`;

CREATE TABLE `user_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_user_id` int(11) NOT NULL,
  `contact_user_id` int(11) NOT NULL,
  `contact_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `contact_first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `contact_last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mutual` tinyint(4) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `date2` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner_user_id_2` (`owner_user_id`,`contact_phone`),
  KEY `owner_user_id` (`owner_user_id`,`contact_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_notify_settings` */

DROP TABLE IF EXISTS `user_notify_settings`;

CREATE TABLE `user_notify_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `peer_type` tinyint(4) NOT NULL,
  `peer_id` int(11) NOT NULL,
  `show_previews` tinyint(4) NOT NULL DEFAULT '-1',
  `silent` tinyint(4) NOT NULL DEFAULT '-1',
  `mute_until` int(11) NOT NULL DEFAULT '-1',
  `sound` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_passwords` */

DROP TABLE IF EXISTS `user_passwords`;

CREATE TABLE `user_passwords` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `new_algo_salt1` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `srp_id` bigint(20) NOT NULL DEFAULT '0',
  `srp_b` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `B` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hint` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `has_recovery` tinyint(4) NOT NULL DEFAULT '0',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `code_expired` int(11) NOT NULL DEFAULT '0',
  `attempts` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_presences` */

DROP TABLE IF EXISTS `user_presences`;

CREATE TABLE `user_presences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `last_seen_at` bigint(20) NOT NULL,
  `last_seen_auth_key_id` bigint(20) NOT NULL,
  `last_seen_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `user_id_2` (`user_id`,`last_seen_at`)
) ENGINE=InnoDB AUTO_INCREMENT=394 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_privacies` */

DROP TABLE IF EXISTS `user_privacies`;

CREATE TABLE `user_privacies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key_type` tinyint(4) NOT NULL DEFAULT '0',
  `rules` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`key_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_privacys` */

DROP TABLE IF EXISTS `user_privacys`;

CREATE TABLE `user_privacys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key_type` tinyint(4) NOT NULL DEFAULT '0',
  `rules` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`key_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_profile_photos` */

DROP TABLE IF EXISTS `user_profile_photos`;

CREATE TABLE `user_profile_photos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `photo_id` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_pts_updates` */

DROP TABLE IF EXISTS `user_pts_updates`;

CREATE TABLE `user_pts_updates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pts` int(11) NOT NULL,
  `pts_count` int(11) NOT NULL,
  `update_type` tinyint(4) NOT NULL DEFAULT '0',
  `update_data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date2` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=650 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_qts_updates` */

DROP TABLE IF EXISTS `user_qts_updates`;

CREATE TABLE `user_qts_updates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `qts` int(11) NOT NULL,
  `update_type` int(11) NOT NULL,
  `update_data` blob NOT NULL,
  `date2` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `user_sticker_sets` */

DROP TABLE IF EXISTS `user_sticker_sets`;

CREATE TABLE `user_sticker_sets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `sticker_set_id` bigint(20) NOT NULL DEFAULT '0',
  `archived` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq` (`user_id`,`sticker_set_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `username` */

DROP TABLE IF EXISTS `username`;

CREATE TABLE `username` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `peer_type` tinyint(4) NOT NULL DEFAULT '0',
  `peer_id` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_type` tinyint(4) NOT NULL DEFAULT '0',
  `access_hash` bigint(20) NOT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT '0',
  `about` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `is_bot` tinyint(1) NOT NULL DEFAULT '0',
  `account_days_ttl` int(11) NOT NULL DEFAULT '180',
  `photos` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `min` tinyint(4) NOT NULL DEFAULT '0',
  `restricted` tinyint(4) NOT NULL DEFAULT '0',
  `restriction_reason` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `delete_reason` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=1000004 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `wall_papers` */

DROP TABLE IF EXISTS `wall_papers`;

CREATE TABLE `wall_papers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `color` int(11) NOT NULL DEFAULT '0',
  `bg_color` int(11) NOT NULL DEFAULT '0',
  `photo_id` bigint(20) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
