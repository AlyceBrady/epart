
-- The following Patient-related table(s) have foreign keys to Person

DROP TABLE IF EXISTS HealthHistory;
DROP TABLE IF EXISTS PatientAnnotations;

-- The following Resource-related table(s) have foreign keys to Person
-- and/or Village

DROP TABLE IF EXISTS HealthCareAssignments;
DROP TABLE IF EXISTS HealthCareFacilities;
DROP TABLE IF EXISTS HealthCareWorkers;

