# Troubleshooting Summary - ESG-13441 Manual Publish Workflow
**Database Migration & Build Issues - Lessons Learned**

## Executive Summary

During the implementation of ESG-13441 (Manual Publish Workflow), we encountered several database migration and build configuration issues that consumed approximately 3-4 hours of troubleshooting time. This document provides a quick reference for the problems encountered and their solutions.

---

## Problems Encountered & Solutions

### 1. SQL Server Temporal Tables - System Versioning

**Problem:** Migration failed with "Invalid column name" errors even after adding columns.

**Root Cause:** SQL Server temporal tables require special handling when modifying schema.

**Solution:**
```sql
-- Always follow this pattern:
ALTER TABLE [dbo].[TableName] SET (SYSTEM_VERSIONING = OFF);
-- Add columns to MAIN table
-- Add columns to HISTORY table (matching definitions)
ALTER TABLE [dbo].[TableName] SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [schema].[HistoryTableName]));
```

**Time Saved:** ~30 minutes per migration issue  
**Documentation:** [DBUP-MIGRATIONS.md#sql-server-temporal-tables](./DBUP-MIGRATIONS.md#sql-server-temporal-tables)

---

### 2. Parse-Time Column Validation

**Problem:** SQL statements referencing newly created columns failed with "Invalid column name" errors.

**Root Cause:** SQL Server parses entire script before execution, preventing references to columns created in the same script.

**Solution:**
```sql
-- Use dynamic SQL for statements referencing new columns
DECLARE @sql NVARCHAR(MAX) = N'
    UPDATE [dbo].[TableName] 
    SET NewColumn = value;
';
EXEC sp_executesql @sql;
```

**Time Saved:** ~45 minutes per occurrence  
**Documentation:** [DBUP-MIGRATIONS.md#issue-1-invalid-column-name](./DBUP-MIGRATIONS.md#issue-1-invalid-column-name-errors-after-migration)

---

### 3. History Table Name Mismatch

**Problem:** Migration failed with "Cannot find object 'History.Reports'".

**Root Cause:** Assumed history table name didn't match actual SQL Server naming (`history.Reports_History`).

**Solution:**
```sql
-- Query to find actual history table name:
SELECT 
    OBJECT_NAME(t.object_id) AS TableName,
    SCHEMA_NAME(h.schema_id) + '.' + h.name AS HistoryTable
FROM sys.tables t
LEFT JOIN sys.tables h ON t.history_table_id = h.object_id
WHERE t.name = 'Reports';
```

**Time Saved:** ~20 minutes  
**Documentation:** [DBUP-MIGRATIONS.md#issue-2-incorrect-history-table-name](./DBUP-MIGRATIONS.md#issue-2-incorrect-history-table-name)

---

### 4. Nullability Mismatch in Temporal Tables

**Problem:** System versioning failed to re-enable with nullability mismatch error.

**Root Cause:** Main table and history table had different nullability for `IsLocked` column.

**Solution:**
```sql
-- MUST match exactly
ALTER TABLE [dbo].[Reports] ADD IsLocked BIT NOT NULL DEFAULT 0;
ALTER TABLE [history].[Reports_History] ADD IsLocked BIT NOT NULL DEFAULT 0;
```

**Time Saved:** ~15 minutes  
**Documentation:** [DBUP-MIGRATIONS.md#issue-3-nullability-mismatch](./DBUP-MIGRATIONS.md#issue-3-nullability-mismatch-in-temporal-tables)

---

### 5. Embedded Resource Caching

**Problem:** Migration script changes not applied even after rebuilding project.

**Root Cause:** Visual Studio and MSBuild cache embedded resources (SQL migration scripts).

**Solution:**
```powershell
# Always use Clean + Rebuild for Infrastructure.SqlServer project
# Or use script with -Clean flag:
.\scripts\run-core-api-migrations.ps1 -Clean
```

**Time Saved:** ~40 minutes of "why isn't my change working?"  
**Documentation:** [DBUP-MIGRATIONS.md#embedded-resource-caching](./DBUP-MIGRATIONS.md#embedded-resource-caching)

---

### 6. Incorrect NuGet Feed URL

**Problem:** BFF failed to restore packages with 404 errors from Azure DevOps feed.

**Root Cause:** NuGet.config pointed to wrong feed (`pkgs.dev.azure.com` instead of GitHub Packages).

**Solution:**
```xml
<!-- CORRECT URL in NuGet.config -->
<add key="SE-Sustainability-Business" 
     value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />
```

**Time Saved:** ~30 minutes  
**Documentation:** [NUGET-CONFIGURATION.md#issue-1-wrong-nuget-feed-url](./NUGET-CONFIGURATION.md#issue-1-wrong-nuget-feed-url)

---

## Diagnostic Tools Created

### 1. run-core-api-migrations.ps1
- Automates migration execution
- Handles process cleanup
- Provides clean build option
- **Location:** [`scripts/run-core-api-migrations.ps1`](../../scripts/run-core-api-migrations.ps1)

### 2. run-database-diagnostic.ps1
- Verifies migrations applied
- Checks column existence
- Validates indexes
- **Location:** [`scripts/run-database-diagnostic.ps1`](../../scripts/run-database-diagnostic.ps1)

### 3. diagnose-database-schema.sql
- Direct SQL verification
- Can run in SSMS
- Detailed schema reporting
- **Location:** [`scripts/diagnose-database-schema.sql`](../../scripts/diagnose-database-schema.sql)

**Documentation:** [DIAGNOSTIC-SCRIPTS.md](./DIAGNOSTIC-SCRIPTS.md)

---

## Prevention Checklist

Before creating new migrations:

- [ ] Read [DbUp Migrations Guide](./DBUP-MIGRATIONS.md)
- [ ] Check if table is temporal (affects migration pattern)
- [ ] Query actual history table name
- [ ] Plan to use dynamic SQL for data operations
- [ ] Include IF NOT EXISTS checks
- [ ] Add PRINT statements for each step
- [ ] Wrap in BEGIN TRANSACTION/COMMIT

Before running migrations:

- [ ] Clean + Rebuild Infrastructure.SqlServer project
- [ ] Use `.\scripts\run-core-api-migrations.ps1 -Clean`
- [ ] Stop running API processes
- [ ] Back up database (if production)

After running migrations:

- [ ] Run `.\scripts\run-database-diagnostic.ps1`
- [ ] Verify columns exist
- [ ] Check migration recorded in SchemaVersions
- [ ] Test API startup (no 500 errors)
- [ ] Test endpoint calls

---

## Key Lessons Learned

### 1. Always Use Diagnostic Scripts First
Instead of guessing what's wrong, run diagnostics immediately:
```powershell
.\scripts\run-database-diagnostic.ps1
```

### 2. Clean Rebuild After Script Changes
Migration scripts are embedded resources and **must** be rebuilt:
```powershell
.\scripts\run-core-api-migrations.ps1 -Clean
```

### 3. Temporal Tables Require Special Handling
Never directly modify temporal table schemas without following the OFF → changes → ON pattern.

### 4. Dynamic SQL for New Column References
Always use `EXEC sp_executesql` for statements referencing columns created in the same migration.

### 5. Verify, Don't Assume
Always query sys.tables to find actual history table names.

### 6. Document As You Go
Create troubleshooting docs immediately when issues are resolved, while the solution is fresh.

---

## Time Investment Analysis

### Total Time Spent: ~3.5 hours

**Breakdown:**
- SQL Server temporal tables: 1 hour
- Parse-time validation (dynamic SQL): 1 hour  
- History table naming: 30 minutes
- Nullability mismatch: 20 minutes
- Embedded resource caching: 45 minutes
- NuGet feed configuration: 30 minutes
- Creating diagnostic tools: 30 minutes (one-time investment)

### Time Savings for Future Issues: ~2.5 hours

With proper documentation and diagnostic tools in place, similar issues should now take:
- Temporal table issues: 5-10 minutes
- Dynamic SQL needs: 5 minutes
- History table discovery: 2 minutes
- Nullability fixes: 2 minutes
- Embedded resource refresh: 3 minutes
- NuGet issues: 5 minutes

**Expected ROI:** After 2-3 similar issues, time savings break even with documentation time.

---

## Quick Command Reference

```powershell
# Run migrations with clean build
.\scripts\run-core-api-migrations.ps1 -Clean

# Verify migrations applied
.\scripts\run-database-diagnostic.ps1

# Clear NuGet cache
dotnet nuget locals all --clear

# Check migration history
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" `
  -Q "SELECT TOP 10 ScriptName, Applied FROM SchemaVersions ORDER BY Applied DESC"

# Find history table name
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" `
  -Q "SELECT SCHEMA_NAME(h.schema_id) + '.' + h.name FROM sys.tables t LEFT JOIN sys.tables h ON t.history_table_id = h.object_id WHERE t.name = 'Reports'"
```

---

## Updated Documentation

### New Files Created
1. [`docs/troubleshooting/DBUP-MIGRATIONS.md`](./DBUP-MIGRATIONS.md) - Comprehensive migration troubleshooting
2. [`docs/troubleshooting/NUGET-CONFIGURATION.md`](./NUGET-CONFIGURATION.md) - NuGet feed and package issues
3. [`docs/troubleshooting/DIAGNOSTIC-SCRIPTS.md`](./DIAGNOSTIC-SCRIPTS.md) - How to use diagnostic tools

### Updated Files
1. [`.cursorrules`](../../.cursorrules) - Added temporal table patterns, dynamic SQL rules, NuGet standards
2. [`scripts/README.md`](../../scripts/README.md) - Added troubleshooting links, updated BFF instructions
3. [`docs/progress-core-api.md`](../progress-core-api.md) - Added migration troubleshooting section
4. [`docs/progress-bff.md`](../progress-bff.md) - Added NuGet configuration section
5. [`docs/progress-ui.md`](../progress-ui.md) - Added documentation completion tracking

---

## Related Documentation

- **[DbUp Migrations Troubleshooting](./DBUP-MIGRATIONS.md)** - Detailed migration patterns
- **[NuGet Configuration](./NUGET-CONFIGURATION.md)** - Package management and feeds
- **[Local NuGet Packages](./LOCAL-NUGET-PACKAGES.md)** - Building and using local SDK packages
- **[Diagnostic Scripts Guide](./DIAGNOSTIC-SCRIPTS.md)** - Tool usage
- **[Scripts README](../../scripts/README.md)** - Script documentation
- **[ADR: Manual Publish Workflow](../adr/ADR-ESG-13441-manual-publish-workflow.md)** - Architecture decision

---

## Contact & Support

For questions about these troubleshooting procedures:
1. Review the detailed guides linked above
2. Check `.cursorrules` for mandatory patterns
3. Run diagnostic scripts to verify system state
4. Reference this summary for quick solutions

---

**Last Updated:** 2025-10-16  
**Related Ticket:** ESG-13441 - Manual Publish Workflow  
**Time Saved:** ~2.5 hours per future occurrence  
**Documentation Investment:** 1.5 hours (one-time)

