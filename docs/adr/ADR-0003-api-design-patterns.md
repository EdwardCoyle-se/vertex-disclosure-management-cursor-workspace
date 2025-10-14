### **ADR-0003-api-design-patterns**

**Title:** API Design Patterns and CQRS Implementation

---

### **1. Status**

**Status:** Approved

**Date:** 2025-01-17

**Decision Makers:** Tech Lead, API Architect, Frontend Lead

---

### **2. Context**

**2.1. Background**
The Disclosure Management platform requires a robust API design that can handle complex business operations, provide optimal performance for different access patterns, and maintain consistency with Vertex platform standards while supporting the diverse needs of disclosure reporting workflows.

**2.2. Problem Statement**
ESG disclosure workflows involve complex read and write patterns with different performance requirements. Dashboard queries need fast aggregations, report authoring requires real-time updates, and compliance operations demand strong consistency and audit trails. A unified API approach may not optimally serve these diverse requirements.

**2.3. Constraints & Requirements**
- **Technical Constraints:** Must use MediatR for CQRS implementation, adhere to RESTful principles
- **Performance Constraints:** <200ms response times for reads, <500ms for complex operations
- **Business Constraints:** Regulatory audit requirements, real-time collaboration needs
- **Platform Constraints:** Must align with Vertex API standards and authentication patterns

**2.4. Stakeholders**
- **Primary:** Frontend development team, API consumers, Performance team
- **Secondary:** Business stakeholders, Compliance team, DevOps team

---

### **3. Decision**

**3.1. Decision Statement**
Implement Command Query Responsibility Segregation (CQRS) pattern using MediatR with dedicated Commands for write operations and Queries for read operations, combined with RESTful HTTP verbs and resource-based URL patterns for intuitive API consumption.

**3.2. Solution Overview**
- **Technology Stack:** MediatR for CQRS, ASP.NET Core Web API, FluentValidation
- **Architecture Pattern:** CQRS with separate read and write models, RESTful resource design
- **Implementation Approach:** Vertical slice architecture with feature-based organization
- **Integration Points:** BFF aggregation layer, real-time updates via polling

**3.3. Technical Specifications**
- **Command Pattern:** Write operations using MediatR IRequest<T> commands with validation
- **Query Pattern:** Read operations optimized for specific UI needs and performance
- **API Versioning:** Date-based versioning (2025-07-17) following Vertex standards
- **Error Handling:** Consistent error responses with correlation IDs and user-friendly messages
- **Authentication:** OAuth2/OIDC integration with organizational boundary enforcement
- **Validation:** FluentValidation for comprehensive input validation with business rules

**CQRS Implementation Examples:**
```csharp
// Commands (Write Operations)
public record CreateReportCommand(string Name, string OrganizationId, string FrameworkId) : IRequest<Report>;
public record UpdateReportAnswerCommand(string ReportId, string QuestionId, string AnswerValue) : IRequest<ReportAnswer>;
public record DeleteReportCommand(string ReportId) : IRequest<bool>;

// Queries (Read Operations)  
public record GetReportQuery(string ReportId) : IRequest<Report>;
public record GetReportsByOrganizationQuery(string OrganizationId) : IRequest<IEnumerable<Report>>;
public record GetDashboardMetricsQuery(string OrganizationId) : IRequest<DashboardMetrics>;
```

**API Endpoint Design:**
```
POST   /reports                           - CreateReportCommand
GET    /reports/{id}                      - GetReportQuery  
GET    /reports/organization/{orgId}      - GetReportsByOrganizationQuery
PUT    /reports/{id}/answers              - UpdateReportAnswerCommand
DELETE /reports/{id}                      - DeleteReportCommand
GET    /reports/{id}/status               - GetReportStatusQuery
POST   /reports/{id}/recalculate-status   - RecalculateReportStatusCommand
```

---

### **4. Reasoning**

**4.1. Evaluation Criteria**
- **Performance:** Optimal read/write operation performance for different access patterns
- **Maintainability:** Clear separation of concerns and predictable code organization
- **Scalability:** Independent optimization of read and write operations
- **Developer Experience:** Intuitive API design with consistent patterns

**4.2. Key Decision Factors**
- Complex dashboard queries require different optimization than transactional operations
- Real-time collaboration needs efficient update patterns without complex event sourcing
- Regulatory compliance requires clear audit trails and validation at the API boundary
- Frontend team productivity benefits from predictable RESTful patterns

**4.3. Trade-offs Accepted**
- Increased code complexity with separate command and query models
- Potential data consistency considerations between read and write models
- Additional abstraction layers may impact initial development velocity

---

### **5. Alternatives Considered**

**5.1. Alternative 1: Traditional CRUD with Rich Domain Models**
- **Description:** Standard repository pattern with unified read/write models
- **Pros:** Simpler initial development, familiar patterns, easier testing
- **Cons:** Performance limitations for complex queries, difficulty optimizing for different access patterns
- **Rejection Reason:** Performance requirements for dashboard queries and collaboration features require specialized optimization

**5.2. Alternative 2: Full Event Sourcing with CQRS**
- **Description:** Complete event sourcing implementation with event store and projection management
- **Pros:** Ultimate auditability, temporal queries, high scalability potential
- **Cons:** Significant complexity increase, operational overhead, learning curve
- **Rejection Reason:** Over-engineering for current requirements and team expertise level

**5.3. Alternative 3: GraphQL API**
- **Description:** GraphQL implementation for flexible client-driven queries
- **Pros:** Efficient data fetching, client flexibility, strong typing
- **Cons:** Caching complexity, security considerations, team learning curve
- **Rejection Reason:** Vertex platform standards favor RESTful APIs and team lacks GraphQL expertise

---

### **6. Consequences**

**6.1. Positive Consequences**
- **Technical Benefits:** Optimal performance for different access patterns, clear separation of concerns
- **Business Benefits:** Fast dashboard loading, efficient report authoring, strong audit capabilities
- **Team Benefits:** Predictable development patterns, clear API contracts, focused optimization efforts

**6.2. Negative Consequences**
- **Technical Debt:** Additional complexity in maintaining separate command and query models
- **Operational Overhead:** More endpoints to monitor and maintain
- **Learning Curve:** Team needs training on CQRS patterns and MediatR framework

**6.3. Risk Mitigation**
- Comprehensive documentation and training on CQRS patterns
- Automated testing strategies for both command and query operations
- Performance monitoring and alerting for API response times

---

### **7. Implementation Plan**

**7.1. Implementation Phases**
- **Phase 1:** Core CQRS infrastructure setup with MediatR and validation pipeline
- **Phase 2:** Framework and Report command/query implementation
- **Phase 3:** Advanced operations (status calculation, bulk operations, export functionality)

**7.2. Dependencies**
- **Technical Dependencies:** MediatR package installation, FluentValidation setup
- **Team Dependencies:** CQRS training for development team
- **External Dependencies:** Authentication service integration

**7.3. Success Criteria**
- **Performance Metrics:** <200ms for query operations, <500ms for command operations
- **Quality Metrics:** >90% test coverage for handlers, 100% validation coverage
- **User Experience:** Consistent API response formats, intuitive error messages

**7.4. Rollback Plan**
- Gradual migration strategy allows fallback to traditional CRUD patterns if needed
- API versioning enables parallel operation of old and new patterns

---

### **8. Monitoring & Review**

**8.1. Monitoring Strategy**
- **Key Metrics:** API response times by operation type, error rates by endpoint, validation failure rates
- **Monitoring Tools:** Application Insights for API performance, custom dashboards for CQRS metrics
- **Alert Thresholds:** >500ms command operations, >200ms query operations, >1% error rates

**8.2. Review Schedule**
- **Short-term Review:** 1 month post-implementation for performance validation
- **Long-term Review:** Quarterly review during feature expansion phases
- **Trigger Events:** Performance degradation, high error rates, team feedback on complexity

---

### **9. References**

**9.1. Related Documentation**
- **PRD:** ProductDesign/DisclosureManagement_PRD.md
- **TDD:** ProductDesign/DisclosureManagement_TDD.md - Section 2.3 System Interfaces
- **Vertex Standards:** docs/CODING_STANDARDS.md API design patterns

**9.2. External References**
- **CQRS Pattern:** Martin Fowler - CQRS documentation
- **MediatR:** MediatR GitHub repository and documentation
- **RESTful API Design:** Richardson Maturity Model for REST APIs

**9.3. Related ADRs**
- **Depends on:** ADR-0001 (Domain Bounded Contexts), ADR-0002 (Data Model Strategy)
- **Related:** ADR-0004 (Frontend Architecture Patterns)
- **Supersedes:** None

---

### **10. Appendices**

**10.1. API Response Format Standards**
```json
// Successful Response
{
  "data": {
    "id": "dm_rpt_11a2b3c4d5e6f789012345678901ab",
    "name": "2024 CDP Climate Report",
    "status": "IN_PROGRESS"
  },
  "meta": {
    "timestamp": "2025-01-17T10:30:00Z",
    "correlationId": "abc123-def456-ghi789"
  }
}

// Error Response
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Report name is required",
    "details": [
      {
        "field": "name",
        "code": "REQUIRED",
        "message": "Name field cannot be empty"
      }
    ]
  },
  "meta": {
    "timestamp": "2025-01-17T10:30:00Z", 
    "correlationId": "abc123-def456-ghi789"
  }
}
```

**10.2. Handler Implementation Pattern**
```csharp
public class CreateReportHandler : IRequestHandler<CreateReportCommand, Report>
{
    private readonly IReportRepository _repository;
    private readonly IValidator<CreateReportCommand> _validator;
    private readonly IClaimsService _claimsService;

    public async Task<Report> Handle(CreateReportCommand request, CancellationToken cancellationToken)
    {
        // Validation
        var validationResult = await _validator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
            throw new ValidationException(validationResult.Errors);

        // Business Logic
        var reportEntity = new ReportEntity
        {
            Name = request.Name,
            OrganizationId = request.OrganizationId,
            FrameworkId = request.FrameworkId,
            Status = ReportStatus.DRAFT.ToString(),
            CreatedBy = _claimsService.GetUserId()
        };

        await _repository.CreateAsync(reportEntity);
        
        // Return API Model
        return ReportMapper.ToApiModel(reportEntity);
    }
}
```
