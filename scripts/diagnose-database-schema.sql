-- =====================================================
-- Database Schema Diagnostic Script
-- ESG-13441: Manual Publish Workflow
-- Run this against: sqldb-disclosure-managment-non
-- =====================================================

PRINT '=== Diagnostic Script for ESG-13441 Manual Publish Workflow ===';
PRINT '';

-- 1. Check if Reports table exists
PRINT '1. Checking if Reports table exists...';
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Reports')
BEGIN
    PRINT '   ✓ Reports table EXISTS';
END
ELSE
BEGIN
    PRINT '   ✗ Reports table DOES NOT EXIST';
END
PRINT '';

-- 2. Check current columns in Reports table
PRINT '2. Current columns in Reports table:';
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable,
    c.is_identity AS IsIdentity
FROM 
    sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE 
    c.object_id = OBJECT_ID('dbo.Reports')
ORDER BY 
    c.column_id;
PRINT '';

-- 3. Check specifically for new columns
PRINT '3. Checking for new publish-related columns:';

DECLARE @IsLockedExists BIT = 0;
DECLARE @PublishedByUserIdExists BIT = 0;
DECLARE @PublishedDateExists BIT = 0;

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Reports') AND name = 'IsLocked')
    SET @IsLockedExists = 1;
    
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Reports') AND name = 'PublishedByUserId')
    SET @PublishedByUserIdExists = 1;
    
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Reports') AND name = 'PublishedDate')
    SET @PublishedDateExists = 1;

PRINT '   IsLocked: ' + CASE WHEN @IsLockedExists = 1 THEN '✓ EXISTS' ELSE '✗ MISSING' END;
PRINT '   PublishedByUserId: ' + CASE WHEN @PublishedByUserIdExists = 1 THEN '✓ EXISTS' ELSE '✗ MISSING' END;
PRINT '   PublishedDate: ' + CASE WHEN @PublishedDateExists = 1 THEN '✓ EXISTS' ELSE '✗ MISSING' END;
PRINT '';

-- 4. Check DbUp journal table (SchemaVersions)
PRINT '4. Checking DbUp migration history:';
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SchemaVersions')
BEGIN
    PRINT '   ✓ SchemaVersions table EXISTS';
    PRINT '';
    PRINT '   Recent migrations:';
    SELECT TOP 10
        ScriptName,
        Applied
    FROM 
        dbo.SchemaVersions
    ORDER BY 
        Applied DESC;
    PRINT '';
    
    -- Check specifically for ESG-13441 migration
    IF EXISTS (SELECT * FROM dbo.SchemaVersions WHERE ScriptName LIKE '%20251015%' OR ScriptName LIKE '%AddPublishFields%')
    BEGIN
        PRINT '   ✓ ESG-13441 migration (AddPublishFields) IS RECORDED in SchemaVersions';
        SELECT ScriptName, Applied FROM dbo.SchemaVersions WHERE ScriptName LIKE '%20251015%' OR ScriptName LIKE '%AddPublishFields%';
    END
    ELSE
    BEGIN
        PRINT '   ✗ ESG-13441 migration (AddPublishFields) IS NOT RECORDED in SchemaVersions';
    END
END
ELSE
BEGIN
    PRINT '   ✗ SchemaVersions table DOES NOT EXIST (DbUp not initialized)';
END
PRINT '';

-- 5. Check for indexes related to new columns
PRINT '5. Checking for new indexes:';
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Reports_PublishedDate' AND object_id = OBJECT_ID('dbo.Reports'))
BEGIN
    PRINT '   ✓ IX_Reports_PublishedDate index EXISTS';
END
ELSE
BEGIN
    PRINT '   ✗ IX_Reports_PublishedDate index MISSING';
END
PRINT '';

-- 6. Sample data from Reports table (to check Status values)
PRINT '6. Sample Status values from Reports table:';
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Reports')
BEGIN
    SELECT TOP 5
        Report_Id,
        Status,
        CASE 
            WHEN EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Reports') AND name = 'IsLocked') 
            THEN 'Column exists'
            ELSE 'Column missing'
        END AS IsLockedStatus
    FROM 
        dbo.Reports;
END
PRINT '';

PRINT '=== End of Diagnostic Script ===';

