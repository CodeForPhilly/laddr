/*!40103 SET TIME_ZONE='+00:00' */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `project_buzz` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Class` enum('Laddr\\ProjectBuzz') NOT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatorID` int(11) DEFAULT NULL,
  `ProjectID` int(10) unsigned NOT NULL,
  `Handle` varchar(255) NOT NULL,
  `Headline` varchar(255) NOT NULL,
  `URL` varchar(255) NOT NULL,
  `Published` timestamp NOT NULL,
  `ImageID` int(10) unsigned DEFAULT NULL,
  `Summary` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Handle` (`Handle`),
  KEY `ProjectID` (`ProjectID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `project_buzz` VALUES (1,'Laddr\\ProjectBuzz','2022-10-05 00:42:40',2,1,'laddr_v3.1.1_released','Laddr v3.1.1 released!','https://github.com/CodeForPhilly/laddr/releases/tag/v3.1.1','2022-08-06 19:15:00',NULL,'## Technical\r\n\r\n- chore(deps): bump emergence-slack to v1.0.2 @themightychris');
