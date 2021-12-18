USE ROCID_CARGAS;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE ROCID_CARGAS
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (rocid003_log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE ROCID_CARGAS
SET RECOVERY FULL;
GO