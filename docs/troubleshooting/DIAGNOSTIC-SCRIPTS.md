# Diagnostic Scripts Guide
**Disclosure Management - Database & Migration Diagnostic Tools**

## Table of Contents
- [Overview](#overview)
- [Available Scripts](#available-scripts)
- [Usage Examples](#usage-examples)
- [Interpreting Results](#interpreting-results)
- [When to Use Each Script](#when-to-use-each-script)
- [Related Documentation](#related-documentation)

---

## Overview

This guide documents the diagnostic scripts created for troubleshooting database migrations and verifying the Disclosure Management system state.

**Location:** All scripts are in [`scripts/`](../../scripts/) directory

---

## Available Scripts

### 1. run-core-api-migrations.ps1

**Purpose:** Run DbUp database migrations with proper error handling and environment setup.

**Location:** [`scripts/run-core-api-migrations.ps1`](../../scripts/run-core-api-migrations.ps1)

**Features:**
- Stops running Core API processes
- Optional clean build
- Restores NuGet packages
- Builds solution
- Runs migrations
- Provides detailed output and error messages

**Parameters:**
```powershell
-Clean          # Optional: Clean build before running migrations
-Environment    # Optional: Environment name (default: "local")
```

**Usage:**
```powershell
# Basic run
.\scripts\run-core-api-migrations.ps1

# With clean build (recommended after changing migration scripts)
.\scripts\run-core-api-migrations.ps1 -Clean

# Specify environment
.\scripts\run-core-api-migrations.ps1 -Environment non
```

**What It Does:**
1. **Step 1:** Checks for and stops running Core API processes
2. **Step 2:** Navigates to Core API directory
3. **Step 3:** Optionally cleans solution (`-Clean` flag)
4. **Step 4:** Restores NuGet packages
5. **Step 5:** Builds solution
6. **Step 6:** Runs database migrations with environment variables
7. Provides success/failure messages with troubleshooting hints

**Example Output (Success):**
```
=== Core API Database Migrations ===

Step 1: Checking for running Core API processes...
[OK] No running processes found

Step 2: Navigating to Core API directory...
[OK] Current directory: C:\Dev\dm\DotNet_Angular\...

Step 3: Skipping clean (use -Clean to enable)

Step 4: Restoring NuGet packages...
[OK] NuGet packages restored

Step 5: Building solution...
[OK] Build succeeded

Step 6: Running database migrations...
--- Migration Output ---
Starting migration for ESG-13441...
Migration completed successfully.
--- End Migration Output ---

[OK] Migrations completed successfully

=== Migration Complete ===

Next steps:
  1. Run the diagnostic script to verify columns exist:
     .\scripts\run-database-diagnostic.ps1
```

---

### 2. run-database-diagnostic.ps1

**Purpose:** Verify database schema and migration status.

**Location:** [`scripts/run-database-diagnostic.ps1`](../../scripts/run-database-diagnostic.ps1)

**Features:**
- Checks if tables exist
- Lists current columns
- Verifies new columns exist
- Checks migration history
- Verifies indexes
- Shows sample data

**Usage:**
```powershell
.\scripts\run-database-diagnostic.ps1
```

**What It Does:**
1. Reads connection string from appsettings.local.json
2. Executes diagnostic SQL script
3. Reports on:
   - Table existence
   - Column definitions
   - New column presence (IsLocked, PublishedDate, PublishedByUserId)
   - DbUp migration history
   - Index existence
   - Sample data validation

**Example Output (Success):**
```
=== Database Schema Diagnostic ===

Connection Details:
  Server:   127.0.0.1,1433
  Database: sqldb-disclosure-managment-non
  Username: sa

[OK] Diagnostic script found
[OK] sqlcmd found

Running diagnostic script...
--- Diagnostic Output ---

1. Checking if Reports table exists...
   ✓ Reports table EXISTS

2. Current columns in Reports table:
   (Lists all columns including new ones)

3. Checking for new publish-related columns:
   IsLocked: ✓ EXISTS
   PublishedByUserId: ✓ EXISTS
   PublishedDate: ✓ EXISTS

4. Checking DbUp migration history:
   ✓ SchemaVersions table EXISTS
   ✓ ESG-13441 migration (AddPublishFields) IS RECORDED

5. Checking for new indexes:
   ✓ IX_Reports_PublishedDate index EXISTS

6. Sample Status values from Reports table:
   Report_Id: discmgmt_report_xxx
   Status: active
   IsLockedStatus: Column exists

=== End of Diagnostic Script ===

[OK] Diagnostic completed successfully
```

---

### 3. diagnose-database-schema.sql

**Purpose:** SQL script executed by run-database-diagnostic.ps1 to check database state.

**Location:** [`scripts/diagnose-database-schema.sql`](../../scripts/diagnose-database-schema.sql)

**Features:**
- Direct SQL queries for schema validation
- Can be run manually in SQL Server Management Studio (SSMS)
- Provides detailed column information

**Manual Usage (SSMS):**
```sql
-- Open script in SSMS
-- Connect to database: sqldb-disclosure-managment-non
-- Execute script (F5)
```

**What It Checks:**
```sql
-- 1. Table existence
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Reports'

-- 2. Column list
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Reports'

-- 3. New columns
SELECT * FROM sys.columns 
WHERE object_id = OBJECT_ID('dbo.Reports') 
AND name IN ('IsLocked', 'PublishedDate', 'PublishedByUserId')

-- 4. Migration history
SELECT ScriptName, Applied 
FROM SchemaVersions 
ORDER BY Applied DESC

-- 5. Indexes
SELECT * FROM sys.indexes 
WHERE name = 'IX_Reports_PublishedDate'

-- 6. Sample data
SELECT TOP 10 Report_Id, Status, IsLocked, PublishedDate 
FROM Reports
```

---

### 4. check-history-table.sql

**Purpose:** Discover the actual history table name for SQL Server temporal tables.

**Location:** Created during troubleshooting (documented in [DBUP-MIGRATIONS.md](./DBUP-MIGRATIONS.md#issue-2-incorrect-history-table-name))

**Usage:**
```sql
-- Create file: scripts/check-history-table.sql
SELECT 
    OBJECT_NAME(t.object_id) AS TableName,
    t.temporal_type_desc AS TemporalType,
    SCHEMA_NAME(h.schema_id) + '.' + h.name AS HistoryTable
FROM sys.tables t
LEFT JOIN sys.tables h ON t.history_table_id = h.object_id
WHERE t.name = 'Reports';

-- Execute via sqlcmd
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" -i scripts\check-history-table.sql
```

**Example Output:**
```
TableName    TemporalType                 HistoryTable
-----------  ---------------------------  -----------------------
Reports      SYSTEM_VERSIONED_TEMPORAL_TABLE  history.Reports_History
```

---

## Usage Examples

### Scenario 1: After Creating New Migration Script

```powershell
# 1. Clean build and run migrations
.\scripts\run-core-api-migrations.ps1 -Clean

# 2. Verify migration was applied
.\scripts\run-database-diagnostic.ps1

# 3. Check for specific column
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" -Q "SELECT TOP 1 IsLocked FROM Reports"
```

### Scenario 2: Migration Fails - Debugging

```powershell
# 1. Run diagnostic to see current state
.\scripts\run-database-diagnostic.ps1

# 2. Check history table name (if temporal table issue)
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" -i scripts\check-history-table.sql

# 3. Check DbUp migration history
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" -Q "SELECT TOP 10 ScriptName, Applied FROM SchemaVersions ORDER BY Applied DESC"

# 4. Fix migration script
# Edit: DotNet_Angular/.../DBMigrations/20251015/001-AddPublishFields.sql

# 5. Clean build and retry
.\scripts\run-core-api-migrations.ps1 -Clean
```

### Scenario 3: Verify System is Healthy

```powershell
# 1. Check database schema
.\scripts\run-database-diagnostic.ps1

# 2. Expected output should show:
# - ✓ All tables exist
# - ✓ All columns exist
# - ✓ Migration recorded
# - ✓ Indexes created
```

---

## Interpreting Results

### Success Indicators

✅ **Green checkmarks or [OK] messages**
- Database schema is correct
- Migrations have been applied
- System is ready for use

### Warning Indicators

⚠️ **Yellow warnings**
- Minor issues that don't block functionality
- Consider addressing but not urgent

### Error Indicators

❌ **Red X marks or [ERROR] messages**
- Critical issues blocking functionality
- Must be addressed before proceeding

### Common Diagnostic Outputs

#### Columns Missing
```
3. Checking for new publish-related columns:
   IsLocked: ✗ MISSING
   PublishedByUserId: ✗ MISSING
   PublishedDate: ✗ MISSING
```

**Action:** Run migration: `.\scripts\run-core-api-migrations.ps1 -Clean`

#### Migration Not Recorded
```
4. Checking DbUp migration history:
   ✓ SchemaVersions table EXISTS
   ✗ ESG-13441 migration (AddPublishFields) IS NOT RECORDED
```

**Action:** Migration either failed or hasn't run. Check Core API logs and re-run.

#### Index Missing
```
5. Checking for new indexes:
   ✗ IX_Reports_PublishedDate index MISSING
```

**Action:** Migration script may have failed partway. Review migration logs.

---

## When to Use Each Script

### Use `run-core-api-migrations.ps1` When:

- ✅ Creating new migration scripts
- ✅ Migration script was modified
- ✅ Pulled latest code with new migrations
- ✅ Setting up new development environment
- ✅ Switching between branches with different migrations
- ✅ Database schema is out of sync with code

**Always use `-Clean` flag when:**
- Migration script was edited
- Previous migration failed mysteriously
- Embedded resources might be cached

### Use `run-database-diagnostic.ps1` When:

- ✅ After running migrations (verification)
- ✅ Getting 500 errors about missing columns
- ✅ Debugging database schema issues
- ✅ Verifying system setup for new developer
- ✅ Before running tests
- ✅ Investigating why migrations "should" be applied but aren't showing up

### Use `diagnose-database-schema.sql` Directly When:

- ✅ Need to inspect schema in SSMS
- ✅ PowerShell script isn't available
- ✅ Automation scripts are failing
- ✅ Need to customize diagnostic queries
- ✅ Generating reports on schema state

### Use `check-history-table.sql` When:

- ✅ Writing migrations for temporal tables
- ✅ Getting "Cannot find object History.TableName" errors
- ✅ Documenting temporal table structure
- ✅ Debugging temporal table system versioning issues

---

## Error Patterns & Solutions

### Pattern 1: Migration Script Runs But No Changes

**Symptoms from Diagnostic:**
```
✓ Migration IS RECORDED in SchemaVersions
✗ Columns are MISSING
```

**Cause:** Embedded resource caching issue

**Solution:**
```powershell
# Clean rebuild the Infrastructure.SqlServer project
.\scripts\run-core-api-migrations.ps1 -Clean
```

**See:** [DBUP-MIGRATIONS.md - Embedded Resource Caching](./DBUP-MIGRATIONS.md#embedded-resource-caching)

### Pattern 2: sqlcmd Not Found

**Symptoms:**
```
[ERROR] sqlcmd not found. Please install SQL Server Command Line Utilities.
```

**Solution:**
1. Install SQL Server Command Line Utilities
2. Add to PATH: `C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn`
3. Restart PowerShell

### Pattern 3: Connection Failed

**Symptoms:**
```
sqlcmd: Error: Connection failed
```

**Solution:**
1. Check SQL Server is running
2. Verify connection string in appsettings.local.json
3. Test connection: `sqlcmd -S 127.0.0.1,1433 -U sa -P "password" -Q "SELECT @@VERSION"`

---

## Script Maintenance

### Adding New Diagnostic Checks

To add checks to `diagnose-database-schema.sql`:

```sql
-- Add after existing checks
PRINT '7. Checking for [YourNewCheck]...';

IF EXISTS (YOUR_CHECK_QUERY)
BEGIN
    PRINT '   ✓ [YourCheck] EXISTS';
END
ELSE
BEGIN
    PRINT '   ✗ [YourCheck] MISSING';
END
```

### Updating Migration Runner

To add features to `run-core-api-migrations.ps1`:

```powershell
# Add new parameter
param(
    [switch]$Clean = $false,
    [string]$Environment = "local",
    [switch]$YourNewFlag = $false  # Add here
)

# Add new step
Write-Host "Step X: Your new step..." -ForegroundColor Yellow
# Your logic here
Write-Host "✓ Step completed" -ForegroundColor Green
```

---

## Related Documentation

- [DbUp Migrations Troubleshooting](./DBUP-MIGRATIONS.md) - Migration-specific issues
- [NuGet Configuration](./NUGET-CONFIGURATION.md) - Package restore problems
- [Scripts README](../../scripts/README.md) - Complete script documentation
- [Coding Standards - Testing](../CODING_STANDARDS.md#testing) - Testing standards

---

## Quick Command Reference

```powershell
# Run migrations
.\scripts\run-core-api-migrations.ps1

# Run migrations with clean build
.\scripts\run-core-api-migrations.ps1 -Clean

# Check database schema
.\scripts\run-database-diagnostic.ps1

# Manual SQL execution
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" -Q "YOUR_SQL_HERE"

# Check migration history
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" -Q "SELECT TOP 10 ScriptName, Applied FROM SchemaVersions ORDER BY Applied DESC"

# Clear NuGet cache (if needed)
dotnet nuget locals all --clear
```

---

**Last Updated:** 2025-10-16  
**Related Ticket:** ESG-13441 - Manual Publish Workflow

