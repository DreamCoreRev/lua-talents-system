-- ----------------------------
-- Table structure for character_talentspell
-- ----------------------------
DROP TABLE IF EXISTS `character_talentspell`;
CREATE TABLE `character_talentspell`  (
  `guid` int(0) UNSIGNED NOT NULL,
  `account_id` int(0) UNSIGNED NOT NULL DEFAULT 0,
  `spell` int(0) UNSIGNED NOT NULL,
  `active` tinyint(0) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`, `spell`, `active`) USING BTREE,
  UNIQUE INDEX `unique_talent`(`guid`, `spell`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;
