-- Schema legacy per il rehearsal della Fase 7.
-- Struttura allineata a InfraOrgITDocker/legacy/01-schema.sql
-- (schema legacy): stessi tipi, default, indici e foreign key.
-- Ridotto alle tabelle lette da tools/LegacyImport; restano fuori
-- AdminAuditEntries e __EFMigrationsHistory, che l'importer non legge.
-- Nessun dato e nessun artefatto reale: i dati fittizi stanno in 02-data.sql.
-- Il database è già selezionato da MYSQL_DATABASE / connection string.

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

CREATE TABLE `ApplicationApiQueryParams` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationApiId` int NOT NULL,
  `Name` varchar(200) NOT NULL,
  `ParamType` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ApplicationApiQueryParams_ApplicationApiId` (`ApplicationApiId`),
  CONSTRAINT `FK_ApplicationApiQueryParams_ApplicationVersionApis_Application~` FOREIGN KEY (`ApplicationApiId`) REFERENCES `ApplicationVersionApis` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ApplicationActions` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationId` int NOT NULL,
  `Label` varchar(100) NOT NULL,
  `Order` int NOT NULL,
  `CommandTemplateId` int DEFAULT NULL,
  `CustomScript` longtext,
  `ParameterValues` longtext NOT NULL,
  `RequiresConfirmation` tinyint(1) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ApplicationActions_ApplicationId` (`ApplicationId`),
  KEY `IX_ApplicationActions_CommandTemplateId` (`CommandTemplateId`),
  CONSTRAINT `FK_ApplicationActions_Applications_ApplicationId` FOREIGN KEY (`ApplicationId`) REFERENCES `Applications` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ApplicationActions_CommandTemplates_CommandTemplateId` FOREIGN KEY (`CommandTemplateId`) REFERENCES `CommandTemplates` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  PRIMARY KEY (`Id`),
  KEY `IX_CommandExecutions_ServerId` (`ServerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `CommandTemplates` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `Script` longtext NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ApplicationProject` (
  `ApplicationsId` int NOT NULL,
  `ProjectsId` int NOT NULL,
  PRIMARY KEY (`ApplicationsId`,`ProjectsId`),
  KEY `IX_ApplicationProject_ProjectsId` (`ProjectsId`),
  CONSTRAINT `FK_ApplicationProject_Applications_ApplicationsId` FOREIGN KEY (`ApplicationsId`) REFERENCES `Applications` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ApplicationProject_Projects_ProjectsId` FOREIGN KEY (`ProjectsId`) REFERENCES `Projects` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Applications` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(200) NOT NULL,
  `BasePath` varchar(50) NOT NULL,
  `ListeningOnPort` int NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ApplicationVersionApis` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationVersionId` int NOT NULL,
  `Url` varchar(200) NOT NULL,
  `RequestTypeEnum` int NOT NULL,
  `Description` varchar(200) NOT NULL,
  `Body` longtext,
  PRIMARY KEY (`Id`),
  KEY `IX_ApplicationVersionApis_ApplicationVersionId` (`ApplicationVersionId`),
  CONSTRAINT `FK_ApplicationVersionApis_ApplicationVersions_ApplicationVersio~` FOREIGN KEY (`ApplicationVersionId`) REFERENCES `ApplicationVersions` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ApplicationVersions` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ApplicationId` int NOT NULL,
  `VersionNumber` varchar(25) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ApplicationVersions_ApplicationId` (`ApplicationId`),
  CONSTRAINT `FK_ApplicationVersions_Applications_ApplicationId` FOREIGN KEY (`ApplicationId`) REFERENCES `Applications` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `DiagramNodes` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `DiagramId` int NOT NULL,
  `NodeType` varchar(30) NOT NULL,
  `EntityId` int NOT NULL,
  `X` double NOT NULL,
  `Y` double NOT NULL,
  `Width` double DEFAULT NULL,
  `Height` double DEFAULT NULL,
  `Collapsed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `IX_DiagramNodes_DiagramId` (`DiagramId`),
  CONSTRAINT `FK_DiagramNodes_Diagrams_DiagramId` FOREIGN KEY (`DiagramId`) REFERENCES `Diagrams` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  PRIMARY KEY (`Id`),
  KEY `IX_DiagramEdges_DiagramId` (`DiagramId`),
  CONSTRAINT `FK_DiagramEdges_Diagrams_DiagramId` FOREIGN KEY (`DiagramId`) REFERENCES `Diagrams` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Diagrams` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `IsDefault` tinyint(1) NOT NULL DEFAULT '0',
  `CreatedAt` datetime(6) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `DiagramScopeItems` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `DiagramId` int NOT NULL,
  `ScopeType` varchar(30) NOT NULL,
  `EntityId` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_DiagramScopeItems_DiagramId` (`DiagramId`),
  CONSTRAINT `FK_DiagramScopeItems_Diagrams_DiagramId` FOREIGN KEY (`DiagramId`) REFERENCES `Diagrams` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Environments` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Description` varchar(250) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Groups` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` longtext NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `GroupUser` (
  `GroupsId` int NOT NULL,
  `UsersId` int NOT NULL,
  PRIMARY KEY (`GroupsId`,`UsersId`),
  KEY `IX_GroupUser_UsersId` (`UsersId`),
  CONSTRAINT `FK_GroupUser_Groups_GroupsId` FOREIGN KEY (`GroupsId`) REFERENCES `Groups` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_GroupUser_Users_UsersId` FOREIGN KEY (`UsersId`) REFERENCES `Users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `MenuRole` (
  `MenuId` int NOT NULL,
  `RolesId` int NOT NULL,
  PRIMARY KEY (`MenuId`,`RolesId`),
  KEY `IX_MenuRole_RolesId` (`RolesId`),
  CONSTRAINT `FK_MenuRole_Menus_MenuId` FOREIGN KEY (`MenuId`) REFERENCES `Menus` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_MenuRole_Roles_RolesId` FOREIGN KEY (`RolesId`) REFERENCES `Roles` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Menus` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Path` varchar(200) NOT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  `HideBackButton` tinyint(1) NOT NULL DEFAULT '0',
  `IsVisible` tinyint(1) NOT NULL DEFAULT '1',
  `Order` int DEFAULT NULL,
  `ParentId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Menus_ParentId` (`ParentId`),
  CONSTRAINT `FK_Menus_Menus_ParentId` FOREIGN KEY (`ParentId`) REFERENCES `Menus` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Projects` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ProviderEnvironmentGroupRoles` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProviderEnvironmentId` int NOT NULL,
  `GroupId` int NOT NULL,
  `RoleId` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ProviderEnvironmentGroupRoles_GroupId` (`GroupId`),
  KEY `IX_ProviderEnvironmentGroupRoles_ProviderEnvironmentId` (`ProviderEnvironmentId`),
  KEY `IX_ProviderEnvironmentGroupRoles_RoleId` (`RoleId`),
  CONSTRAINT `FK_ProviderEnvironmentGroupRoles_Groups_GroupId` FOREIGN KEY (`GroupId`) REFERENCES `Groups` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ProviderEnvironmentGroupRoles_ProviderEnvironments_ProviderE~` FOREIGN KEY (`ProviderEnvironmentId`) REFERENCES `ProviderEnvironments` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ProviderEnvironmentGroupRoles_Roles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `Roles` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ProviderEnvironments` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProviderId` int NOT NULL,
  `EnvironmentId` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ProviderEnvironments_EnvironmentId` (`EnvironmentId`),
  KEY `IX_ProviderEnvironments_ProviderId` (`ProviderId`),
  CONSTRAINT `FK_ProviderEnvironments_Environments_EnvironmentId` FOREIGN KEY (`EnvironmentId`) REFERENCES `Environments` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ProviderEnvironments_Providers_ProviderId` FOREIGN KEY (`ProviderId`) REFERENCES `Providers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Providers` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ProxyConnections` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `SourceServerId` int NOT NULL,
  `TargetServerId` int NOT NULL,
  `Direction` varchar(20) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ProxyConnections_SourceServerId` (`SourceServerId`),
  KEY `IX_ProxyConnections_TargetServerId` (`TargetServerId`),
  CONSTRAINT `FK_ProxyConnections_Servers_SourceServerId` FOREIGN KEY (`SourceServerId`) REFERENCES `Servers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_ProxyConnections_Servers_TargetServerId` FOREIGN KEY (`TargetServerId`) REFERENCES `Servers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ProxyRoutes` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProxyConnectionId` int NOT NULL DEFAULT '0',
  `Route` varchar(200) NOT NULL,
  `MappedTo` varchar(50) DEFAULT NULL,
  `TargetProxyConnectionId` int DEFAULT NULL,
  `TargetServerApplicationId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ProxyRoutes_ProxyConnectionId` (`ProxyConnectionId`),
  KEY `IX_ProxyRoutes_TargetProxyConnectionId` (`TargetProxyConnectionId`),
  KEY `IX_ProxyRoutes_TargetServerApplicationId` (`TargetServerApplicationId`),
  CONSTRAINT `FK_ProxyRoutes_ProxyConnections_ProxyConnectionId` FOREIGN KEY (`ProxyConnectionId`) REFERENCES `ProxyConnections` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ProxyRoutes_ProxyConnections_TargetProxyConnectionId` FOREIGN KEY (`TargetProxyConnectionId`) REFERENCES `ProxyConnections` (`Id`),
  CONSTRAINT `FK_ProxyRoutes_ServerApplications_TargetServerApplicationId` FOREIGN KEY (`TargetServerApplicationId`) REFERENCES `ServerApplications` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ReachabilityTests` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ServerId` int DEFAULT NULL,
  `Hostname` varchar(200) NOT NULL,
  `Port` int NOT NULL,
  `Description` varchar(200) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ReachabilityTests_ServerId` (`ServerId`),
  CONSTRAINT `FK_ReachabilityTests_Servers_ServerId` FOREIGN KEY (`ServerId`) REFERENCES `Servers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Roles` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Label` varchar(100) NOT NULL,
  `ScopeEnum` int NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `RoleUser` (
  `RolesId` int NOT NULL,
  `UsersId` int NOT NULL,
  PRIMARY KEY (`RolesId`,`UsersId`),
  KEY `IX_RoleUser_UsersId` (`UsersId`),
  CONSTRAINT `FK_RoleUser_Roles_RolesId` FOREIGN KEY (`RolesId`) REFERENCES `Roles` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_RoleUser_Users_UsersId` FOREIGN KEY (`UsersId`) REFERENCES `Users` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ServerApplications` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ServerId` int NOT NULL,
  `ApplicationVersionId` int NOT NULL,
  `ExposedPort` int NOT NULL,
  `ProxyRouteId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ServerApplications_ApplicationVersionId` (`ApplicationVersionId`),
  KEY `IX_ServerApplications_ProxyRouteId` (`ProxyRouteId`),
  KEY `IX_ServerApplications_ServerId` (`ServerId`),
  CONSTRAINT `FK_ServerApplications_ApplicationVersions_ApplicationVersionId` FOREIGN KEY (`ApplicationVersionId`) REFERENCES `ApplicationVersions` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ServerApplications_ProxyRoutes_ProxyRouteId` FOREIGN KEY (`ProxyRouteId`) REFERENCES `ProxyRoutes` (`Id`),
  CONSTRAINT `FK_ServerApplications_Servers_ServerId` FOREIGN KEY (`ServerId`) REFERENCES `Servers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ServerCredentials` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Username` varchar(200) NOT NULL,
  `AuthType` varchar(20) NOT NULL,
  `EncryptedSecret` longtext NOT NULL,
  `EncryptedPassphrase` longtext,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Servers` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ProviderEnvironmentId` int NOT NULL DEFAULT '0',
  `Name` varchar(200) NOT NULL,
  `IpAddress` varchar(200) NOT NULL,
  `Hostname` varchar(200) NOT NULL,
  `CredentialId` int DEFAULT NULL,
  `HostKeyFingerprint` varchar(100) DEFAULT NULL,
  `SshPort` int NOT NULL DEFAULT '22',
  PRIMARY KEY (`Id`),
  KEY `IX_Servers_ProviderEnvironmentId` (`ProviderEnvironmentId`),
  KEY `IX_Servers_CredentialId` (`CredentialId`),
  CONSTRAINT `FK_Servers_ProviderEnvironments_ProviderEnvironmentId` FOREIGN KEY (`ProviderEnvironmentId`) REFERENCES `ProviderEnvironments` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Servers_ServerCredentials_CredentialId` FOREIGN KEY (`CredentialId`) REFERENCES `ServerCredentials` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Users` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Surname` varchar(100) NOT NULL,
  `Username` varchar(100) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_Users_Username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
