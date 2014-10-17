--
-- RAMP: Record and Activity Management Program
-- EPART: Epidemic Patient and Resource Tracking
--
-- Create Users and Authorizations tables for an initial RAMP/EPART
-- database.  Define a single user, a database administrator, who can
-- create other users and define what they are authorized to do.
-- To make setting up new development environments easier, define
-- additional generic users with different access permissions as well.

-- Prerequisite: The database name (epart_demo) and the database
-- administrator role (epart_dba) must be defined in the 
-- application/configs/application.ini file.

-- You must run MySQL as root (or some other user that has permission
-- to create databases) to execute the commands found in this file.

-- Create Users Table (ramp_auth_users):
--
-- For most databases, there should be only one initial user record
-- for a database administrator who would then be responsible for both
-- (a) adding other users (including other database administrators)
-- with their roles, and (b) filling in the authorizations table.
--
-- This file, however, provides SQL code to create several generic
-- test users for development test purposes straight "out of the box",
-- without requiring the initial database administrator to create
-- additional users.  (Real usernames for an actual EPART system should
-- identify individuals, not be shared among offices or roles.)
--
-- This developer database uses internal authentication, so the
-- 'password' field is set to be NOT NULL.  The default password should
-- also be specified in application.ini as ramp.defaultPassword.  The
-- default password will cause EPART to redirect users to the
-- Change Password screen when they first log in, allowing the
-- password to be entered and encrypted correctly.  This should be done
-- for the dba user account immediately after Ramp/EPART is set up.
--
-- The identification and contact information for the Ramp/EPART users
-- is defined in the Person table, since all of the Ramp/EPART users should
-- be represented in the database.
--
-- The creation of these developer "users" assumes that the
-- 'epart_dba', 'patientUpdates', 'resourceUpdates', and
-- 'authOfficial' roles have been defined in application.ini.


USE `epart_demo`;

DROP TABLE IF EXISTS `ramp_auth_users`;
CREATE TABLE `ramp_auth_users` (
  `username` varchar(100) NOT NULL,
  `password` varchar(150) NOT NULL DEFAULT 'no_pw',
  `active` enum('FALSE', 'TRUE') NOT NULL DEFAULT 'FALSE',
  `role` varchar(100) NOT NULL DEFAULT 'guest' ,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `domainID` int(11) NOT NULL,
  PRIMARY KEY (`username`)
);


-- Create Initial Users:
--   (In a production EPART database, users should represent individuals, not
--   offices or roles.)

LOCK TABLES `ramp_auth_users` WRITE;
INSERT INTO `ramp_auth_users` (username, active, role, domainID)
VALUES
('patient_admin', 'TRUE', 'patientUpdates', 1)
, ('resource_admin', 'TRUE', 'resourceUpdates', 2)
, ('super_admin', 'TRUE', 'authOfficial', 3)
, ('dba', 'TRUE', 'epart_dba', 4)
;
UNLOCK TABLES;

--
-- Create Resources and Authorizations Table (ramp_auth_auths):
--
-- Usually most resources and authorizations would be defined using
-- EPART itself, but for this pre-defined demo environment,
-- they are defined here.
--
-- "Guests" (anyone who is not logged in) may see the activities listed
-- in activity files in the docs/rampDocs directory and other
-- directories containing public EPART information, such as lists of
-- terms, academic programs, modules, and module offerings.  Database
-- administrators, HR staff, and Registrar staff may see the same data
-- (inherited from the "guest" role), and may each see other things as
-- well.  The generic "hr" user may access activities and tables
-- related to institutional staff records, while the generic "reg" user
-- may access activities and tables related to student records.  The
-- database administrator may view the contents of the Users table
-- (ramp_auth_users) and Person table and view, add, modify, and delete
-- resources and access rules from the Authorizations table (ramp_auth_auths).
-- The "developer" user is provided as a convenience for developers, and has
-- access to everything that the "hr", "reg" and "dba" users do.
--
-- The creation of these developer "users" assumes that the
-- 'smart_dba', 'hr_staff', 'reg_staff', and 'developer' roles have
-- been defined in application.ini.

DROP TABLE IF EXISTS `ramp_auth_auths`;
CREATE TABLE `ramp_auth_auths` (
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `role` varchar(100) NOT NULL,
  `resource_type` enum('Activity','Document','Report','Table',
                       'Admin-Table') NOT NULL,
  `resource_name` varchar(100) NOT NULL,
  `action` enum('All','View','AddRecords','ModifyRecords','DeleteRecords',
                'AllButDelete') NOT NULL DEFAULT 'View'
);


-- Create Initial Authorization Rules:

LOCK TABLES `ramp_auth_auths` WRITE;
INSERT INTO `ramp_auth_auths`
(`role`, `resource_type`, `resource_name`, `action`) VALUES
('epart_dba','Activity','Admin','View')
, ('epart_dba','Table','ramp_auth_users','View')
, ('epart_dba','Table','ramp_auth_users','ModifyRecords')
, ('epart_dba','Admin-Table','Person','View')
, ('epart_dba','Admin-Table','Person','AddRecords')
, ('epart_dba','Admin-Table','ramp_auth_users','ALL')
, ('epart_dba','Table','ramp_auth_auths','All')
, ('epart_dba','Table','ramp_lock_relations','All')
, ('epart_dba','Table','ramp_lock_locks','View')
, ('epart_dba','Table','ramp_lock_locks','DeleteRecords')
, ('epart_dba','Table','Person','View')
, ('epart_dba','Document','../..','View')
, ('epart_dba','Document','../../installation','View')
, ('guest','Activity','.','View')
, ('guest','Activity','../docs/rampDocs','View')
, ('guest','Document','.','View')
, ('guest','Document','rampDocs','View')
, ('guest','Activity','EPART','View')
, ('guest','Table','HealthCareFacilities','View')
, ('guest','Activity','EPART/ValidCodeTables','View')
, ('guest','Table','AnnotationTypes','View')
, ('guest','Table','AuthorizationTypes','View')
, ('guest','Table','DiagnosisStatusValues','View')
, ('guest','Table','FacilityStatus','View')
, ('guest','Table','FacilityTypes','View')
, ('guest','Table','HCWorkerRoles','View')
, ('guest','Table','HealthStatusValues','View')
, ('epart_dba','Table','AnnotationTypes','All')
, ('epart_dba','Table','AuthorizationTypes','All')
, ('epart_dba','Table','DiagnosisStatusValues','All')
, ('epart_dba','Table','FacilityStatus','All')
, ('epart_dba','Table','FacilityTypes','All')
, ('epart_dba','Table','HCWorkerRoles','All')
, ('epart_dba','Table','HealthStatusValues','AllButDelete')
, ('authOfficial','Activity','EPART/completeActivity.act','View')
, ('authOfficial','Table','Person','AllButDelete')
, ('authOfficial','Table','Village','AllButDelete')
, ('authOfficial','Table','PhoneNumber','All')
, ('patientUpdates','Activity','EPART/patientIndex.act','View')
, ('patientUpdates','Table','Person','View')
, ('patientUpdates','Table','Person','AddRecords')
, ('patientUpdates','Table','Village','View')
, ('patientUpdates','Table','HealthHistory','All')
, ('patientUpdates','Table','PatientAnnotations','All')
, ('resourceUpdates','Activity','EPART/resourceIndex.act','View')
, ('resourceUpdates','Table','Person','View')
, ('resourceUpdates','Table','Person','AddRecords')
, ('resourceUpdates','Table','Village','View')
, ('resourceUpdates','Table','HealthCareFacilities','AllButDelete')
, ('resourceUpdates','Table','HealthCareWorkers','All')
, ('resourceUpdates','Table','HealthCareAssignments','All')
;
UNLOCK TABLES;

-- Very basic authorizations can alternatively be defined in 
-- the application.ini file, e.g., guest access to the docs/rampDocs
-- directory or smart_dba access to the Admin directory and the
-- ramp_auth_users and ramp_auth_auths tables.
