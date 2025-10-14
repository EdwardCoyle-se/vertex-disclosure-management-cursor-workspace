# Common Vertex Implementation Patterns

> **Purpose**: Examples and patterns that Cursor AI should reference when implementing common scenarios in Vertex projects. These examples are based on **currently implemented** patterns in your templates.

## 📚 Table of Contents

1. [CQRS Implementation Patterns](#cqrs-implementation-patterns)
2. [API Controller Patterns](#api-controller-patterns)
3. [Angular Component Patterns](#angular-component-patterns)
4. [Validation Patterns](#validation-patterns)
5. [Service Integration Patterns](#service-integration-patterns)

---

## 🔄 CQRS Implementation Patterns

### Basic Query Pattern (Currently Implemented)

Based on your `ReadTemplateHandler` and `ReadTemplateRequest`:

```csharp
// Query Request
public record ReadTemplateRequest(int Id) : IRequest<IEnumerable<API.Models.Template>>;

// Query Handler
public class ReadTemplateHandler : IRequestHandler<ReadTemplateRequest, IEnumerable<API.Models.Template>>
{
    private readonly IEFRepository<TemplateEntity> _templateRepository;
    
    public ReadTemplateHandler(IEFRepository<TemplateEntity> templateRepository)
    {
        _templateRepository = templateRepository;
    }
    
    public async Task<IEnumerable<API.Models.Template>> Handle(ReadTemplateRequest request, CancellationToken cancellationToken)
    {
        var results = await _templateRepository.GetAllAsync();
        return results.Data.Select(TemplateMapper.TemplateEntityToTemplate) ?? [];
    }
}
```

### Command Pattern (Template for Implementation)

Following the same pattern as the query, implement commands like this:

```csharp
// Command Request
public record CreateTemplateCommand(string Name, string Description) : IRequest<API.Models.Template>;

// Command Handler
public class CreateTemplateHandler : IRequestHandler<CreateTemplateCommand, API.Models.Template>
{
    private readonly IEFRepository<TemplateEntity> _templateRepository;
    
    public CreateTemplateHandler(IEFRepository<TemplateEntity> templateRepository)
    {
        _templateRepository = templateRepository;
    }
    
    public async Task<API.Models.Template> Handle(CreateTemplateCommand request, CancellationToken cancellationToken)
    {
        var entity = new TemplateEntity
        {
            Name = request.Name,
            Description = request.Description
        };
        
        var result = await _templateRepository.CreateAsync(entity);
        
        if (!result.Success)
            throw new InvalidOperationException("Failed to create template");
            
        return TemplateMapper.TemplateEntityToTemplate(result.Data);
    }
}
```

---

## 🎮 API Controller Patterns

### Basic Controller (Currently Implemented)

Based on your `TemplateController`:

```csharp
[ApiController]
[Route("[controller]")]
[ApiVersion(ApiVersionInfo.V2025_07_17)]
[ApiExplorerSettings(GroupName = $"{ApiVersionInfo.V2025_07_17}")]
public class TemplateController : VertexControllerBase
{
    private readonly IMediator _mediator;
    
    public TemplateController(ILogger<TemplateController> logger, IMediator mediator) 
        : base(logger)
    {
        _mediator = mediator;
    }
    
    /// <summary>
    /// Retrieves a collection of template data objects.
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Models.Template>>> GetTemplate()
    {
        var request = new ReadTemplateRequest(1);
        var response = await _mediator.Send(request);
        return Ok(response);
    }
}
```

### Expanded Controller Pattern (Template for Implementation)

Following the same pattern, add more endpoints:

```csharp
[ApiController]
[Route("[controller]")]
[ApiVersion(ApiVersionInfo.V2025_07_17)]
[ApiExplorerSettings(GroupName = $"{ApiVersionInfo.V2025_07_17}")]
public class TemplateController : VertexControllerBase
{
    private readonly IMediator _mediator;
    
    public TemplateController(ILogger<TemplateController> logger, IMediator mediator) 
        : base(logger)
    {
        _mediator = mediator;
    }
    
    /// <summary>
    /// Retrieves all templates
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Models.Template>>> GetTemplates()
    {
        var request = new ReadTemplatesRequest();
        var response = await _mediator.Send(request);
        return Ok(response);
    }
    
    /// <summary>
    /// Retrieves a specific template by ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<Models.Template>> GetTemplate(int id)
    {
        var request = new ReadTemplateRequest(id);
        var response = await _mediator.Send(request);
        return Ok(response);
    }
    
    /// <summary>
    /// Creates a new template
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<Models.Template>> CreateTemplate([FromBody] CreateTemplateCommand command)
    {
        var result = await _mediator.Send(command);
        return CreatedAtAction(nameof(GetTemplate), new { id = result.Id }, result);
    }
    
    /// <summary>
    /// Updates an existing template
    /// </summary>
    [HttpPut("{id}")]
    public async Task<ActionResult<Models.Template>> UpdateTemplate(int id, [FromBody] UpdateTemplateCommand command)
    {
        var result = await _mediator.Send(command);
        return Ok(result);
    }
    
    /// <summary>
    /// Deletes a template
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteTemplate(int id)
    {
        var command = new DeleteTemplateCommand(id);
        await _mediator.Send(command);
        return NoContent();
    }
}
```

---

## 🎨 Angular Component Patterns

### Basic Standalone Component (Currently Implemented)

Based on your `DemoComponent`:

```typescript
import { Component } from '@angular/core';
import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate';

@Component({
  selector: 'vx-demo',
  templateUrl: './demo.component.html',
  imports: [TranslatePipe],
})
export class DemoComponent {}
```

**Template (`demo.component.html`):**
```html
<div class="flex h-screen flex-col items-center justify-center">
  <div class="border border-black p-3">
    Translations:
    <div>In MicroApp en.json: {{ 'measure.micro' | translate }}</div>
    <div>In MicroApp en.json: {{ 'measure.businessEntity' | translate }}</div>
    <div>In shared en.json: {{ 'shared.businessEntity' | translate }}</div>
  </div>
</div>
```

### Main Application Bootstrap (Currently Implemented)

Based on your `main.ts`:

```typescript
import { bootstrapVertexApplication } from '@se-sustainability-business/vertex-ui-shared/app';
import { routes } from './demo.routes';

bootstrapVertexApplication({
  // Replace with [YOUR_MICRO_APP_NAME_HERE]
  app: 'home',
  // [YOUR_MICRO_APP_NAME_HERE], see readme for more info
  routes: routes,
}).catch((err: unknown) => {
  console.error(err);
});
```

### Basic Routing (Currently Implemented)

Based on your `demo.routes.ts`:

```typescript
import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./routes/demo/demo.component').then((m) => m.DemoComponent),
  },
];
```

### Component Pattern Template (For Implementation)

Follow this pattern when creating new components:

```typescript
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate';

@Component({
  selector: 'vx-your-component',
  standalone: true,
  imports: [CommonModule, TranslatePipe],
  template: `
    <div class="component-container">
      <h2>{{ 'your.translation.key' | translate }}</h2>
      <!-- Your component content -->
    </div>
  `,
  styleUrls: ['./your-component.component.scss']
})
export class YourComponent {
  // Component logic
}
```

---

## ✅ Validation Patterns

### FluentValidation (Currently Implemented)

Based on your `ReadTemplateRequestValidator`:

```csharp
public class ReadTemplateRequestValidator : AbstractValidator<ReadTemplateRequest>
{
    public ReadTemplateRequestValidator()
    {
        RuleFor(x => x.Id)
            .GreaterThan(0).WithMessage("The ID must be a positive number.");
    }
}
```

### Extended Validation Pattern (Template for Implementation)

Following the same pattern, create more comprehensive validators:

```csharp
public class CreateTemplateCommandValidator : AbstractValidator<CreateTemplateCommand>
{
    public CreateTemplateCommandValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .WithMessage("Name is required")
            .MaximumLength(100)
            .WithMessage("Name cannot exceed 100 characters");
            
        RuleFor(x => x.Description)
            .MaximumLength(500)
            .WithMessage("Description cannot exceed 500 characters");
    }
}
```

---

## 🔗 Service Integration Patterns

### Dependency Injection (Currently Implemented)

Based on your `ApplicationInstaller`:

```csharp
public static class ApplicationInstaller
{
    public static IServiceCollection InstallApplicationDependencies(this IServiceCollection services, IConfigurationRoot config)
    {
        services.Configure<SupportedIssuersOptions>(config.GetSection(SupportedIssuersOptions.CONFIGURATION_SECTION));
        
        // Setup the EnvironmentOptions
        var environmentOptions = new EnvironmentOptions
        {
            Environment = EnvironmentExtensions.AppEnvironment
        };
        
        services.AddSingleton(environmentOptions);
        services.AddSingleton<PolicyCreator>();
        services.AddTransient<ClaimsService>();

        // Exception handling options and global filter
        services.Configure<ExceptionHandlingOptions>(config.GetSection(ExceptionHandlingOptions.ConfigurationSection));
        services.AddControllers(options =>
        {
            options.Filters.Add<HttpResultProcessingFilter>();
        });
        services.AddScoped<HttpResultProcessingFilter>();

        return services;
    }
}
```

### Health Checks (Currently Implemented)

Based on your `HealthCheck` implementation:

```csharp
public class HealthCheck : IHealthCheck
{
    public Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        return Task.FromResult(HealthCheckResult.Healthy("Healthy"));
    }
}
```

---

**Note for Cursor**: These patterns are based on what's **actually implemented** in your current templates. For additional patterns and enhancements, see `docs/RECOMMENDED_ADDITIONS.md`.
