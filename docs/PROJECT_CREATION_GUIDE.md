# Vertex Project Creation Guide

> **Purpose**: Step-by-step instructions for Cursor AI to create new Vertex projects following established patterns and conventions.

## 🎯 Project Creation Workflows

### Workflow 1: Complete New Application
When creating a brand new Vertex application with frontend, BFF, and Core API.

### Workflow 2: Frontend-Only Application
When creating a new Angular application that uses existing APIs.

### Workflow 3: API-Only Project
When creating a new backend service or extending existing functionality.

---

## 🚀 Workflow 1: Complete New Application

### Prerequisites Checklist
- [ ] Product Requirements Document (PRD) completed
- [ ] Technical Design Document (TDD) reviewed
- [ ] Domain name identified (e.g., "inventory", "reporting", "analytics")
- [ ] Database schema designed
- [ ] Authentication requirements defined

### Step 1: Project Planning
1. **Identify the domain name** (this will be used throughout)
   - Example: `inventory` for an inventory management system
   - Use lowercase, single word if possible
   - This becomes part of all project names

2. **Define project structure**:
   ```
   vertex-[domain]-ui/          # Angular frontend
   vertex-[domain]-bff/         # Backend-for-Frontend API  
   vertex-[domain]-api/         # Core CRUD API
   ```

### Step 2: Create Core API Project

#### 2.1 Copy and Rename Template
```bash
# Copy the API template
cp -r vertex-cursor-templates/DotNet_Angular/vertex-api-template/ vertex-[domain]-api/
cd vertex-[domain]-api/
```

#### 2.2 Update Project Names
**Replace all occurrences of:**
- `Template` → `[Domain]` (PascalCase, e.g., `Inventory`)
- `template` → `[domain]` (lowercase, e.g., `inventory`)

**Key files to update:**
```
service/SE.Sustainability.Vertex.Template.API/
├── SE.Sustainability.Vertex.Template.API.csproj → SE.Sustainability.Vertex.[Domain].API.csproj
├── TemplateApi.cs → [Domain]Api.cs
└── Controllers/TemplateController.cs → Controllers/[Domain]Controller.cs

service/SE.Sustainability.Vertex.Template.Core/
├── SE.Sustainability.Vertex.Template.Core.csproj → SE.Sustainability.Vertex.[Domain].Core.csproj
└── Features/Template/ → Features/[Domain]/

# Continue for all projects in the solution
```

#### 2.3 Update Namespaces
Replace all namespace declarations:
```csharp
// FROM
namespace SE.Sustainability.Vertex.Template.API;

// TO  
namespace SE.Sustainability.Vertex.[Domain].API;
```

#### 2.4 Update Domain Models
1. **Create domain entities** in `Infrastructure.SqlServer/Entities/`
2. **Create API models** in `API.Models/`
3. **Update DbContext** with your entity sets
4. **Create mappers** between entities and models

#### 2.5 Implement Core Features
Using CQRS pattern:

```csharp
// Example: Inventory domain
public record ReadInventoryItemRequest(int Id) : IRequest<IEnumerable<InventoryItem>>;

public class ReadInventoryItemHandler : IRequestHandler<ReadInventoryItemRequest, IEnumerable<InventoryItem>>
{
    // Implementation
}
```

### Step 3: Create BFF Project

#### 3.1 Copy and Rename Template
```bash
cp -r vertex-cursor-templates/DotNet_Angular/vertex-bff-template/ vertex-[domain]-bff/
cd vertex-[domain]-bff/
```

#### 3.2 Update Project References
1. **Replace Template references** with your domain
2. **Add Refit interface** for Core API communication:

```csharp
public interface I[Domain]CoreApi
{
    [Get("/api/[domain]")]
    Task<IEnumerable<[Domain]Item>> GetItemsAsync();
    
    [Post("/api/[domain]")]
    Task<[Domain]Item> CreateItemAsync([Body] Create[Domain]ItemCommand command);
}
```

#### 3.3 Implement BFF-Specific Logic
- **Data aggregation** from multiple sources
- **Response transformation** for UI needs
- **UI-specific validations**

### Step 4: Create Angular Project

#### 4.1 Copy and Rename Template
```bash
cp -r vertex-cursor-templates/DotNet_Angular/vertex-ui-template/ vertex-[domain]-ui/
cd vertex-[domain]-ui/
```

#### 4.2 Update Configuration Files

**package.json**:
```json
{
  "name": "vertex-[domain]-ui",
  "version": "0.0.0"
}
```

**angular.json**:
```json
{
  "projects": {
    "vertex-[domain]-ui": {
      "projectType": "application"
    }
  }
}
```

#### 4.3 Update Main Application File

**src/main.ts**:
```typescript
import { bootstrapVertexApplication } from '@se-sustainability-business/vertex-ui-shared/app';
import { routes } from './[domain].routes';

bootstrapVertexApplication({
  app: '[domain]',
  routes: routes,
}).catch((err: unknown) => {
  console.error(err);
});
```

#### 4.4 Create Feature Components
```typescript
// src/features/[domain]/components/[domain]-list.component.ts
@Component({
  selector: 'app-[domain]-list',
  standalone: true,
  imports: [CommonModule, VertexTableComponent],
  template: `
    <vx-table [data]="[domain]Items$ | async" [columns]="columns">
    </vx-table>
  `
})
export class [Domain]ListComponent {
  [domain]Items$ = this.[domain]Service.getItems();
  
  columns = [
    { key: 'id', label: 'ID' },
    { key: 'name', label: 'Name' },
    { key: 'description', label: 'Description' }
  ];
  
  constructor(private [domain]Service: [Domain]Service) {}
}
```

### Step 5: Configure Databases and Migrations

#### 5.1 Update Connection Strings
```json
// appsettings.json
{
  "ConnectionStrings": {
    "[Domain]Database": "Server=localhost;Database=Vertex[Domain];Trusted_Connection=true;"
  }
}
```

#### 5.2 Create Database Migrations
```csharp
// In Infrastructure.SqlServer/Migrations/
// Create DbUp migration scripts
// 001_Create_[Domain]_Tables.sql
CREATE TABLE [Domain]Items (
    Id int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Description nvarchar(500),
    CreatedDate datetime2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Step 6: Configure Development Environment

#### 6.1 Update Docker Compose (if used)
```yaml
# docker-compose.yml
services:
  vertex-[domain]-api:
    build: ./vertex-[domain]-api
    ports:
      - "5001:80"
  
  vertex-[domain]-bff:
    build: ./vertex-[domain]-bff
    ports:
      - "5002:80"
      
  vertex-[domain]-ui:
    build: ./vertex-[domain]-ui
    ports:
      - "4200:80"
```

#### 6.2 Configure Local Development
1. **Set up HTTPS certificates**
2. **Configure CORS policies**
3. **Set up local authentication**

---

## 🎨 Workflow 2: Frontend-Only Application

### When to Use
- Consuming existing APIs
- Creating dashboards or reporting interfaces
- Adding new UI functionality to existing services

### Step 1: Create Angular Project
```bash
cp -r vertex-cursor-templates/DotNet_Angular/vertex-ui-template/ vertex-[app-name]-ui/
cd vertex-[app-name]-ui/
```

### Step 2: Configure API Integration
```typescript
// src/config/api.config.ts
export const API_CONFIG = {
  coreApiUrl: 'https://api-core.vertex.com',
  bffApiUrl: 'https://api-bff.vertex.com',
  authUrl: 'https://auth.vertex.com'
};
```

### Step 3: Create API Services
```typescript
@Injectable({
  providedIn: 'root'
})
export class ExistingApiService {
  constructor(private http: HttpClient) {}
  
  getData(): Observable<DataModel[]> {
    return this.http.get<DataModel[]>(`${API_CONFIG.coreApiUrl}/data`);
  }
}
```

### Step 4: Implement Components
Follow the same component patterns as in Workflow 1, but focus on:
- **Data visualization**
- **Form handling**
- **User interactions**

---

## 🔧 Workflow 3: API-Only Project

### When to Use
- Creating microservices
- Extending existing functionality
- Building integration services

### Step 1: Choose Template Type

**For CRUD Operations** → Use `vertex-api-template`
**For BFF Services** → Use `vertex-bff-template`

### Step 2: Create Project Structure
```bash
cp -r vertex-cursor-templates/DotNet_Angular/vertex-api-template/ vertex-[service-name]-api/
```

### Step 3: Define Domain Models
```csharp
// API.Models/[Entity].cs
public class [Entity]
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime CreatedDate { get; set; }
}
```

### Step 4: Implement CQRS Features
```csharp
// Core/Features/[Entity]/Queries/
public record Get[Entity]Query(int Id) : IRequest<[Entity]>;

// Core/Features/[Entity]/Commands/  
public record Create[Entity]Command(string Name) : IRequest<[Entity]>;

// Core/Features/[Entity]/Handlers/
public class Get[Entity]Handler : IRequestHandler<Get[Entity]Query, [Entity]>
{
    // Implementation
}
```

### Step 5: Create API Controllers
```csharp
[ApiController]
[Route("[controller]")]
public class [Entity]Controller : VertexControllerBase
{
    private readonly IMediator _mediator;
    
    public [Entity]Controller(IMediator mediator)
    {
        _mediator = mediator;
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<[Entity]>> Get(int id)
    {
        var query = new Get[Entity]Query(id);
        var result = await _mediator.Send(query);
        return Ok(result);
    }
}
```

---

## ✅ Post-Creation Checklist

### Code Quality
- [ ] All placeholder names replaced
- [ ] Namespaces updated consistently  
- [ ] Project references correct
- [ ] No compilation errors
- [ ] Tests passing

### Configuration
- [ ] Connection strings updated
- [ ] Environment variables set
- [ ] CORS policies configured
- [ ] Authentication configured

### Documentation
- [ ] README updated with project specifics
- [ ] API documentation generated
- [ ] Deployment instructions created

### Security
- [ ] Authorization policies implemented
- [ ] Input validation in place
- [ ] Sensitive data protected
- [ ] HTTPS enforced

### DevOps
- [ ] CI/CD pipelines configured
- [ ] Docker files created
- [ ] Health checks implemented
- [ ] Logging configured

---

## 🔍 Common Patterns and Troubleshooting

### Pattern: Adding New Entity

1. **Create Entity** in Infrastructure layer
2. **Create Model** in API.Models
3. **Create Mapper** between Entity and Model
4. **Add DbSet** to DbContext
5. **Create Migration** script
6. **Implement CQRS** features
7. **Create Controller** endpoints
8. **Add Validation** rules
9. **Write Tests**

### Pattern: Adding External Integration

1. **Create Interface** in Core layer
2. **Implement Service** in Infrastructure layer
3. **Register in DI** container
4. **Create Configuration** section
5. **Add Error Handling**
6. **Implement Retry Logic**
7. **Add Integration Tests**

### Troubleshooting Common Issues

#### Build Errors
- Check all namespace references
- Verify project dependencies
- Ensure NuGet packages restored

#### Runtime Errors
- Check connection strings
- Verify database exists
- Check authentication configuration

#### Performance Issues
- Review database queries
- Check caching implementation
- Monitor API response times

---

**Note for Cursor**: This guide provides the systematic approach to creating Vertex projects. Always follow the established patterns and update documentation as you go. Each step builds upon the previous one, so complete them in order for best results.
