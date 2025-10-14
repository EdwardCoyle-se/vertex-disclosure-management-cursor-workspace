### **ADR-0002-data-model-strategy**

**Title:** Data Model Strategy and Entity Framework Patterns

---

### **1. Status**

**Status:** Approved

**Date:** 2025-01-17

**Decision Makers:** Tech Lead, Database Architect, Solution Architect

---

### **2. Context**

**2.1. Background**
The Disclosure Management platform requires a robust data model that supports complex framework hierarchies, multi-typed answer storage, comprehensive audit trails, and organizational multi-tenancy while maintaining performance and compliance with Vertex platform standards.

**2.2. Problem Statement**
ESG disclosure data has complex requirements including hierarchical frameworks, polymorphic answer types, version tracking for regulatory compliance, and organizational isolation. The data model must efficiently support these requirements while maintaining query performance and data integrity.

**2.3. Constraints & Requirements**
- **Technical Constraints:** Must use vertex-dotnet-api-sdk base classes and ResourceId format
- **Business Constraints:** Regulatory audit requirements, organizational data isolation
- **Performance Constraints:** Support for 1,000 concurrent users with complex framework queries
- **Compliance Constraints:** Full audit trails, data retention policies, GDPR compliance

**2.4. Stakeholders**
- **Primary:** Development team, Database Administrator, Compliance team
- **Secondary:** Performance team, Security team, Business stakeholders

---

### **3. Decision**

**3.1. Decision Statement**
Implement a normalized data model using Entity Framework Core with vertex-dotnet-api-sdk base classes, polymorphic answer storage through typed columns with JSON backup, and comprehensive audit tracking for regulatory compliance.

**3.2. Solution Overview**
- **Technology Stack:** Entity Framework Core, SQL Server, vertex-dotnet-api-sdk base classes
- **Architecture Pattern:** Domain-driven entity design with aggregate roots and value objects
- **Implementation Approach:** Code-first migrations with DbUp for schema management
- **Integration Points:** Organizational boundaries through consistent OrganizationId filtering

**3.3. Technical Specifications**
- **Entity Base Classes:**
  - NamedEntityBase: Framework, Report, FileMetadata (entities with descriptive names)
  - EntityBase: FrameworkQuestion, ReportAnswer (entities without names but full audit tracking)
- **Resource ID Format:** VARCHAR(54) pattern `dm_<assetType>_<guid>` for all entities
- **Answer Storage Strategy:** 
  - Typed columns for common data types (text, number, boolean, date)
  - JSON column for complete answer data and complex structures
  - File references through separate FileMetadata entities
- **Audit Strategy:** Comprehensive audit trails through base class CreatedBy/UpdatedBy fields
- **Organizational Isolation:** Consistent OrganizationId filtering across all user-data entities

---

### **4. Reasoning**

**4.1. Evaluation Criteria**
- **Performance:** Query efficiency for large datasets and complex framework hierarchies
- **Flexibility:** Support for diverse framework question types and future extensibility
- **Compliance:** Full audit trails and data lineage for regulatory requirements
- **Consistency:** Alignment with Vertex platform patterns and standards

**4.2. Key Decision Factors**
- Vertex platform consistency requires adherence to established entity patterns
- Regulatory requirements mandate comprehensive audit trails and version tracking
- Performance requirements need efficient querying of hierarchical framework data
- Multi-tenant architecture requires bulletproof organizational data isolation

**4.3. Trade-offs Accepted**
- Some data duplication in typed columns vs JSON for query performance optimization
- Increased storage requirements for comprehensive audit trails
- Additional complexity in answer handling logic for type safety

---

### **5. Alternatives Considered**

**5.1. Alternative 1: Pure JSON Answer Storage**
- **Description:** Store all answer data in single JSON columns without typed fields
- **Pros:** Maximum flexibility, simpler schema design, easier framework evolution
- **Cons:** Poor query performance, limited SQL filtering capabilities, type safety challenges
- **Rejection Reason:** Performance requirements and query complexity make JSON-only approach impractical

**5.2. Alternative 2: Entity-Attribute-Value (EAV) Pattern**
- **Description:** Generic attribute storage with dynamic schema capabilities
- **Pros:** Ultimate flexibility, easy framework addition, minimal schema changes
- **Cons:** Complex queries, poor performance, difficult to maintain referential integrity
- **Rejection Reason:** Query complexity and performance characteristics incompatible with user experience requirements

**5.3. Alternative 3: Separate Tables per Answer Type**
- **Description:** Dedicated tables for text answers, numeric answers, boolean answers, etc.
- **Pros:** Optimal query performance, strong type safety, clear data organization
- **Cons:** Complex application logic, difficult framework evolution, schema management overhead
- **Rejection Reason:** Framework evolution complexity and application logic overhead outweigh performance benefits

---

### **6. Consequences**

**6.1. Positive Consequences**
- **Technical Benefits:** Optimal query performance, strong type safety, efficient indexing strategies
- **Business Benefits:** Regulatory compliance, audit trail capabilities, organizational data security
- **Team Benefits:** Familiar Entity Framework patterns, predictable development experience

**6.2. Negative Consequences**
- **Technical Debt:** Answer handling logic requires careful type coordination
- **Storage Overhead:** Some data duplication between typed columns and JSON storage
- **Migration Complexity:** Schema changes require careful coordination between typed and JSON data

**6.3. Risk Mitigation**
- Comprehensive unit testing for answer type handling logic
- Automated testing for organizational data isolation
- Performance monitoring and query optimization strategies

---

### **7. Implementation Plan**

**7.1. Implementation Phases**
- **Phase 1:** Core entity creation with base class inheritance and ResourceId implementation
- **Phase 2:** Answer polymorphism implementation with typed columns and JSON backup
- **Phase 3:** Organizational filtering implementation and security validation

**7.2. Dependencies**
- **Technical Dependencies:** vertex-dotnet-api-sdk package, Entity Framework Core setup
- **Team Dependencies:** Database design review and approval
- **External Dependencies:** SQL Server infrastructure provisioning

**7.3. Success Criteria**
- **Performance Metrics:** <200ms query response times for complex framework hierarchies
- **Data Integrity:** 100% organizational data isolation validation
- **Compliance Metrics:** Complete audit trail coverage for all data modifications

**7.4. Rollback Plan**
- Database schema versioning allows rollback to previous migration states
- Data migration scripts support bidirectional transformations

---

### **8. Monitoring & Review**

**8.1. Monitoring Strategy**
- **Key Metrics:** Query performance, database storage growth, organizational isolation validation
- **Monitoring Tools:** SQL Server Performance Insights, Application Insights database metrics
- **Alert Thresholds:** >500ms query times, storage growth >20% monthly, any cross-organizational data access

**8.2. Review Schedule**
- **Short-term Review:** 2 months post-implementation for performance validation
- **Long-term Review:** Quarterly review during framework expansion phases
- **Trigger Events:** Performance degradation, compliance audit requirements, new framework types

---

### **9. References**

**9.1. Related Documentation**
- **PRD:** ProductDesign/DisclosureManagement_PRD.md
- **TDD:** ProductDesign/DisclosureManagement_TDD.md - Section 2.2 Data Structures
- **Entity Framework:** docs/examples/COMMON_PATTERNS.md

**9.2. External References**
- **Entity Framework Core:** Microsoft documentation for EF Core patterns
- **Domain-Driven Design:** Aggregate design and entity relationship patterns
- **Vertex SDK:** vertex-dotnet-api-sdk entity base class documentation

**9.3. Related ADRs**
- **Depends on:** ADR-0001 (Domain Bounded Contexts)
- **Related:** ADR-0003 (API Design Patterns), ADR-0004 (Multi-tenant Architecture)
- **Supersedes:** None

---

### **10. Appendices**

**10.1. Entity Relationship Diagram**
```
Framework (NamedEntityBase)
├── FrameworkQuestion (EntityBase) [1:N]
└── Report (NamedEntityBase) [1:N]
    └── ReportAnswer (EntityBase) [1:N]
        └── FileMetadata (NamedEntityBase) [0:1]

Organizational Isolation:
- Framework: Global (no OrganizationId)
- FrameworkQuestion: Global (no OrganizationId)
- Report: OrganizationId (tenant boundary)
- ReportAnswer: OrganizationId (tenant boundary)
- FileMetadata: OrganizationId (tenant boundary)
```

**10.2. Answer Storage Example**
```sql
-- ReportAnswer polymorphic storage example
INSERT INTO Report_Answers (
    Report_Answer_Id,
    Report_Id,
    Framework_Question_Id,
    Organization_Id,
    Answer_Value_Text,        -- For text responses
    Answer_Value_Number,      -- For numeric responses  
    Answer_Value_Boolean,     -- For yes/no responses
    Answer_Value_Date,        -- For date responses
    Answer_Value_Json,        -- Complete answer data
    Source_Of_Data,
    Confidence_Score,
    Version_History,
    Created_User_Id,
    Created_Ts
) VALUES (
    'dm_ans_11a2b3c4d5e6f789012345678901ab',
    'dm_rpt_22b3c4d5e6f7890123456789012abc',
    'dm_fqn_33c4d5e6f7890123456789012abcde',
    'org_12345678901234567890123456789012',
    'Our carbon emissions target is net-zero by 2030',
    NULL,
    NULL,
    NULL,
    '{"text": "Our carbon emissions target is net-zero by 2030", "confidence": 95, "source": "Corporate Sustainability Report 2024"}',
    'MANUAL_ENTRY',
    95,
    '[]',
    'usr_user123456789012345678901234567',
    GETUTCDATE()
);
```
