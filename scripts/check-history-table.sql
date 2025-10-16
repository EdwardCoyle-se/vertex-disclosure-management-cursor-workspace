-- Quick check: Does History schema and History.Reports table exist?

-- Check if History schema exists
SELECT SCHEMA_NAME 
FROM INFORMATION_SCHEMA.SCHEMATA 
WHERE SCHEMA_NAME = 'History';

-- Check if History.Reports table exists
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'History' AND TABLE_NAME = 'Reports';

-- Check current Reports table temporal status
SELECT 
    OBJECT_NAME(t.object_id) AS TableName,
    t.temporal_type_desc AS TemporalType,
    SCHEMA_NAME(h.schema_id) + '.' + h.name AS HistoryTable
FROM sys.tables t
LEFT JOIN sys.tables h ON t.history_table_id = h.object_id
WHERE t.name = 'Reports';

