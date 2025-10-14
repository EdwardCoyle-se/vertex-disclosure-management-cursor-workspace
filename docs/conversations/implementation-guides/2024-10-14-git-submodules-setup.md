# Git Submodules Setup for Vertex Projects

**Date**: October 14, 2024  
**Context**: Setting up Git submodules for Vertex template projects in DotNet_Angular folder  
**Status**: ✅ Completed

## Problem Statement

Needed to properly configure Git submodules for all Vertex projects in the DotNet_Angular folder to:
- Maintain independent development of each project
- Provide a unified template repository structure
- Enable easy replication across development machines

## Solution Overview

Configure each Vertex project as a Git submodule within the main template repository structure.

## Implementation Steps

### 1. Existing Submodules Identified
Already configured in `.gitmodules`:
- `vertex-dotnet-api-sdk`
- `vertex-ui-shared`
- `vertex-ui-template`

### 2. Additional Projects to Add
- `vertex-ui-disclosure-management`
- `vertex-disclosure-management-api`
- `vertex-bff-disclosure-management`
- `vertex-ui-measure`

### 3. Commands Used

```bash
# Navigate to main repository
cd C:\Dev\dm

# Add new submodules
git submodule add https://github.com/SE-Sustainability-Business/vertex-ui-disclosure-management.git DotNet_Angular/vertex-ui-disclosure-management
git submodule add https://github.com/SE-Sustainability-Business/vertex-disclosure-management-api.git DotNet_Angular/vertex-disclosure-management-api
git submodule add https://github.com/SE-Sustainability-Business/vertex-bff-disclosure-management.git DotNet_Angular/vertex-bff-disclosure-management
git submodule add https://github.com/SE-Sustainability-Business/vertex-ui-measure.git DotNet_Angular/vertex-ui-measure

# Commit submodule additions
git add .gitmodules
git add DotNet_Angular/vertex-ui-disclosure-management
git add DotNet_Angular/vertex-disclosure-management-api
git add DotNet_Angular/vertex-bff-disclosure-management
git add DotNet_Angular/vertex-ui-measure
git commit -m "Add remaining Vertex projects as submodules"
git push origin main
```

### 4. Replication on New Machines

```bash
# Clone with all submodules
git clone --recurse-submodules https://github.com/your-org/vertex-cursor-templates.git dm

# Or if already cloned
git submodule update --init --recursive
```

## Key Commands Reference

```bash
# Check submodule status
git submodule status

# Update all submodules to latest
git submodule update --remote

# Update specific submodule
git submodule update DotNet_Angular/vertex-ui-shared

# Working within a submodule
cd DotNet_Angular/vertex-ui-disclosure-management
git add .
git commit -m "Update features"
git push origin main
cd ../..
git add DotNet_Angular/vertex-ui-disclosure-management
git commit -m "Update submodule reference"
```

## Best Practices Established

1. **Consistent Structure**: All Vertex projects in DotNet_Angular/ as submodules
2. **Version Pinning**: Main repo tracks specific commits for reproducible builds
3. **Documentation**: Include submodule setup in README
4. **CI/CD**: Use `--recurse-submodules` in build scripts

## Follow-up Actions

- [ ] Update main README.md with submodule setup instructions
- [ ] Document submodule workflow in PROJECT_CREATION_GUIDE.md
- [ ] Add submodule commands to development scripts/Makefile

## Related Documentation

- [Git Submodules Official Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- `docs/PROJECT_CREATION_GUIDE.md` - Update with submodule workflow
- `.gitmodules` - Configuration file for all submodules
