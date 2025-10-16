# Troubleshooting Guides
**Disclosure Management - Problem Resolution & Prevention**

## Overview

This directory contains comprehensive troubleshooting guides created from real-world issues encountered during Disclosure Management development. Each guide provides detailed problem analysis, step-by-step solutions, and prevention strategies.

---

## Available Guides

### 🔥 Quick Start: Troubleshooting Summary
**[TROUBLESHOOTING-SUMMARY-ESG-13441.md](./TROUBLESHOOTING-SUMMARY-ESG-13441.md)**

**Quick reference for common issues** encountered during ESG-13441 implementation.
- Executive summary of all problems and solutions
- Time investment analysis
- Prevention checklist
- Quick command reference

**Use this when:** You need a fast overview or remember seeing a similar issue before.

---

### 🗄️ DbUp Migrations
**[DBUP-MIGRATIONS.md](./DBUP-MIGRATIONS.md)**

**Comprehensive guide for database migration issues** with SQL Server and DbUp.
- SQL Server temporal tables handling
- Dynamic SQL patterns for parse-time validation
- History table name discovery
- Nullability mismatch resolution
- Embedded resource caching issues
- Best practices and migration script template

**Use this when:**
- Creating new database migrations
- Getting "Invalid column name" errors
- Working with temporal tables
- Migration runs but changes don't appear
- Getting system versioning errors

---

### 📦 NuGet Configuration
**[NUGET-CONFIGURATION.md](./NUGET-CONFIGURATION.md)**

**Complete guide for NuGet feed configuration** and package management.
- GitHub Packages vs Azure DevOps feeds
- Authentication setup
- Package restore troubleshooting
- Version conflict resolution

**Use this when:**
- Getting 404 errors on package restore
- Setting up new development environment
- Getting authentication errors
- BFF won't build due to missing packages

---

### 📦 Local NuGet Packages
**[LOCAL-NUGET-PACKAGES.md](./LOCAL-NUGET-PACKAGES.md)**

**Step-by-step guide for building and using local SDK packages** during development.
- Complete workflow from SDK changes to BFF testing
- Building local NuGet packages
- Configuring BFF to use local packages
- Iteration workflow
- Common package issues and solutions
- Automation scripts

**Use this when:**
- Making changes to Core API SDK that BFF needs
- Developing features across Core API and BFF simultaneously
- Testing SDK changes before publishing
- Getting "package downgrade" errors
- Local package not found errors
- Need rapid iteration on SDK changes

---

### 🔧 Diagnostic Scripts
**[DIAGNOSTIC-SCRIPTS.md](./DIAGNOSTIC-SCRIPTS.md)**

**Guide for using diagnostic tools** to verify system state.
- `run-core-api-migrations.ps1` - Automated migration execution
- `run-database-diagnostic.ps1` - Schema verification
- `diagnose-database-schema.sql` - Manual SQL diagnostics
- Interpreting diagnostic output
- When to use each tool

**Use this when:**
- Verifying migrations were applied
- Checking database schema state
- Investigating why changes aren't visible
- Before and after running migrations
- Setting up diagnostic automation

---

## Troubleshooting Workflow

### 1. Identify the Problem Category

| Symptoms | Likely Category | Guide to Use |
|----------|----------------|--------------|
| "Invalid column name" errors | Database Migration | [DBUP-MIGRATIONS.md](./DBUP-MIGRATIONS.md) |
| Migration script changes not applied | Database Migration | [DBUP-MIGRATIONS.md](./DBUP-MIGRATIONS.md) |
| System versioning errors | Database Migration | [DBUP-MIGRATIONS.md](./DBUP-MIGRATIONS.md) |
| 404 Package not found | NuGet Configuration | [NUGET-CONFIGURATION.md](./NUGET-CONFIGURATION.md) |
| Package restore fails | NuGet Configuration | [NUGET-CONFIGURATION.md](./NUGET-CONFIGURATION.md) |
| Version conflicts | NuGet Configuration | [NUGET-CONFIGURATION.md](./NUGET-CONFIGURATION.md) |
| Package downgrade detected | Local NuGet Packages | [LOCAL-NUGET-PACKAGES.md](./LOCAL-NUGET-PACKAGES.md) |
| Local package not found | Local NuGet Packages | [LOCAL-NUGET-PACKAGES.md](./LOCAL-NUGET-PACKAGES.md) |
| Need to test SDK changes | Local NuGet Packages | [LOCAL-NUGET-PACKAGES.md](./LOCAL-NUGET-PACKAGES.md) |
| Need to verify migrations | Diagnostic Scripts | [DIAGNOSTIC-SCRIPTS.md](./DIAGNOSTIC-SCRIPTS.md) |
| Setting up new environment | All Guides | Start with Summary |

### 2. Use Diagnostic Tools First

Before diving into fixes, **always verify the current state**:

```powershell
# Check database schema
.\scripts\run-database-diagnostic.ps1

# Expected output will guide next steps
```

### 3. Follow the Appropriate Guide

Each guide includes:
- ✅ Clear problem descriptions
- ✅ Root cause analysis
- ✅ Step-by-step solutions
- ✅ Prevention strategies
- ✅ Code examples
- ✅ Links to related guides

### 4. Document New Issues

If you encounter a new issue:
1. Solve it using available guides
2. Document the solution
3. Update the appropriate guide
4. Consider adding to [TROUBLESHOOTING-SUMMARY](./TROUBLESHOOTING-SUMMARY-ESG-13441.md)

---

## Prevention: Key Rules

### Database Migrations

```sql
-- ALWAYS follow this pattern for temporal tables:
ALTER TABLE [dbo].[Table] SET (SYSTEM_VERSIONING = OFF);
-- Add columns to MAIN table
-- Add columns to HISTORY table (matching definitions)
ALTER TABLE [dbo].[Table] SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [schema].[Table_History]));

-- ALWAYS use dynamic SQL for new column references:
DECLARE @sql NVARCHAR(MAX) = N'UPDATE [dbo].[Table] SET NewColumn = value;';
EXEC sp_executesql @sql;
```

### Build Process

```powershell
# ALWAYS use Clean build after changing migration scripts:
.\scripts\run-core-api-migrations.ps1 -Clean

# ALWAYS verify with diagnostics:
.\scripts\run-database-diagnostic.ps1
```

### NuGet Configuration

```xml
<!-- ALWAYS use GitHub Packages -->
<add key="SE-Sustainability-Business" 
     value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />

<!-- NEVER use Azure DevOps feeds -->
<!-- <add key="..." value="https://pkgs.dev.azure.com/..." /> -->
```

---

## Quick Reference

### Most Common Commands

```powershell
# Run migrations (with clean build)
.\scripts\run-core-api-migrations.ps1 -Clean

# Verify database schema
.\scripts\run-database-diagnostic.ps1

# Clear NuGet cache
dotnet nuget locals all --clear

# Check migration history
sqlcmd -S 127.0.0.1,1433 -d sqldb-disclosure-managment-non -U sa -P "password" `
  -Q "SELECT TOP 10 ScriptName, Applied FROM SchemaVersions ORDER BY Applied DESC"

# Package Core API SDK locally
cd DotNet_Angular\vertex-disclosure-management-api\service
dotnet pack SE.Sustainability.Vertex.DisclosureManagement.API.SDK\*.csproj `
  --configuration Debug --output ..\..\..\..\LocalPackages
```

### Most Common Fixes

| Problem | Quick Fix |
|---------|-----------|
| Migration not applied | `.\scripts\run-core-api-migrations.ps1 -Clean` |
| Columns missing | Run diagnostics, check migration script, rebuild |
| Package restore fails | Check NuGet.config URL, clear cache |
| Temporal table errors | Follow OFF → changes → ON pattern |
| Dynamic SQL needed | Wrap UPDATE/SELECT in `EXEC sp_executesql` |

---

## Related Documentation

### Repository Documentation
- [Coding Standards](../CODING_STANDARDS.md) - General coding guidelines
- [Architecture Guide](../ARCHITECTURE_GUIDE.md) - System architecture
- [Design System](../DESIGN_SYSTEM.md) - UI/UX guidelines
- [Custom Components](../CUSTOM_COMPONENTS.md) - Reusable UI components

### Repository Rules
- [.cursorrules](../../.cursorrules) - Mandatory development patterns
  - See: Database Migration section
  - See: NuGet Configuration section
  - See: SQL Server Temporal Tables rules

### Scripts
- [Scripts README](../../scripts/README.md) - PowerShell script documentation
- [`run-core-api-migrations.ps1`](../../scripts/run-core-api-migrations.ps1)
- [`run-database-diagnostic.ps1`](../../scripts/run-database-diagnostic.ps1)
- [`diagnose-database-schema.sql`](../../scripts/diagnose-database-schema.sql)

### Progress Tracking
- [Core API Progress](../progress-core-api.md)
- [BFF Progress](../progress-bff.md)
- [UI Progress](../progress-ui.md)

---

## Contributing to Troubleshooting Guides

### When to Add New Content

Add to existing guides when you:
- Encounter a variation of a documented problem
- Find a more efficient solution
- Discover additional context or edge cases
- Have insights that would help others

### How to Update Guides

1. **Identify the right guide** from the list above
2. **Read the existing content** to avoid duplication
3. **Add your content** following the established format:
   - Clear problem description
   - Root cause analysis
   - Step-by-step solution
   - Prevention strategies
   - Code examples where applicable
4. **Test your solution** before documenting
5. **Link related sections** for cross-referencing
6. **Update this README** if adding new guides

### Creating New Guides

Create a new guide when:
- The problem category doesn't fit existing guides
- The issue is complex enough to warrant its own document
- You anticipate others will face the same issue
- The solution involves multiple systems/layers

**Format:**
```markdown
# [Category] Troubleshooting Guide
**Disclosure Management - [Brief Description]**

## Table of Contents
## Overview
## Common Issues
## Best Practices
## Related Documentation
## Quick Reference
```

---

## Feedback & Improvements

These guides are living documents. If you:
- Find errors or outdated information
- Have suggestions for improvement
- Discover better solutions
- Want to add new troubleshooting topics

Please update the relevant guide and document your changes in the commit message.

---

**Last Updated:** 2025-10-16  
**Related Project:** Disclosure Management  
**Related Ticket:** ESG-13441 - Manual Publish Workflow

