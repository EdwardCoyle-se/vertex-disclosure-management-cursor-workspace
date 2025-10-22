# Fix for Automatic Publishing Issue (ESG-13441)

## Problem
Newly generated reports were automatically transitioning from `ACTIVE` to `PUBLISHED` status when they reached 100% completion, bypassing the manual publish workflow.

## Root Cause
The `ReportStatusService.GetNextStatus()` extension method contained logic that automatically transitioned reports from `ACTIVE` to `PUBLISHED` when `isComplete` was `true`:

```csharp
ReportStatus.ACTIVE => isComplete ? ReportStatus.PUBLISHED : ReportStatus.ACTIVE,
```

This method was being called by two handlers after every answer save:
1. `BulkUpsertReportAnswersHandler.cs` (line 113-114)
2. `UpdateReportAnswerHandler.cs` (line 56-57)

## Solution
Modified `GetNextStatus()` in `ReportStatus.cs` to prevent automatic status transitions:

```csharp
ReportStatus.ACTIVE => ReportStatus.ACTIVE, // Never auto-transition to PUBLISHED
```

### Key Changes
- **File**: `SE.Sustainability.Vertex.DisclosureManagement.API.Models/Enums/ReportStatus.cs`
- **Method**: `GetNextStatus()`
- **Change**: Removed conditional logic that auto-published complete reports
- **Impact**: Reports now remain in `ACTIVE` status regardless of completion percentage until explicitly published via the manual publish button

## Behavior After Fix
1. ✅ Reports stay in `ACTIVE` status when reaching 100% completion
2. ✅ Only the explicit "Publish" button action transitions reports to `PUBLISHED` status
3. ✅ The status update calls in answer handlers are now no-ops (harmless, just maintain ACTIVE status)
4. ✅ Published reports cannot transition back to other statuses (unchanged)

## Testing Checklist
- [ ] Generate a new report from a standard framework
- [ ] Answer all mandatory questions to reach 100% completion
- [ ] Verify report remains in `ACTIVE` status (not auto-published)
- [ ] Click the "Publish" button
- [ ] Verify report transitions to `PUBLISHED` status successfully
- [ ] Verify "Publish" button shows correct state (locked/published)
- [ ] Repeat test with custom questionnaire

## Related Files
- Core API: `ReportStatus.cs` (modified)
- Core API: `BulkUpsertReportAnswersHandler.cs` (no changes needed - calls now no-op)
- Core API: `UpdateReportAnswerHandler.cs` (no changes needed - calls now no-op)
- Core API: `ReportStatusService.cs` (no changes needed)
- BFF: `PublishReportCommandHandler.cs` (already correct - handles explicit publish)
- UI: `reports.component.ts` (already correct - calls BFF publish endpoint)

## Notes
- The status update calls in answer handlers were left in place as they're harmless no-ops
- If needed in the future, these calls could be removed for minor performance optimization
- The fix ensures the manual publish workflow (ADR-ESG-13441) works as designed

