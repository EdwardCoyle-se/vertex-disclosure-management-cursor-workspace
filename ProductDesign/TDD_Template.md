### **AI Prompt: TDD Generation Template**

**Your Role:** You are a Senior Software Engineer or Solutions Architect working on the Vertex sustainability platform. Your task is to generate a comprehensive Technical Design Document (TDD) for a new feature or product named `[Feature/Product Name]`. You will be given one or more source documents, such as a PRD, containing the product overview and requirements.

**Context for Cursor AI:** This TDD will guide the implementation of a Vertex application using:
- **Architecture:** Clean Architecture with CQRS (Command Query Responsibility Segregation)
- **Frontend:** Angular 20+ with standalone components and vertex-ui-shared library
- **Backend:** .NET 8 APIs with MediatR, Entity Framework Core, and vertex-dotnet-api-sdk
- **Data:** SQL Server with DbUp migrations (🚨 CRITICAL: NEVER use EF Core migrations)
- **Patterns:** Repository pattern, dependency injection, event-driven architecture

**Your Instructions:** Use the provided source material to populate the following TDD template. Focus on technical specifications that align with Vertex architectural patterns and can be directly implemented using the established templates and coding standards. Adhere strictly to the structure and instructions for each section. Your tone should be technical, precise, and objective. If information is not available in the source documents, make logical assumptions based on Vertex standards and clearly state them, or use placeholders like `[TBD - To Be Determined by Engineering Team]`.

---

### **Technical Design Document: [Feature/Product Name]**

**Implementation Context:**
`[Instructions: Extract the domain name from the PRD and define the technical project structure.]`
*   **Domain:** `[e.g., inventory]`
*   **Projects to Create:**
    - `vertex-[domain]-ui` (Angular Frontend)
    - `vertex-[domain]-bff` (Backend-for-Frontend API)
    - `vertex-[domain]-api` (Core CRUD API)
*   **Base Templates:** Use vertex-cursor-templates as starting point

### **1. Product Overview**

**1.1. Purpose & Problem Statement**
`[Instructions: From the source document, summarize the primary business purpose of this feature. Clearly state the user problem it is designed to solve. Provide a concrete example of how a user would benefit from this feature.]`

**1.2. Target Audience**
`[Instructions: Identify and list the primary user personas who will use this feature. For each persona, briefly describe their role and why they need this feature.]`
*   **Persona 1:** `[e.g., Mid-level Manager]`
*   **Persona 2:** `[e.g., Administrative Assistant]`
*   **Persona 3:** `[e.g., Sales Representative]`

**1.3. Expected Outcomes & KPIs**
`[Instructions: List the expected qualitative outcomes (e.g., increased efficiency). Then, list the specific, measurable Key Performance Indicators (KPIs) that will be used to track the success of this feature, as defined in the source material.]`
*   **Qualitative Outcomes:**
    *   `[e.g., Increased user productivity]`
    *   `[e.g., Enhanced user satisfaction]`
*   **Key Performance Indicators (KPIs):**
    *   `[e.g., Reduction in average task completion time]`
    *   `[e.g., User engagement rate with the feature]`
    *   `[e.g., Feature adoption rate among the target audience]`

### **2. Design Details**

**2.1. Architectural Overview**
`[Instructions: Follow the standard Vertex three-tier architecture. Describe how the components interact and any specific customizations needed for this domain.]`

**Standard Vertex Architecture:**
```mermaid
graph TB
    subgraph "Frontend Tier"
        UI[Angular Application<br/>vertex-[domain]-ui]
        UILib[vertex-ui-shared]
    end
    
    subgraph "BFF Tier"
        BFF[BFF API<br/>vertex-[domain]-bff]
    end
    
    subgraph "Core Tier"
        API[Core API<br/>vertex-[domain]-api]
        DB[(SQL Server Database)]
    end
    
    subgraph "Infrastructure"
        AUTH[OAuth2/OIDC]
        LOG[Application Insights]
        MSG[Azure Service Bus]
    end
    
    UI --> UILib
    UI --> BFF
    BFF --> API
    API --> DB
    
    BFF --> AUTH
    API --> AUTH
    BFF --> LOG
    API --> LOG
    API --> MSG
```

**Component Responsibilities:**
*   **Angular Frontend:** User interface, client-side validation, routing, state management
*   **BFF API:** Data aggregation, UI-specific transformations, frontend auth handling
*   **Core API:** Domain business logic, CRUD operations, data persistence, integration events
*   **Database:** Data storage with Entity Framework Core and DbUp migrations (🚨 CRITICAL: NEVER use EF Core migrations)

**2.2. Data Structures and Algorithms**
`[Instructions: Define the core domain entities and their relationships. CRITICAL: All entities must inherit from appropriate base classes from SE.Sustainability.Vertex.Api.Sdk.Entities. Use Entity Framework conventions and follow Vertex naming patterns.]`

**Entity Base Class Selection:**
- **NamedEntityBase**: For entities with a Name property (most common)
- **EntityBase**: For entities without a Name but need full audit tracking
- **MinimalEntityBase**: For simple entities with minimal tracking
- **EntityAuditBase**: Alternative audit pattern

**Core Domain Entities:**
```csharp
// Example: For inventory domain - Use NamedEntityBase (most common)
public class [Domain]Item : NamedEntityBase
{
    public string Description { get; set; } = default!;
    public [Domain]Status Status { get; set; }
    public decimal Price { get; set; }
    // Automatically includes: Id (ResourceId format), Name, CreatedBy, CreatedDate, LastUpdatedBy, LastUpdatedDate
}

public class [Domain]ItemConfiguration : NamedEntityBaseConfiguration<[Domain]Item>
{
    protected override string IdColumnName => "[Domain]_Item_Id";

    public override void Configure(EntityTypeBuilder<[Domain]Item> builder)
    {
        base.Configure(builder);
        
        builder.ToTable("[Domain]Items");
        builder.Property(e => e.Description).HasMaxLength(1000);
        builder.Property(e => e.Status).HasConversion<string>();
        builder.Property(e => e.Price).HasPrecision(18, 2);
    }
}

// Example: For entities without Name - Use EntityBase
public class [Domain]History : EntityBase
{
    public string [Domain]ItemId { get; set; } = default!;
    public string ChangeType { get; set; } = default!;
    public string ChangeData { get; set; } = default!;
    // Automatically includes: Id, CreatedBy, CreatedDate, LastUpdatedBy, LastUpdatedDate
}
```

**Repository Interfaces:**
```csharp
// CRITICAL: Must implement IEFRepository<TEntity> from vertex-dotnet-api-sdk
public interface I[Domain]Repository : IEFRepository<[Domain]Item>
{
    Task<IEnumerable<[Domain]Item>> GetByStatusAsync([Domain]Status status);
    Task<[Domain]Item?> GetByNameAsync(string name);
}

public class [Domain]Repository : EFRepository<[Domain]Item>, I[Domain]Repository
{
    public [Domain]Repository([Domain]DbContext context) : base(context)
    {
    }

    public async Task<IEnumerable<[Domain]Item>> GetByStatusAsync([Domain]Status status)
    {
        var result = await GetAllAsync(
            configureWheres: query => query.Where(t => t.Status == status),
            orderBy: query => query.OrderBy(t => t.Name)
        );
        return result.Items;
    }
}
```

**API Models:**
```csharp
public class [Domain]Item
{
    public string Id { get; set; } = default!;
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public [Domain]Status Status { get; set; }
    public DateTime CreatedDate { get; set; }
}

public class Create[Domain]ItemCommand
{
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public decimal Price { get; set; }
}

public class Update[Domain]ItemCommand
{
    public string Id { get; set; } = default!;
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public [Domain]Status Status { get; set; }
}
```

**Resource ID Format:**
All entities use ResourceId format: `<application>_<assetType>_<guid>` (VARCHAR(54))
```csharp
// Examples for domain abbreviations:
// "im_ind_11a2b3c4d5e6f789012345678901ab" (IndicatorManagement - Indicator)
// "iv_itm_11a2b3c4d5e6f789012345678901ab" (Inventory - Item)
```

**Business Logic Algorithms:**
*   **CQRS Operations:** All business operations implemented as Commands (write) and Queries (read)
*   **Validation:** FluentValidation for input validation with custom business rules
*   **Mapping:** Entity ↔ Model mapping using explicit mapper classes
*   **Caching:** In-memory caching for frequently accessed reference data

**2.3. System Interfaces**
`[Instructions: Detail how this feature will communicate with other systems. Break this down into three sub-sections.]`
*   **API Endpoints:** `[List the primary RESTful API endpoints that will be created. Include the HTTP method (POST, GET, PUT, DELETE) and a brief description of its function.]`
*   **Third-Party Services:** `[List any external services this feature will integrate with (e.g., Calendar APIs, Email servers, CRM systems).]`
*   **Internal Modules:** `[Describe how this feature will communicate with other existing modules within the main application (e.g., Notifications, Core Task Management).]`

**2.4. User Interfaces (UI)**
`[Instructions: List and briefly describe the key front-end components or screens the user will interact with for this feature. 🚨 CRITICAL: ALL UI components MUST use vertex-ui-shared library components. NEVER create custom UI components.]`

**🚨 CRITICAL UI REQUIREMENTS:**
- **COMPONENT HIERARCHY**: 1) vertex-ui-shared (FIRST), 2) Quartz components, 3) Custom reusable (LAST RESORT)
- **MUST USE**: `@se-sustainability-business/vertex-ui-shared` components for ALL UI elements when available
- **CUSTOM COMPONENTS**: If needed, create in `src/app/shared/components/` and document in `CUSTOM_COMPONENTS.md`
- **FORBIDDEN**: One-off HTML scattered in templates, custom components when libraries have them

**🚨 CRITICAL TRANSLATION REQUIREMENTS:**
- **MUST USE**: `{{ 'module.key' | translate }}` for ALL user-facing text
- **REQUIRED**: Import TranslatePipe: `import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate'`
- **REQUIRED**: Translation keys follow format: `module.key` (e.g., 'inventory.title', 'shared.save')
- **REQUIRED**: Translation files in `public/i18n/en.json`, alphabetically sorted
- **FORBIDDEN**: Hardcoded strings, custom translation solutions

**🚨 CRITICAL ACCESSIBILITY REQUIREMENTS:**
- **MUST MEET**: WCAG 2.1 AA standards and European Accessibility Act compliance
- **REQUIRED**: ESLint with `...angular.configs.templateAccessibility` configuration
- **REQUIRED**: Storybook with `@storybook/addon-a11y` for real-time testing
- **REQUIRED**: axe DevTools browser extension for manual testing
- **REQUIRED**: Proper ARIA attributes (`role`, `aria-expanded`, `aria-disabled`, etc.)
- **REQUIRED**: Full keyboard navigation support for all interactive elements
- **FORBIDDEN**: Bypassing accessibility rules, missing ARIA attributes, keyboard-inaccessible elements
- **REFERENCE**: Storybook at https://vertex-components-non.sb.se.com

**Required UI Components:**
*   `[e.g., Automation Builder using VxTableComponent and VxButtonComponent]`
*   `[e.g., Dashboard using VxChartComponent and VxCardComponent]`

**2.5. Hardware Interfaces**
`[Instructions: State whether any special hardware is required. If none is needed, explicitly state: "No special hardware interfaces are required as this is a software-based feature."]`

### **3. Testing Plan**

**3.1. Test Strategy**
`[Instructions: Outline the comprehensive testing strategy. List the different types of testing that will be performed and briefly describe the goal of each.]`
*   **Unit Testing:** `[e.g., Verify individual functions and components in isolation.]`
*   **Integration Testing:** `[e.g., Test the interaction between frontend, backend, and APIs.]`
*   **System Testing:** `[e.g., Validate the end-to-end functionality of the feature within the complete application.]`
*   **User Acceptance Testing (UAT):** `[e.g., Conduct sessions with target users to validate requirements and usability.]`

**3.2. Testing Tools**
`[Instructions: List the specific tools that will be used for each phase of testing.]`
*   **Unit Testing:** `[e.g., JUnit (Backend), Jest/React Testing Library (Frontend)]`
*   **Integration/API Testing:** `[e.g., Postman, Supertest]`
*   **System (E2E) Testing:** `[e.g., Selenium, Cypress, Playwright]`
*   **UAT Feedback:** `[e.g., UserTesting.com, In-app feedback forms]`

**3.3. Test Environments**
`[Instructions: Describe the different environments that will be used for development and testing.]`
*   **Development:** `[e.g., Local developer machines.]`
*   **Staging/QA:** `[e.g., A cloud-based environment that mirrors production.]`
*   **Production:** `[e.g., Live environment, possibly using feature flags for limited rollout.]`

**3.4. Example Test Cases**
`[Instructions: Create a few high-level example test cases covering the happy path, edge cases, and error handling.]`
*   **Happy Path:** `[e.g., Verify a user can successfully create, save, and execute a simple automation.]`
*   **Error Handling:** `[e.g., Verify the system handles an API failure from a third-party service gracefully.]`
*   **UI Validation:** `[e.g., Verify the drag-and-drop interface is responsive and works across major browsers.]`

**3.5. Reporting and Metrics**
`[Instructions: Define the metrics for measuring testing quality.]`
*   **Test Coverage:** `[e.g., Target >90% code coverage for backend services.]`
*   **Bug Tracking:** `[e.g., All bugs will be tracked and managed in Jira.]`

### **4. Deployment Plan**

**4.1. Deployment Environment & Tools**
`[Instructions: Describe the production infrastructure and the tools that will be used for the CI/CD pipeline.]`
*   **Deployment Environment:** `[e.g., High-availability Kubernetes cluster on AWS/GCP/Azure.]`
*   **Version Control:** `[e.g., Git (using GitFlow branching strategy).]`
*   **CI/CD Pipeline:** `[e.g., Jenkins, GitLab CI, or GitHub Actions.]`
*   **Containerization:** `[e.g., Docker.]`

**4.2. Deployment Steps**
`[Instructions: Outline the step-by-step process for deploying the feature from code commit to production.]`
1.  **Code Review:** All code merged to the main branch must be peer-reviewed.
2.  **Automated Testing:** CI pipeline runs all unit and integration tests automatically.
3.  **Build:** A new Docker image is built and pushed to a container registry.
4.  **Deploy to Staging:** The new image is deployed to the staging environment.
5.  **Automated E2E Tests:** System tests are run against the staging environment.
6.  **UAT & Manual QA:** Final validation is performed on staging.
7.  **Deploy to Production:** Upon approval, the image is deployed to the production environment (potentially using a Canary or Blue/Green strategy).

**4.3. Post-Deployment Verification & Rollback**
`[Instructions: Describe the plan for verifying the deployment and how to handle a potential failure.]`
*   **Verification:** `[e.g., Perform smoke tests on critical functionality. Monitor performance and error rates using tools like Prometheus, Grafana, or Datadog.]`
*   **Rollback Plan:** `[e.g., Maintain automated scripts to quickly roll back to the previous stable version in case of critical failure.]`