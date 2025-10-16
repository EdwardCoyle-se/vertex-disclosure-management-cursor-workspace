# DbUp Migration Troubleshooting Guide
**Disclosure Management - Database Migration Issues & Solutions**

## Table of Contents
- [Overview](#overview)
- [Common Issues](#common-issues)
- [SQL Server Temporal Tables](#sql-server-temporal-tables)
- [Embedded Resource Caching](#embedded-resource-caching)
- [Diagnostic Tools](#diagnostic-tools)
- [Best Practices](#best-practices)
- [Related Documentation](#related-documentation)

---

## Overview

This guide documents common DbUp migration issues encountered in the Disclosure Management project, specifically focusing on problems that arose during the ESG-13441 (Manual Publish Workflow) implementation.

**Time Investment:** The issues documented here cost approximately 3-4 hours of troubleshooting time. Following this guide should reduce similar issues to minutes.

---

## Common Issues

### Issue 1: "Invalid column name" Errors After Migration

**Symptom:**
```
Microsoft.Data.SqlClient.SqlException (0x80131904): Invalid column name 'IsLocked'.
Invalid column name 'PublishedDate'.
Invalid column name 'PublishedByUserId'.
```

**Root Cause:**
SQL Server parses the **entire migration script** before executing any statements. If your script references new columns in UPDATE/SELECT statements, SQL Server will reject the script even though the columns are created earlier in the same script.

**Solution:**
Use **dynamic SQL** for any statements that reference newly created columns:

```sql
-- ❌ BAD: Direct UPDATE will fail at parse time
ALTER TABLE [dbo].[Reports] ADD IsLocked BIT NOT NULL DEFAULT 0;
UPDATE [dbo].[Reports] SET IsLocked = 1 WHERE Status = 'published';

-- ✅ GOOD: Use dynamic SQL
ALTER TABLE [dbo].[Reports] ADD IsLocked BIT NOT NULL DEFAULT 0;

DECLARE @UpdateSql NVARCHAR(MAX) = N'
    UPDATE [dbo].[Reports] 
    SET IsLocked = 1 
    WHERE Status = ''published'';
';
EXEC sp_executesql @UpdateSql;
```

**See Full Example:**
[`DotNet_Angular/vertex-disclosure-management-api/service/SE.Sustainability.Vertex.DisclosureManagement.Infrastructure.SqlServer/DBMigrations/20251015/001-AddPublishFields.sql`](../../DotNet_Angular/vertex-disclosure-management-api/service/SE.Sustainability.Vertex.DisclosureManagement.Infrastructure.SqlServer/DBMigrations/20251015/001-AddPublishFields.sql)

---

### Issue 2: Incorrect History Table Name

**Symptom:**
```
Cannot find the object "History.Reports" because it does not exist or you do not have permissions.
```

**Root Cause:**
SQL Server temporal tables may have custom history table names that don't match the pattern `History.[TableName]`.

**Solution:**
1. Query to find the actual history table name:
```sql
SELECT 
    OBJECT_NAME(t.object_id) AS TableName,
    t.temporal_type_desc AS TemporalType,
    SCHEMA_NAME(h.schema_id) + '.' + h.name AS HistoryTable
FROM sys.tables t
LEFT JOIN sys.tables h ON t.history_table_id = h.object_id
WHERE t.name = 'Reports';
```

2. Use the discovered name in your migrations:
```sql
-- Found actual name: history.Reports_History
ALTER TABLE [history].[Reports_History]
ADD IsLocked BIT NOT NULL DEFAULT 0;
```

**Diagnostic Script:**
See [`scripts/check-history-table.sql`](../../scripts/check-history-table.sql)

---

### Issue 3: Nullability Mismatch in Temporal Tables

**Symptom:**
```
Setting SYSTEM_VERSIONING to ON failed because column 'IsLocked' does not have 
the same nullability attribute in tables 'dbo.Reports' and 'history.Reports_History'.
```

**Root Cause:**
SQL Server temporal tables require **identical column definitions** in both main and history tables, including nullability.

**Solution:**
Ensure both tables have matching nullability:

```sql
-- ❌ BAD: Mismatch
ALTER TABLE [dbo].[Reports] ADD IsLocked BIT NOT NULL DEFAULT 0;
ALTER TABLE [history].[Reports_History] ADD IsLocked BIT NULL;

-- ✅ GOOD: Match nullability
ALTER TABLE [dbo].[Reports] ADD IsLocked BIT NOT NULL DEFAULT 0;
ALTER TABLE [history].[Reports_History] ADD IsLocked BIT NOT NULL DEFAULT 0;
```

---

## SQL Server Temporal Tables

### What Are Temporal Tables?

SQL Server temporal tables automatically track the full history of data changes. They consist of:
1. **Main table** - Current data with `SYSTEM_VERSIONING = ON`
2. **History table** - Historical records with system-generated timestamps

### Migration Pattern for Temporal Tables

**Required Steps (in order):**

```sql
BEGIN TRANSACTION;

-- Step 1: Turn OFF system versioning
ALTER TABLE [dbo].[Reports] SET (SYSTEM_VERSIONING = OFF);

-- Step 2: Add columns to MAIN table
ALTER TABLE [dbo].[Reports] ADD IsLocked BIT NOT NULL DEFAULT 0;

-- Step 3: Add columns to HISTORY table (matching definition)
ALTER TABLE [history].[Reports_History] ADD IsLocked BIT NOT NULL DEFAULT 0;

-- Step 4: Turn system versioning back ON
ALTER TABLE [dbo].[Reports] SET (
    SYSTEM_VERSIONING = ON (
        HISTORY_TABLE = [history].[Reports_History]
    )
);

-- Step 5: Use dynamic SQL for updates
DECLARE @UpdateSql NVARCHAR(MAX) = N'
    UPDATE [dbo].[Reports] SET IsLocked = 1 WHERE Status = ''published'';
';
EXEC sp_executesql @UpdateSql;

COMMIT TRANSACTION;
```

### Critical Rules

1. ✅ **Always** turn off system versioning before schema changes
2. ✅ **Always** update both main and history tables
3. ✅ **Always** match column definitions exactly (type, length, nullability)
4. ✅ **Always** turn system versioning back on after changes
5. ✅ **Always** use dynamic SQL for data operations on new columns

---

## Embedded Resource Caching

### Issue: Migration Script Changes Not Applied

**Symptom:**
- Updated migration script in source code
- Rebuilt project
- Migration still fails with old script content

**Root Cause:**
Visual Studio and MSBuild can cache embedded resources (like SQL migration scripts). The old version remains in the DLL even after rebuild.

**Solution:**

1. **Clean Build** the specific Infrastructure project:
   ```powershell
   # In Visual Studio:
   # Right-click SE.Sustainability.Vertex.DisclosureManagement.Infrastructure.SqlServer
   # Select "Clean", then "Rebuild"
   ```

2. **Or use PowerShell script:**
   ```powershell
   .\scripts\run-core-api-migrations.ps1 -Clean
   ```

3. **Verify script is embedded:**
   ```powershell
   # Check DLL for embedded resources
   $dll = "path\to\SE.Sustainability.Vertex.DisclosureManagement.Infrastructure.SqlServer.dll"
   [System.Reflection.Assembly]::LoadFrom($dll).GetManifestResourceNames() | 
       Where-Object { $_ -like "*AddPublishFields*" }
   ```

### Prevention

- Always **Clean + Rebuild** the Infrastructure.SqlServer project after changing migration scripts
- Use the `-Clean` flag when running migration scripts: `.\scripts\run-core-api-migrations.ps1 -Clean`

---

## Diagnostic Tools

### 1. Database Schema Diagnostic Script

**Purpose:** Verify migration was applied and columns exist

**Script:** [`scripts/diagnose-database-schema.sql`](../../scripts/diagnose-database-schema.sql)

**Usage:**
```powershell
.\scripts\run-database-diagnostic.ps1
```

**Output:**
- ✅ Columns exist/missing status
- ✅ Migration recorded in SchemaVersions
- ✅ Index existence
- ✅ Sample data with new columns

### 2. Core API Migration Runner

**Purpose:** Run DbUp migrations with proper error handling

**Script:** [`scripts/run-core-api-migrations.ps1`](../../scripts/run-core-api-migrations.ps1)

**Usage:**
```powershell
# Normal run
.\scripts\run-core-api-migrations.ps1

# With clean build
.\scripts\run-core-api-migrations.ps1 -Clean

# Specify environment
.\scripts\run-core-api-migrations.ps1 -Environment non
```

**Features:**
- Stops running API processes
- Clean build option
- Restore packages
- Run migrations with detailed output
- Error handling and troubleshooting hints

### 3. Check History Table Script

**Purpose:** Discover actual history table names for temporal tables

**Script:** Created during troubleshooting (see Issue 2)

```sql
SELECT 
    OBJECT_NAME(t.object_id) AS TableName,
    t.temporal_type_desc AS TemporalType,
    SCHEMA_NAME(h.schema_id) + '.' + h.name AS HistoryTable
FROM sys.tables t
LEFT JOIN sys.tables h ON t.history_table_id = h.object_id
WHERE t.name = 'YourTableName';
```

---

## Best Practices

### Migration Script Structure

```sql
-- Migration: [Description]
-- Date: YYYY-MM-DD
-- Purpose: [Detailed purpose]
-- Jira: ESG-XXXXX

BEGIN TRANSACTION;

PRINT 'Starting migration for ESG-XXXXX...';

-- Step 1: Turn off system versioning (if temporal table)
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'TableName' AND temporal_type = 2)
BEGIN
    PRINT '1. Turning off system versioning...';
    ALTER TABLE [dbo].[TableName] SET (SYSTEM_VERSIONING = OFF);
    PRINT '   System versioning turned off.';
END

-- Step 2: Add columns to main table with IF NOT EXISTS checks
PRINT '2. Adding columns to main table...';
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TableName') AND name = 'NewColumn')
BEGIN
    ALTER TABLE [dbo].[TableName] ADD NewColumn DATATYPE CONSTRAINTS;
    PRINT '   Added NewColumn.';
END

-- Step 3: Add columns to history table (if applicable)
PRINT '3. Adding columns to history table...';
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('history.TableName_History') AND name = 'NewColumn')
BEGIN
    ALTER TABLE [history].[TableName_History] ADD NewColumn DATATYPE CONSTRAINTS;
    PRINT '   Added NewColumn to history table.';
END

-- Step 4: Turn system versioning back on
PRINT '4. Turning system versioning back on...';
ALTER TABLE [dbo].[TableName] SET (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = [history].[TableName_History])
);
PRINT '   System versioning turned on.';

-- Step 5: Data updates using dynamic SQL
PRINT '5. Updating existing data...';
DECLARE @UpdateSql NVARCHAR(MAX) = N'
    UPDATE [dbo].[TableName]
    SET NewColumn = value
    WHERE condition;
';
EXEC sp_executesql @UpdateSql;
PRINT '   Data updated.';

-- Step 6: Create indexes (using dynamic SQL if referencing new columns)
PRINT '6. Creating indexes...';
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TableName_NewColumn')
BEGIN
    DECLARE @IndexSql NVARCHAR(MAX) = N'
        CREATE INDEX IX_TableName_NewColumn ON [dbo].[TableName](NewColumn);
    ';
    EXEC sp_executesql @IndexSql;
    PRINT '   Created index.';
END

PRINT 'Migration completed successfully.';
COMMIT TRANSACTION;
```

### Checklist Before Running Migrations

- [ ] Migration script has clear PRINT statements for each step
- [ ] IF NOT EXISTS checks for columns, indexes
- [ ] Temporal table handling (OFF → changes → ON)
- [ ] Matching definitions in main and history tables
- [ ] Dynamic SQL for operations on new columns
- [ ] Transaction wrapping with proper error handling
- [ ] Clean build of Infrastructure.SqlServer project
- [ ] Stop running API processes before migration
- [ ] Backup database (if production)

### Post-Migration Verification

1. Run diagnostic script: `.\scripts\run-database-diagnostic.ps1`
2. Check for new columns in both tables
3. Verify migration recorded in SchemaVersions
4. Check sample data
5. Test API startup (no 500 errors)
6. Test endpoint calls

---

## Related Documentation

- [NuGet Configuration Troubleshooting](./NUGET-CONFIGURATION.md) - Fix package restore issues
- [Diagnostic Scripts Guide](./DIAGNOSTIC-SCRIPTS.md) - Using diagnostic tools
- [Coding Standards - Database Section](../CODING_STANDARDS.md#database-migrations) - Migration standards
- [Architecture Guide - Data Layer](../ARCHITECTURE_GUIDE.md#data-persistence) - DbUp patterns
- [Scripts README](../../scripts/README.md) - PowerShell script documentation

---

## Quick Reference

### Error → Solution Mapping

| Error Message | Root Cause | Solution |
|---------------|------------|----------|
| `Invalid column name 'X'` | Parse-time validation | Use dynamic SQL (Issue 1) |
| `Cannot find object "History.TableName"` | Wrong history table name | Query sys.tables (Issue 2) |
| `nullability attribute` mismatch | Different nullability | Match nullability (Issue 3) |
| Migration runs but no changes | Cached embedded resources | Clean + Rebuild |
| `SYSTEM_VERSIONING` fails | Temporal table not handled | Follow temporal table pattern |

---

**Last Updated:** 2025-10-16  
**Related Ticket:** ESG-13441 - Manual Publish Workflow

