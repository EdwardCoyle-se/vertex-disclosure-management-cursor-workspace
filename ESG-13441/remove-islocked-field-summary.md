# Remove IsLocked Field - Architectural Improvement

**Date**: 2025-10-17  
**Ticket**: ESG-13441  
**Type**: Architectural Refactoring

## Problem

The `IsLocked` field in the `Reports` table created data redundancy and potential for inconsistency:

```typescript
// Frontend was checking BOTH
isReportLocked(): boolean {
  return report?.isLocked === true || report?.status === 'published';
  //     ^^^^^^^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  //     Two sources of truth for the same concept!
}
```

**Issues:**
- ✅ Two sources of truth (IsLocked and Status)
- ✅ Risk of `Status = 'published'` but `IsLocked = false` (data mismatch)
- ✅ Extra database column and storage overhead
- ✅ Extra field to maintain in migrations
- ✅ Confusion about which field is authoritative

## Solution

**Derive locked state from Status field:**
- `Status == 'published'` → **locked** (cannot be edited)
- `Status == 'active'` → **unlocked** (can be edited)
- Future statuses (`'archived'`, `'withdrawn'`) → **locked**

## Changes Made

### 1. Database Migration

**New Migration**: `20251017/001-RemoveIsLocked.sql`
- Turns off system versioning for temporal table
- Drops `IsLocked` column from `Reports` table
- Drops `IsLocked` column from `Reports_History` table
- Turns system versioning back on
- Verifies migration with status summary

### 2. Core API Changes (6 files)

#### Entity Layer
**`ReportEntity.cs`**:
- Removed `IsLocked` property
- Removed `IsLocked` column configuration

#### API Model
**`Report.cs`**:
- Removed `IsLocked` property

#### Handler
**`PublishReportHandler.cs`**:
```csharp
// BEFORE:
if (report.IsLocked)
{
    return new PublishReportResponse { Success = false, ErrorMessage = "Report is already locked" };
}
entity.IsLocked = true;

// AFTER:
if (string.Equals(report.Status, DisclosureManagementConstants.REPORT_STATUS_PUBLISHED, StringComparison.OrdinalIgnoreCase))
{
    return new PublishReportResponse { Success = false, ErrorMessage = "Report is already published" };
}
// Locked state is implicit from Status - no assignment needed
```

#### Tests
**`PublishReportHandlerTests.cs`**: 28 changes
- Removed all `IsLocked = false` and `IsLocked = true` from test data
- Changed assertion from `IsLocked` to `Status`:
  ```csharp
  // BEFORE:
  Assert.That(result.Report!.IsLocked, Is.True);
  
  // AFTER:
  Assert.That(result.Report!.Status, Is.EqualTo("published"));
  ```

**`ReportsControllerTests.cs`**: 1 change
- Removed `IsLocked = true` from test data

### 3. BFF Changes (1 file)

**`PublishReportCommandHandlerTests.cs`**: 1 change
- Removed `IsLocked = true` from test data

### 4. Frontend Changes (2 files)

#### Service Interface
**`bff.service.ts`**:
```typescript
// REMOVED:
isLocked?: boolean;
```

#### Component Logic
**`reports.component.ts`**:
```typescript
// BEFORE:
isReportLocked(): boolean {
  return report?.isLocked === true || report?.status === 'published';
}

isPublished(): boolean {
  const statusIsPublished = report?.status?.toLowerCase() === 'published';
  return statusIsPublished && report?.isLocked === true;
}

// AFTER:
isReportLocked(): boolean {
  // Any status other than 'active' means locked
  return report?.status?.toLowerCase() !== 'active';
}

isPublished(): boolean {
  // Status is the single source of truth
  return report?.status?.toLowerCase() === 'published';
}
```

## Benefits

| Benefit | Impact |
|---------|--------|
| **Single Source of Truth** | Status field is now authoritative |
| **No Data Mismatch Risk** | Impossible for `IsLocked`/`Status` inconsistency |
| **Simpler Data Model** | One less column in database |
| **Clearer Semantics** | "Published" inherently means "locked" |
| **Future-Proof** | Easy to add new locked statuses (`archived`, `withdrawn`) |
| **Less Code** | Fewer fields to maintain and test |

## Files Affected

**Core API (6 files)**:
- `DBMigrations/20251017/001-RemoveIsLocked.sql` (new)
- `ReportEntity.cs`
- `Report.cs`
- `PublishReportHandler.cs`
- `PublishReportHandlerTests.cs`
- `ReportsControllerTests.cs`

**BFF (1 file)**:
- `PublishReportCommandHandlerTests.cs`

**Frontend (2 files)**:
- `bff.service.ts`
- `reports.component.ts`

## Testing

✅ **Build Status**: Successful (0 errors, 12 warnings)  
✅ **Compilation**: All references to `IsLocked` removed  
✅ **Test Updates**: 30 test data instances updated

## Next Steps

1. Run database migration: `./scripts/run-core-api-migrations.ps1`
2. Run full Core API test suite
3. Run BFF test suite
4. Manual testing of publish workflow
5. Verify no regressions in existing published reports

## Migration Timing

⚠️ **Important**: This migration must be applied when there are no in-flight publish operations, as it removes a column from the Reports table.

## Backward Compatibility

✅ **Safe**: Removing a field does not break existing published reports. The `Status` field already contains the authoritative state, so no data is lost.

