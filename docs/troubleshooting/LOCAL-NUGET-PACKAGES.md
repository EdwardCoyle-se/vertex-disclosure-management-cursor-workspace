# Local NuGet Package Development Guide
**Disclosure Management - Building and Using Local SDK Packages**

## Table of Contents
- [Overview](#overview)
- [When to Use Local Packages](#when-to-use-local-packages)
- [Complete Workflow](#complete-workflow)
- [Common Issues](#common-issues)
- [Verification Steps](#verification-steps)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Related Documentation](#related-documentation)

---

## Overview

When developing features that require changes to both the **Core API SDK** and the **BFF** simultaneously, you need a way to test these changes locally without publishing to the NuGet feed. This guide documents the complete workflow for building and using local NuGet packages.

**Use Case (ESG-13441):**
- Added new models and endpoints to Core API (`PublishReportResponse`, `FrameworkVersionValidation`)
- BFF needed to reference these new types immediately
- Couldn't publish to production NuGet feed during development
- Solution: Build local NuGet package and configure BFF to use it

**Time Investment:** Initial setup takes ~15 minutes. Subsequent iterations take ~3 minutes.

---

## When to Use Local Packages

### ✅ Use Local Packages When:

- **Developing across layers** - Changes to Core API SDK that BFF needs immediately
- **Testing before publishing** - Verify changes work before publishing to production feed
- **Breaking changes** - Testing API contract changes without affecting other developers
- **Rapid iteration** - Need quick feedback loop during development
- **Version conflicts** - Avoiding conflicts with published versions

### ❌ Don't Use Local Packages When:

- **Only changing Core API** - BFF doesn't need updates
- **Only changing BFF** - No SDK changes required
- **Production deployment** - Always use published packages
- **Sharing with team** - Publish to feed instead
- **Long-term development** - Causes version drift

---

## Complete Workflow

### Phase 1: Make Changes to Core API SDK

#### 1.1 Update Core API Code

```powershell
cd DotNet_Angular\vertex-disclosure-management-api\service
```

Make your changes in the SDK project:
- `SE.Sustainability.Vertex.DisclosureManagement.API.Models/` - Add DTOs
- `SE.Sustainability.Vertex.DisclosureManagement.API.SDK/` - Add Refit interfaces

Example changes (ESG-13441):
```csharp
// API.Models/PublishReportResponse.cs
public class PublishReportResponse
{
    public bool Success { get; set; }
    public bool FrameworkVersionMismatch { get; set; }
    public string? Message { get; set; }
}

// API.SDK/IDisclosureManagementApi.cs
[Post("/reports/{reportId}/publish")]
Task<PublishReportResponse> PublishReportAsync(
    string reportId, 
    [Body] PublishReportRequestDto request
);
```

#### 1.2 Build Core API to Verify

```powershell
# Build to ensure no compilation errors
dotnet build

# Run tests if available
dotnet test
```

---

### Phase 2: Package Core API SDK Locally

#### 2.1 Create LocalPackages Directory

```powershell
# From repository root
cd C:\Dev\dm
mkdir LocalPackages -Force
```

#### 2.2 Build NuGet Package

```powershell
cd DotNet_Angular\vertex-disclosure-management-api\service

# Pack the SDK project
dotnet pack SE.Sustainability.Vertex.DisclosureManagement.API.SDK\SE.Sustainability.Vertex.DisclosureManagement.API.SDK.csproj `
    --configuration Debug `
    --output ..\..\..\..\LocalPackages
```

**Output:**
```
Successfully created package 'C:\Dev\dm\LocalPackages\SE.Sustainability.Vertex.DisclosureManagement.API.SDK.1.0.0.nupkg'.
```

**Important Notes:**
- Use `Debug` configuration for development
- Version number comes from `.csproj` file (typically `1.0.0` for local dev)
- Output path must point to repository root `LocalPackages/` directory

#### 2.3 Verify Package Created

```powershell
dir C:\Dev\dm\LocalPackages\SE.Sustainability.Vertex.DisclosureManagement.API.SDK*

# Expected output:
# SE.Sustainability.Vertex.DisclosureManagement.API.SDK.1.0.0.nupkg
```

---

### Phase 3: Configure BFF to Use Local Package

#### 3.1 Update NuGet.config

**Location:** `DotNet_Angular/vertex-bff-disclosure-management/service/NuGet.config`

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <!-- LOCAL PACKAGE SOURCE - MUST BE FIRST -->
    <add key="LocalPackages" value="../../../LocalPackages" />
    
    <!-- Standard package sources -->
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
    <add key="SE-Sustainability-Business" value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />
  </packageSources>
</configuration>
```

**Critical:** LocalPackages must be listed **first** to take precedence over other sources.

#### 3.2 Update Project References

Update all BFF projects that reference the SDK:

**Files to Update:**
- `SE.Sustainability.Vertex.BFF.DisclosureManagement.Core/SE.Sustainability.Vertex.BFF.DisclosureManagement.Core.csproj`
- `SE.Sustainability.Vertex.BFF.DisclosureManagement.API.Models/SE.Sustainability.Vertex.BFF.DisclosureManagement.API.Models.csproj`

```xml
<ItemGroup>
  <!-- LOCAL DEV: Using local package from ../../../LocalPackages (ESG-13441) -->
  <!-- PRODUCTION: Change to published version when available (e.g., 8.0.11) -->
  <PackageReference Include="SE.Sustainability.Vertex.DisclosureManagement.API.SDK" Version="1.0.0" />
</ItemGroup>
```

**Critical:** Version `1.0.0` must match the version in the local package.

---

### Phase 4: Restore and Build BFF

#### 4.1 Clear NuGet Caches

```powershell
# CRITICAL: Clear all caches before restore
dotnet nuget locals all --clear
```

This clears:
- `http-cache` - Downloaded packages cache
- `global-packages` - Global NuGet packages folder
- `temp` - Temporary cache
- `plugins-cache` - NuGet plugins

#### 4.2 Restore Packages

```powershell
cd DotNet_Angular\vertex-bff-disclosure-management\service\SE.Sustainability.Vertex.BFF.DisclosureManagement.API

# Restore with force to ensure fresh package resolution
dotnet restore --force
```

**Expected Output:**
```
Restore succeeded.
  Determining projects to restore...
  Restored C:\Dev\dm\...\SE.Sustainability.Vertex.BFF.DisclosureManagement.Core.csproj (in X ms).
  Restored C:\Dev\dm\...\SE.Sustainability.Vertex.BFF.DisclosureManagement.API.Models.csproj (in X ms).
```

**If you see errors**, see [Common Issues](#common-issues) section below.

#### 4.3 Build BFF

```powershell
# Build to verify everything compiles
dotnet build

# Expected output:
# Build succeeded.
#     0 Warning(s)
#     0 Error(s)
```

#### 4.4 Verify Local Package is Used

```powershell
# List packages and their sources
dotnet list package --include-transitive | Select-String "DisclosureManagement.API.SDK"

# Expected output should show version 1.0.0
```

---

### Phase 5: Test and Iterate

#### 5.1 Run Both Services

```powershell
# Terminal 1: Core API
cd DotNet_Angular\vertex-disclosure-management-api\service\SE.Sustainability.Vertex.DisclosureManagement.API
dotnet run

# Terminal 2: BFF
cd DotNet_Angular\vertex-bff-disclosure-management\service\SE.Sustainability.Vertex.BFF.DisclosureManagement.API
dotnet run
```

#### 5.2 Test Your Changes

Make API calls to verify the new endpoints/models work correctly.

#### 5.3 Iterate on Changes

When you need to make more changes to the SDK:

```powershell
# 1. Make changes to Core API SDK
# 2. Repackage
cd DotNet_Angular\vertex-disclosure-management-api\service
dotnet pack SE.Sustainability.Vertex.DisclosureManagement.API.SDK\*.csproj `
    --configuration Debug `
    --output ..\..\..\..\LocalPackages

# 3. Clear cache and rebuild BFF
cd ..\..\..\vertex-bff-disclosure-management\service
dotnet nuget locals all --clear
cd SE.Sustainability.Vertex.BFF.DisclosureManagement.API
dotnet restore --force
dotnet build

# 4. Restart BFF
dotnet run
```

---

## Common Issues

### Issue 1: "Package downgrade detected"

**Symptom:**
```
error NU1605: Detected package downgrade: SE.Sustainability.Vertex.DisclosureManagement.API.SDK 
from 8.0.10 to 1.0.0
```

**Root Cause:**
Another project in the solution references a higher version from the production feed.

**Solution:**

1. **Find all references:**
   ```powershell
   cd DotNet_Angular\vertex-bff-disclosure-management\service
   Get-ChildItem -Recurse -Filter "*.csproj" | Select-String "DisclosureManagement.API.SDK"
   ```

2. **Update ALL references to version 1.0.0:**
   ```xml
   <PackageReference Include="SE.Sustainability.Vertex.DisclosureManagement.API.SDK" Version="1.0.0" />
   ```

3. **Clear cache and restore:**
   ```powershell
   dotnet nuget locals all --clear
   dotnet restore --force
   ```

---

### Issue 2: Local Package Not Found

**Symptom:**
```
error NU1101: Unable to find package SE.Sustainability.Vertex.DisclosureManagement.API.SDK.
```

**Root Cause:**
- Package doesn't exist in LocalPackages directory
- Relative path in NuGet.config is incorrect
- Package version doesn't match reference

**Solution:**

1. **Verify package exists:**
   ```powershell
   dir C:\Dev\dm\LocalPackages\*.nupkg
   ```

2. **Check NuGet.config relative path:**
   ```xml
   <!-- From BFF service/ directory, go up 3 levels to reach LocalPackages -->
   <add key="LocalPackages" value="../../../LocalPackages" />
   ```

3. **Verify version matches:**
   ```powershell
   # Check package version in filename
   dir C:\Dev\dm\LocalPackages\SE.Sustainability.Vertex.DisclosureManagement.API.SDK*.nupkg
   
   # Should show: SE.Sustainability.Vertex.DisclosureManagement.API.SDK.1.0.0.nupkg
   # Version must match .csproj references
   ```

---

### Issue 3: Changes Not Reflected After Repackaging

**Symptom:**
Rebuilt local package but BFF still uses old version.

**Root Cause:**
NuGet package cache wasn't cleared before restore.

**Solution:**

```powershell
# MUST clear cache BEFORE restore
dotnet nuget locals all --clear

# Then restore and build
cd DotNet_Angular\vertex-bff-disclosure-management\service\SE.Sustainability.Vertex.BFF.DisclosureManagement.API
dotnet restore --force
dotnet build
```

**Prevention:**
Always clear cache before restore when updating local packages.

---

### Issue 4: Wrong Package Source Used

**Symptom:**
BFF restores version 8.0.10 from GitHub instead of 1.0.0 from LocalPackages.

**Root Cause:**
LocalPackages source not prioritized in NuGet.config.

**Solution:**

Ensure LocalPackages is **first** in the sources list:

```xml
<packageSources>
  <!-- MUST BE FIRST -->
  <add key="LocalPackages" value="../../../LocalPackages" />
  <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
  <add key="SE-Sustainability-Business" value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />
</packageSources>
```

---

### Issue 5: Build Succeeds But Runtime Errors

**Symptom:**
BFF builds successfully but throws errors at runtime about missing types.

**Root Cause:**
- Multiple versions of SDK in bin directory
- Old assemblies not cleaned

**Solution:**

```powershell
# Clean all projects
cd DotNet_Angular\vertex-bff-disclosure-management\service
dotnet clean

# Delete bin/obj folders manually
Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | Remove-Item -Recurse -Force

# Restore and build fresh
dotnet restore --force
dotnet build
```

---

## Verification Steps

### 1. Verify Local Package Built

```powershell
cd C:\Dev\dm\LocalPackages
dir *.nupkg

# Should show:
# SE.Sustainability.Vertex.DisclosureManagement.API.SDK.1.0.0.nupkg
```

### 2. Verify NuGet.config Correct

```powershell
cd DotNet_Angular\vertex-bff-disclosure-management\service
Get-Content NuGet.config

# Verify:
# - LocalPackages source exists
# - LocalPackages is first in list
# - Relative path is correct (../../../LocalPackages)
```

### 3. Verify Package References

```powershell
cd DotNet_Angular\vertex-bff-disclosure-management\service
Get-ChildItem -Recurse -Filter "*.csproj" | Select-String 'DisclosureManagement.API.SDK'

# All references should show Version="1.0.0"
```

### 4. Verify Package Resolution

```powershell
cd SE.Sustainability.Vertex.BFF.DisclosureManagement.API
dotnet restore --verbosity detailed 2>&1 | Select-String "DisclosureManagement.API.SDK"

# Look for lines showing package resolved from LocalPackages
```

### 5. Verify BFF Builds

```powershell
dotnet build

# Should complete with no errors
# Build succeeded.
#     0 Warning(s)
#     0 Error(s)
```

### 6. Verify Runtime

```powershell
# Start BFF
dotnet run

# Should start without errors
# Application started. Press Ctrl+C to shut down.
```

---

## Best Practices

### 1. Version Management

```xml
<!-- Use consistent version for local development -->
<PackageReference Include="SE.Sustainability.Vertex.DisclosureManagement.API.SDK" Version="1.0.0" />

<!-- ALWAYS add comments -->
<!-- LOCAL DEV: Using local package from ../../../LocalPackages (ESG-XXXXX) -->
<!-- PRODUCTION: Change to published version when available (e.g., 8.0.11) -->
```

### 2. Documentation

Always document when using local packages:
- Add TODO comments in code
- Note in PR description
- Update JIRA ticket
- Don't commit .csproj changes with local versions

### 3. Clean Up

```powershell
# Before committing code:
# 1. Revert .csproj version changes
<PackageReference Include="..." Version="8.0.10" />  <!-- Restore production version -->

# 2. Remove local package
Remove-Item C:\Dev\dm\LocalPackages\SE.Sustainability.Vertex.DisclosureManagement.API.SDK* -Force

# 3. Clear cache
dotnet nuget locals all --clear

# 4. Restore from production feed
cd DotNet_Angular\vertex-bff-disclosure-management\service
dotnet restore
```

### 4. Workflow Automation Script

Create a helper script for rapid iteration:

**File:** `scripts/rebuild-local-sdk.ps1`

```powershell
# Rebuild Core API SDK and update BFF
param(
    [switch]$SkipTests = $false
)

Write-Host "=== Rebuilding Local Core API SDK ===" -ForegroundColor Cyan

# Step 1: Build Core API SDK
Write-Host "`n1. Building Core API SDK..." -ForegroundColor Yellow
cd DotNet_Angular\vertex-disclosure-management-api\service
dotnet build

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Core API build failed" -ForegroundColor Red
    exit 1
}

# Step 2: Package SDK
Write-Host "`n2. Packaging SDK..." -ForegroundColor Yellow
dotnet pack SE.Sustainability.Vertex.DisclosureManagement.API.SDK\*.csproj `
    --configuration Debug `
    --output ..\..\..\..\LocalPackages

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Packaging failed" -ForegroundColor Red
    exit 1
}

# Step 3: Clear NuGet cache
Write-Host "`n3. Clearing NuGet cache..." -ForegroundColor Yellow
dotnet nuget locals all --clear

# Step 4: Restore BFF
Write-Host "`n4. Restoring BFF packages..." -ForegroundColor Yellow
cd ..\..\..\vertex-bff-disclosure-management\service
dotnet restore --force

# Step 5: Build BFF
Write-Host "`n5. Building BFF..." -ForegroundColor Yellow
dotnet build

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] BFF build failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n[OK] Local SDK rebuilt and BFF updated successfully!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Start Core API: cd DotNet_Angular\vertex-disclosure-management-api\service\SE.Sustainability.Vertex.DisclosureManagement.API && dotnet run"
Write-Host "  2. Start BFF: cd DotNet_Angular\vertex-bff-disclosure-management\service\SE.Sustainability.Vertex.BFF.DisclosureManagement.API && dotnet run"
```

**Usage:**
```powershell
.\scripts\rebuild-local-sdk.ps1
```

---

## Troubleshooting

### Quick Diagnostic

```powershell
# Check if local package exists
Test-Path C:\Dev\dm\LocalPackages\SE.Sustainability.Vertex.DisclosureManagement.API.SDK.1.0.0.nupkg

# Check NuGet config
Get-Content DotNet_Angular\vertex-bff-disclosure-management\service\NuGet.config

# Check package references
cd DotNet_Angular\vertex-bff-disclosure-management\service
Get-ChildItem -Recurse -Filter "*.csproj" | Select-String 'DisclosureManagement.API.SDK'

# List NuGet sources
dotnet nuget list source
```

### Nuclear Option: Complete Reset

If nothing works:

```powershell
# 1. Delete LocalPackages
Remove-Item C:\Dev\dm\LocalPackages\* -Force

# 2. Clear all caches
dotnet nuget locals all --clear

# 3. Clean all projects
cd DotNet_Angular\vertex-bff-disclosure-management\service
dotnet clean

# 4. Delete bin/obj
Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | Remove-Item -Recurse -Force

# 5. Rebuild local package
cd ..\..\..\vertex-disclosure-management-api\service
dotnet pack SE.Sustainability.Vertex.DisclosureManagement.API.SDK\*.csproj `
    --configuration Debug `
    --output ..\..\..\..\LocalPackages

# 6. Restore and build BFF
cd ..\..\..\vertex-bff-disclosure-management\service
dotnet restore --force
dotnet build
```

---

## Related Documentation

- [NuGet Configuration](./NUGET-CONFIGURATION.md) - Feed setup and authentication
- [DbUp Migrations](./DBUP-MIGRATIONS.md) - Database migration patterns
- [Diagnostic Scripts](./DIAGNOSTIC-SCRIPTS.md) - Diagnostic tools
- [Troubleshooting Summary](./TROUBLESHOOTING-SUMMARY-ESG-13441.md) - Quick reference
- [Scripts README](../../scripts/README.md) - PowerShell scripts

---

## Quick Reference

```powershell
# Build local package
cd DotNet_Angular\vertex-disclosure-management-api\service
dotnet pack SE.Sustainability.Vertex.DisclosureManagement.API.SDK\*.csproj --configuration Debug --output ..\..\..\..\LocalPackages

# Update BFF to use local package
dotnet nuget locals all --clear
cd DotNet_Angular\vertex-bff-disclosure-management\service\SE.Sustainability.Vertex.BFF.DisclosureManagement.API
dotnet restore --force
dotnet build

# Verify
dir C:\Dev\dm\LocalPackages\*.nupkg
dotnet list package | Select-String "DisclosureManagement.API.SDK"
```

---

**Last Updated:** 2025-10-16  
**Related Ticket:** ESG-13441 - Manual Publish Workflow  
**Time Saved:** ~45 minutes per iteration after initial setup

