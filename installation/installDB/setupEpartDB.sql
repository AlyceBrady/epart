-- Define the EPART table schemas and populate with sample data.

--
-- This file contains SQL code to create administrative tables used by
-- EPART and sample EPART tables that have corresponding table settings
-- in the demoSettings/EPART directory.
--

--
-- Create Database: `epart_demo`
--

DROP DATABASE IF EXISTS `epart_demo`;
CREATE DATABASE `epart_demo`;

-- Define what "guest" users (those who are not logged in) are
-- authorized to do, create an EPART administrator role, and define what
-- administrative users with that role may do.  As an example, and/or
-- to make development easier, create several test users ("hr", "reg",
-- and "developer") and define what those users may do.

SOURCE createEPARTUsersAuths.sql;

-- Create and populate the built-in tables used for record locking.

SOURCE createEPARTLocks.sql;

-- Read in various files to set up tables that form the initial demo.

SOURCE epartCoreSetup.sql

SOURCE epartPatientSetup.sql

SOURCE epartResourcesSetup.sql

-- Grant the MySQL accounts created in createEPARTMysqlAccts.sql
-- the ability to execute functions and procedures that allow the
-- database to do some of its own consistency maintenance.
--
--      IS THIS NECESSARY?

-- SOURCE grant_func_proc_privs.sql;

