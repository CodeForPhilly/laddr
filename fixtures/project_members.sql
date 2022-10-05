/*!40103 SET TIME_ZONE='+00:00' */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `project_members` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Class` enum('Laddr\\ProjectMember') NOT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatorID` int(11) DEFAULT NULL,
  `ProjectID` int(10) unsigned NOT NULL,
  `MemberID` int(10) unsigned NOT NULL,
  `Role` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ProjectMember` (`ProjectID`,`MemberID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `project_members` VALUES (1,'Laddr\\ProjectMember','2022-10-05 00:41:02',2,1,2,'Founder');
