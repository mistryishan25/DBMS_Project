-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema DBMS_PROJECT
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema DBMS_PROJECT
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DBMS_PROJECT` DEFAULT CHARACTER SET utf8 ;
USE `DBMS_PROJECT` ;

-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`seller`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`seller` (
  `s_id` VARCHAR(50) NOT NULL,
  `salesman_name` VARCHAR(50) NOT NULL,
  `salesaman_contact` VARCHAR(50) NOT NULL,
  `salesman_email` VARCHAR(50) NULL,
  `transportation_mode` VARCHAR(50) NULL,
  `gst_number` BIGINT NULL,
  PRIMARY KEY (`s_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`grocery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`grocery` (
  `g_id` VARCHAR(50) NOT NULL,
  `item_name` VARCHAR(50) NULL,
  `item_category` VARCHAR(50) NULL,
  `item_quantity` INT NULL,
  `item_wcost` FLOAT NULL,
  `item_restock_date` DATE NOT NULL,
  `next_restock_date` DATE NULL,
  `s_id` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`g_id`),
  INDEX `s_id_idx` (`s_id` ASC) VISIBLE,
  CONSTRAINT `s_id`
    FOREIGN KEY (`s_id`)
    REFERENCES `DBMS_PROJECT`.`seller` (`s_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`medicines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`medicines` (
  `m_id` VARCHAR(50) NOT NULL,
  `item_name` VARCHAR(50) NULL,
  `item_category` VARCHAR(50) NULL,
  `item_quantity` INT NULL,
  `item_wcost` FLOAT NULL,
  `item_restock_date` DATE NOT NULL,
  `next_restock_date` DATE NULL,
  `s_id` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`m_id`),
  INDEX `s_id_idx` (`s_id` ASC) VISIBLE,
  CONSTRAINT `s_id`
    FOREIGN KEY (`s_id`)
    REFERENCES `DBMS_PROJECT`.`seller` (`s_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`sensors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`sensors` (
  `sensor_id` VARCHAR(50) NOT NULL,
  `location_spot` VARCHAR(50) NULL,
  `sensor_status` INT NULL,
  PRIMARY KEY (`sensor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`front`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`front` (
  `location_spot` VARCHAR(50) NOT NULL,
  `sensor_id` VARCHAR(50) NOT NULL,
  `tag_id` VARCHAR(50) NULL,
  `item_id` VARCHAR(50) NULL,
  PRIMARY KEY (`location_spot`),
  INDEX `sensor_id _idx` (`sensor_id` ASC) VISIBLE,
  CONSTRAINT `sensor_id `
    FOREIGN KEY (`sensor_id`)sensors
    REFERENCES `DBMS_PROJECT`.`sensors` (`sensor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`readers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`readers` (
  `reader_id` VARCHAR(50) NOT NULL,
  `visible_quantity` INT NULL,
  `item_category` VARCHAR(50) NULL,
  `location_spot` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`reader_id`),
  INDEX `location_spot_idx` (`location_spot` ASC) VISIBLE,
  CONSTRAINT `location_spot`
    FOREIGN KEY (`location_spot`)
    REFERENCES `DBMS_PROJECT`.`front` (`location_spot`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`customer_information`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`customer_information` (
  `customer_id` INT NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `bhim_id` BIGINT NOT NULL,
  `address` VARCHAR(50) NOT NULL,
  `email_id` VARCHAR(50) NULL,
  `contact_number` BIGINT NOT NULL,
  `age` INT NOT NULL,
  `date_of_shopping` DATE NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`rfid_raw_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`rfid_raw_data` (
  `tag_id` VARCHAR(50) NOT NULL,
  `location_spot` VARCHAR(50) NOT NULL,
  `item_id` VARCHAR(50) NOT NULL,
  `city` VARCHAR(50) NULL,
  `date_of_shopping` DATE NULL,
  `rfid_time` TIME NOT NULL,
  PRIMARY KEY (`tag_id`, `item_id`),
  INDEX `location_spot_idx` (`location_spot` ASC) VISIBLE,
  CONSTRAINT `location_spot`
    FOREIGN KEY (`location_spot`)
    REFERENCES `DBMS_PROJECT`.`front` (`location_spot`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`band_tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`band_tag` (
  `tag_id` VARCHAR(50) NOT NULL,
  `customer_id` INT NOT NULL,
  `item_id` VARCHAR(50) NULL,
  `vessel_tag_id` VARCHAR(50) NULL,
  `vessel_weight` FLOAT NULL,
  `in_time` TIME NOT NULL,
  `location_seq` VARCHAR(100) NOT NULL,
  `out_time` TIME NULL,
  PRIMARY KEY (`tag_id`, `in_time`),
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `DBMS_PROJECT`.`customer_information` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `tag_id`
    FOREIGN KEY (`tag_id`)
    REFERENCES `DBMS_PROJECT`.`rfid_raw_data` (`tag_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`payment_information`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`payment_information` (
  `account_number` BIGINT NOT NULL,
  `customer_id` INT NOT NULL,
  `bhim_id` BIGINT NOT NULL,
  `card_number` BIGINT NOT NULL,
  `mode_of_payment` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`account_number`),
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `DBMS_PROJECT`.`customer_information` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`list` (
  `list_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `date_of_making_list` DATE NOT NULL,
  PRIMARY KEY (`list_id`),
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `DBMS_PROJECT`.`customer_information` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`shopping_lists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`shopping_lists` (
  `item_id` VARCHAR(50) NOT NULL,
  `item_category` VARCHAR(50) NOT NULL,
  `item_weight_in_kg` FLOAT NOT NULL,
  `quantity` INT NOT NULL,
  `item_cost_in_rupees` FLOAT NOT NULL,
  `list_id` INT NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `list_id_idx` (`list_id` ASC) VISIBLE,
  CONSTRAINT `list_id`
    FOREIGN KEY (`list_id`)
    REFERENCES `DBMS_PROJECT`.`list` (`list_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`medical_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`medical_info` (
  `patient_id` INT NOT NULL,
  `mediclaim_number` BIGINT NOT NULL,
  `doctor_id` INT NOT NULL,
  `doctor_name` VARCHAR(50) NOT NULL,
  `doze_prescribed` VARCHAR(50) NOT NULL,
  `m_id` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`patient_id`),
  INDEX `m_id_idx` (`m_id` ASC) VISIBLE,
  CONSTRAINT `m_id`
    FOREIGN KEY (`m_id`)
    REFERENCES `DBMS_PROJECT`.`medicines` (`m_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`medical_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`medical_log` (
  `customer_id` INT NOT NULL,
  `time` TIME NOT NULL,
  `date_of_shopping` DATE NOT NULL,
  `patient_id` INT NOT NULL,
  PRIMARY KEY (`customer_id`, `time`, `date_of_shopping`),
  INDEX `patient_id_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `DBMS_PROJECT`.`customer_information` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `patient_id`
    FOREIGN KEY (`patient_id`)
    REFERENCES `DBMS_PROJECT`.`medical_info` (`patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`analysis_sdata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`analysis_sdata` (
  `item_id` VARCHAR(50) NOT NULL,
  `sensor_id` VARCHAR(50) NOT NULL,
  `false_positives` INT NULL,
  `false_negatives` INT NULL,
  `true_positives` INT NULL,
  `true_negatives` INT NULL,
  `sensor_status` INT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `sensor_id_idx` (`sensor_id` ASC) VISIBLE,
  CONSTRAINT `item_id`
    FOREIGN KEY (`item_id`)
    REFERENCES `DBMS_PROJECT`.`shopping_lists` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sensor_id`
    FOREIGN KEY (`sensor_id`)
    REFERENCES `DBMS_PROJECT`.`sensors` (`sensor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`analysis_gdata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`analysis_gdata` (
  `g_id` VARCHAR(50) NOT NULL,
  `sensor_id` VARCHAR(50) NOT NULL,
  `false_positives` INT NULL,
  `false_negatives` INT NULL,
  `true_positives` INT NULL,
  `true_negatives` INT NULL,
  `sensor_status` INT NULL,
  PRIMARY KEY (`g_id`, `sensor_id`),
  INDEX `sensor_id_idx` (`sensor_id` ASC) VISIBLE,
  CONSTRAINT `g_id`
    FOREIGN KEY (`g_id`)
    REFERENCES `DBMS_PROJECT`.`grocery` (`g_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sensor_id`
    FOREIGN KEY (`sensor_id`)
    REFERENCES `DBMS_PROJECT`.`sensors` (`sensor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBMS_PROJECT`.`analysis_mdata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBMS_PROJECT`.`analysis_mdata` (
  `sensor_id` VARCHAR(50) NOT NULL,
  `m_id` VARCHAR(50) NOT NULL,
  `false_positives` INT NULL,
  `false_negatives` INT NULL,
  `true_positives` INT NULL,
  `true_negatives` INT NULL,
  `sensor_status` INT NULL,
  PRIMARY KEY (`sensor_id`, `m_id`),
  INDEX `m_id_idx` (`m_id` ASC) VISIBLE,
  CONSTRAINT `m_id`
    FOREIGN KEY (`m_id`)
    REFERENCES `DBMS_PROJECT`.`medicines` (`m_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sensor_id `
    FOREIGN KEY (`sensor_id`)
    REFERENCES `DBMS_PROJECT`.`sensors` (`sensor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
