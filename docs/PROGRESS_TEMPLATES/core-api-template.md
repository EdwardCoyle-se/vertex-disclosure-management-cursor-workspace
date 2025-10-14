# [DOMAIN] Core API Progress

> **Purpose**: Track implementation progress for the vertex-[domain]-api service.

## 📊 Project Overview
- **Domain**: [domain]
- **Service**: vertex-[domain]-api
- **Type**: Core CRUD API with Clean Architecture
- **Dependencies**: SQL Server Database
- **Started**: [DATE]
- **Target Completion**: [DATE]

## 🎯 Implementation Status

### Phase 1: Project Setup & Structure
- [ ] 📋 Copy vertex-api-template to vertex-[domain]-api
- [ ] 📋 Replace all Template placeholders with [Domain] names
- [ ] 📋 Update namespaces (SE.Sustainability.Vertex.[Domain].*)
- [ ] 📋 Update project references and solution file
- [ ] 📋 Configure appsettings for database connection
- [ ] 📋 Set up DbUp migration infrastructure

### Phase 2: Data Models & Database
- [ ] 📋 Create domain entities in Infrastructure.SqlServer/Entities/
- [ ] 📋 Create API models in API.Models/
- [ ] 📋 Create entity configurations for EF Core
- [ ] 🚨 **CRITICAL**: Write DbUp migration scripts in DBMigrations/yyyymmdd/ directories
- [ ] 🚨 **MANDATORY**: Use date-specific folders (e.g., DBMigrations/20250822/)
- [ ] 🚨 **MANDATORY**: Name scripts 001-<DBAction>.sql, 002-<DBAction>.sql, etc.
- [ ] 🚨 **FORBIDDEN**: Do NOT use Entity Framework Core migrations
- [ ] 📋 Create and test database schema using DbUp
- [ ] 📋 Create mapper classes (Entity ↔ Model)

### Phase 3: Core CRUD Operations
- [ ] 📋 Implement Read[Domain]Query and Handler
- [ ] 📋 Implement List[Domain]sQuery and Handler  
- [ ] 📋 Implement Create[Domain]Command and Handler
- [ ] 📋 Implement Update[Domain]Command and Handler
- [ ] 📋 Implement Delete[Domain]Command and Handler
- [ ] 📋 Add FluentValidation for all commands/queries

### Phase 4: API Controllers
- [ ] 📋 Create [Domain]Controller with basic CRUD endpoints
- [ ] 📋 Add proper HTTP status codes and responses
- [ ] 📋 Add API documentation with XML comments
- [ ] 📋 Add proper error handling and logging
- [ ] 📋 Test all endpoints with Swagger

### Phase 5: Business Logic & Advanced Features
- [ ] 📋 Implement domain-specific business rules
- [ ] 📋 Add advanced filtering and search capabilities
- [ ] 📋 Implement audit logging (CreatedBy, ModifiedBy, etc.)
- [ ] 📋 Add integration events (if needed)
- [ ] 📋 Implement caching for read operations (if needed)

### Phase 6: Testing & Quality
- [ ] 📋 Write unit tests for handlers and validators
- [ ] 📋 Write integration tests for API endpoints
- [ ] 📋 Add health checks and monitoring
- [ ] 📋 Performance testing and optimization
- [ ] 📋 Security review and validation

### Phase 7: Deployment & Documentation
- [ ] 📋 Configure CI/CD pipeline
- [ ] 📋 Set up environment-specific configurations
- [ ] 📋 Update API documentation
- [ ] 📋 Create deployment runbook
- [ ] 📋 Conduct final testing in staging environment

## 📝 Implementation Notes

### Key Decisions
- **Database Schema**: [Notes about schema decisions]
- **Business Rules**: [Key business logic implementations]
- **Performance**: [Caching and optimization choices]

### Challenges & Solutions
- **Challenge**: [Description]
  - **Solution**: [How it was resolved]

### Code Review Items
- [ ] All CQRS handlers follow established patterns
- [ ] Proper error handling and logging throughout
- [ ] Validation rules are comprehensive
- [ ] API documentation is complete
- [ ] Security considerations addressed

## 🔗 Dependencies & Integration

### Database Dependencies
- SQL Server instance configured
- 🚨 **CRITICAL**: DbUp migration tool set up (NOT Entity Framework migrations)
- Entity Framework Core configured for data access only
- SqlMigrationHandler implemented from template

### External Integrations
- [ ] [List any external services this API needs to integrate with]

### API Versioning
- Using date-based versioning: `2025-07-17`
- Swagger documentation grouped by version

## 🚀 Next Steps
1. **Complete Core API implementation**
2. **Deploy to development environment**
3. **Begin BFF service development** (depends on this service)
4. **Integration testing with BFF**

---

**Progress Legend:**
- 📋 Pending
- 🚧 In Progress  
- ✅ Completed
- ❌ Blocked
- ⚠️ Needs Review
