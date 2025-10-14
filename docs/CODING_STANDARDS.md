# Vertex Coding Standards

> **Purpose**: This document defines the coding standards, patterns, and conventions that Cursor AI should follow when working on Vertex projects.

## 🏗️ Architecture Principles

### Clean Architecture
All .NET projects follow Clean Architecture principles:

```
┌─────────────────────────────────────────────┐
│                 API Layer                   │  ← Controllers, Middleware, Configuration
├─────────────────────────────────────────────┤
│               Core Layer                    │  ← Business Logic, Entities, Interfaces
├─────────────────────────────────────────────┤
│           Infrastructure Layer              │  ← Data Access, External Services
└─────────────────────────────────────────────┘
```

**Key Rules:**
- Core layer has no dependencies on external frameworks
- Infrastructure depends on Core, never the reverse
- API layer orchestrates between Core and Infrastructure
- Use dependency injection for all cross-layer communication

### CQRS with MediatR
All business operations use Command Query Responsibility Segregation:

**Queries** (Read Operations):
```csharp
// Request
public record ReadTemplateRequest(int Id) : IRequest<IEnumerable<Template>>;

// Handler
public class ReadTemplateHandler : IRequestHandler<ReadTemplateRequest, IEnumerable<Template>>
{
    public async Task<IEnumerable<Template>> Handle(ReadTemplateRequest request, CancellationToken cancellationToken)
    {
        // Implementation
    }
}
```

**Commands** (Write Operations):
```csharp
// Request
public record CreateTemplateCommand(string Name, string Description) : IRequest<Template>;

// Handler
public class CreateTemplateHandler : IRequestHandler<CreateTemplateCommand, Template>
{
    public async Task<Template> Handle(CreateTemplateCommand request, CancellationToken cancellationToken)
    {
        // Implementation
    }
}
```

## 📁 Project Structure Standards

### .NET API Projects

```
SE.Sustainability.Vertex.[Domain].API/
├── Controllers/           # API endpoints
├── Installers/           # Dependency injection configuration
├── Authentication/       # Auth configuration
├── Filters/             # Action filters
├── Options/             # Configuration models
├── Program.cs           # Entry point
└── [Domain]Api.cs       # Main application class

SE.Sustainability.Vertex.[Domain].Core/
├── Features/            # CQRS features organized by domain
│   └── [Entity]/
│       ├── Commands/    # Write operations
│       ├── Queries/     # Read operations
│       ├── Handlers/    # MediatR handlers
│       └── Validators/  # FluentValidation validators
├── Extensions/          # Service collection extensions
├── Mappers/            # Entity to model mapping
└── Interfaces/         # Core abstractions

SE.Sustainability.Vertex.[Domain].Infrastructure.SqlServer/
├── Entities/           # EF Core entities
├── Repositories/       # Data access implementations
├── DBMigrations/       # DbUp SQL migration scripts (🚨 CRITICAL: NOT EF migrations)
│   ├── 20250822/       # Date-specific directories (yyyymmdd)
│   │   ├── 001-CreateTables.sql
│   │   └── 002-AddIndexes.sql
│   └── 20250823/
│       └── 001-AddColumns.sql
├── SqlMigrationHandler.cs # DbUp migration handler
└── [Domain]DbContext.cs # EF Core context (for data access only)
```

### Angular Projects

```
src/
├── app/
│   ├── features/       # Feature modules (lazy-loaded)
│   ├── shared/         # Shared components/services
│   ├── core/          # Singleton services
│   └── models/        # TypeScript interfaces/types
├── assets/            # Static assets
├── environments/      # Environment configurations
└── styles/           # Global styles
```

## 🎯 Naming Conventions

### .NET Naming
- **Namespaces**: `SE.Sustainability.Vertex.[Domain].[Layer]`
- **Classes**: PascalCase (e.g., `TemplateController`, `ReadTemplateHandler`)
- **Methods**: PascalCase (e.g., `GetTemplateAsync`)
- **Properties**: PascalCase (e.g., `TemplateName`)
- **Variables**: camelCase (e.g., `templateRepository`)
- **Constants**: PascalCase (e.g., `MaxRetryAttempts`)

### Angular Naming
- **Components**: kebab-case files, PascalCase classes (e.g., `template-list.component.ts`, `TemplateListComponent`)
- **Services**: kebab-case files, PascalCase classes (e.g., `template.service.ts`, `TemplateService`)
- **Interfaces**: PascalCase with 'I' prefix (e.g., `ITemplate`)
- **Types**: PascalCase (e.g., `TemplateStatus`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `API_BASE_URL`)

### API Versioning
- Use date-based versioning: `2025-07-17`
- Apply to controllers: `[ApiVersion(ApiVersionInfo.V2025_07_17)]`
- Group in Swagger: `[ApiExplorerSettings(GroupName = $"{ApiVersionInfo.V2025_07_17}")]`

## 🔧 Code Patterns

### Dependency Injection Registration

**Installer Pattern** (Preferred):
```csharp
public static class ApplicationInstaller
{
    public static IServiceCollection InstallApplicationDependencies(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Register services
        services.AddScoped<ITemplateService, TemplateService>();
        return services;
    }
}
```

### Error Handling

**API Controllers**:
```csharp
[HttpGet("{id}")]
public async Task<ActionResult<Template>> GetTemplate(int id)
{
    try
    {
        var request = new ReadTemplateRequest(id);
        var result = await _mediator.Send(request);
        return Ok(result);
    }
    catch (NotFoundException)
    {
        return NotFound();
    }
    catch (ValidationException ex)
    {
        return BadRequest(ex.Message);
    }
}
```

**Angular Services**:
```typescript
getTemplate(id: number): Observable<Template> {
  return this.http.get<Template>(`${this.baseUrl}/template/${id}`)
    .pipe(
      catchError(this.handleError<Template>('getTemplate'))
    );
}

private handleError<T>(operation = 'operation', result?: T) {
  return (error: any): Observable<T> => {
    console.error(`${operation} failed: ${error.message}`);
    return of(result as T);
  };
}
```

### Validation

**FluentValidation** for .NET:
```csharp
public class CreateTemplateCommandValidator : AbstractValidator<CreateTemplateCommand>
{
    public CreateTemplateCommandValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(100);
            
        RuleFor(x => x.Description)
            .NotEmpty()
            .MaximumLength(500);
    }
}
```

**Angular Forms**:
```typescript
templateForm = this.fb.group({
  name: ['', [Validators.required, Validators.maxLength(100)]],
  description: ['', [Validators.required, Validators.maxLength(500)]]
});
```

## 🗃️ Entity Framework & Data Access Patterns

### Entity Base Classes (vertex-dotnet-api-sdk)

**CRITICAL**: All entities MUST inherit from the appropriate base class from `SE.Sustainability.Vertex.Api.Sdk.Entities`:

#### Entity Hierarchy
```
LastUpdatedDateEntityBase (base)
    ├── MinimalEntityBase : LastUpdatedDateEntityBase  
    │   ├── EntityBase : MinimalEntityBase
    │   │   └── NamedEntityBase : EntityBase
    │   └── EntityAuditBase : LastUpdatedDateEntityBase
```

#### Base Class Selection Guide

**Use NamedEntityBase** (Most Common):
```csharp
public class Template : NamedEntityBase
{
    public string Description { get; set; } = default!;
    public TemplateStatus Status { get; set; }
    // Automatically includes: Id, Name, CreatedBy, CreatedDate, LastUpdatedBy, LastUpdatedDate
}

public class TemplateConfiguration : NamedEntityBaseConfiguration<Template>
{
    protected override string IdColumnName => "Template_Id";

    public override void Configure(EntityTypeBuilder<Template> builder)
    {
        base.Configure(builder);
        
        builder.ToTable("Templates");
        builder.Property(e => e.Description).HasMaxLength(1000);
        builder.Property(e => e.Status).HasConversion<string>();
    }
}
```

**Use EntityBase** (When Name is not needed):
```csharp
public class TemplateHistory : EntityBase
{
    public string TemplateId { get; set; } = default!;
    public string ChangeType { get; set; } = default!;
    public string ChangeData { get; set; } = default!;
    // Automatically includes: Id, CreatedBy, CreatedDate, LastUpdatedBy, LastUpdatedDate
}
```

**Use MinimalEntityBase** (Minimal tracking):
```csharp
public class TemplateCache : MinimalEntityBase
{
    public string CacheKey { get; set; } = default!;
    public string CacheValue { get; set; } = default!;
    // Automatically includes: Id, LastUpdatedDate
}
```

**Use EntityAuditBase** (Alternative audit pattern):
```csharp
public class TemplateAudit : EntityAuditBase
{
    public string EntityId { get; set; } = default!;
    public string Action { get; set; } = default!;
    // Automatically includes: CreatedBy, CreatedDate, LastUpdatedBy, LastUpdatedDate
}
```

### Repository Pattern (IEFRepository)

**CRITICAL**: All repositories MUST implement `IEFRepository<TEntity>` from `SE.Sustainability.Vertex.Api.Sdk.Interfaces`:

#### Repository Implementation
```csharp
public interface ITemplateRepository : IEFRepository<Template>
{
    Task<IEnumerable<Template>> GetTemplatesByStatusAsync(TemplateStatus status);
    Task<Template?> GetTemplateByNameAsync(string name);
}

public class TemplateRepository : EFRepository<Template>, ITemplateRepository
{
    public TemplateRepository(VertexDbContext context) : base(context)
    {
    }

    public async Task<IEnumerable<Template>> GetTemplatesByStatusAsync(TemplateStatus status)
    {
        var result = await GetAllAsync(
            configureWheres: query => query.Where(t => t.Status == status),
            orderBy: query => query.OrderBy(t => t.Name)
        );
        return result.Items;
    }

    public async Task<Template?> GetTemplateByNameAsync(string name)
    {
        var result = await GetAllAsync(
            pageSize: 1,
            configureWheres: query => query.Where(t => t.Name == name)
        );
        return result.Items.FirstOrDefault();
    }
}
```

#### Standard Repository Registration
```csharp
public static class InfrastructureInstaller
{
    public static IServiceCollection InstallInfrastructureDependencies(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Register repositories using the standard pattern
        services.AddScoped<ITemplateRepository, TemplateRepository>();
        
        return services;
    }
}
```

### Resource ID Standards

**Format**: `VARCHAR(54)` with pattern `<application>_<assetType>_<guid>`

#### Examples
```csharp
// IndicatorManagement domain examples
"im_ind_11a2b3c4d5e6f789012345678901ab"  // Indicator
"im_pd_11a2b3c4d5e6f789012345678901ab"   // Performance Data  
"im_ent_11a2b3c4d5e6f789012345678901ab"  // Entity

// Template domain examples  
"tm_tmp_11a2b3c4d5e6f789012345678901ab"  // Template
"tm_cat_11a2b3c4d5e6f789012345678901ab"  // Category
```

#### Resource ID Generation
```csharp
public static class ResourceIdGenerator
{
    public static string Generate(string application, string assetType)
    {
        var guid = Guid.NewGuid().ToString("N")[0..26]; // First 26 chars of GUID
        return $"{application}_{assetType}_{guid}";
    }
}

// Usage in entity creation
public class Template : NamedEntityBase
{
    public Template()
    {
        Id = ResourceIdGenerator.Generate("tm", "tmp");
    }
}
```

## 📦 Package Management

### .NET Packages
**Always Include**:
- `SE.Sustainability.Vertex.Api.Sdk` - Core functionality and base classes
- `MediatR` - CQRS implementation
- `FluentValidation` - Input validation
- `Microsoft.EntityFrameworkCore.SqlServer` - Data access

**Version Management**:
- Use consistent versions across projects
- Update packages regularly for security patches
- Pin versions in production deployments

### Angular Packages
**Always Include**:
- `@se-sustainability-business/vertex-ui-shared` - Component library
- `@angular/cdk` - Angular component dev kit
- `@fortawesome/angular-fontawesome` - Icon library

**Development Dependencies**:
- `eslint` + `angular-eslint` - Code linting
- `prettier` - Code formatting
- `husky` + `lint-staged` - Pre-commit hooks

## 🧪 Testing Standards

### .NET Testing
**Unit Tests**:
```csharp
[Fact]
public async Task Handle_ValidRequest_ReturnsTemplates()
{
    // Arrange
    var handler = new ReadTemplateHandler(_mockRepository.Object);
    var request = new ReadTemplateRequest(1);
    
    // Act
    var result = await handler.Handle(request, CancellationToken.None);
    
    // Assert
    result.Should().NotBeNull();
    result.Should().HaveCountGreaterThan(0);
}
```

**Integration Tests**:
```csharp
[Fact]
public async Task GetTemplate_ValidId_ReturnsOk()
{
    // Arrange
    var client = _factory.CreateClient();
    
    // Act
    var response = await client.GetAsync("/template/1");
    
    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.OK);
}
```

### Angular Testing
**Component Tests**:
```typescript
describe('TemplateListComponent', () => {
  let component: TemplateListComponent;
  let fixture: ComponentFixture<TemplateListComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [TemplateListComponent]
    });
    fixture = TestBed.createComponent(TemplateListComponent);
    component = fixture.componentInstance;
  });

  it('should display templates', () => {
    component.templates = mockTemplates;
    fixture.detectChanges();
    
    const templateElements = fixture.debugElement.queryAll(By.css('.template-item'));
    expect(templateElements.length).toBe(mockTemplates.length);
  });
});
```

## 🔐 Security Standards

### Authentication
- Use OAuth2/OIDC via `vertex-dotnet-api-sdk`
- Include correlation IDs in all requests
- Validate JWT tokens on every API call

### Authorization
- Implement role-based access control (RBAC)
- Use `[Authorize]` attributes on controllers
- Check permissions in Angular route guards

### Data Protection
- Never log sensitive information
- Use HTTPS for all communications
- Implement proper CORS policies
- Validate all inputs server-side

## 📝 Documentation Standards

### Code Comments
**XML Documentation** for .NET:
```csharp
/// <summary>
/// Retrieves a template by its unique identifier.
/// </summary>
/// <param name="id">The unique identifier of the template.</param>
/// <returns>A task that represents the asynchronous operation. The task result contains the template if found.</returns>
public async Task<Template?> GetTemplateAsync(int id)
```

**JSDoc** for Angular:
```typescript
/**
 * Retrieves a template by its ID
 * @param id - The unique identifier of the template
 * @returns Observable containing the template data
 */
getTemplate(id: number): Observable<Template> {
```

### README Requirements
Each project must include:
- Purpose and overview
- Setup instructions
- Environment requirements
- API documentation links
- Deployment procedures

## 🎨 CSS & Styling Standards

### CSS Logical Properties
**Preferred**: Use CSS logical properties over physical directional properties for better internationalization and RTL support.

**Use logical properties** (recommended):
```css
/* Logical properties (preferred) */
.example {
  margin-block-start: 1rem;      /* instead of margin-top */
  margin-block-end: 1rem;        /* instead of margin-bottom */
  margin-inline-start: 0.5rem;   /* instead of margin-left */
  margin-inline-end: 0.5rem;     /* instead of margin-right */
  
  padding: 1rem 0.5rem;          /* shorthand when values repeat */
  
  border-inline-start: 1px solid #ccc;  /* instead of border-left */
  border-inline-end: 1px solid #ccc;    /* instead of border-right */
  
  inset-block-start: 0;          /* instead of top */
  inset-block-end: 0;            /* instead of bottom */
  inset-inline-start: 0;         /* instead of left */
  inset-inline-end: 0;           /* instead of right */
}
```

**Avoid physical properties** (legacy):
```css
/* Physical properties (avoid when possible) */
.legacy-example {
  margin-top: 1rem;
  margin-bottom: 1rem;
  margin-left: 0.5rem;
  margin-right: 0.5rem;
  
  border-left: 1px solid #ccc;
  border-right: 1px solid #ccc;
  
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
}
```

### CSS Best Practices
- **Use shorthand properties** to avoid redundant values:
  - `padding: 1rem;` instead of `padding-top: 1rem; padding-right: 1rem; padding-bottom: 1rem; padding-left: 1rem;`
  - `padding: 1rem 0.5rem;` instead of `padding-top: 1rem; padding-right: 0.5rem; padding-bottom: 1rem; padding-left: 0.5rem;`
- **Use modern color notation**: `rgb(255 255 255 / 50%)` instead of `rgba(255, 255, 255, 0.5)`
- **Use percentage for alpha values**: `50%` instead of `0.5`
- **Order CSS properties** according to linting rules (typically: positioning, box model, typography, visual, misc)
- **Avoid `@apply` directives** in component stylesheets - use direct CSS properties for build stability

## 🚀 Performance Guidelines

### .NET Performance
- Use `async/await` for all I/O operations
- Implement caching for frequently accessed data
- Use `IAsyncEnumerable` for large datasets
- Profile database queries and optimize as needed

### Angular Performance
- Use `OnPush` change detection strategy
- Implement lazy loading for feature modules
- Use virtual scrolling for large lists
- Optimize bundle size with tree shaking

## 🔄 Git Workflow

### Commit Messages
Follow conventional commits:
```
feat(api): add template creation endpoint
fix(ui): resolve template list loading issue
docs(readme): update setup instructions
```

### Branch Naming
- `feature/[ticket-id]-brief-description`
- `bugfix/[ticket-id]-brief-description`
- `hotfix/[ticket-id]-brief-description`

### Pull Request Requirements
- Link to Jira ticket
- Include automated tests
- Pass all CI/CD checks
- Require code review approval
- Update documentation if needed

---

**Note for Cursor**: These standards ensure consistency across all Vertex projects. Always reference these patterns when implementing new features or refactoring existing code.
