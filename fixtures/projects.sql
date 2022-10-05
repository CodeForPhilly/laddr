/*!40103 SET TIME_ZONE='+00:00' */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `projects` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Class` enum('Laddr\\Project') NOT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatorID` int(11) DEFAULT NULL,
  `Modified` timestamp NULL DEFAULT NULL,
  `ModifierID` int(10) unsigned DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `Handle` varchar(255) NOT NULL,
  `MaintainerID` int(10) unsigned DEFAULT NULL,
  `UsersUrl` varchar(255) DEFAULT NULL,
  `DevelopersUrl` varchar(255) DEFAULT NULL,
  `README` text,
  `NextUpdate` int(10) unsigned NOT NULL DEFAULT '1',
  `Stage` enum('Commenting','Bootstrapping','Prototyping','Testing','Maintaining','Drifting','Hibernating') NOT NULL DEFAULT 'Commenting',
  `ChatChannel` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Handle` (`Handle`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `projects` VALUES (1,'Laddr\\Project','2022-10-05 00:41:02',2,'2022-10-05 00:41:20',2,'Laddr','laddr',2,'http://codeforphilly.github.io/laddr/','https://github.com/CodeForPhilly/laddr',NULL,2,'Maintaining','laddr');


CREATE TABLE `history_projects` (
  `RevisionID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ID` int(10) unsigned NOT NULL,
  `Class` enum('Laddr\\Project') NOT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatorID` int(11) DEFAULT NULL,
  `Modified` timestamp NULL DEFAULT NULL,
  `ModifierID` int(10) unsigned DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `Handle` varchar(255) NOT NULL,
  `MaintainerID` int(10) unsigned DEFAULT NULL,
  `UsersUrl` varchar(255) DEFAULT NULL,
  `DevelopersUrl` varchar(255) DEFAULT NULL,
  `README` text,
  `NextUpdate` int(10) unsigned NOT NULL DEFAULT '1',
  `Stage` enum('Commenting','Bootstrapping','Prototyping','Testing','Maintaining','Drifting','Hibernating') NOT NULL DEFAULT 'Commenting',
  `ChatChannel` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RevisionID`),
  KEY `ID` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `history_projects` SELECT NULL AS RevisionID, projects.* FROM `projects`;
