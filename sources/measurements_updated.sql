-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 03, 2014 at 05:36 PM
-- Server version: 5.5.27
-- PHP Version: 5.4.24

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `measurements`
--

-- --------------------------------------------------------

--
-- Table structure for table `ENUM_ExperimentSuiteConfigurationKey`
--

CREATE TABLE IF NOT EXISTS `ENUM_ExperimentSuiteConfigurationKey` (
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ENUM_ExperimentSuiteConfigurationKey`
--

INSERT INTO `ENUM_ExperimentSuiteConfigurationKey` (`value`) VALUES
('NumberOfActiveRPis'),
('NumberOfPoweredRPis');

-- --------------------------------------------------------

--
-- Table structure for table `ENUM_GranularityLevel`
--

CREATE TABLE IF NOT EXISTS `ENUM_GranularityLevel` (
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ENUM_GranularityLevel`
--

INSERT INTO `ENUM_GranularityLevel` (`value`) VALUES
('Cluster blackbox'),
('Cluster whitebox'),
('RPi components');

-- --------------------------------------------------------

--
-- Table structure for table `ENUM_LoadGeneratorConfigurationKey`
--

CREATE TABLE IF NOT EXISTS `ENUM_LoadGeneratorConfigurationKey` (
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ENUM_LoadGeneratorType`
--

CREATE TABLE IF NOT EXISTS `ENUM_LoadGeneratorType` (
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ENUM_LoadGeneratorType`
--

INSERT INTO `ENUM_LoadGeneratorType` (`value`) VALUES
('Application'),
('Benchmark');

-- --------------------------------------------------------

--
-- Table structure for table `ExperimentSuite`
--

CREATE TABLE IF NOT EXISTS `ExperimentSuite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `granularityLevel` varchar(255) NOT NULL,
  `objective` varchar(255) NOT NULL,
  `executionStartedAt` int(11),  
--  `executionEndedAt` date,
  PRIMARY KEY (`id`),
  KEY `granularityLevel` (`granularityLevel`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `ExperimentSuiteConfiguration`
--

CREATE TABLE IF NOT EXISTS `ExperimentSuiteConfiguration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `experimentSuiteId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `key` (`key`),
  KEY `experimentSuiteId` (`experimentSuiteId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `LoadGenerator`
--

CREATE TABLE IF NOT EXISTS `LoadGenerator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `loadGeneratorType` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `loadGeneratorType` (`loadGeneratorType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `LoadGeneratorConfiguration`
--

CREATE TABLE IF NOT EXISTS `LoadGeneratorConfiguration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `MeasurementTool`
--

CREATE TABLE IF NOT EXISTS `MeasurementTool` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `accuracyError` decimal(5,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `MeasurementTool`
--

INSERT INTO `MeasurementTool` (`id`, `label`, `description`, `accuracyError`) VALUES
(1, 'Voltcraft Energy Monitor 3000', 'What does the tool', '0.000'),
(2, 'Voltcraft Multimeter MT-51', 'What does the tool', '0.000'),
(7, 'Energenie EGM-PWM-LAN ', 'http://www.elv.de/energenie-egm-pwm-lan-energiekosten-messgeraet-mit-lan-schnittstelle.html', '0.000');

-- --------------------------------------------------------

--
-- Table structure for table `MeasurementValue`
--

CREATE TABLE IF NOT EXISTS `MeasurementValue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(255),
  `value` double NOT NULL,
  `measuredAt` int(11) NOT NULL,
  `measuredBy` int(11) DEFAULT NULL,
  `measuredFor` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `measuredBy` (`measuredBy`),
  KEY `measuredFor` (`measuredFor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `N2M_loadGConf2expSuite`
--

CREATE TABLE IF NOT EXISTS `N2M_loadGConf2expSuite` (
  `loadGeneratorConfigurationId` int(11) NOT NULL,
  `experimentSuiteId` int(11) NOT NULL,
  UNIQUE KEY `loadGeneratorConfiguration_2` (`loadGeneratorConfigurationId`,`experimentSuiteId`),
  KEY `loadGeneratorConfiguration` (`loadGeneratorConfigurationId`),
  KEY `experimentSuite` (`experimentSuiteId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ExperimentSuite`
--
ALTER TABLE `ExperimentSuite`
  ADD CONSTRAINT `experimentsuite_ibfk_1` FOREIGN KEY (`granularityLevel`) REFERENCES `ENUM_GranularityLevel` (`value`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `ExperimentSuiteConfiguration`
--
ALTER TABLE `ExperimentSuiteConfiguration`
  ADD CONSTRAINT `experimentsuiteconfiguration_ibfk_2` FOREIGN KEY (`experimentSuiteId`) REFERENCES `ExperimentSuite` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `experimentsuiteconfiguration_ibfk_1` FOREIGN KEY (`key`) REFERENCES `enum_experimentsuiteconfigurationkey` (`value`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `LoadGenerator`
--
ALTER TABLE `LoadGenerator`
  ADD CONSTRAINT `loadgenerator_ibfk_1` FOREIGN KEY (`loadGeneratorType`) REFERENCES `ENUM_LoadGeneratorType` (`value`) ON DELETE SET NULL ON UPDATE NO ACTION;

--
-- Constraints for table `LoadGeneratorConfiguration`
--
ALTER TABLE `LoadGeneratorConfiguration`
  ADD CONSTRAINT `loadgeneratorconfiguration_ibfk_1` FOREIGN KEY (`key`) REFERENCES `ENUM_LoadGeneratorConfigurationKey` (`value`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `MeasurementValue`
--
ALTER TABLE `MeasurementValue`
  ADD CONSTRAINT `measurementvalue_ibfk_2` FOREIGN KEY (`measuredBy`) REFERENCES `MeasurementTool` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  ADD CONSTRAINT `measurementvalue_ibfk_3` FOREIGN KEY (`measuredFor`) REFERENCES `ExperimentSuite` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION;

--
-- Constraints for table `N2M_loadGConf2expSuite`
--
ALTER TABLE `N2M_loadGConf2expSuite`
  ADD CONSTRAINT `n2m_loadgconf2expsuite_ibfk_2` FOREIGN KEY (`experimentSuiteId`) REFERENCES `ExperimentSuite` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `n2m_loadgconf2expsuite_ibfk_1` FOREIGN KEY (`loadGeneratorConfigurationId`) REFERENCES `LoadGeneratorConfiguration` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
