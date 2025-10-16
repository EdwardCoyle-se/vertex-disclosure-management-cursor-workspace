# Disclosure Management Core API Progress

> **Purpose**: Track implementation progress for the vertex-disclosure-management-api service.

## 📊 Project Overview
- **Domain**: disclosure-management
- **Service**: vertex-disclosure-management-api
- **Type**: Core CRUD API with Clean Architecture
- **Dependencies**: SQL Server Database, Framework Library API, Indicator Management API
- **Started**: 2025-01-10
- **Current Status**: Substantially complete (~80% based on main progress.md), core functionality operational
- **Target Completion**: 2025-02-28

## 🎯 Implementation Status

### Phase 1: Project Setup & Structure
- [x] ✅ Copy vertex-api-template to vertex-disclosure-management-api
- [x] ✅ Replace all Template placeholders with DisclosureManagement names
- [x] ✅ Update namespaces (SE.Sustainability.Vertex.DisclosureManagement.*)
- [x] ✅ Update project references and solution file
- [x] ✅ Configure appsettings for database connection
- [x] ✅ Set up DbUp migration infrastructure

### Phase 2: Data Models & Database
- [x] ✅ Create Report entity with NamedEntityBase inheritance
- [x] ✅ Create ReportAnswer entity with audit tracking
- [x] ✅ Create ReportWorkflowAssignment entity for collaboration
- [ ] 🚧 Create Framework reference entities for local caching
- [x] ✅ Create DataType and status enums
- [x] ✅ Create API models for Report, ReportAnswer, FrameworkQuestion
- [x] ✅ Create entity configurations for EF Core with ResourceId format
- [x] ✅ Write initial database migration scripts for report entities
- [x] ✅ Create and test database schema with sample data
- [x] ✅ Create mapper classes (Entity ↔ Model) for report types

### Phase 3: Core CRUD Operations  
- [x] ✅ Implement GetReportQuery and Handler with answer loading
- [x] ✅ Implement ListReportsQuery and Handler with organizational filtering
- [x] ✅ Implement CreateReportCommand and Handler with validation
- [x] ✅ Implement UpdateReportCommand and Handler
- [ ] 🚧 Implement DeleteReportCommand and Handler with cascade rules
- [x] ✅ Implement SaveAnswerCommand and Handler with audit tracking
- [x] ✅ Implement GetFrameworkQuestionsQuery for report workspace
- [x] ✅ Add FluentValidation for all commands/queries

### Phase 4: API Controllers
- [x] ✅ Create ReportsController with CRUD endpoints
- [x] ✅ Create AnswersController for answer management operations  
- [x] ✅ Add framework integration endpoints for question hierarchy
- [x] ✅ Add proper HTTP status codes (200, 201, 404, 400, 409)
- [x] ✅ Add comprehensive API documentation with XML comments
- [x] ✅ Add proper error handling with correlation IDs
- [x] ✅ Add structured logging throughout controllers
- [x] ✅ Test all endpoints with Swagger UI

### Phase 5: Business Logic & Advanced Features
- [x] ✅ Implement report business logic with organizational data isolation
- [x] ✅ Add JWT claims filtering for multi-tenant security
- [x] ✅ Implement answer audit tracking and data lineage
- [x] ✅ Add comprehensive validation rules for report and answer data
- [x] ✅ Implement search and filtering capabilities across reports
- [x] ✅ Add structured logging for all report and answer operations
- [ ] 🚧 Add framework comparison capabilities between versions
- [ ] 🚧 Implement CSV export functionality for reports
- [ ] 🚧 Add caching for frequently accessed framework metadata

### Phase 6: Testing & Quality
- [x] ✅ Write unit tests for core handlers and validators (basic coverage)
- [x] ✅ Write integration tests for API endpoints with test database
- [x] ✅ Add tests for organizational data isolation and JWT handling
- [x] ✅ Add health checks for database and external dependencies
- [x] ✅ Basic security review for JWT handling and data access completed
- [ ] 🚧 Expand test coverage for edge cases and error scenarios
- [ ] 🚧 Performance testing with large report datasets (1000+ questions)
- [ ] 🚧 Load testing for concurrent user scenarios
- [ ] 🚧 Add tests for advanced export and integration workflows

### Phase 7: Document Management Architecture Cleanup (NEW) 
- [ ] 📋 **Remove ReportDocument Infrastructure** - Delete entities, repositories, handlers, and controllers (no longer needed)
- [ ] 📋 **Update QuestionDocuments Schema** - Remove Report_Document_Id FK, add direct Atlas_Document_Id field
- [ ] 📋 **Database Migration** - Drop Report_Documents table, modify Question_Documents structure
- [ ] 📋 **Update AI Integration** - Modify AI answer handlers to use Atlas document IDs directly
- [ ] 📋 **Cleanup DTOs and Models** - Remove ReportDocument-related request/response classes
- [ ] 📋 **Add QuestionDocument Cleanup Logic** - Handle orphaned records when Atlas documents are deleted

### Phase 8: Deployment & Documentation
- [ ] 📋 Configure Azure DevOps CI/CD pipeline
- [ ] 📋 Set up environment-specific configurations (dev, staging, prod)
- [ ] 📋 Configure Application Insights for monitoring and logging
- [ ] 📋 Update OpenAPI/Swagger documentation
- [ ] 📋 Create deployment runbook with rollback procedures
- [ ] 📋 Conduct final testing in staging environment
- [ ] 📋 Create API usage documentation for BFF service integration

## 📝 Implementation Notes

### Key Decisions
- **Database Schema**: Using stable identifiers (Framework.Id, DisclosureId) with separate versioned entities for temporal data
- **Hierarchy Management**: Adjacency list pattern on DisclosureNodeVersion with ParentDisclosureId for N-level nesting
- **Organizational Isolation**: Framework-level tenancy via OrganizationId with query filters from JWT claims
- **Versioning Strategy**: Monotonic VersionOrder with revision support (IsPublished flag for draft/published workflow)
- **Data Types**: Normalized categories (Narrative, Quantitative, etc.) with raw source type preservation
- **Document Storage Architecture (NEW)**: **Eliminated Local Document Storage** - BFF now manages VertexAtlas.Data integration directly, Core API only maintains AI question-document relationships via QuestionDocuments table

### Challenges & Solutions
- **Challenge**: Complex hierarchy queries with performance concerns
  - **Solution**: Implement recursive CTEs for hierarchy loading with caching for frequently accessed trees
- **Challenge**: CSV import with large datasets and validation
  - **Solution**: Streaming processing with batch validation and transaction management for rollback capability
- **Challenge**: Multi-tenant data isolation without performance impact
  - **Solution**: Global filters in EF Core context with organization claim extraction from JWT

### Code Review Items
- [ ] All CQRS handlers follow established Vertex patterns with MediatR
- [ ] Proper error handling with structured logging and correlation IDs
- [ ] Comprehensive validation rules for all business operations
- [ ] API documentation includes examples and error scenarios
- [ ] Security considerations: JWT validation, organizational filtering, input sanitization
- [ ] Performance: query optimization, caching strategies, pagination support
- [ ] ResourceId format consistency across all entities (fw_xxx_guid)

## 🔗 Dependencies & Integration

### Database Dependencies
- SQL Server instance configured with appropriate collation
- DbUp migration tool set up for version-controlled schema changes
- Entity Framework Core 8.0 with audit interceptors configured

### External Integrations
- [ ] Azure Service Bus for framework update notifications
- [ ] Application Insights for telemetry and monitoring
- [ ] Azure Blob Storage for CSV file processing and temporary storage

### API Versioning
- Using date-based versioning: `2025-07-17`
- Swagger documentation grouped by version
- Backward compatibility maintained for at least 12 months

### Phase 9: Manual Publish Workflow (ESG-13441)
**Added**: 2024-10-15  
**Status**: ✅ Completed  
**Purpose**: Enable manual publishing of reports with locking mechanism and framework version validation

#### Database Changes
- [x] ✅ Create DbUp migration (DBMigrations/20251015/001-AddPublishFields.sql)
- [x] ✅ Add `PublishedDate` column to Reports table (DATETIME2 NULL)
- [x] ✅ Add `PublishedByUserId` column to Reports table (NVARCHAR(54) NULL)
- [x] ✅ Add `IsLocked` column to Reports table (BIT NOT NULL DEFAULT 0)
- [x] ✅ Convert existing `Status` values to lowercase for consistency
- [x] ✅ Set `IsLocked = 1` for existing 'published' reports
- [x] ✅ Create filtered index on `PublishedDate` for performance

#### Entity and Model Updates
- [x] ✅ Update `ReportEntity` with new publish-related properties
- [x] ✅ Configure EF Core mappings with PascalCase column names
- [x] ✅ Update `Report` API model with XML documentation
- [x] ✅ Update entity mappers to include new fields

#### Business Logic (CQRS)
- [x] ✅ Create `PublishReportRequest` and `PublishReportResponse` classes
- [x] ✅ Create `ValidateFrameworkVersionRequest` and `FrameworkVersionValidation` classes
- [x] ✅ Implement `PublishReportHandler` with validation logic
- [x] ✅ Implement `ValidateFrameworkVersionHandler` for version checks
- [x] ✅ Create `PublishReportValidator` using FluentValidation
- [x] ✅ Add business rules: check if already published, validate framework version
- [x] ✅ Implement status update to 'published' (lowercase)
- [x] ✅ Set `IsLocked = true` and populate audit fields

#### API Endpoints
- [x] ✅ Add `POST /reports/{reportId}/publish` endpoint
  - Request body: `{ userId, currentFrameworkVersion }`
  - Response: `{ success, report, frameworkVersionMismatch, latestFrameworkVersion, errorMessage }`
- [x] ✅ Add `GET /reports/{reportId}/validate-framework-version` endpoint
  - Query param: `currentFrameworkVersion`
  - Response: `{ isValid, currentVersion, latestVersion, requiresUpdate, errorMessage }`
- [x] ✅ Implement proper error handling for already-published reports
- [x] ✅ Implement proper error handling for report-not-found scenarios
- [x] ✅ Add comprehensive logging for debugging

#### API SDK Updates
- [x] ✅ Update `IDisclosureManagementApi` Refit interface with new methods
- [x] ✅ Add `PublishReportAsync(string reportId, PublishReportRequestDto request)`
- [x] ✅ Add `ValidateFrameworkVersionAsync(string reportId, string currentFrameworkVersion)`
- [x] ✅ Create `PublishReportRequestDto` class

#### Database Migration & Troubleshooting
- [x] ✅ Create migration script `001-AddPublishFields.sql`
- [x] ✅ Handle SQL Server temporal tables (system versioning)
- [x] ✅ Fix dynamic SQL for parse-time validation issues
- [x] ✅ Correct history table name (`history.Reports_History`)
- [x] ✅ Match nullability for `IsLocked` in main and history tables
- [x] ✅ Create diagnostic script `diagnose-database-schema.sql`
- [x] ✅ Create PowerShell automation `run-core-api-migrations.ps1`
- [x] ✅ Create PowerShell diagnostic `run-database-diagnostic.ps1`
- [x] ✅ Verify migration applied successfully
- [x] ✅ Verify columns exist in database
- [x] ✅ Verify indexes created
- [x] ✅ Test Core API starts without 500 errors
- [x] ✅ Document troubleshooting in `docs/troubleshooting/DBUP-MIGRATIONS.md`
- [x] ✅ Document scripts in `docs/troubleshooting/DIAGNOSTIC-SCRIPTS.md`

#### Testing & Validation
- [ ] 📋 Unit tests for `PublishReportHandler`
- [ ] 📋 Unit tests for `ValidateFrameworkVersionHandler`
- [ ] 📋 Unit tests for `PublishReportValidator`
- [ ] 📋 Integration tests for publish endpoints
- [ ] 📋 Test framework version mismatch scenarios
- [ ] 📋 Test concurrent publish attempts
- [x] ✅ Manual testing with running Core API (no 500 errors)

## 🚀 Next Steps
1. **Complete Manual Publish testing** with unit and integration tests
2. **Deploy to development environment** with CI/CD pipeline
3. **Integration testing with BFF** using Refit interfaces
4. **Load testing** with realistic framework data volumes

---

**Progress Legend:**
- 📋 Pending
- 🚧 In Progress  
- ✅ Completed
- ❌ Blocked
- ⚠️ Needs Review

