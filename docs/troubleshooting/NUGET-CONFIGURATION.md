# NuGet Configuration Troubleshooting Guide
**Disclosure Management - NuGet Feed Issues & Solutions**

## Table of Contents
- [Overview](#overview)
- [Common Issues](#common-issues)
- [Correct Configuration](#correct-configuration)
- [Local Package Development](#local-package-development)
- [Authentication Setup](#authentication-setup)
- [Verification Steps](#verification-steps)
- [Related Documentation](#related-documentation)

---

## Overview

This guide documents NuGet feed configuration issues encountered in the Disclosure Management project, specifically problems with incorrect feed URLs and authentication during the ESG-13441 implementation.

---

## Common Issues

### Issue 1: Wrong NuGet Feed URL

**Symptom:**
```
error NU1301: Unable to load the service index for source 
https://pkgs.dev.azure.com/SchneiderElecOne/.../SE-Sustainability-Business/nuget/v3/index.json
Response status code does not indicate success: 404 (Not Found)
```

**Root Cause:**
The NuGet.config file contained an incorrect Azure DevOps feed URL instead of the GitHub Packages feed.

**Solution:**
Update `NuGet.config` with the correct GitHub Packages URL:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <!-- ✅ CORRECT: GitHub Packages -->
    <add key="SE-Sustainability-Business" value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />
    
    <!-- ❌ WRONG: Azure DevOps (do not use) -->
    <!-- <add key="SE-Sustainability-Business" value="https://pkgs.dev.azure.com/SchneiderElecOne/.../nuget/v3/index.json" /> -->
    
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
  </packageSources>
</configuration>
```

**Files to Check:**
- [`DotNet_Angular/vertex-bff-disclosure-management/service/NuGet.config`](../../DotNet_Angular/vertex-bff-disclosure-management/service/NuGet.config)

---

### Issue 2: Package Restore Fails Repeatedly

**Symptom:**
```
dotnet restore
error NU1301: Unable to load the service index...
```

**Root Cause:**
NuGet package restore cache may contain failed attempts.

**Solution:**

1. **Clear NuGet cache:**
   ```powershell
   dotnet nuget locals all --clear
   ```

2. **Restore packages:**
   ```powershell
   dotnet restore
   ```

3. **If still failing, check NuGet.config location:**
   ```powershell
   # Solution-level (preferred for Vertex projects)
   # Location: [Solution]/service/NuGet.config
   
   # Global user-level (fallback)
   # Location: %APPDATA%\NuGet\NuGet.Config
   ```

---

## Correct Configuration

### BFF Service NuGet.config

**Location:** `DotNet_Angular/vertex-bff-disclosure-management/service/NuGet.config`

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <!-- Local package source for development -->
    <add key="LocalPackages" value="../../LocalPackages" />
    
    <!-- Standard package sources -->
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
    
    <!-- GitHub Packages feed for SE-Sustainability-Business -->
    <add key="SE-Sustainability-Business" value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />
  </packageSources>
</configuration>
```

### Core API Configuration

The Core API typically uses the **global NuGet.config** which already has correct settings. No solution-level config is needed.

**Global Location:** `%APPDATA%\NuGet\NuGet.Config`

---

## Local Package Development

> **📖 For comprehensive local package workflow**, see **[Local NuGet Packages Guide](./LOCAL-NUGET-PACKAGES.md)** which includes:
> - Complete step-by-step workflow
> - Building and packaging SDK
> - Configuring BFF to use local packages
> - Iteration workflow
> - Common issues and solutions
> - Automation scripts

### When to Use Local Packages

Use local packages when:
- Developing changes across Core API SDK and BFF simultaneously
- Testing changes before publishing to package feed
- Avoiding version conflicts during active development

### Setup Local Package Source

1. **Create local package directory:**
   ```powershell
   mkdir LocalPackages
   ```

2. **Add to NuGet.config:**
   ```xml
   <add key="LocalPackages" value="../../LocalPackages" />
   ```

3. **Build and package Core API SDK:**
   ```powershell
   cd DotNet_Angular/vertex-disclosure-management-api/service/SE.Sustainability.Vertex.DisclosureManagement.API.SDK
   dotnet pack -c Debug -o ../../../../LocalPackages
   ```

4. **Update BFF to use local version:**
   ```xml
   <!-- In BFF .csproj files -->
   <PackageReference Include="SE.Sustainability.Vertex.DisclosureManagement.API.SDK" Version="1.0.0" />
   ```

5. **Clear cache and restore:**
   ```powershell
   dotnet nuget locals all --clear
   cd DotNet_Angular/vertex-bff-disclosure-management/service/SE.Sustainability.Vertex.BFF.DisclosureManagement.API
   dotnet restore
   ```

### Local Package Checklist

- [ ] LocalPackages directory created at solution root
- [ ] NuGet.config includes LocalPackages source
- [ ] Core API SDK built and packaged
- [ ] Package version matches BFF reference
- [ ] NuGet cache cleared before restore
- [ ] Comments in .csproj indicate local development mode

**Example Comment:**
```xml
<!-- LOCAL DEV: Using local package from ../../../LocalPackages (ESG-13441) -->
<!-- PRODUCTION: Change to published version when available (e.g., 8.0.11) -->
<PackageReference Include="SE.Sustainability.Vertex.DisclosureManagement.API.SDK" Version="1.0.0" />
```

---

## Authentication Setup

### GitHub Packages Authentication

GitHub Packages requires authentication to download packages.

#### Option 1: Personal Access Token (PAT)

1. **Create GitHub PAT:**
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate new token with `read:packages` scope
   - Copy token (you won't see it again)

2. **Add to NuGet.config:**
   ```xml
   <configuration>
     <packageSources>
       <add key="SE-Sustainability-Business" value="https://nuget.pkg.github.com/SE-Sustainability-Business/index.json" />
     </packageSources>
     <packageSourceCredentials>
       <SE-Sustainability-Business>
         <add key="Username" value="your-github-username" />
         <add key="ClearTextPassword" value="your-github-pat" />
       </SE-Sustainability-Business>
     </packageSourceCredentials>
   </configuration>
   ```

3. **⚠️ Security Note:** 
   - Never commit NuGet.config with credentials to source control
   - Use .gitignore or environment variables
   - Consider using credential providers instead

#### Option 2: Azure Artifacts Credential Provider

For Azure DevOps feeds (if needed):

```powershell
# Install credential provider
iex (iwr -Uri https://aka.ms/install-artifacts-credprovider.ps1 -UseBasicParsing)

# Restore will prompt for authentication
dotnet restore
```

---

## Verification Steps

### 1. Verify NuGet.config Location

```powershell
# Check if solution-level config exists
Test-Path "DotNet_Angular/vertex-bff-disclosure-management/service/NuGet.config"

# View configuration
Get-Content "DotNet_Angular/vertex-bff-disclosure-management/service/NuGet.config"
```

### 2. Test Package Restore

```powershell
cd DotNet_Angular/vertex-bff-disclosure-management/service/SE.Sustainability.Vertex.BFF.DisclosureManagement.API

# Clear cache
dotnet nuget locals all --clear

# Restore with diagnostic output
dotnet restore --verbosity detailed
```

### 3. Verify Package Sources

```powershell
# List configured sources
dotnet nuget list source

# Expected output:
# Registered Sources:
#   1. nuget.org [Enabled]
#      https://api.nuget.org/v3/index.json
#   2. SE-Sustainability-Business [Enabled]
#      https://nuget.pkg.github.com/SE-Sustainability-Business/index.json
#   3. LocalPackages [Enabled]
#      ../../LocalPackages
```

### 4. Check Package References

```powershell
# In BFF Core project
dotnet list package

# Verify version and source for:
# SE.Sustainability.Vertex.DisclosureManagement.API.SDK
```

---

## Troubleshooting Checklist

### Package Restore Fails

- [ ] Correct feed URL in NuGet.config
- [ ] NuGet.config in correct location (service/ folder)
- [ ] Authentication configured (if required)
- [ ] NuGet cache cleared
- [ ] Internet connection available
- [ ] No firewall/proxy blocking package feed

### Local Packages Not Found

- [ ] LocalPackages directory exists
- [ ] Package version matches reference
- [ ] Package actually exists in LocalPackages directory
- [ ] NuGet.config includes LocalPackages source
- [ ] Relative path to LocalPackages is correct
- [ ] Cache cleared after packaging

### Version Conflicts

- [ ] Check all .csproj files for version consistency
- [ ] Verify local version doesn't conflict with published version
- [ ] Clear bin/ and obj/ directories
- [ ] Run `dotnet restore --force-evaluate`

---

## Common Error Messages

### Error → Solution Mapping

| Error | Solution |
|-------|----------|
| `NU1301: Unable to load service index` | Check feed URL, check authentication |
| `404 (Not Found)` | Wrong feed URL (use GitHub Packages URL) |
| `401 (Unauthorized)` | Add authentication credentials |
| `Unable to find package` | Check package version, check source priority |
| `Package downgrade detected` | Update version in .csproj files |
| `Failed to restore` | Clear cache, check NuGet.config location |

---

## Related Documentation

- [DbUp Migrations Troubleshooting](./DBUP-MIGRATIONS.md) - Database migration issues
- [Diagnostic Scripts Guide](./DIAGNOSTIC-SCRIPTS.md) - Using diagnostic tools
- [Scripts README](../../scripts/README.md) - PowerShell automation scripts
- [Architecture Guide - Dependencies](../ARCHITECTURE_GUIDE.md#package-management) - Package management patterns

---

## Quick Fix Commands

```powershell
# Fix NuGet feed URL in BFF
cd DotNet_Angular/vertex-bff-disclosure-management/service
# Edit NuGet.config - change to: https://nuget.pkg.github.com/SE-Sustainability-Business/index.json

# Clear cache and restore
dotnet nuget locals all --clear
cd SE.Sustainability.Vertex.BFF.DisclosureManagement.API
dotnet restore

# Verify
dotnet list package
```

---

**Last Updated:** 2025-10-16  
**Related Ticket:** ESG-13441 - Manual Publish Workflow

