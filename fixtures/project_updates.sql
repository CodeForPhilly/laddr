/*!40103 SET TIME_ZONE='+00:00' */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `project_updates` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Class` enum('Laddr\\ProjectUpdate') NOT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatorID` int(11) DEFAULT NULL,
  `Modified` timestamp NULL DEFAULT NULL,
  `ModifierID` int(10) unsigned DEFAULT NULL,
  `ProjectID` int(10) unsigned NOT NULL,
  `Number` int(10) unsigned NOT NULL,
  `Body` text NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ProjectID` (`ProjectID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `project_updates` VALUES (1,'Laddr\\ProjectUpdate','2022-10-05 00:41:20',2,NULL,NULL,1,1,'Today we set up sample data to add to the project repository');


CREATE TABLE `history_project_updates` (
  `RevisionID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ID` int(10) unsigned NOT NULL,
  `Class` enum('Laddr\\ProjectUpdate') NOT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatorID` int(11) DEFAULT NULL,
  `Modified` timestamp NULL DEFAULT NULL,
  `ModifierID` int(10) unsigned DEFAULT NULL,
  `ProjectID` int(10) unsigned NOT NULL,
  `Number` int(10) unsigned NOT NULL,
  `Body` text NOT NULL,
  PRIMARY KEY (`RevisionID`),
  KEY `ID` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `history_project_updates` SELECT NULL AS RevisionID, project_updates.* FROM `project_updates`;
