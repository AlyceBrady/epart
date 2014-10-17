--
-- Tables for information about patients
--


USE `epart_demo`;

-- Drop triggers, functions, and procedures referring to tables defined
-- in this file.

-- DROP FUNCTION IF EXISTS NumChildren;

-- Drop tables that define enumerated values used by Patient-related tables.

DROP TABLE IF EXISTS HealthStatusValues;
DROP TABLE IF EXISTS DiagnosisStatusValues;
DROP TABLE IF EXISTS AnnotationTypes;
DROP TABLE IF EXISTS AuthorizationTypes;

-- Drop Patient-related tables.

DROP TABLE IF EXISTS HealthHistory;
DROP TABLE IF EXISTS PatientAnnotations;

-- Create tables that define enumerated values used by Patient-related tables.

CREATE Table HealthStatusValues (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    status VARCHAR ( 20 ) NOT NULL
    , updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO HealthStatusValues (status) VALUES
('No Symptoms')
, ('Sick')
, ('Recovered')
, ('Deceased')
;

CREATE Table DiagnosisStatusValues (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    diagnosisStatus VARCHAR ( 20 ) NOT NULL
    , updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO DiagnosisStatusValues (diagnosisStatus) VALUES
('None')
, ('Suspected')
, ('Tested Positive')
, ('Tested Negative')
;

CREATE TABLE AnnotationTypes (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    , annotationCode VARCHAR ( 20 ) NOT NULL
    , updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO AnnotationTypes (annotationCode) VALUES
('type1')
, ('type2')
;

CREATE TABLE AuthorizationTypes (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    authCode VARCHAR ( 40 ) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO AuthorizationTypes (authCode) VALUES
('Example: Medical Doctor')
, ('Example: Health Facility Admin')
, ('Example: Other Health Care Worker')
, ('Example: Government Official')
, ('Example: Other')
;


CREATE TABLE HealthHistory (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    personID INT NOT NULL,
    healthStatus VARCHAR ( 20 ) NOT NULL,
    diagnosisStatus VARCHAR ( 20 ) NOT NULL,
    date DATE NOT NULL,
    enteredBy VARCHAR ( 40 ) NOT NULL,
    authorizationType VARCHAR ( 40 ) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (personID) REFERENCES Person (personID)
);

CREATE TABLE PatientAnnotations (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    personID INT NOT NULL,
    annotationType VARCHAR ( 20 ) NOT NULL,
    annotation VARCHAR ( 150 ) NOT NULL,
    date DATE NOT NULL,
    enteredBy VARCHAR ( 40 ) NOT NULL,
    authorizationType VARCHAR ( 40 ) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (personID) REFERENCES Person (personID)
);

/*
-- Spouse, children, parents, siblings?
-- For example,
CREATE TABLE Children (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    parentID INT NOT NULL,
    personID INT,
    name VARCHAR ( 50 ),
    gender ENUM('Unknown', 'M', 'F') NOT NULL DEFAULT 'Unknown',
    birthDate DATE DEFAULT NULL,
    deceasedDate DATE DEFAULT NULL,
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parentID) REFERENCES Staff (personID)
);


-- Contacts while infected?


DELIMITER //
CREATE FUNCTION NumChildren(id INT)
RETURNS INT DETERMINISTIC
COMMENT "Computes the number of children for the given person ID"
BEGIN
    SELECT COUNT(name) INTO @childrenCount FROM Children
            WHERE `parentID` = id;
    RETURN @childrenCount;
END; //
DELIMITER ;

*/

