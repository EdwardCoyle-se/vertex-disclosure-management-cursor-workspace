# 🔧 Development Scripts

Helper scripts for database diagnostics, migrations, and troubleshooting the Disclosure Management project.

**📚 For Detailed Troubleshooting:**
- [DbUp Migrations Guide](../docs/troubleshooting/DBUP-MIGRATIONS.md) - SQL Server temporal tables, dynamic SQL, embedded resources
- [NuGet Configuration Guide](../docs/troubleshooting/NUGET-CONFIGURATION.md) - Package restore and feed configuration
- [Diagnostic Scripts Guide](../docs/troubleshooting/DIAGNOSTIC-SCRIPTS.md) - Using diagnostic tools effectively

---

## Available Scripts

### `run-core-api-migrations.ps1`

Builds the Core API and runs database migrations.

```powershell
# Run migrations (builds Core API first)
.\scripts\run-core-api-migrations.ps1

# Run with clean build
.\scripts\run-core-api-migrations.ps1 -Clean

# Run against different environment
.\scripts\run-core-api-migrations.ps1 -Environment "dev"
```

**What it does:**
1. Stops running Core API processes
2. Restores NuGet packages
3. Builds the Core API solution
4. Runs database migrations using DbUp

---

### `run-database-diagnostic.ps1`

Checks if database migrations were applied successfully.

```powershell
# Run diagnostic
.\scripts\run-database-diagnostic.ps1

# Use custom connection
.\scripts\run-database-diagnostic.ps1 -Server "127.0.0.1,1433" -Database "sqldb-disclosure-managment-non"
```

**What it checks:**
1. Reports table exists
2. New columns (IsLocked, PublishedByUserId, PublishedDate) exist
3. DbUp migration history
4. Indexes are created
5. Sample data from Reports table

---

### `diagnose-database-schema.sql`

SQL script used by `run-database-diagnostic.ps1`. Can be run manually in SSMS.

**To run manually:**
1. Open SQL Server Management Studio (SSMS)
2. Connect to your local SQL Server (127.0.0.1,1433)
3. Open this script
4. Execute against `sqldb-disclosure-managment-non` database

---

## Manual Approach (No Scripts)

### Option 1: Visual Studio

1. **Build the Core API**:
   - Open `vertex-disclosure-management-api` solution in Visual Studio
   - Right-click solution → **Rebuild**

2. **Run Migrations**:
   - Set `SE.Sustainability.Vertex.DisclosureManagement.API` as startup project
   - Check if there's a "Run Migrations" launch profile
   - If not, edit launch settings and add command line argument: `run-migrations`
   - Run the application (it will run migrations and exit)

3. **Verify**:
   - Open SSMS
   - Run `SELECT * FROM dbo.SchemaVersions ORDER BY Applied DESC`
   - Check for the ESG-13441 migration

---

### Option 2: Command Line

```powershell
# Navigate to Core API
cd DotNet_Angular\vertex-disclosure-management-api\service\SE.Sustainability.Vertex.DisclosureManagement.API

# Set environment
$env:APP_ENV = "local"
$env:ASPNETCORE_ENVIRONMENT = "local"

# Build and run migrations
dotnet build
dotnet run -- run-migrations

# Verify in SSMS or run diagnostic
cd ..\..\..\..\scripts
.\run-database-diagnostic.ps1
```

---

## Database Troubleshooting

### ❌ Migrations Seem Stuck or Not Applying

**Option A: Check Migration History**

```sql
-- In SSMS, run this against your database:
SELECT * FROM dbo.SchemaVersions 
ORDER BY Applied DESC;
```

If you see the ESG-13441 migration (`001-AddPublishFields.sql`) already recorded but columns are missing, the migration may have failed partway through.

**Option B: Fresh Start (Nuclear Option)**

If migrations are in a bad state, drop and recreate the database:

```sql
-- In SSMS, run against master database:
USE master;
GO

-- Close all connections
ALTER DATABASE [sqldb-disclosure-managment-non] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Drop the database
DROP DATABASE [sqldb-disclosure-managment-non];
GO

-- Recreate it
CREATE DATABASE [sqldb-disclosure-managment-non];
GO
```

Then run migrations fresh:
```powershell
.\scripts\run-core-api-migrations.ps1
```

This ensures all migrations run from scratch in the correct order.

---

### ❌ "Invalid column name" Errors

**Cause:** Migrations haven't been applied to the database yet.

**Solution:** Run the migration script (see above)

---

### ❌ SQL Server Not Running

```powershell
# Check SQL Server status
Get-Service | Where-Object { $_.Name -like "MSSQL*" }

# Restart SQL Server if needed
Restart-Service MSSQLSERVER
```

---

## For BFF Development

Once migrations are working and you need to rebuild the BFF with the local Core API SDK:

1. **Package the Core API SDK locally:**
   ```powershell
   cd DotNet_Angular\vertex-disclosure-management-api\service
   dotnet pack SE.Sustainability.Vertex.DisclosureManagement.API.SDK\SE.Sustainability.Vertex.DisclosureManagement.API.SDK.csproj `
       --configuration Debug `
       --output ..\..\..\..\LocalPackages
   ```

2. **The BFF's NuGet.config already points to LocalPackages**, so just rebuild:
   ```powershell
   cd DotNet_Angular\vertex-bff-disclosure-management\service
   dotnet nuget locals all --clear
   dotnet restore --force
   dotnet build
   ```

   **Note:** The BFF uses GitHub Packages for SE-Sustainability-Business packages. Ensure your NuGet.config has:
   ```xml
   <add key="SE-Sustainability-Business" value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />
   ```
   
   See [NuGet Configuration Guide](../docs/troubleshooting/NUGET-CONFIGURATION.md) for authentication setup.

---

## 📝 Notes

- **Core API**: Can be built and run independently (no auth required)
- **BFF**: Requires GitHub Packages authentication for SE-Sustainability-Business packages
- **LocalPackages**: The BFF is configured to use packages from `../../../LocalPackages/` first for development
- **Migrations**: Use DbUp (NOT Entity Framework migrations)
- **Temporal Tables**: Special handling required - see [DbUp Migrations Guide](../docs/troubleshooting/DBUP-MIGRATIONS.md#sql-server-temporal-tables)

---

## 📚 Documentation

For comprehensive troubleshooting and detailed explanations:
- **[DbUp Migrations Troubleshooting](../docs/troubleshooting/DBUP-MIGRATIONS.md)** - Temporal tables, dynamic SQL, embedded resources
- **[NuGet Configuration](../docs/troubleshooting/NUGET-CONFIGURATION.md)** - Package feeds, authentication
- **[Local NuGet Packages](../docs/troubleshooting/LOCAL-NUGET-PACKAGES.md)** - Building and using local SDK packages
- **[Diagnostic Scripts Guide](../docs/troubleshooting/DIAGNOSTIC-SCRIPTS.md)** - Script usage and interpretation

---

**Related Ticket:** ESG-13441 - Manual Publish Workflow
