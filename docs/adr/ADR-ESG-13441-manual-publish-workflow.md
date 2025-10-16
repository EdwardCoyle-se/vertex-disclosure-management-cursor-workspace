### **Architecture Decision Record: Manual Publish Workflow**

**Title:** ADR-ESG-13441-Manual-Publish-Workflow

---

### **1. Status**

**Status:** Approved

**Date:** 2024-10-15

**Decision Makers:** Disclosure Management Product Team, Vertex Architecture Team

---

### **2. Context**

**2.1. Background**

The Disclosure Management platform currently implements an automatic publishing mechanism where reports transition from "Active" to "Published" status immediately upon completion of all required disclosure questions. This automatic behavior removes user control over the finalization process and does not align with typical document management workflows where users explicitly choose when to "lock" and finalize reports for submission.

User feedback and usability testing revealed that ESG professionals require explicit control over when reports become read-only and are considered finalized. This is particularly important given:
- The need to review complete reports before submission
- Collaboration workflows where multiple team members review before finalization
- Regulatory compliance requirements for explicit approval processes
- Risk of premature submission due to accidental completion

**2.2. Problem Statement**

Users lack control over when disclosure reports transition to published status, resulting in reports becoming read-only without explicit user action. This automatic behavior creates confusion about report lifecycle, prevents final review workflows, and misaligns with user expectations for document management systems where publication is a deliberate, user-initiated action.

**2.3. Constraints & Requirements**

- **Technical Constraints:**
  - Must maintain backward compatibility with existing published reports
  - Must integrate with existing three-tier Vertex architecture (UI → BFF → Core API)
  - Must support framework version validation to prevent publishing against outdated frameworks
  - Database schema changes must use DbUp migrations (NOT Entity Framework migrations)
  - Must enforce read-only state across all answer input components

- **Business Constraints:**
  - Must provide clear visual feedback on report completion status
  - Must prevent accidental publishing through confirmation dialogs
  - Must maintain audit trail of who published and when
  - Must support future "unpublish" functionality (separate implementation)
  - Must handle edge case where framework version updates between page load and publish action

- **Architectural Constraints:**
  - Must follow Clean Architecture with CQRS pattern using MediatR
  - All entities must inherit from vertex-dotnet-api-sdk base classes
  - All repositories must implement IEFRepository<TEntity>
  - Frontend must use vertex-ui-shared components or properly documented custom components
  - Must meet WCAG 2.1 AA accessibility standards

**2.4. Stakeholders**

- **Primary:**
  - ESG Managers (primary users of disclosure reporting functionality)
  - Sustainability Consultants (external users managing multiple client reports)
  - Corporate Sustainability Directors (oversight and review)
  - Disclosure Management Development Team

- **Secondary:**
  - Vertex Platform Architecture Team
  - QA/Testing Team
  - Product Management
  - End-user support teams

---

### **3. Decision**

**3.1. Decision Statement**

We will implement a manual publishing workflow that requires users to explicitly click a "Publish" button to transition reports from "Active" to "Published" status, replacing the automatic publishing behavior, with visual progress feedback, confirmation dialogs, and framework version validation.

**3.2. Solution Overview**

- **Technology Stack:**
  - Frontend: Angular 20+ with vertex-ui-shared components, custom `vx-dm-progress-button` component
  - BFF: .NET 8 Web API with Clean Architecture
  - Core API: .NET 8 with CQRS/MediatR pattern
  - Database: SQL Server with DbUp migrations
  - Dialog System: Existing `vx-dm-confirmation-dialog` component

- **Architecture Pattern:**
  - CQRS pattern with `PublishReportCommand` and `ValidateFrameworkVersionQuery`
  - Repository pattern using `IEFRepository<TEntity>`
  - Event-driven status transitions with audit logging
  - Optimistic UI updates with rollback on failure

- **Implementation Approach:**
  1. Database schema extension with publish-related fields
  2. Core API command/query handlers for publish and validation
  3. BFF orchestration layer for framework version checking
  4. Frontend progress button with visual completion feedback
  5. Confirmation dialog workflow with edge case handling
  6. Read-only mode enforcement across all input components

- **Integration Points:**
  - Integrates with existing Report entity and repository infrastructure
  - Leverages existing Framework versioning system for validation
  - Uses existing answer completion calculation logic (extended to track required vs optional)
  - Coordinates with future "unpublish" workflow (separate ticket)

**3.3. Technical Specifications**

- **Data Models:**

  **ReportEntity** (extends `NamedEntityBase` - reports have descriptive names):
  ```csharp
  public class ReportEntity : NamedEntityBase
  {
      // Existing fields...
      public string Status { get; set; } = string.Empty;  // Values: "active", "published"
      
      // NEW FIELDS:
      public DateTime? PublishedDate { get; set; }
      public string? PublishedByUserId { get; set; }
      public bool IsLocked { get; set; }
      
      // Inherited from NamedEntityBase: Id (ResourceId), Name, CreatedBy, CreatedDate, LastUpdatedBy, LastUpdatedDate
  }
  ```

- **Repository Pattern:**
  
  Repository implements `IEFRepository<ReportEntity>` from vertex-dotnet-api-sdk:
  ```csharp
  public interface IReportRepository : IEFRepository<ReportEntity>
  {
      Task<ReportEntity?> GetByIdAsync(string reportId);
      Task<bool> UpdateStatusAsync(string reportId, string status, string userId);
      // Additional domain-specific methods...
  }
  ```

- **Resource ID Strategy:**
  
  Maintains existing ResourceId format: `VARCHAR(54)` with pattern `dm_rpt_<guid>`
  - Example: `"dm_rpt_11a2b3c4d5e6f789012345678901ab"`
  - Application prefix: `dm` (disclosure-management)
  - Asset type: `rpt` (report)

- **API Design:**
  
  **New BFF Endpoints:**
  - `POST /api/reports/{reportId}/publish` - Publish report with version validation
  - `GET /api/reports/{reportId}/framework-version` - Check framework version status
  
  **New Core API Commands/Queries:**
  - `PublishReportCommand` - Execute publish operation with audit fields
  - `ValidateFrameworkVersionQuery` - Validate framework version for report's period
  
  **API Versioning:** Uses date-based versioning (e.g., "2025-07-17")

- **Database Changes:**
  
  **Migration Script:** `DBMigrations/20251015/001-AddPublishFields.sql`
  ```sql
  ALTER TABLE Reports
  ADD PublishedDate DATETIME2 NULL,
      PublishedByUserId VARCHAR(54) NULL,
      IsLocked BIT NOT NULL DEFAULT 0;
  
  CREATE INDEX IX_Reports_PublishedDate ON Reports(PublishedDate) WHERE PublishedDate IS NOT NULL;
  
  -- Backfill existing published reports
  UPDATE Reports 
  SET IsLocked = 1 
  WHERE Status = 'published';
  ```

- **Security Considerations:**
  - OAuth2/OIDC authentication via vertex-dotnet-api-sdk
  - Role-based authorization: users must have "CanPublishReports" permission
  - Organizational boundary enforcement: users can only publish reports in their organization
  - Audit logging of publish actions with user ID and timestamp
  - Read-only enforcement at both API and UI layers (defense in depth)

---

### **4. Reasoning**

**4.1. Evaluation Criteria**

- **Usability:** User control over report finalization is critical for confidence and workflow alignment
- **Compliance:** Explicit publish action creates clear audit trail for regulatory requirements
- **Risk Mitigation:** Confirmation dialogs and framework version checks prevent accidental or invalid publishing
- **Maintainability:** Leverage existing CQRS patterns and component infrastructure for consistency
- **Performance:** Minimal performance impact (single command operation with database index support)
- **Alignment:** Follows Vertex architecture standards (Clean Architecture, CQRS, vertex-dotnet-api-sdk)

**4.2. Key Decision Factors**

1. **User Control:** Feedback from ESG professionals indicated strong preference for explicit publish action rather than automatic behavior
2. **Review Workflows:** Many organizations require review cycles before finalization, which automatic publishing prevented
3. **Framework Versioning:** Need to handle edge case where framework updates between page load and publish action
4. **Audit Requirements:** Regulatory compliance requires explicit record of who published and when
5. **Future Extensibility:** Manual publish enables future "unpublish" workflow and approval processes

**4.3. Trade-offs Accepted**

- **Additional User Action Required:** Users must now explicitly click "Publish" rather than automatic transition (ACCEPTABLE - desired behavior)
- **Framework Version Check Overhead:** Small performance cost for version validation on publish (ACCEPTABLE - critical for data integrity)
- **UI Complexity:** Progress button with visual feedback adds component complexity (ACCEPTABLE - improves UX significantly)
- **Migration Complexity:** Must backfill existing published reports with IsLocked flag (ACCEPTABLE - one-time migration cost)

---

### **5. Alternatives Considered**

**5.1. Alternative 1: Auto-Publish with Undo Feature**

- **Description:** Keep automatic publishing on completion but add "Undo Publish" functionality immediately after
- **Pros:** 
  - Minimal user action required in happy path
  - Simpler initial implementation (no publish button needed)
- **Cons:** 
  - Still lacks explicit user control over finalization
  - Creates confusion about report state transitions
  - Undo workflow is more complex than preventing incorrect publish
  - Does not align with user mental model of document finalization
- **Rejection Reason:** Does not solve core problem of lack of user control; users expect explicit publish action similar to other document management systems

**5.2. Alternative 2: Auto-Publish with Confirmation Dialog**

- **Description:** Automatically trigger publish when complete, but show confirmation dialog
- **Pros:**
  - Provides user confirmation before finalization
  - Less UI complexity (no persistent publish button)
- **Cons:**
  - Interrupts user workflow with unexpected dialog
  - Dialog appears at potentially inconvenient time (immediately after last question)
  - User may not be ready to review/finalize at moment of completion
  - No visual indicator of progress toward publishable state
- **Rejection Reason:** Creates interruption-based UX rather than user-initiated action; does not support review workflows where users complete answers then review before publishing

**5.3. Alternative 3: Status-Based Workflow (Draft → Complete → Published)**

- **Description:** Implement three-status workflow where "Complete" is intermediate state before "Published"
- **Pros:**
  - More granular state tracking
  - Clearer separation between completion and publication
- **Cons:**
  - Adds complexity to status management
  - Requires UI changes to support three states
  - "Complete" status semantic meaning unclear to users
  - Does not provide significant benefit over Active/Published binary
- **Rejection Reason:** Unnecessary complexity; two-status workflow (Active/Published) with manual publish achieves same goal with simpler implementation

---

### **6. Consequences**

**6.1. Positive Consequences**

- **Technical Benefits:**
  - Clear audit trail with PublishedDate and PublishedByUserId fields
  - Framework version validation prevents data integrity issues
  - Read-only enforcement through IsLocked flag provides reliable state management
  - Reusable `vx-dm-progress-button` component for future progress-based actions
  - Clean separation of concerns between completion tracking and publication

- **Business Benefits:**
  - Users have explicit control over report finalization timing
  - Supports review workflows before submission
  - Reduces risk of accidental premature publication
  - Aligns with user expectations from other document management systems
  - Provides clear visual feedback on progress toward completion
  - Enables future approval workflows and unpublish functionality

- **Team Benefits:**
  - Consistent with Vertex architectural patterns (easy to maintain)
  - Well-documented completion percentage calculation for future adjustments
  - Reusable component pattern for other progress-based features
  - Clear CQRS command for publish operation (testable, maintainable)

**6.2. Negative Consequences**

- **Technical Debt:**
  - Completion percentage calculation now needs to distinguish required vs optional questions (added complexity)
  - Framework version matching logic requires ongoing maintenance as framework versioning evolves
  - Read-only enforcement must be maintained across all future answer input components

- **Operational Overhead:**
  - Migration script must backfill existing published reports with IsLocked flag
  - Support team must understand new publish workflow for user assistance
  - Additional monitoring needed for framework version mismatch scenarios

- **Learning Curve:**
  - Users must adjust to new explicit publish action (though aligns with existing mental models)
  - Documentation must be updated to reflect new workflow
  - Training materials needed for existing users

**6.3. Risk Mitigation**

- **Risk:** Users confused by new publish button
  - **Mitigation:** Clear progress percentage display, confirmation dialog with explanation, in-app guidance
  
- **Risk:** Framework version mismatch causes user frustration
  - **Mitigation:** Clear messaging in mismatch dialog, automatic framework update, preserve all answers
  
- **Risk:** Performance impact from framework version checks
  - **Mitigation:** Database indexing on framework version fields, caching of framework metadata
  
- **Risk:** Read-only enforcement missed in some UI components
  - **Mitigation:** Comprehensive testing checklist, centralized read-only state service, code review focus area

---

### **7. Implementation Plan**

**7.1. Implementation Phases**

- **Phase 1: Database & Core API (Week 1)**
  - Create DbUp migration script for new fields
  - Update ReportEntity with publish-related properties
  - Implement PublishReportCommand and handler
  - Implement ValidateFrameworkVersionQuery and handler
  - Update repository interfaces and implementations
  - Write unit tests for command/query handlers

- **Phase 2: BFF Service (Week 1)**
  - Add publish endpoint to ReportsController
  - Implement framework version validation orchestration
  - Add error handling and response mapping
  - Write integration tests for publish endpoint

- **Phase 3: Frontend Core Components (Week 2)**
  - Create vx-dm-progress-button component with visual progress bar
  - Update report completion calculation to distinguish required vs optional
  - Document completion calculation logic
  - Add translation keys for publish workflow
  - Create component Storybook stories

- **Phase 4: Frontend Integration (Week 2)**
  - Integrate publish button into workspace component
  - Implement confirmation dialog workflow
  - Implement framework mismatch dialog workflow
  - Add read-only mode enforcement across answer inputs
  - Add optional questions indicator with accessibility support

- **Phase 5: Testing & Documentation (Week 3)**
  - Comprehensive E2E testing of publish workflow
  - Accessibility testing with axe DevTools
  - Framework version mismatch scenario testing
  - Update progress tracking documents
  - Update user documentation
  - Code review and QA validation

**7.2. Dependencies**

- **Technical Dependencies:**
  - Existing completion percentage calculation logic (extend to support required/optional distinction)
  - Framework versioning system for validation queries
  - vx-dm-confirmation-dialog component (already exists)
  - Report answer repositories (for read-only enforcement)

- **Team Dependencies:**
  - Product team approval of progress button visual design
  - QA team for comprehensive workflow testing
  - Documentation team for user-facing materials

- **External Dependencies:**
  - None (all implementation internal to Disclosure Management platform)

**7.3. Success Criteria**

- **Technical Metrics:**
  - Publish operation completes in <500ms (95th percentile)
  - Framework version validation adds <100ms overhead
  - Zero errors in read-only enforcement (all inputs properly disabled)
  - 100% unit test coverage for PublishReportCommand handler
  - All accessibility tests pass (WCAG 2.1 AA)

- **Business Metrics:**
  - User task completion time for publish workflow <30 seconds
  - Zero incidents of accidental publishing in first month
  - User satisfaction score >4.5/5 for publish workflow
  - Support ticket volume for publish-related questions <5/month

**7.4. Rollback Plan**

If critical issues arise during implementation:

1. **Database Rollback:**
   - Create reverse migration script to drop new columns
   - Existing reports remain functional (new fields nullable)

2. **API Rollback:**
   - Feature flag to disable manual publish endpoints
   - Fall back to completion-based status logic (temporary)

3. **Frontend Rollback:**
   - Hide publish button via configuration
   - Remove read-only enforcement temporarily

4. **Communication:**
   - Notify users of temporary reversion
   - Provide timeline for fix and re-deployment

---

### **8. Monitoring & Review**

**8.1. Monitoring Strategy**

- **Key Metrics:**
  - Publish operation success rate (target: >99.5%)
  - Framework version mismatch rate (track for framework update coordination)
  - Average time between completion and publish (understand user behavior)
  - Read-only enforcement error rate (target: 0%)
  - Publish confirmation dialog abandonment rate (understand user hesitation)

- **Monitoring Tools:**
  - Azure Application Insights for API performance and error tracking
  - Frontend analytics for button interaction and dialog workflow
  - Database query performance monitoring for publish operations
  - Custom dashboard for publish workflow metrics

- **Alert Thresholds:**
  - Alert if publish success rate <98%
  - Alert if framework version validation failures >10/hour
  - Alert if read-only bypass attempts detected
  - Alert if publish operation p95 latency >1000ms

**8.2. Review Schedule**

- **Short-term Review:** 1 month post-deployment
  - Review user adoption and workflow metrics
  - Assess support ticket volume and common issues
  - Evaluate framework version mismatch frequency
  - Gather user feedback through surveys

- **Long-term Review:** Quarterly
  - Review completion percentage calculation effectiveness
  - Assess need for additional workflow states
  - Evaluate performance metrics and optimization opportunities
  - Consider promotion of vx-dm-progress-button to vertex-ui-shared

- **Trigger Events for Early Review:**
  - Framework versioning system changes
  - Major increase in support tickets related to publish workflow
  - Performance degradation in publish operations
  - User feedback indicating confusion or workflow issues
  - Implementation of "unpublish" feature (dependent functionality)

---

### **9. References**

**9.1. Related Documentation**

- **PRD:** `ProductDesign/DisclosureManagement_PRD.md` - Product requirements and user personas
- **TDD:** `ProductDesign/DisclosureManagement_TDD.md` - Technical design specifications
- **Coding Standards:** `docs/CODING_STANDARDS.md` - Vertex coding conventions and patterns
- **Architecture Guide:** `docs/ARCHITECTURE_GUIDE.md` - System architecture patterns
- **Critical Rules:** `docs/CRITICAL_RULES.md` - Mandatory development rules
- **Custom Components:** `docs/CUSTOM_COMPONENTS.md` - Custom component tracking

**9.2. External References**

- **vertex-dotnet-api-sdk:** Entity base classes (NamedEntityBase, IEFRepository)
- **vertex-ui-shared:** Component library and design system
- **DbUp Documentation:** Database migration framework
- **MediatR Documentation:** CQRS implementation library
- **WCAG 2.1 AA Standards:** Web accessibility guidelines

**9.3. Related ADRs**

- **Supersedes:** None (new functionality)
- **Related:** 
  - `ADR-0001-domain-bounded-contexts.md` - Domain model design
  - `ADR-0002-data-model-strategy.md` - Entity and repository patterns
  - `ADR-0003-api-design-patterns.md` - API endpoint conventions
- **Dependencies:** None

**9.4. JIRA & Project Links**

- **Epic:** ESG-13441 - Manual Publish Workflow
- **User Stories:** 
  - ESG-13441 - Manual publish button implementation
  - [Future] ESG-XXXX - Unpublish functionality (separate ticket)
  - [Future] ESG-XXXX - Appendix for deprecated framework questions (Sprint 14)
- **Technical Tasks:** To be created during sprint planning

---

### **10. Appendices**

**10.1. Architecture Diagrams**

```
USER WORKFLOW:
┌─────────────────────────────────────────────────────────────────────┐
│ 1. User answers questions in Active report                         │
│ 2. Completion percentage updates in real-time                      │
│ 3. User clicks "Publish (95% Complete)" button                     │
│ 4. Confirmation dialog: "Publishing will lock all questions..."    │
│ 5. User clicks "OK"                                                 │
│ 6. System checks framework version                                 │
│    ├─ Match: Report published, status → "published"                │
│    └─ Mismatch: Show mismatch dialog, apply new framework          │
│ 7. Report becomes read-only (IsLocked = true)                      │
│ 8. Button changes to "Unpublish" (future ticket)                   │
└─────────────────────────────────────────────────────────────────────┘

SYSTEM ARCHITECTURE:
┌──────────────────────────────────────────────────────────────────────┐
│  Angular Frontend (vertex-disclosure-management-ui)                 │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ Reports Workspace Component                                    │ │
│  │ ├─ vx-dm-progress-button (new custom component)               │ │
│  │ ├─ vx-dm-confirmation-dialog (existing)                       │ │
│  │ └─ Answer input components (read-only enforcement)            │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                              │                                       │
│                              ▼                                       │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ Report Service                                                 │ │
│  │ └─ publishReport(reportId, frameworkVersion)                  │ │
│  └────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────┐
│  BFF API (vertex-bff-disclosure-management)                          │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ ReportsController                                              │ │
│  │ POST /api/reports/{id}/publish                                 │ │
│  │ ├─ Validate framework version via Core API                    │ │
│  │ ├─ If mismatch: Return mismatch response                      │ │
│  │ └─ If match: Call Core API publish endpoint                   │ │
│  └────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────┐
│  Core API (vertex-disclosure-management-api)                         │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ CQRS Handlers                                                  │ │
│  │ ├─ PublishReportCommand                                       │ │
│  │ │  └─ Update Status, PublishedDate, PublishedByUserId,       │ │
│  │ │     IsLocked                                                │ │
│  │ └─ ValidateFrameworkVersionQuery                              │ │
│  │    └─ Check report's framework vs latest for period          │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                              │                                       │
│                              ▼                                       │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ ReportRepository (IEFRepository<ReportEntity>)                │ │
│  └────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
                      ┌────────────────┐
                      │  SQL Server    │
                      │  Reports Table │
                      └────────────────┘
```

**10.2. Code Examples**

**vx-dm-progress-button Component Usage:**
```typescript
<vx-dm-progress-button
  [progress]="reportCompletionPercentage"
  [disabled]="isPublishing || report.status === 'published'"
  [loading]="isPublishing"
  (clicked)="onPublishClick()">
</vx-dm-progress-button>
```

**Completion Percentage Calculation (Documented):**
```typescript
/**
 * Calculates report completion percentage based on REQUIRED questions only.
 * 
 * Business Logic:
 * - Only counts questions marked as IsRequired = true
 * - A question is "answered" when all its required fields are filled
 * - Optional fields on a question do not affect completion status
 * 
 * @param reportId - The report ID to calculate completion for
 * @returns Percentage (0-100) of required questions answered
 * 
 * @example
 * // Report with 10 required questions, 7 answered, 3 unanswered
 * calculateCompletionPercentage(reportId) // Returns 70
 * 
 * // Report with 8 required questions (all answered) + 5 optional questions (2 answered)
 * calculateCompletionPercentage(reportId) // Returns 100 (optional questions don't affect %)
 */
calculateCompletionPercentage(reportId: string): number {
  // Implementation details...
}
```

**PublishReportCommand:**
```csharp
public record PublishReportCommand : IRequest<ServiceResponse<Report>>
{
    public string ReportId { get; init; } = string.Empty;
    public string UserId { get; init; } = string.Empty;
    public string CurrentFrameworkVersion { get; init; } = string.Empty;
}

public class PublishReportHandler : IRequestHandler<PublishReportCommand, ServiceResponse<Report>>
{
    private readonly IReportRepository _reportRepository;
    private readonly IMediator _mediator;
    
    public async Task<ServiceResponse<Report>> Handle(
        PublishReportCommand request, 
        CancellationToken cancellationToken)
    {
        // Validate report exists and is in "active" status
        var report = await _reportRepository.GetByIdAsync(request.ReportId);
        if (report == null) return ServiceResponse<Report>.NotFound();
        if (report.Status != "active") return ServiceResponse<Report>.BadRequest("Report must be in active status");
        
        // Validate framework version
        var versionCheck = await _mediator.Send(new ValidateFrameworkVersionQuery 
        { 
            ReportId = request.ReportId, 
            CurrentVersion = request.CurrentFrameworkVersion 
        });
        
        if (!versionCheck.IsValid) 
            return ServiceResponse<Report>.BadRequest("Framework version mismatch");
        
        // Update report to published status
        report.Status = "published";
        report.PublishedDate = DateTime.UtcNow;
        report.PublishedByUserId = request.UserId;
        report.IsLocked = true;
        
        await _reportRepository.UpdateAsync(report);
        
        return ServiceResponse<Report>.Success(report);
    }
}
```

**10.3. Performance Analysis**

Expected performance characteristics:
- **Publish Operation:** <500ms (95th percentile)
  - Framework version validation: ~50ms (cached framework metadata)
  - Database update: ~100ms (single UPDATE with index support)
  - Response serialization: ~50ms
  - Network overhead: ~100ms (typical)

- **Completion Percentage Calculation:** <100ms
  - Query required questions: ~30ms (indexed on IsRequired)
  - Query answered questions: ~40ms (indexed on ReportId)
  - Calculation logic: <10ms
  - Cached for 30 seconds per report to reduce load

**10.4. Security Analysis**

**Threat Model:**
1. **Unauthorized Publishing:** Mitigated by role-based authorization and organizational boundary checks
2. **Bypassing Read-Only Enforcement:** Mitigated by IsLocked checks in both API and UI layers
3. **Framework Version Manipulation:** Mitigated by server-side validation (client cannot override)
4. **Concurrent Publishing Attempts:** Mitigated by database transaction isolation and optimistic concurrency

**Security Controls:**
- Authentication: OAuth2/OIDC tokens required for all API calls
- Authorization: "CanPublishReports" permission check
- Input Validation: FluentValidation on all command inputs
- Audit Logging: PublishedDate and PublishedByUserId recorded for compliance
- Defense in Depth: Read-only enforcement at both API and UI layers

---

### **ADR Checklist**

- [x] Title follows naming convention (ESG-13441 JIRA ticket format)
- [x] Status is clearly indicated with date and decision makers
- [x] Context provides sufficient background for understanding the decision
- [x] Decision is clearly stated with technical specifications
- [x] Reasoning explains why this decision was made
- [x] At least 2-3 alternatives were considered and documented
- [x] Consequences (both positive and negative) are identified
- [x] Implementation plan includes phases and dependencies
- [x] Monitoring and review strategy is defined
- [x] All relevant references and links are included
- [x] ADR has been reviewed by relevant stakeholders
- [x] ADR aligns with Vertex architecture standards and patterns

