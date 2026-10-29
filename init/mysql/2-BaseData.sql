-- 2-BaseData.sql: generic data shared by every installation: environments, roles, menus and the development admin user.
USE `infraorgit`;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

LOCK TABLES `EnvironmentDefinitions` WRITE;
/*!40000 ALTER TABLE `EnvironmentDefinitions` DISABLE KEYS */;
REPLACE INTO `EnvironmentDefinitions` (`Id`, `Name`, `Description`, `CreatedAt`, `UpdatedAt`, `Version`) VALUES (1,'PRE','Ambiente di pre-produzione','2026-10-28 14:00:19.887688','2026-10-28 14:00:19.887688',0),(2,'INT','Ambiente di test integrato','2026-10-28 14:00:19.890095','2026-10-28 14:00:19.890095',0),(3,'PROD','Ambiente di produzione','2026-10-28 14:00:19.891223','2026-10-28 14:00:19.891223',0);
/*!40000 ALTER TABLE `EnvironmentDefinitions` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
REPLACE INTO `Roles` (`Id`, `Name`, `Label`, `ScopeEnum`, `CreatedAt`, `UpdatedAt`, `Version`) VALUES (1,'ServerAdmin','Amministratore server','Environment','2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(2,'ServerOperator','Operatore server','Environment','2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(3,'SystemAdmin','Amministratore di sistema','System','2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0);
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `Menus` WRITE;
/*!40000 ALTER TABLE `Menus` DISABLE KEYS */;
REPLACE INTO `Menus` (`Id`, `Name`, `Path`, `IsActive`, `HideBackButton`, `IsVisible`, `Order`, `ParentId`, `CreatedAt`, `UpdatedAt`, `Version`) VALUES (1,'Home','/',1,1,1,0,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(2,'Ambienti','/environments',1,1,1,1,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(3,'Applicazioni','/applications',1,1,1,1,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(4,'Providers','/providers',1,1,1,1,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(5,'Servers','/servers',1,1,1,1,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(6,'Ambiente {name}','/environments/{id}',1,0,0,0,2,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(7,'Applicazione {name}','/applications/{id}',1,0,0,0,3,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(8,'Server {name}','/servers/{id}',1,0,0,0,5,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(9,'Provider {name}','/providers/{id}',1,0,0,0,4,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(10,'Diagrammi','/diagrams',1,1,1,10,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(12,'Progetti','/projects',1,1,1,30,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(13,'Users','/users',1,1,1,40,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(14,'Groups','/groups',1,1,1,50,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(15,'Roles','/roles',1,1,1,60,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(16,'Menu','/menu',1,1,1,70,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(18,'Progetto {name}','/projects/{id}',1,0,0,0,12,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(19,'Credenziali','/credentials',1,1,1,80,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(20,'Comandi','/commands',1,1,1,81,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(21,'Test di rete','/reachability',1,1,1,82,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(22,'Registro esecuzioni','/executions',1,1,1,83,NULL,'2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0);
/*!40000 ALTER TABLE `Menus` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `MenuRole` WRITE;
/*!40000 ALTER TABLE `MenuRole` DISABLE KEYS */;
REPLACE INTO `MenuRole` (`MenuId`, `RolesId`) VALUES (13,3),(14,3),(15,3),(16,3),(19,3),(20,3),(21,3),(22,3);
/*!40000 ALTER TABLE `MenuRole` ENABLE KEYS */;
UNLOCK TABLES;

-- Development user of keycloak/realm-infraorgit.json, SystemAdmin on a fresh volume. Negative Id: AUTO_INCREMENT
-- never produces it, so the REPLACE of 3-CustomData.sql cannot hand the role over to a different user.
LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
REPLACE INTO `Users` (`Id`, `Name`, `Surname`, `Username`, `CreatedAt`, `UpdatedAt`, `Version`) VALUES (-1,'Dev','Admin','admin','2026-10-25 00:00:00.000000','2026-10-25 00:00:00.000000',0),(5,'Sensei','Kiritof','senseikiritof','2026-10-28 14:00:19.911489','2026-10-28 14:00:19.911489',0);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `RoleUser` WRITE;
/*!40000 ALTER TABLE `RoleUser` DISABLE KEYS */;
REPLACE INTO `RoleUser` (`RolesId`, `UsersId`) VALUES (3,-1),(3,5);
/*!40000 ALTER TABLE `RoleUser` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

