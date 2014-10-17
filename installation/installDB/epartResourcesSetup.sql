--
-- Tables with information about resources, e.g., health care facilities
-- health care workers, supplies, etc.
--


USE `epart_demo`;

-- Drop triggers, functions, and procedures referring to tables defined
-- in this file.

-- Drop tables that define enumerated values used by Resource-related tables.

DROP TABLE IF EXISTS FacilityTypes;
DROP TABLE IF EXISTS FacilityStatus;
DROP TABLE IF EXISTS HCWorkerRoles;

-- Drop Resource-related tables.

DROP TABLE IF EXISTS HealthCareAssignments;
DROP TABLE IF EXISTS HealthCareFacilities;
DROP TABLE IF EXISTS HealthCareWorkers;

-- Create tables that define enumerated values used by Resource-related tables.

CREATE Table FacilityTypes (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    facilityType VARCHAR ( 20 ) NOT NULL
    , updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO FacilityTypes (facilityType) VALUES
('Office')
, ('Outpatient Clinic')
, ('Hospital')
, ('Mobile Facility')
;

CREATE Table FacilityStatus (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    facilityStatus VARCHAR ( 20 ) NOT NULL
    , updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO FacilityStatus (facilityStatus) VALUES
('Open')
, ('Closed')
, ('Opening Soon')
;

CREATE Table HCWorkerRoles (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    role VARCHAR ( 30 ) NOT NULL
    , updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO HCWorkerRoles (role) VALUES
('Ambulance')
, ('Doctor')
, ('Nurse')
, ('Social Worker')
, ('Health Facility Admin')
, ('Health Facility Employee')
, ('Traditional Healer')
, ('Community Leader')
, ('Volunteer')
, ('Grave Digger')
, ('Other')
;

CREATE TABLE HealthCareFacilities (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    facility_name VARCHAR ( 40 ) NOT NULL,
    facilityType VARCHAR ( 20 ) NOT NULL,
    addressLocality INT NOT NULL,
    numberStreet VARCHAR ( 30 ) DEFAULT NULL,
    facilityStatus VARCHAR ( 20 ) NOT NULL,
    totalBeds INT,
    availableBeds INT,
    primaryContactPerson VARCHAR ( 50 ),
    primaryContactNumber VARCHAR (20),
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (addressLocality) REFERENCES Village (village_id)
);

CREATE TABLE HealthCareWorkers (
    personID INT NOT NULL PRIMARY KEY ,
    role VARCHAR ( 30 ) NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (personID) REFERENCES Person (personID),
    UNIQUE (personID)
);

CREATE TABLE HealthCareAssignments (
    pk_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    personID INT NOT NULL,
    facility_id INT NOT NULL,
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (personID, facility_id),
    FOREIGN KEY (personID) REFERENCES Person (personID),
    FOREIGN KEY (facility_id) REFERENCES HealthCareFacilities (pk_id),
    Index (personID),
    Index (facility_id)
);

-- Define Triggers, Functions, and Procedures that deal with tables
-- defined in this file.



-- Populate tables.

LOCK TABLES `HealthCareFacilities` WRITE;
INSERT INTO `HealthCareFacilities`
(pk_id, facility_name, facilityType, addressLocality, facilityStatus,
	totalBeds, availableBeds, primaryContactPerson) VALUES
(1,  'Bronson Hospital', 'Hospital', 2, 'Open', 900, 100, 'Lucy van Pelt')
;
UNLOCK TABLES;

LOCK TABLES `HealthCareWorkers` WRITE;
INSERT INTO `HealthCareWorkers`
(personID, role) VALUES
(5,  'Doctor')
;
UNLOCK TABLES;

LOCK TABLES `HealthCareAssignments` WRITE;
INSERT INTO `HealthCareAssignments`
(personID, facility_id) VALUES
(5,  1)
;
UNLOCK TABLES;

