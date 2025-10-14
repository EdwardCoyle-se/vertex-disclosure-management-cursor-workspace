# Example Project Structure

> **Purpose**: Shows Cursor AI exactly how to structure a complete Vertex project with all necessary files and folders.

## 📁 Complete Project Structure Example

This example shows the structure for a hypothetical "Inventory Management" system using domain name `inventory`.

```
vertex-inventory-solution/
├── vertex-inventory-ui/                           # Angular Frontend
│   ├── src/
│   │   ├── app/
│   │   │   ├── features/
│   │   │   │   └── inventory/
│   │   │   │       ├── components/
│   │   │   │       │   ├── inventory-list/
│   │   │   │       │   │   ├── inventory-list.component.ts
│   │   │   │       │   │   ├── inventory-list.component.html
│   │   │   │       │   │   └── inventory-list.component.scss
│   │   │   │       │   ├── inventory-form/
│   │   │   │       │   │   ├── inventory-form.component.ts
│   │   │   │       │   │   ├── inventory-form.component.html
│   │   │   │       │   │   └── inventory-form.component.scss
│   │   │   │       │   └── inventory-dashboard/
│   │   │   │       │       ├── inventory-dashboard.component.ts
│   │   │   │       │       ├── inventory-dashboard.component.html
│   │   │   │       │       └── inventory-dashboard.component.scss
│   │   │   │       ├── services/
│   │   │   │       │   ├── inventory.service.ts
│   │   │   │       │   └── inventory-state.service.ts
│   │   │   │       ├── models/
│   │   │   │       │   ├── inventory-item.model.ts
│   │   │   │       │   ├── create-inventory-item.model.ts
│   │   │   │       │   └── inventory-search-params.model.ts
│   │   │   │       └── guards/
│   │   │   │           └── inventory.guard.ts
│   │   │   ├── shared/
│   │   │   │   ├── components/
│   │   │   │   ├── services/
│   │   │   │   └── models/
│   │   │   └── core/
│   │   │       ├── services/
│   │   │       │   ├── config.service.ts
│   │   │       │   └── auth.service.ts
│   │   │       └── interceptors/
│   │   │           ├── auth.interceptor.ts
│   │   │           └── error.interceptor.ts
│   │   ├── inventory.routes.ts
│   │   ├── main.ts
│   │   ├── index.html
│   │   └── styles.css
│   ├── public/
│   │   ├── config/
│   │   │   ├── config.json
│   │   │   └── config.non.json
│   │   └── i18n/
│   │       └── inventory/
│   │           └── en.json
│   ├── angular.json
│   ├── package.json
│   ├── tsconfig.json
│   ├── eslint.config.js
│   └── README.md
│
├── vertex-inventory-bff/                          # Backend-for-Frontend API
│   ├── service/
│   │   ├── SE.Sustainability.Vertex.Inventory.BFF.API/
│   │   │   ├── Controllers/
│   │   │   │   ├── InventoryController.cs
│   │   │   │   └── InventoryDashboardController.cs
│   │   │   ├── Models/
│   │   │   │   ├── InventoryDashboardModel.cs
│   │   │   │   └── InventorySearchRequest.cs
│   │   │   ├── Services/
│   │   │   │   └── IInventoryCoreApi.cs         # Refit interface
│   │   │   ├── Installers/
│   │   │   │   ├── ApplicationInstaller.cs
│   │   │   │   └── RefitInstaller.cs
│   │   │   ├── Authentication/
│   │   │   │   └── AuthConfig.cs
│   │   │   ├── appsettings.json
│   │   │   ├── appsettings.local.json
│   │   │   ├── Program.cs
│   │   │   ├── InventoryBffApi.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.BFF.API.csproj
│   │   ├── SE.Sustainability.Vertex.Inventory.BFF.Core/
│   │   │   ├── Features/
│   │   │   │   └── Dashboard/
│   │   │   │       ├── Queries/
│   │   │   │       │   └── GetDashboardDataQuery.cs
│   │   │   │       └── Handlers/
│   │   │   │           └── GetDashboardDataHandler.cs
│   │   │   ├── Extensions/
│   │   │   │   └── ServiceCollectionExtensions.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.BFF.Core.csproj
│   │   └── SE.Sustainability.Vertex.Inventory.BFF.sln
│   ├── Dockerfile
│   ├── Makefile
│   └── README.md
│
├── vertex-inventory-api/                          # Core CRUD API
│   ├── service/
│   │   ├── SE.Sustainability.Vertex.Inventory.API/
│   │   │   ├── Controllers/
│   │   │   │   └── InventoryController.cs
│   │   │   ├── Installers/
│   │   │   │   ├── ApplicationInstaller.cs
│   │   │   │   └── DbInstaller.cs
│   │   │   ├── Authentication/
│   │   │   │   └── AuthConfig.cs
│   │   │   ├── Filters/
│   │   │   │   └── ValidationFilter.cs
│   │   │   ├── Options/
│   │   │   │   └── DatabaseOptions.cs
│   │   │   ├── appsettings.json
│   │   │   ├── appsettings.local.json
│   │   │   ├── Program.cs
│   │   │   ├── InventoryApi.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.API.csproj
│   │   │
│   │   ├── SE.Sustainability.Vertex.Inventory.API.Models/
│   │   │   ├── InventoryItem.cs
│   │   │   ├── CreateInventoryItemRequest.cs
│   │   │   ├── UpdateInventoryItemRequest.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.API.Models.csproj
│   │   │
│   │   ├── SE.Sustainability.Vertex.Inventory.Core/
│   │   │   ├── Features/
│   │   │   │   └── Inventory/
│   │   │   │       ├── Commands/
│   │   │   │       │   ├── CreateInventoryItemCommand.cs
│   │   │   │       │   ├── UpdateInventoryItemCommand.cs
│   │   │   │       │   └── DeleteInventoryItemCommand.cs
│   │   │   │       ├── Queries/
│   │   │   │       │   ├── GetInventoryItemQuery.cs
│   │   │   │       │   └── GetInventoryItemsQuery.cs
│   │   │   │       ├── Handlers/
│   │   │   │       │   ├── CreateInventoryItemHandler.cs
│   │   │   │       │   ├── UpdateInventoryItemHandler.cs
│   │   │   │       │   ├── DeleteInventoryItemHandler.cs
│   │   │   │       │   ├── GetInventoryItemHandler.cs
│   │   │   │       │   └── GetInventoryItemsHandler.cs
│   │   │   │       └── Validators/
│   │   │   │           ├── CreateInventoryItemValidator.cs
│   │   │   │           └── UpdateInventoryItemValidator.cs
│   │   │   ├── Extensions/
│   │   │   │   └── ServiceCollectionExtensions.cs
│   │   │   ├── Mappers/
│   │   │   │   └── InventoryItemMapper.cs
│   │   │   ├── Interfaces/
│   │   │   │   └── IInventoryRepository.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.Core.csproj
│   │   │
│   │   ├── SE.Sustainability.Vertex.Inventory.Core.CrossCutting/
│   │   │   ├── InventoryConstants.cs
│   │   │   ├── ApiVersionInfo.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.Core.CrossCutting.csproj
│   │   │
│   │   ├── SE.Sustainability.Vertex.Inventory.Infrastructure.SqlServer/
│   │   │   ├── Entities/
│   │   │   │   └── InventoryItemEntity.cs
│   │   │   ├── Configurations/
│   │   │   │   └── InventoryItemConfiguration.cs
│   │   │   ├── Repositories/
│   │   │   │   └── InventoryRepository.cs
│   │   │   ├── Migrations/
│   │   │   │   ├── 001_Create_InventoryItems_Table.sql
│   │   │   │   └── 002_Add_InventoryItem_Indexes.sql
│   │   │   ├── InventoryDbContext.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.Infrastructure.SqlServer.csproj
│   │   │
│   │   ├── SE.Sustainability.Vertex.Inventory.Unit.Test/
│   │   │   ├── Features/
│   │   │   │   └── Inventory/
│   │   │   │       ├── Handlers/
│   │   │   │       │   ├── CreateInventoryItemHandlerTests.cs
│   │   │   │       │   └── GetInventoryItemHandlerTests.cs
│   │   │   │       └── Validators/
│   │   │   │           └── CreateInventoryItemValidatorTests.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.Unit.Test.csproj
│   │   │
│   │   ├── SE.Sustainability.Vertex.Inventory.Integration.Test/
│   │   │   ├── Controllers/
│   │   │   │   └── InventoryControllerTests.cs
│   │   │   ├── Infrastructure/
│   │   │   │   └── TestFixture.cs
│   │   │   └── SE.Sustainability.Vertex.Inventory.Integration.Test.csproj
│   │   │
│   │   └── SE.Sustainability.Vertex.Inventory.sln
│   ├── Dockerfile
│   ├── Makefile
│   └── README.md
│
├── docs/                                          # Project Documentation
│   ├── api/
│   │   ├── swagger.json
│   │   └── postman_collection.json
│   ├── architecture/
│   │   ├── system-overview.md
│   │   └── data-model.md
│   └── deployment/
│       ├── local-setup.md
│       └── azure-deployment.md
│
├── docker-compose.yml                             # Local development
├── docker-compose.override.yml                   # Local overrides
├── .gitignore
└── README.md                                      # Solution overview
```

## 📝 Key File Examples

### 1. Main Angular Application (main.ts)
```typescript
import { bootstrapVertexApplication } from '@se-sustainability-business/vertex-ui-shared/app';
import { routes } from './inventory.routes';

bootstrapVertexApplication({
  app: 'inventory',
  routes: routes,
  appBaseHref: '/inventory/',
  translateModules: ['shared', 'inventory']
}).catch((err: unknown) => {
  console.error(err);
});
```

### 2. Angular Routes (inventory.routes.ts)
```typescript
import { Routes } from '@angular/router';
import { InventoryGuard } from './app/features/inventory/guards/inventory.guard';

export const routes: Routes = [
  {
    path: '',
    canActivate: [InventoryGuard],
    children: [
      {
        path: '',
        loadComponent: () =>
          import('./app/features/inventory/components/inventory-list/inventory-list.component')
            .then(m => m.InventoryListComponent),
      },
      {
        path: 'create',
        loadComponent: () =>
          import('./app/features/inventory/components/inventory-form/inventory-form.component')
            .then(m => m.InventoryFormComponent),
      },
      {
        path: ':id/edit',
        loadComponent: () =>
          import('./app/features/inventory/components/inventory-form/inventory-form.component')
            .then(m => m.InventoryFormComponent),
      },
      {
        path: 'dashboard',
        loadComponent: () =>
          import('./app/features/inventory/components/inventory-dashboard/inventory-dashboard.component')
            .then(m => m.InventoryDashboardComponent),
      }
    ]
  }
];
```

### 3. API Startup (InventoryApi.cs)
```csharp
using SE.Sustainability.Vertex.Api.Sdk;
using SE.Sustainability.Vertex.Inventory.API.Installers;
using SE.Sustainability.Vertex.Inventory.Core.CrossCutting;
using SE.Sustainability.Vertex.Inventory.Core.Extensions;

namespace SE.Sustainability.Vertex.Inventory.API;

public class InventoryApi(string[] args) : VertexApiBase<InventoryApi>(args)
{
    protected override string ApplicationName => "Inventory API";
    protected override IReadOnlyCollection<string> ApiVersions => ApiVersionInfo.AllVersions;
    protected override IReadOnlyCollection<Assembly> XmlDocumentationAssemblies => [
        Assembly.GetExecutingAssembly(),
        typeof(API.Models.InventoryItem).Assembly,
        typeof(InventoryConstants).Assembly,
    ];

    protected override void ConfigureServices()
    {
        base.ConfigureServices();

        Services
            .InstallDbDependencies(Builder.Configuration)
            .InstallApplicationDependencies(Builder.Configuration);

        Builder.Services.AddCoreApplication(Builder.Configuration);
    }

    protected override void UseApplicationMiddleware()
    {
        base.UseApplicationMiddleware();
        WebApplication.UseHttpsRedirection();
    }
}
```

### 4. DbContext (InventoryDbContext.cs)
```csharp
using Microsoft.EntityFrameworkCore;
using SE.Sustainability.Vertex.Inventory.Infrastructure.SqlServer.Entities;
using SE.Sustainability.Vertex.Inventory.Infrastructure.SqlServer.Configurations;

namespace SE.Sustainability.Vertex.Inventory.Infrastructure.SqlServer;

public class InventoryDbContext : DbContext
{
    public InventoryDbContext(DbContextOptions<InventoryDbContext> options) : base(options) { }

    public DbSet<InventoryItemEntity> InventoryItems { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        modelBuilder.ApplyConfiguration(new InventoryItemConfiguration());
    }
}
```

### 5. Entity Configuration (InventoryItemConfiguration.cs)
```csharp
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SE.Sustainability.Vertex.Inventory.Infrastructure.SqlServer.Entities;

namespace SE.Sustainability.Vertex.Inventory.Infrastructure.SqlServer.Configurations;

public class InventoryItemConfiguration : IEntityTypeConfiguration<InventoryItemEntity>
{
    public void Configure(EntityTypeBuilder<InventoryItemEntity> builder)
    {
        builder.ToTable("InventoryItems");
        
        builder.HasKey(e => e.Id);
        
        builder.Property(e => e.Name)
            .IsRequired()
            .HasMaxLength(100);
            
        builder.Property(e => e.Description)
            .HasMaxLength(500);
            
        builder.Property(e => e.Quantity)
            .IsRequired()
            .HasColumnType("decimal(18,2)");
            
        builder.Property(e => e.CreatedDate)
            .IsRequired()
            .HasDefaultValueSql("GETUTCDATE()");
            
        builder.Property(e => e.CreatedBy)
            .IsRequired()
            .HasMaxLength(100);
            
        builder.HasIndex(e => e.Name)
            .HasDatabaseName("IX_InventoryItems_Name");
    }
}
```

### 6. Docker Compose (docker-compose.yml)
```yaml
version: '3.8'

services:
  vertex-inventory-ui:
    build:
      context: ./vertex-inventory-ui
      dockerfile: Dockerfile
    ports:
      - "4200:80"
    environment:
      - NODE_ENV=development
    depends_on:
      - vertex-inventory-bff

  vertex-inventory-bff:
    build:
      context: ./vertex-inventory-bff
      dockerfile: Dockerfile
    ports:
      - "5002:80"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__DefaultConnection=Server=sql-server;Database=VertexInventory;User Id=sa;Password=YourPassword123!;TrustServerCertificate=true;
      - ExternalApis__InventoryCoreApi=http://vertex-inventory-api
    depends_on:
      - vertex-inventory-api
      - sql-server

  vertex-inventory-api:
    build:
      context: ./vertex-inventory-api
      dockerfile: Dockerfile
    ports:
      - "5001:80"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__DefaultConnection=Server=sql-server;Database=VertexInventory;User Id=sa;Password=YourPassword123!;TrustServerCertificate=true;
    depends_on:
      - sql-server

  sql-server:
    image: mcr.microsoft.com/mssql/server:2022-latest
    ports:
      - "1433:1433"
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=YourPassword123!
    volumes:
      - sql-data:/var/opt/mssql

volumes:
  sql-data:
```

### 7. Solution README.md
```markdown
# Vertex Inventory Management System

## Overview
Complete inventory management solution built with Vertex architecture patterns.

## Architecture
- **Frontend**: Angular 20+ with vertex-ui-shared components
- **BFF**: .NET 8 Backend-for-Frontend API
- **Core API**: .NET 8 CRUD API with Clean Architecture
- **Database**: SQL Server with Entity Framework Core

## Getting Started

### Prerequisites
- Node.js 18+
- .NET 8 SDK
- SQL Server (or Docker)
- FontAwesome token
- GitHub PAT for private packages

### Local Development
```bash
# Start all services
docker-compose up -d

# Or run individually:
cd vertex-inventory-ui && npm start
cd vertex-inventory-bff && dotnet run
cd vertex-inventory-api && dotnet run
```

### Database Setup
```bash
cd vertex-inventory-api
dotnet ef database update
```

## Project Structure
- `/vertex-inventory-ui` - Angular frontend application
- `/vertex-inventory-bff` - Backend-for-Frontend API
- `/vertex-inventory-api` - Core domain API
- `/docs` - Documentation and API specs

## API Documentation
- Core API: http://localhost:5001/swagger
- BFF API: http://localhost:5002/swagger

## Contributing
Follow the Vertex coding standards and patterns defined in the documentation.
```

---

**Note for Cursor**: This structure provides a complete, realistic example of how to organize a Vertex project. Use this as a template and adapt the domain-specific elements (inventory → your domain) while maintaining the overall structure and patterns.
