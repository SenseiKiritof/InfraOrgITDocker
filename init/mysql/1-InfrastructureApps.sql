CREATE DATABASE IF NOT EXISTS `infraorgit`;
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
DROP TABLE IF EXISTS `__EFMigrationsHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `__EFMigrationsHistory` (
  `MigrationId` varchar(150) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ApplicationActions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ApplicationActions` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationId` int NOT NULL,
  `Label` varchar(100) NOT NULL,
  `Order` int NOT NULL,
  `CommandTemplateId` int DEFAULT NULL,
  `CustomScript` longtext,
  `ParameterValuesJson` json NOT NULL,
  `RequiresConfirmation` tinyint(1) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ApplicationActions_ApplicationId` (`ApplicationId`),
  KEY `IX_ApplicationActions_CommandTemplateId` (`CommandTemplateId`),
  KEY `IX_ApplicationActions_Order` (`Order`),
  CONSTRAINT `FK_ApplicationActions_Applications_ApplicationId` FOREIGN KEY (`ApplicationId`) REFERENCES `Applications` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ApplicationActions_CommandTemplates_CommandTemplateId` FOREIGN KEY (`CommandTemplateId`) REFERENCES `CommandTemplates` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ApplicationApiQueryParams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ApplicationApiQueryParams` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationApiId` int NOT NULL,
  `Name` varchar(200) NOT NULL,
  `ParamType` varchar(20) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ApplicationApiQueryParams_ApplicationApiId` (`ApplicationApiId`),
  CONSTRAINT `FK_ApplicationApiQueryParams_ApplicationVersionApis_Application~` FOREIGN KEY (`ApplicationApiId`) REFERENCES `ApplicationVersionApis` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `CK_ApplicationApiQueryParams_ParamType` CHECK ((`ParamType` in (_utf8mb4'Int',_utf8mb4'String',_utf8mb4'Bool',_utf8mb4'DateTime',_utf8mb4'Double',_utf8mb4'Decimal')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ApplicationProject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ApplicationProject` (
  `ApplicationsId` int NOT NULL,
  `ProjectsId` int NOT NULL,
  PRIMARY KEY (`ApplicationsId`,`ProjectsId`),
  KEY `IX_ApplicationProject_ProjectsId` (`ProjectsId`),
  CONSTRAINT `FK_ApplicationProject_Applications_ApplicationsId` FOREIGN KEY (`ApplicationsId`) REFERENCES `Applications` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ApplicationProject_Projects_ProjectsId` FOREIGN KEY (`ProjectsId`) REFERENCES `Projects` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Applications` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(200) NOT NULL,
  `BasePath` varchar(50) NOT NULL,
  `ListeningOnPort` int NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_Applications_Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ApplicationVersionApis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ApplicationVersionApis` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationVersionId` int NOT NULL,
  `Url` varchar(200) NOT NULL,
  `RequestTypeEnum` varchar(10) NOT NULL,
  `Description` varchar(200) NOT NULL,
  `Body` longtext,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ApplicationVersionApis_ApplicationVersionId` (`ApplicationVersionId`),
  CONSTRAINT `FK_ApplicationVersionApis_ApplicationVersions_ApplicationVersio~` FOREIGN KEY (`ApplicationVersionId`) REFERENCES `ApplicationVersions` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `CK_ApplicationVersionApis_RequestTypeEnum` CHECK ((`RequestTypeEnum` in (_utf8mb4'GET',_utf8mb4'POST',_utf8mb4'PUT',_utf8mb4'PATCH',_utf8mb4'DELETE')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ApplicationVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ApplicationVersions` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationId` int NOT NULL,
  `VersionNumber` varchar(25) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_ApplicationVersions_ApplicationId_VersionNumber` (`ApplicationId`,`VersionNumber`),
  CONSTRAINT `FK_ApplicationVersions_Applications_ApplicationId` FOREIGN KEY (`ApplicationId`) REFERENCES `Applications` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `CommandExecutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CommandExecutions` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(100) NOT NULL,
  `ServerId` int NOT NULL,
  `ServerName` varchar(200) NOT NULL,
  `Kind` varchar(20) NOT NULL,
  `Label` varchar(200) NOT NULL,
  `Script` longtext NOT NULL,
  `ExitCode` int DEFAULT NULL,
  `Output` longtext NOT NULL,
  `StartedAt` datetime(6) NOT NULL,
  `EndedAt` datetime(6) DEFAULT NULL,
  `IdempotencyKey` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_CommandExecutions_IdempotencyKey` (`IdempotencyKey`),
  KEY `IX_CommandExecutions_ServerId` (`ServerId`),
  KEY `IX_CommandExecutions_StartedAt` (`StartedAt`),
  CONSTRAINT `CK_CommandExecutions_Kind` CHECK ((`Kind` in (_utf8mb4'Action',_utf8mb4'Reachability',_utf8mb4'Console')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `CommandTemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CommandTemplates` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `Script` longtext NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_CommandTemplates_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `DiagramEdges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DiagramEdges` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `DiagramId` int NOT NULL,
  `ProxyConnectionId` int NOT NULL,
  `TargetNodeType` varchar(30) NOT NULL,
  `TargetEntityId` int NOT NULL,
  `SourceHandle` varchar(50) DEFAULT NULL,
  `TargetHandle` varchar(50) DEFAULT NULL,
  `BendX` double DEFAULT NULL,
  `BendY` double DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_DiagramEdges_DiagramId_ProxyConnectionId_TargetNodeType_Targ~` (`DiagramId`,`ProxyConnectionId`,`TargetNodeType`,`TargetEntityId`),
  CONSTRAINT `FK_DiagramEdges_Diagrams_DiagramId` FOREIGN KEY (`DiagramId`) REFERENCES `Diagrams` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `CK_DiagramEdges_TargetNodeType` CHECK ((`TargetNodeType` in (_utf8mb4'Provider',_utf8mb4'ProviderEnvironment',_utf8mb4'Server',_utf8mb4'ServerApplication')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `DiagramNodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DiagramNodes` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `DiagramId` int NOT NULL,
  `NodeType` varchar(30) NOT NULL,
  `EntityId` int NOT NULL,
  `X` double NOT NULL,
  `Y` double NOT NULL,
  `Width` double DEFAULT NULL,
  `Height` double DEFAULT NULL,
  `Collapsed` tinyint(1) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_DiagramNodes_DiagramId_NodeType_EntityId` (`DiagramId`,`NodeType`,`EntityId`),
  CONSTRAINT `FK_DiagramNodes_Diagrams_DiagramId` FOREIGN KEY (`DiagramId`) REFERENCES `Diagrams` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `CK_DiagramNodes_NodeType` CHECK ((`NodeType` in (_utf8mb4'Provider',_utf8mb4'ProviderEnvironment',_utf8mb4'Server',_utf8mb4'ServerApplication')))
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Diagrams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Diagrams` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `IsDefault` tinyint(1) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `DiagramScopeItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DiagramScopeItems` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `DiagramId` int NOT NULL,
  `ScopeType` varchar(30) NOT NULL,
  `EntityId` int NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_DiagramScopeItems_DiagramId_ScopeType_EntityId` (`DiagramId`,`ScopeType`,`EntityId`),
  CONSTRAINT `FK_DiagramScopeItems_Diagrams_DiagramId` FOREIGN KEY (`DiagramId`) REFERENCES `Diagrams` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `CK_DiagramScopeItems_ScopeType` CHECK ((`ScopeType` in (_utf8mb4'Provider',_utf8mb4'ProviderEnvironment',_utf8mb4'Project')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `EnvironmentDefinitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EnvironmentDefinitions` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Description` varchar(250) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_EnvironmentDefinitions_Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Groups` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_Groups_Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `GroupUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GroupUser` (
  `GroupsId` int NOT NULL,
  `UsersId` int NOT NULL,
  PRIMARY KEY (`GroupsId`,`UsersId`),
  KEY `IX_GroupUser_UsersId` (`UsersId`),
  CONSTRAINT `FK_GroupUser_Groups_GroupsId` FOREIGN KEY (`GroupsId`) REFERENCES `Groups` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_GroupUser_Users_UsersId` FOREIGN KEY (`UsersId`) REFERENCES `Users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `MenuRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MenuRole` (
  `MenuId` int NOT NULL,
  `RolesId` int NOT NULL,
  PRIMARY KEY (`MenuId`,`RolesId`),
  KEY `IX_MenuRole_RolesId` (`RolesId`),
  CONSTRAINT `FK_MenuRole_Menus_MenuId` FOREIGN KEY (`MenuId`) REFERENCES `Menus` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_MenuRole_Roles_RolesId` FOREIGN KEY (`RolesId`) REFERENCES `Roles` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Menus` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Path` varchar(200) NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `HideBackButton` tinyint(1) NOT NULL,
  `IsVisible` tinyint(1) NOT NULL,
  `Order` int DEFAULT NULL,
  `ParentId` int DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Menus_ParentId` (`ParentId`),
  CONSTRAINT `FK_Menus_Menus_ParentId` FOREIGN KEY (`ParentId`) REFERENCES `Menus` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Projects` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_Projects_Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ProviderEnvironmentGroupRoles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProviderEnvironmentGroupRoles` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProviderEnvironmentId` int NOT NULL,
  `GroupId` int NOT NULL,
  `RoleId` int NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_ProviderEnvironmentGroupRoles_ProviderEnvironmentId_GroupId_~` (`ProviderEnvironmentId`,`GroupId`,`RoleId`),
  KEY `IX_ProviderEnvironmentGroupRoles_GroupId` (`GroupId`),
  KEY `IX_ProviderEnvironmentGroupRoles_RoleId` (`RoleId`),
  CONSTRAINT `FK_ProviderEnvironmentGroupRoles_Groups_GroupId` FOREIGN KEY (`GroupId`) REFERENCES `Groups` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ProviderEnvironmentGroupRoles_ProviderEnvironments_ProviderE~` FOREIGN KEY (`ProviderEnvironmentId`) REFERENCES `ProviderEnvironments` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ProviderEnvironmentGroupRoles_Roles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `Roles` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ProviderEnvironments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProviderEnvironments` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProviderId` int NOT NULL,
  `EnvironmentDefinitionId` int NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_ProviderEnvironments_ProviderId_EnvironmentDefinitionId` (`ProviderId`,`EnvironmentDefinitionId`),
  KEY `IX_ProviderEnvironments_EnvironmentDefinitionId` (`EnvironmentDefinitionId`),
  CONSTRAINT `FK_ProviderEnvironments_EnvironmentDefinitions_EnvironmentDefin~` FOREIGN KEY (`EnvironmentDefinitionId`) REFERENCES `EnvironmentDefinitions` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_ProviderEnvironments_Providers_ProviderId` FOREIGN KEY (`ProviderId`) REFERENCES `Providers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Providers` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_Providers_Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ProxyConnections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProxyConnections` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `SourceServerId` int NOT NULL,
  `TargetServerId` int NOT NULL,
  `Direction` varchar(20) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ProxyConnections_SourceServerId` (`SourceServerId`),
  KEY `IX_ProxyConnections_TargetServerId` (`TargetServerId`),
  CONSTRAINT `FK_ProxyConnections_Servers_SourceServerId` FOREIGN KEY (`SourceServerId`) REFERENCES `Servers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_ProxyConnections_Servers_TargetServerId` FOREIGN KEY (`TargetServerId`) REFERENCES `Servers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `CK_ProxyConnections_DifferentServers` CHECK ((`SourceServerId` <> `TargetServerId`)),
  CONSTRAINT `CK_ProxyConnections_Direction` CHECK ((`Direction` in (_utf8mb4'Outgoing',_utf8mb4'Incoming')))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ProxyRoutes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProxyRoutes` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProxyConnectionId` int NOT NULL,
  `Route` varchar(200) NOT NULL,
  `MappedTo` varchar(50) DEFAULT NULL,
  `TargetServerApplicationId` int DEFAULT NULL,
  `TargetProxyConnectionId` int DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_ProxyRoutes_ProxyConnectionId_Route` (`ProxyConnectionId`,`Route`),
  KEY `IX_ProxyRoutes_TargetProxyConnectionId` (`TargetProxyConnectionId`),
  KEY `IX_ProxyRoutes_TargetServerApplicationId` (`TargetServerApplicationId`),
  CONSTRAINT `FK_ProxyRoutes_ProxyConnections_ProxyConnectionId` FOREIGN KEY (`ProxyConnectionId`) REFERENCES `ProxyConnections` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ProxyRoutes_ProxyConnections_TargetProxyConnectionId` FOREIGN KEY (`TargetProxyConnectionId`) REFERENCES `ProxyConnections` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_ProxyRoutes_ServerApplications_TargetServerApplicationId` FOREIGN KEY (`TargetServerApplicationId`) REFERENCES `ServerApplications` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ReachabilityTests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReachabilityTests` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ServerId` int DEFAULT NULL,
  `Hostname` varchar(200) NOT NULL,
  `Port` int NOT NULL,
  `Description` varchar(200) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ReachabilityTests_ServerId` (`ServerId`),
  CONSTRAINT `FK_ReachabilityTests_Servers_ServerId` FOREIGN KEY (`ServerId`) REFERENCES `Servers` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `CK_ReachabilityTests_Port` CHECK ((`Port` between 1 and 65535))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Roles` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Label` varchar(100) NOT NULL,
  `ScopeEnum` varchar(20) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_Roles_Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `RoleUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RoleUser` (
  `RolesId` int NOT NULL,
  `UsersId` int NOT NULL,
  PRIMARY KEY (`RolesId`,`UsersId`),
  KEY `IX_RoleUser_UsersId` (`UsersId`),
  CONSTRAINT `FK_RoleUser_Roles_RolesId` FOREIGN KEY (`RolesId`) REFERENCES `Roles` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_RoleUser_Users_UsersId` FOREIGN KEY (`UsersId`) REFERENCES `Users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ServerApplications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ServerApplications` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ServerId` int NOT NULL,
  `ApplicationVersionId` int NOT NULL,
  `ExposedPort` int NOT NULL,
  `ProxyRouteId` int DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_ServerApplications_ProxyRouteId` (`ProxyRouteId`),
  KEY `IX_ServerApplications_ApplicationVersionId` (`ApplicationVersionId`),
  KEY `IX_ServerApplications_ServerId` (`ServerId`),
  CONSTRAINT `FK_ServerApplications_ApplicationVersions_ApplicationVersionId` FOREIGN KEY (`ApplicationVersionId`) REFERENCES `ApplicationVersions` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_ServerApplications_ProxyRoutes_ProxyRouteId` FOREIGN KEY (`ProxyRouteId`) REFERENCES `ProxyRoutes` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_ServerApplications_Servers_ServerId` FOREIGN KEY (`ServerId`) REFERENCES `Servers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ServerCredentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ServerCredentials` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Username` varchar(200) NOT NULL,
  `AuthType` varchar(20) NOT NULL,
  `EncryptedSecret` longtext NOT NULL,
  `EncryptedPassphrase` longtext,
  `KeyVersion` int NOT NULL,
  `NeedsReauth` tinyint(1) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_ServerCredentials_Name` (`Name`),
  CONSTRAINT `CK_ServerCredentials_AuthType` CHECK ((`AuthType` in (_utf8mb4'Password',_utf8mb4'PrivateKey')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Servers` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProviderEnvironmentId` int NOT NULL,
  `Name` varchar(200) NOT NULL,
  `IpAddress` varchar(200) NOT NULL,
  `Hostname` varchar(200) NOT NULL,
  `SshPort` int NOT NULL DEFAULT '22',
  `CredentialId` int DEFAULT NULL,
  `HostKeyFingerprint` varchar(100) DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  `JumpServerId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Servers_ProviderEnvironmentId` (`ProviderEnvironmentId`),
  KEY `IX_Servers_CredentialId` (`CredentialId`),
  KEY `IX_Servers_JumpServerId` (`JumpServerId`),
  CONSTRAINT `FK_Servers_ProviderEnvironments_ProviderEnvironmentId` FOREIGN KEY (`ProviderEnvironmentId`) REFERENCES `ProviderEnvironments` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_Servers_ServerCredentials_CredentialId` FOREIGN KEY (`CredentialId`) REFERENCES `ServerCredentials` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_Servers_Servers_JumpServerId` FOREIGN KEY (`JumpServerId`) REFERENCES `Servers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sessions` (
  `Id` varchar(64) NOT NULL,
  `Username` varchar(100) NOT NULL,
  `Payload` longtext NOT NULL,
  `ExpiresAt` datetime(6) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Sessions_ExpiresAt` (`ExpiresAt`),
  KEY `IX_Sessions_Username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Surname` varchar(100) NOT NULL,
  `Username` varchar(100) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) NOT NULL,
  `Version` int NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_Users_Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


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

LOCK TABLES `__EFMigrationsHistory` WRITE;
/*!40000 ALTER TABLE `__EFMigrationsHistory` DISABLE KEYS */;
REPLACE INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`) VALUES ('20261025215632_InitialIdentity','10.0.12'),('20261025223138_Inventory','10.0.12'),('20261025230904_TopologyAndDiagrams','10.0.12'),('20261025232519_RemoteManagement','10.0.12'),('20261026222721_SharedSessions','10.0.12'),('20261027181558_AddServerJumpHost','10.0.12');
/*!40000 ALTER TABLE `__EFMigrationsHistory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

