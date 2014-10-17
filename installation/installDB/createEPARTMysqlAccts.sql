--
-- RAMP: Record and Activity Management Program
-- EPART: Epidemic Patient and Resource Tracking
--
-- Create the basic MySQL user accounts for interacting with a simple
-- EPART Demo -- one for a database administrator and one for web-based
-- EPART access to the EPART Demo -- and grant those accounts appropriate
-- permissions to access the EPART Demo database (whose name is assumed
-- to be 'epart_demo').


-- Please read the installation instructions in INSTALL_DB.txt,
-- particularly the section on "Addressing Security Concerns,"
-- BEFORE using this file or executing these SQL instructions.

-- AT THE VERY LEAST, change the dba and epartdemo passwords
-- in this file and change the permissions on the file to be readable
-- only by the owner.

-- You must run MySQL as root (or some other user that has CREATE USER
-- and GRANT permissions to execute the commands found in this file:
--      mysql> SOURCE filename.sql

-- When finished, edit the application/configs/application.ini file
-- to specify the web-based access account and password as properties
-- available to RAMP/EPART.

-- NOTE: EPART databases require additional permissions for
-- procedures and functions that allow the database to do some of
-- its own consistency maintenance, but these can't be set up until
-- the database and the relevant procedures and functions have been
-- created.  Therefore, you should execute the MySQL commands in
-- grant_func_proc_privs.sql after the database has been created.


-- 1a. CREATE DBA ACCOUNT(S):

-- already created
-- CREATE USER 'dba'@'localhost' IDENTIFIED BY 'would_need_password';

-- 1b. CREATE WEB-BASED RAMP/EPART ACCESS ACCOUNT:

CREATE USER 'epartdemo'@'localhost' IDENTIFIED BY '3p4rtd3m0pw';



-- 2a. SET UP PRIVILEGES FOR DBA ACCOUNT(S):
--     Grant permissions for MySQL access by the database administrator.

GRANT ALL ON `epart_demo`.* TO 'dba'@'localhost';

-- 2b. SET UP PRIVILEGES FOR WEB-BASED RAMP/EPART ACCESS ACCOUNT:
--     Grant EPART software permission to view, add, edit, and delete
--     data, but not to change table schemas.  The actual access
--     permissions for different types of EPART users depend on role-based
--     authorization defined in the EPART authorizations table
--     (ramp_auth_auths); that table might, for example, only allow
--     read-only access to the demo database for non-admin users.
--
--     NOTE:  If you want demo users to only have read-only access to
--     tables in the database, and if you don't need the demo to
--     support an admin role that can create new users, then you could
--     just grant SELECT privileges to the database, e.g.,
--         GRANT SELECT ON `epart_demo`.* TO 'epartdemo'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER, EXECUTE
    ON `epart_demo`.* TO 'epartdemo'@'localhost';

