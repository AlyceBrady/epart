--
-- Tables with generic information about local geographic locations
-- (towns or villages) and about people (name, age, sex, etc).
--


USE `epart_demo`;

-- Drop triggers, functions, and procedures referring to tables defined
-- in this file.

DROP TRIGGER IF EXISTS BirthDate_insert;
DROP TRIGGER IF EXISTS BirthDate_update;
DROP TRIGGER IF EXISTS DeceasedDate_Insert;
DROP TRIGGER IF EXISTS DeceasedDate_Update;

DROP FUNCTION IF EXISTS RampConcat;
DROP FUNCTION IF EXISTS FullName;
DROP FUNCTION IF EXISTS FullNameWTitle;
DROP FUNCTION IF EXISTS FullLastNameFirst;
DROP FUNCTION IF EXISTS FullLNFWTitle;
DROP FUNCTION IF EXISTS FullName;
DROP FUNCTION IF EXISTS AddrOnOneLine;
DROP FUNCTION IF EXISTS ShortAddr;
DROP FUNCTION IF EXISTS PhNumList;
DROP FUNCTION IF EXISTS NumChildren;

-- Before dropping Person and Village tables, need to drop other table(s)
-- that depend on them.
SOURCE dropEPARTPersonVillageDependencies.sql

DROP TABLE IF EXISTS PhoneNumber;

-- Drop tables defined in this file.

DROP TABLE IF EXISTS Person;

DROP TABLE IF EXISTS Village;

CREATE TABLE Village (
    village_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    villageNeighborhood VARCHAR ( 40 ),
    cityTown VARCHAR ( 40 ),
    countyDistrict VARCHAR ( 20 ),
    stateProvince VARCHAR ( 20 ),
    country VARCHAR ( 20 ),
    postalCode VARCHAR ( 10 ),
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Person (
    personID INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    title VARCHAR ( 5 ),
    firstname VARCHAR ( 30 ) NOT NULL,
    middlename VARCHAR ( 30 ),
    lastname VARCHAR ( 40 ) NOT NULL,
    suffix VARCHAR ( 10 ),
    sex ENUM('Unknown', 'M', 'F') NOT NULL DEFAULT 'Unknown',
    birthDate DATE DEFAULT NULL,
    birthPlace VARCHAR ( 50 ),
    age INT,
    deceasedDate DATE DEFAULT NULL,
    addressLocality INT DEFAULT NULL,
    numberStreet VARCHAR ( 30 ),
    citizenship VARCHAR ( 30 ),
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (addressLocality) REFERENCES Village (village_id)
);

CREATE TABLE PhoneNumber (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    personID INT NOT NULL,
    phoneNumber VARCHAR (20) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (personID) REFERENCES Person (personID),
    UNIQUE (personID, phoneNumber)
);


-- Define Triggers, Functions, and Procedures that deal with tables
-- defined in this file.


/*
DELIMITER //
CREATE TRIGGER BirthDate_Insert BEFORE INSERT ON Person
  FOR EACH ROW BEGIN
    SET NEW.age = IF ( NOT NEW.birthDate IS NULL
			AND NOT NEW.deceasedDate IS NULL,
			deceasedDate - birthDate,
			IF ( NOT NEW birthDate IS NULL,
			     CURDATE() - birthDate, NEW.age) );
  END; //
CREATE TRIGGER BirthDate_Update BEFORE UPDATE ON Person
  FOR EACH ROW BEGIN
    SET NEW.age = IF ( NOT NEW.birthDate IS NULL
			AND NOT NEW.deceasedDate IS NULL,
			deceasedDate - birthDate,
			IF ( NOT NEW birthDate IS NULL,
			     CURDATE() - birthDate, NEW.age) );
  END; //
CREATE TRIGGER DeceasedDate_Insert BEFORE INSERT ON Person
  FOR EACH ROW BEGIN
    SET NEW.age = IF ( NOT NEW.birthDate IS NULL
			AND NOT NEW.deceasedDate IS NULL,
			deceasedDate - birthDate,
			IF ( NOT NEW birthDate IS NULL,
			     CURDATE() - birthDate, NEW.age) );
  END; //
CREATE TRIGGER DeceasedDate_Update BEFORE UPDATE ON Person
  FOR EACH ROW BEGIN
    SET NEW.age = IF ( NOT NEW.birthDate IS NULL
			AND NOT NEW.deceasedDate IS NULL,
			deceasedDate - birthDate,
			IF ( NOT NEW birthDate IS NULL,
			     CURDATE() - birthDate, NEW.age) );
  END; //
DELIMITER ;
*/

DELIMITER //
CREATE FUNCTION RampConcat(p1 VARCHAR(50), p2 VARCHAR(50), delim VARCHAR(5))
RETURNS VARCHAR(110) DETERMINISTIC
COMMENT "Concatenates p1 and p2, separated by delim unless p1 or p2 is empty"
BEGIN
    SET p1 = IF ( NOT isNULL(p1), p1, '');
    SET p2 = IF ( NOT isNULL(p2), p2, '');
    RETURN IF ( p1='' OR p2='' , CONCAT(p1, p2), CONCAT(p1, delim, p2));
END; //
DELIMITER ;


CREATE FUNCTION FullName(f VARCHAR(30), m VARCHAR(30),
                         l VARCHAR(40), s VARCHAR(10))
RETURNS VARCHAR(115) DETERMINISTIC
COMMENT "Returns the person's full name"
    RETURN RampConcat(RampConcat(RampConcat(f, m, " "),
                l, " "), s, ", ");

CREATE FUNCTION FullNameWTitle(t VARCHAR ( 5 ), f VARCHAR(30), m VARCHAR(30),
                         l VARCHAR(40), s VARCHAR(10))
RETURNS VARCHAR(115) DETERMINISTIC
COMMENT "Returns the person's full name with title"
    RETURN RampConcat(RampConcat(RampConcat(RampConcat(t, f, " "), m, " "),
                l, " "), s, ", ");

CREATE FUNCTION FullLastNameFirst(f VARCHAR(30), m VARCHAR(30), l VARCHAR(40),
                                  s VARCHAR(10))

RETURNS VARCHAR(115) DETERMINISTIC
COMMENT "Returns the person's full name, last name first"
    RETURN RampConcat(RampConcat(RampConcat(l, f, ", "), m, " "), s, ", ");

CREATE FUNCTION FullLNFWTitle(t VARCHAR ( 5 ), f VARCHAR(30), m VARCHAR(30),
                              l VARCHAR(40), s VARCHAR(10))
RETURNS VARCHAR(115) DETERMINISTIC
COMMENT "Returns the person's full name (last name first) with title"
    RETURN RampConcat(RampConcat(RampConcat(RampConcat(l, t, ", "), f, " "),
                        m, " "), s, ", ");



CREATE FUNCTION AddrOnOneLine(num VARCHAR(40), vill VARCHAR(40),
                              city VARCHAR(40), dist VARCHAR(40),
                              prov VARCHAR(20), nat VARCHAR(10), pc VARCHAR(20))
RETURNS VARCHAR(270) DETERMINISTIC
COMMENT "Returns the address in a single string"
    RETURN RampConcat(RampConcat(RampConcat(RampConcat(
        RampConcat(RampConcat(num, vill, ", "), city, ", "), dist, ", "),
            prov, ", "), nat, ", "), pc, ", ");

CREATE FUNCTION ShortAddr(num VARCHAR(40), vill VARCHAR(40),
                              city VARCHAR(40), dist VARCHAR(40),
                              prov VARCHAR(20), nat VARCHAR(10), pc VARCHAR(20))
RETURNS VARCHAR(270) DETERMINISTIC
COMMENT "Returns an abbreviated address"
    RETURN RampConcat(RampConcat(RampConcat(RampConcat(vill, city, ", "),
            dist, ", "), prov, ", "), nat, ", ");



DELIMITER //
CREATE FUNCTION PhNumList(id INT)
RETURNS VARCHAR(100) DETERMINISTIC
COMMENT "Returns a list of the person's phone numbers as a string"
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE phNum VARCHAR(20);
    DECLARE phNumList VARCHAR(100);
    DECLARE cur CURSOR FOR SELECT phoneNumber FROM PhoneNumber
        where `personID`=id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
        SET phNumList = '';
        read_loop: LOOP
            FETCH cur INTO phNum;
            IF done THEN
              LEAVE read_loop;
            END IF;
            SET phNumList = RampConcat(phNumList, phNum, ', ');
        END LOOP;
    CLOSE cur;
    RETURN phNumList;
END; //
DELIMITER ;


/*
DELIMITER //
CREATE FUNCTION MakeList(tableName VARCHAR(20), fieldName VARCHAR(20), keyFieldName VARCHAR(20), key INT)
RETURNS VARCHAR(100) DETERMINISTIC
COMMENT "Returns a list of multiple instances of a field as a string"
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE fieldVal VARCHAR(20);
    DECLARE listString VARCHAR(100);
    DECLARE cur CURSOR FOR SELECT fieldName FROM tableName
        where keyFieldName=key;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
        SET listString = '';
        read_loop: LOOP
            FETCH cur INTO fieldVal;
            IF done THEN
              LEAVE read_loop;
            END IF;
            SET listString = RampConcat(listString, fieldVal, ', ');
        END LOOP;
    CLOSE cur;
    RETURN listString;
END; //
DELIMITER ;
CREATE FUNCTION PhNumList(id INT)
RETURNS VARCHAR(100) DETERMINISTIC
COMMENT "Returns a list of the person's phone numbers as a string"
    RETURN MakeList(id, 'PhoneNumber', 'phoneNumber', 'personID');
*/

-- Populate tables.

LOCK TABLES `Village` WRITE;
INSERT INTO `Village`
(village_id, cityTown, countyDistrict, stateProvince, country,
    postalCode) VALUES
(1,  'Mattawan', 'Van Buren', 'Michigan', 'US', '49071')
, (2,  'Kalamazoo', 'Kalamazoo', 'Michigan', 'US', '49006')
;
UNLOCK TABLES;

LOCK TABLES `Person` WRITE;
INSERT INTO `Person`
(personID, title, firstname, lastname, sex,
    birthDate, addressLocality, numberStreet, citizenship) VALUES
(1,  'Dr.', 'Alyce', 'Brady', 'F', '1961-06-12', 1, '23233 64th Ave', 'US')
, (2, '', 'Charlie', 'Brown', 'M', '2004-03-01', 1, '23233 64th Ave', 'US')
, (3, '', 'Sally', 'Brown', 'F', '2009-09-01', 1, '23233 64th Ave', 'US')
, (4, '', 'Linus', 'van Pelt', 'M', '2006-07-10', 1, '23233 64th Ave', 'US')
, (5, 'Dr.', 'Lucy', 'van Pelt', 'F', '2004-01-03', 1, '23233 64th Ave', 'US')
;
UNLOCK TABLES;

