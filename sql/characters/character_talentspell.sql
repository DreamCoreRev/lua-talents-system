-- ----------------------------
-- Table structure for character_talentspell
-- ----------------------------
DROP TABLE IF EXISTS `character_talentspell`;
CREATE TABLE `character_talentspell`  (
  `guid` int(11) UNSIGNED NOT NULL,
  `spell` int(11) UNSIGNED NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`, `spell`, `active`) USING BTREE,
  UNIQUE INDEX `unique_talent`(`guid`, `spell`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;
