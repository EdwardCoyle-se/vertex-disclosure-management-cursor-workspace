# Vertex Cursor Templates

> **Purpose**: This repository provides comprehensive templates and patterns for Cursor AI to understand and implement Vertex project architecture, coding standards, and development workflows.

## 🎯 Repository Overview

This repository serves as the **single source of truth** for Cursor AI when working on new Vertex projects. It contains:

1. **ProductDesign/** - Templates for creating PRDs and Technical Design Documents
2. **DotNet_Angular/** - Complete architecture templates for .NET + Angular applications

## 🚀 Quick Start for Cursor

### New Project Creation Workflow

1. **Product Team**: Place documentation in `ProductDesign/docs/`
2. **Use Master Prompt**: Follow `ProductDesign/MASTER_PROMPT.md` for complete project setup
3. **Create Documents**: Generate PRD, TDD, and progress tracking files
4. **Implement in Order**: Core API → BFF → Frontend (see `ProductDesign/WORKFLOW_GUIDE.md`)

### For Understanding Existing Patterns

1. **Analyze ProductDesign/** to understand requirements gathering
2. **Reference DotNet_Angular/** for architecture patterns
3. **Follow the coding standards** defined in `/docs/CODING_STANDARDS.md`
4. **Use the project templates** as starting points

## 📁 Directory Structure

```
vertex-cursor-templates/
├── ProductDesign/                    # Requirements & Design Templates
│   ├── PRD_Template.md              # Product Requirements Document template
│   ├── TDD_Template.md              # Technical Design Document template
│   └── Documentation/               # Source materials for PRD generation
├── DotNet_Angular/                  # .NET + Angular Architecture Templates
│   ├── vertex-api-template/         # Core CRUD API (Clean Architecture)
│   ├── vertex-bff-template/         # Backend-for-Frontend service
│   ├── vertex-dotnet-api-sdk/       # Shared SDK for authentication & observability
│   ├── vertex-ui-shared/            # Angular component library
│   └── vertex-ui-template/          # Angular application template
└── docs/                           # Documentation & Standards
    ├── CODING_STANDARDS.md
    ├── ARCHITECTURE_GUIDE.md
    └── PROJECT_CREATION_GUIDE.md
```

## 🏗️ Architecture Patterns

### Three-Tier Application Structure

Each Vertex project follows this pattern:

1. **Angular Frontend** (`vertex-ui-template`)
   - Standalone Angular application
   - Uses `@se-sustainability-business/vertex-ui-shared` components
   - Communicates only with BFF service

2. **BFF Service** (`vertex-bff-template`) 
   - Backend-for-Frontend API
   - Transforms data for UI consumption
   - Calls Core API via Refit interfaces
   - Clean Architecture with CQRS/MediatR

3. **Core API** (`vertex-api-template`)
   - Pure CRUD operations with business logic
   - Clean Architecture with CQRS/MediatR
   - Entity Framework with SQL Server
   - DbUp for migrations

### Shared Libraries

- **vertex-dotnet-api-sdk**: Authentication, observability, common patterns
- **vertex-ui-shared**: Angular components, services, and utilities

## 📋 Project Creation Workflow

### For Product Teams:
1. Create documentation in `ProductDesign/Documentation/`
2. Use `ProductDesign/PRD_Template.md` to generate PRD
3. Use `ProductDesign/TDD_Template.md` to create technical design

### For Development Teams:
1. **Fork/Copy Templates**: Start with templates from `DotNet_Angular/`
2. **Follow Naming Conventions**: Replace placeholder names consistently
3. **Implement Clean Architecture**: Follow the established patterns
4. **Use Shared Libraries**: Leverage existing SDKs and component libraries

## 🎨 Coding Standards

### .NET Backend Standards
- **Clean Architecture**: Strict separation of concerns
- **CQRS Pattern**: Commands/Queries via MediatR
- **Repository Pattern**: Entity Framework repositories
- **Dependency Injection**: Service registration in installers
- **API Versioning**: Date-based versioning (e.g., `2025-07-17`)

### Angular Frontend Standards
- **Standalone Components**: Modern Angular architecture
- **Shared Component Library**: Use `vertex-ui-shared`
- **Routing**: Lazy-loaded feature modules
- **State Management**: Service-based state with observables

### Common Patterns
- **Error Handling**: Consistent error responses
- **Logging**: Structured logging with correlation IDs
- **Authentication**: OAuth2/OIDC via vertex-dotnet-api-sdk
- **Testing**: Unit, integration, and E2E test coverage

## 🔍 Key Files to Reference

### For Project Creation Workflow:
- `ProductDesign/MASTER_PROMPT.md` - **START HERE** for new projects
- `ProductDesign/WORKFLOW_GUIDE.md` - Complete workflow documentation
- `ProductDesign/PRD_Template.md` - Product Requirements Document template
- `ProductDesign/TDD_Template.md` - Technical Design Document template
- `docs/PROGRESS_TEMPLATES/` - Progress tracking templates for each service

### For Understanding Architecture:
- `DotNet_Angular/vertex-api-template/service/SE.Sustainability.Vertex.Template.API/TemplateApi.cs`
- `DotNet_Angular/vertex-bff-template/service/SE.Sustainability.Vertex.BFF.Template.API/TemplateApi.cs`
- `DotNet_Angular/vertex-ui-template/src/main.ts`

### For Understanding Patterns:
- `DotNet_Angular/vertex-api-template/service/SE.Sustainability.Vertex.Template.Core/Features/`
- `DotNet_Angular/vertex-api-template/service/SE.Sustainability.Vertex.Template.API/Controllers/`
- `DotNet_Angular/vertex-ui-template/src/demo.routes.ts`

### 🚨 Critical Rules:
- **MUST READ**: `docs/CRITICAL_RULES.md` - Mandatory development rules
- **Component Hierarchy**: 1) vertex-ui-shared, 2) Quartz, 3) Custom reusable (track in `docs/CUSTOM_COMPONENTS.md`)
- **Translations**: Use ONLY `{{ 'module.key' | translate }}` for user-facing text
- **Accessibility**: MUST meet WCAG 2.1 AA standards with ESLint + axe DevTools testing
- **vertex-dotnet-api-sdk**: Use ONLY SDK base classes for all entities
- **DbUp Migrations**: Use ONLY DbUp for database migrations (NEVER EF Core migrations)

## 🛠️ Development Guidelines

## 🔄 Placeholder Replacement Guide

When creating a new project, you'll need to replace different placeholder patterns across the templates. Here's your complete reference:

| Template Type | Find | Replace With | Example |
|---------------|------|-------------|---------|
| **Backend (.NET)** | `Template` | `[Domain]` | `Template` → `Inventory` |
| **Backend (.NET)** | `template` | `[domain]` | `template` → `inventory` |
| **Frontend (Angular)** | `[YOUR_MICRO_APP_NAME_HERE]` | `[domain]` | `[YOUR_MICRO_APP_NAME_HERE]` → `inventory` |
| **Frontend (Angular)** | `vertex-ui-template` | `vertex-ui-[domain]` | `vertex-ui-template` → `vertex-ui-inventory` |
| **Namespaces** | `SE.Sustainability.Vertex.Template` | `SE.Sustainability.Vertex.[Domain]` | → `SE.Sustainability.Vertex.Inventory` |
| **Resource IDs** | `tm_` (template prefix) | `[domain-abbrev]_` | `tm_tmp_...` → `inv_itm_...` |

### Example: Creating "Inventory Management" System
- **Domain**: `inventory` (lowercase)
- **Domain (PascalCase)**: `Inventory`
- **Domain Abbreviation**: `inv` (for Resource IDs)

**Search & Replace Operations:**
1. `Template` → `Inventory` (in all .NET files)
2. `template` → `inventory` (in all .NET files)
3. `[YOUR_MICRO_APP_NAME_HERE]` → `inventory` (in Angular files)
4. `vertex-ui-template` → `vertex-ui-inventory` (in Angular files)
5. Update ResourceId prefixes: `tm_` → `inv_`

### Replacement Validation Checklist
- [ ] All `Template` → `[Domain]` replacements complete in .NET projects
- [ ] All `template` → `[domain]` replacements complete in .NET projects  
- [ ] All `[YOUR_MICRO_APP_NAME_HERE]` → `[domain]` replacements complete in Angular
- [ ] All namespace updates complete: `SE.Sustainability.Vertex.[Domain].*`
- [ ] ResourceId format updated with domain abbreviation
- [ ] Project names follow `vertex-[domain]-[type]` pattern

### Naming Conventions
- **Project Names**: Use `vertex-[domain]-[type]` format
- **Namespaces**: Follow `SE.Sustainability.Vertex.[Domain].[Layer]` pattern
- **Classes**: PascalCase with domain context (e.g., `InventoryItem`, `InventoryController`)
- **Database Tables**: Pluralized domain entities (e.g., `InventoryItems`)

### Package Management
- **Frontend**: npm with specific @se-sustainability-business scope
- **Backend**: NuGet with SE.Sustainability.Vertex.Api.Sdk reference

### Environment Setup
- **FontAwesome Token**: Required for UI components
- **GitHub PAT**: Required for private package access
- **SQL Server**: For data persistence
- **Azure Service Bus**: For event messaging

## 📚 Additional Resources

- [Vertex UI Shared Documentation](DotNet_Angular/vertex-ui-shared/docs/VERTEX-UI.md)
- [Angular Template Guide](DotNet_Angular/vertex-ui-template/README.md)
- [API Template Documentation](DotNet_Angular/vertex-api-template/README.md)
- [BFF Template Documentation](DotNet_Angular/vertex-bff-template/README.md)
- [Recommended Enhancements](docs/RECOMMENDED_ADDITIONS.md) - Future improvements not currently implemented

## 🔄 Continuous Integration

All templates include:
- **GitHub Actions**: Automated build, test, and deployment
- **Code Quality**: ESLint, Prettier, StyleLint for frontend
- **Testing**: Unit tests, integration tests, E2E tests
- **Security**: Dependency scanning and vulnerability checks

---

## 🎯 Getting Started with a New Project

**For Product Teams:**
1. Place all product documentation in `ProductDesign/docs/`
2. Ensure requirements, user stories, and business context are clearly documented

**For Development Teams:**
1. Use the **Master Prompt** in `ProductDesign/MASTER_PROMPT.md` to kick off the complete project creation workflow
2. Follow the implementation order: Core API → BFF → Frontend
3. Track progress using the generated progress files in `docs/`

---

**Note for Cursor**: This repository is designed to provide you with complete context for building Vertex applications. Always start with the Master Prompt for new projects, refer to the latest templates, and follow the established patterns for consistency across the platform.
