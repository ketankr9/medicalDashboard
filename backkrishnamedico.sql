-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: krishnamedico
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (16,'Ram','9854578965','Bela Garden'),(17,'test','9874578954','address');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deals_in`
--

DROP TABLE IF EXISTS `deals_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deals_in` (
  `sup_id` int(11) NOT NULL,
  `med_code` int(11) NOT NULL,
  PRIMARY KEY (`sup_id`,`med_code`),
  KEY `med_code` (`med_code`),
  CONSTRAINT `deals_in_ibfk_1` FOREIGN KEY (`sup_id`) REFERENCES `stockist` (`sup_id`),
  CONSTRAINT `deals_in_ibfk_2` FOREIGN KEY (`med_code`) REFERENCES `medicines` (`med_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deals_in`
--

LOCK TABLES `deals_in` WRITE;
/*!40000 ALTER TABLE `deals_in` DISABLE KEYS */;
INSERT INTO `deals_in` VALUES (203,408),(203,409);
/*!40000 ALTER TABLE `deals_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice` (
  `txn_id` int(11) NOT NULL,
  `total_amt` decimal(11,2) DEFAULT NULL,
  `amount_paid` decimal(11,2) DEFAULT NULL,
  `pay_mode` char(1) DEFAULT NULL,
  `txn_date` varchar(11) DEFAULT NULL,
  `discount` decimal(11,2) DEFAULT NULL,
  `updated_on` varchar(11) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`txn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (2,32.00,32.00,'c','2017-12-04',0.00,NULL,'ok'),(4,32.00,32.00,'c','2017-12-04',0.00,NULL,'ok');
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger amt_invoice before INSERT ON invoice
FOR EACH ROW
BEGIN
IF NEW.total_amt < 0 OR NEW.amount_paid < 0 OR NEW.discount < 0 THEN
signal sqlstate '45000' set message_text="Amount must be +ve";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `login_tb`
--

DROP TABLE IF EXISTS `login_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_tb` (
  `username` varchar(255) NOT NULL,
  `passwd` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_tb`
--

LOCK TABLES `login_tb` WRITE;
/*!40000 ALTER TABLE `login_tb` DISABLE KEYS */;
INSERT INTO `login_tb` VALUES ('admin','6d15a47c5ebee50a46902fbda167d5b4381a3b484fdc219531a69824fe65c2923fa1591d93fd48aa5bd425af748b92a9d4bd4db67ffd2a77aa0d0bc8d2633d9b'),('rahul','5c85c7f3642fc07988a217d8f1d9e30b469d92b702a5d0189fd0e9fff36a06adcf6ed61dbadd35b32b846763e948ced0e8b9a0f0e8d96cbea5bd27b16d70573a'),('user','2f9816abaa602fdfdfd69297af41ae1e0244d44ebc24e1c7eb847370401a3c197c4506dbae966ec8c1ccbe15c8d3f1d0ad8aa7008e4f7bd5f4ff777ed6d0bc38');
/*!40000 ALTER TABLE `login_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_available`
--

DROP TABLE IF EXISTS `medicine_available`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicine_available` (
  `med_code` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`med_code`),
  CONSTRAINT `medicine_available_ibfk_1` FOREIGN KEY (`med_code`) REFERENCES `medicines` (`med_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine_available`
--

LOCK TABLES `medicine_available` WRITE;
/*!40000 ALTER TABLE `medicine_available` DISABLE KEYS */;
INSERT INTO `medicine_available` VALUES (408,1),(409,0);
/*!40000 ALTER TABLE `medicine_available` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger quantityCheck before INSERT on medicine_available
FOR EACH ROW
BEGIN
IF NEW.quantity < 0 THEN
signal sqlstate '45000' SET message_text="Quantity can't be -ve";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medicines`
--

DROP TABLE IF EXISTS `medicines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicines` (
  `med_code` int(11) NOT NULL AUTO_INCREMENT,
  `med_type` varchar(10) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `mrp` float DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `quantperleaf` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`med_code`)
) ENGINE=InnoDB AUTO_INCREMENT=410 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicines`
--

LOCK TABLES `medicines` WRITE;
/*!40000 ALTER TABLE `medicines` DISABLE KEYS */;
INSERT INTO `medicines` VALUES (405,'capsules','Almox 500',79.87,'Alkem',30,'Antibiotic'),(406,'tablets','Pracetamol 750',28.33,'Sun Pharma',10,'Pyralegisttabletsic'),(407,'bottle','Iridivic',45.89,'Indoco',1,'Eye drop'),(408,'bottle','Moxicip KT',89.15,'Cipla',1,'Eye Drop, Rx required'),(409,'tube','Fast Relief',32,'Dabur',1,'Muscle Pain');
/*!40000 ALTER TABLE `medicines` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger check_medicine before INSERT ON medicines
FOR EACH ROW
BEGIN
IF NEW.mrp < 0 OR NEW.quantperleaf < 0 THEN
signal sqlstate '45000' set message_text="Price or quantity must be +ve";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `new_medicine_request`
--

DROP TABLE IF EXISTS `new_medicine_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_medicine_request` (
  `name` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `med_type` varchar(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `users_name` varchar(255) DEFAULT NULL,
  `submitted_on` date DEFAULT NULL,
  `req_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`req_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_medicine_request`
--

LOCK TABLES `new_medicine_request` WRITE;
/*!40000 ALTER TABLE `new_medicine_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_medicine_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_stockist_form`
--

DROP TABLE IF EXISTS `new_stockist_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_stockist_form` (
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `submitted_on` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_stockist_form`
--

LOCK TABLES `new_stockist_form` WRITE;
/*!40000 ALTER TABLE `new_stockist_form` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_stockist_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_item` (
  `txn_id` int(11) NOT NULL,
  `med_code` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `rate` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`txn_id`,`med_code`),
  CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`txn_id`) REFERENCES `invoice` (`txn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (2,409,1,32.00),(4,409,1,32.00);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger check_ord_item before INSERT on order_item
FOR EACH ROW
BEGIN
IF NEW.quantity < 0 OR NEW.rate < 0 THEN
signal sqlstate '45000' set message_text="Quantity or rate should be +ve";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `purchase`
--

DROP TABLE IF EXISTS `purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchase` (
  `cust_id` int(11) DEFAULT NULL,
  `txn_id` int(11) DEFAULT NULL,
  KEY `cust_id` (`cust_id`),
  KEY `txn_id` (`txn_id`),
  CONSTRAINT `purchase_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `purchase_ibfk_2` FOREIGN KEY (`txn_id`) REFERENCES `invoice` (`txn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase`
--

LOCK TABLES `purchase` WRITE;
/*!40000 ALTER TABLE `purchase` DISABLE KEYS */;
INSERT INTO `purchase` VALUES (16,2),(17,4);
/*!40000 ALTER TABLE `purchase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock`
--

DROP TABLE IF EXISTS `stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stock` (
  `stk_id` int(11) NOT NULL AUTO_INCREMENT,
  `txn_id` int(11) DEFAULT NULL,
  `med_code` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `mfg` date DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `rate` float DEFAULT NULL,
  `mrp` float DEFAULT NULL,
  `gst` decimal(11,2) DEFAULT NULL,
  `disc` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`stk_id`),
  KEY `txn_id` (`txn_id`),
  KEY `med_code` (`med_code`),
  CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`txn_id`) REFERENCES `stock_purchase` (`txn_id`),
  CONSTRAINT `stock_ibfk_2` FOREIGN KEY (`med_code`) REFERENCES `medicines` (`med_code`)
) ENGINE=InnoDB AUTO_INCREMENT=315 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock`
--

LOCK TABLES `stock` WRITE;
/*!40000 ALTER TABLE `stock` DISABLE KEYS */;
INSERT INTO `stock` VALUES (313,264,408,1,NULL,'2017-01-01',89.15,89.15,2.00,2.00),(314,264,409,2,NULL,'2020-01-01',30,32,2.00,2.00);
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger check_stock before INSERT ON stock FOR EACH ROW
BEGIN
IF NEW.quantity < 0 OR NEW.rate < 0 OR NEW.mrp < 0 OR NEW.gst <0 OR NEW.disc < 0 THEN
signal sqlstate '45000' set message_text="Only +ve integer allowed in quantity,rate,mrp,gst,disc";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `stock_purchase`
--

DROP TABLE IF EXISTS `stock_purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stock_purchase` (
  `txn_id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_date` date DEFAULT NULL,
  `sup_id` int(11) DEFAULT NULL,
  `paid` int(11) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`txn_id`),
  KEY `sup_id` (`sup_id`),
  CONSTRAINT `stock_purchase_ibfk_1` FOREIGN KEY (`sup_id`) REFERENCES `stockist` (`sup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_purchase`
--

LOCK TABLES `stock_purchase` WRITE;
/*!40000 ALTER TABLE `stock_purchase` DISABLE KEYS */;
INSERT INTO `stock_purchase` VALUES (264,'2017-12-04',203,149,'ok');
/*!40000 ALTER TABLE `stock_purchase` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger check_stock_pur before INSERT ON stock_purchase FOR EACH ROW
BEGIN
IF  NEW.paid < 0 THEN
signal sqlstate '45000' set message_text="Amount paid should be +ve";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `stockist`
--

DROP TABLE IF EXISTS `stockist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stockist` (
  `sup_id` int(11) NOT NULL AUTO_INCREMENT,
  `store_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`sup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stockist`
--

LOCK TABLES `stockist` WRITE;
/*!40000 ALTER TABLE `stockist` DISABLE KEYS */;
INSERT INTO `stockist` VALUES (203,'ABC Pharma','Bela Garden, DBG','9854578547'),(204,'DEF Pharma','Tower Chowk, DBG','8745895874');
/*!40000 ALTER TABLE `stockist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-04 15:20:45
