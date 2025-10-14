# Vertex Architecture Patterns and Design Decisions

**Date**: October 14, 2024  
**Context**: Architectural patterns, design decisions, and best practices established for Vertex template system  
**Status**: ✅ Completed - Patterns Established

## Problem Statement

Need to establish consistent architectural patterns and design decisions for the Vertex template system that:
- Provide clear guidance for component development and placement
- Ensure consistency across all Vertex applications
- Support scalability and maintainability
- Integrate seamlessly with existing Vertex ecosystem
- Support team collaboration and knowledge transfer

## Solution Overview

Established comprehensive architectural patterns covering component hierarchy, placement strategies, naming conventions, accessibility standards, and development workflows.

## Key Architectural Decisions

### 1. Three-Tier Application Architecture

**Decision**: Maintain strict three-tier architecture for all Vertex applications

```
┌─────────────────────────────────────┐
│ Angular Frontend (vertex-[domain]-ui) │
│ - Uses @se-sustainability-business/  │
│   vertex-ui-shared                   │
│ - Standalone components              │
│ - TailwindCSS + Design System        │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│ BFF Service (vertex-[domain]-bff)    │
│ - Backend-for-Frontend              │
│ - Data transformation               │
│ - API aggregation                   │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│ Core API (vertex-[domain]-api)       │
│ - Domain CRUD operations            │
│ - Clean Architecture                │
│ - Entity Framework Core             │
└─────────────────────────────────────┘
```

**Rationale**: 
- Clear separation of concerns
- Scalable and maintainable architecture
- Consistent patterns across all Vertex applications
- Supports independent deployment and scaling

### 2. Component Hierarchy (MANDATORY)

**Decision**: Strict component hierarchy for all UI development

```
Priority 1: @se-sustainability-business/vertex-ui-shared
    │
    ├── Use ALWAYS FIRST for any UI need
    ├── Check Storybook documentation thoroughly
    └── Examples: VxButton, VxFormField, VxInput, VxSelect
         │
         ▼ (Only if vertex-ui-shared doesn't have it)
         
Priority 2: Quartz Components
    │
    ├── Use when vertex-ui-shared lacks the component
    ├── Material Design-based components
    └── Examples: QzButton, QzDialog, QzCard
         │
         ▼ (LAST RESORT - Only when neither has it)
         
Priority 3: Custom Reusable Components
    │
    ├── MUST document in CUSTOM_COMPONENTS.md
    ├── MUST include TypeScript interfaces
    ├── MUST include Storybook stories
    └── MUST follow promotion evaluation process
```

**Rationale**:
- Ensures design consistency across platform
- Reduces duplication and maintenance burden
- Leverages shared component investments
- Provides clear escalation path for missing components

### 3. Component Placement Strategy

**Decision**: Three-tier component placement based on reusability scope

#### ✅ Application-Wide Components
- **Location**: `src/app/shared/components/[component-name]/`
- **When**: Component is reusable across multiple routes/features
- **Examples**: `VxDmTable`, `VxDmInput`, `VxFileUpload`
- **Naming**: `vx-dm-` prefix for disclosure management specific components

#### ✅ Route-Specific Components  
- **Location**: `src/routes/[route-name]/[route-path]/shared/[component-name]/`
- **When**: Component contains route-specific business logic
- **Examples**: `VxDmExperienceSelector` in `src/routes/reports/reports/shared/`
- **Characteristics**: Tied to specific business domain or workflow

#### ✅ Single-Use Components
- **Location**: `src/routes/[route-name]/[component-name]/` (alongside parent)
- **When**: Component is used by only one parent component
- **Examples**: Route-specific panels, specialized dialogs
- **Characteristics**: Tightly coupled to specific parent component

**Decision Criteria Framework**:
```
Does this component have cross-route usage potential?
├── YES → Application-Wide (src/app/shared/components/)
└── NO
    │
    Does this component contain route-specific business logic?
    ├── YES → Route-Specific (src/routes/[route]/shared/)
    └── NO → Single-Use (alongside parent component)
```

### 4. Accessibility as First-Class Requirement

**Decision**: WCAG 2.1 AA compliance mandatory for all components

**Implementation Requirements**:
- ✅ **ESLint Configuration**: `...angular.configs.templateAccessibility`
- ✅ **Storybook Integration**: `@storybook/addon-a11y` for real-time testing
- ✅ **Testing Tools**: axe DevTools browser extension mandatory
- ✅ **ARIA Attributes**: Proper `role`, `aria-expanded`, `aria-disabled`
- ✅ **Keyboard Navigation**: All interactive elements keyboard accessible

**Enforcement Mechanisms**:
```typescript
// ESLint configuration (mandatory)
export default tseslint.config({
  extends: [
    ...angular.configs.templateAccessibility, // REQUIRED
  ],
  rules: {
    '@angular-eslint/template/click-events-have-key-events': 'error',
    '@angular-eslint/template/interactive-supports-focus': 'error',
  }
});

// Storybook addon (mandatory)
export default {
  addons: [
    '@storybook/addon-a11y', // REQUIRED for all components
  ],
};
```

### 5. Translation System Integration

**Decision**: Mandatory translation usage for all user-facing text

**Implementation Pattern**:
```typescript
// Component imports (REQUIRED)
import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate';

// Template usage (MANDATORY for all user text)
{{ 'disclosureManagement.upload.dragDropLabel' | translate }}
{{ 'shared.buttons.save' | translate }}
{{ 'shared.buttons.cancel' | translate }}
```

**Translation Key Convention**:
- **Format**: `module.section.key`
- **Examples**: 
  - `'inventory.table.noResults'`
  - `'shared.validation.required'`
  - `'disclosureManagement.report.title'`
- **File Location**: `public/i18n/en.json` (alphabetically sorted)

### 6. Design System Patterns

**Decision**: Specific UI patterns based on user preferences and design system

#### Card Component Pattern (User Preference)
```html
<!-- ✅ CORRECT: Vertex card pattern -->
<div class="card">
  <div class="card-body">
    <!-- Content -->
  </div>
</div>

<!-- ❌ FORBIDDEN: Manual Tailwind styling -->
<div class="rounded-xl border border-gray-100 bg-white p-6 shadow-sm">
  <!-- Content -->
</div>
```

#### Button Consistency Pattern
```html
<!-- ✅ CORRECT: Use qz-button directive -->
<button qz-button variant="primary" size="medium">
  {{ 'shared.buttons.save' | translate }}
</button>

<!-- ❌ FORBIDDEN: Raw HTML buttons -->
<button class="btn btn-primary">Save</button>
```

### 7. Database Migration Strategy

**Decision**: DbUp for all database migrations (NEVER Entity Framework migrations)

**Required Approach**:
```
DBMigrations/
├── 20241014/
│   ├── 001-CreateInventoryTable.sql
│   ├── 002-AddIndexes.sql
│   └── 003-SeedReferenceData.sql
└── 20241015/
    ├── 001-AlterInventoryTable.sql
    └── 002-UpdatePermissions.sql
```

**Execution Pattern**:
```bash
# Run migrations
dotnet [app].dll run-migrations

# NEVER use these EF commands
# dotnet ef migrations add    ❌ FORBIDDEN
# dotnet ef database update   ❌ FORBIDDEN
```

### 8. Repository Pattern with Base Classes

**Decision**: Mandatory base class inheritance for all entities

**Required Base Classes**:
```csharp
// Most common - entities with Name property
public class InventoryItem : NamedEntityBase
{
    // Additional properties
}

// Entities without Name but need full audit tracking
public class Transaction : EntityBase
{
    // Properties
}

// Simple entities with minimal tracking
public class Setting : MinimalEntityBase
{
    // Properties
}

// Repository pattern (REQUIRED)
public interface IInventoryRepository : IEFRepository<InventoryItem>
{
    // Additional methods
}
```

## Development Workflow Patterns

### 1. Git Submodule Management

**Decision**: All Vertex projects as Git submodules for unified development

**Structure**:
```
DotNet_Angular/
├── vertex-dotnet-api-sdk/       (submodule)
├── vertex-ui-shared/            (submodule)
├── vertex-ui-disclosure-management/ (submodule)
├── vertex-disclosure-management-api/ (submodule)
├── vertex-bff-disclosure-management/ (submodule)
└── vertex-ui-measure/           (submodule)
```

**Benefits**:
- Unified template repository
- Independent project development
- Consistent replication across machines
- Version pinning for reproducible builds

### 2. Build and Development Commands

**Decision**: Consistent build commands across projects

```bash
# Angular Projects
npm run build        # NOT ng build (user preference)
npm run dev         # Development server
npm run test        # Run tests
npm run lint        # Linting

# .NET Projects  
dotnet build        # Build solution
dotnet test         # Run tests
dotnet run          # Start application
```

### 3. Component Development Workflow

**Decision**: Systematic approach to component development

```
1. Check vertex-ui-shared Storybook
   ├── Component exists? → Use it
   └── Component missing? → Continue to step 2

2. Check Quartz components
   ├── Component exists? → Use it  
   └── Component missing? → Continue to step 3

3. Create custom component
   ├── Determine placement (app-wide/route-specific/single-use)
   ├── Follow naming conventions (vx-dm- prefix)
   ├── Implement accessibility (WCAG 2.1 AA)
   ├── Create Storybook stories
   ├── Document in CUSTOM_COMPONENTS.md
   └── Evaluate for vertex-ui-shared promotion
```

## Quality Assurance Patterns

### 1. Testing Strategy

**Decision**: Comprehensive testing approach for all components

- **Unit Tests**: Jest for business logic and component behavior
- **Integration Tests**: Angular Testing Library for component integration
- **Accessibility Tests**: Storybook addon-a11y + axe DevTools
- **Visual Tests**: Storybook for component visual regression
- **E2E Tests**: Playwright for critical user flows

### 2. Code Quality Standards

**Decision**: Automated quality enforcement

```typescript
// ESLint configuration
export default tseslint.config({
  extends: [
    ...angular.configs.recommended,
    ...angular.configs.templateAccessibility, // MANDATORY
  ],
  rules: {
    // Accessibility rules (ENFORCED)
    '@angular-eslint/template/click-events-have-key-events': 'error',
    // Component naming (ENFORCED)
    '@angular-eslint/component-selector': ['error', {
      type: 'element',
      prefix: ['vx-dm'], // Application-specific prefix
      style: 'kebab-case'
    }]
  }
});
```

## Documentation and Knowledge Management

### 1. Conversation Documentation System

**Decision**: Systematic documentation of all architectural decisions and implementations

**Structure**:
```
docs/conversations/
├── implementation-guides/    # Step-by-step implementation documentation
├── decisions/               # Architectural and design decisions
├── troubleshooting/         # Problem-solving documentation
└── session-logs/           # Raw conversation exports
```

### 2. Component Tracking System

**Decision**: Comprehensive tracking for promotion and reuse

**Location**: `docs/CUSTOM_COMPONENTS.md`
**Purpose**: Track all custom components for vertex-ui-shared promotion evaluation

## Follow-up Actions Completed

- [x] Three-tier architecture patterns documented
- [x] Component hierarchy rules established and enforced
- [x] Component placement strategy defined with decision criteria
- [x] Accessibility standards implemented (WCAG 2.1 AA)
- [x] Translation system integration completed
- [x] Design system patterns established (card, button consistency)
- [x] Database migration strategy implemented (DbUp)
- [x] Repository pattern with base classes established
- [x] Git submodule management system implemented
- [x] Development workflow patterns documented
- [x] Quality assurance patterns established
- [x] Documentation and knowledge management system created

## Impact and Benefits

### Development Efficiency
- **Consistent Patterns**: Developers know exactly where to place components
- **Reduced Decision Fatigue**: Clear hierarchy eliminates choice paralysis
- **Accelerated Development**: Reusable components reduce implementation time

### Quality Assurance
- **Accessibility**: Built-in WCAG compliance in all components
- **Design Consistency**: Automatic design system adherence
- **Code Quality**: Automated linting and testing standards

### Maintainability
- **Clear Architecture**: Easy to understand and modify systems
- **Documentation**: Comprehensive knowledge base for team transitions
- **Component Tracking**: Systematic approach to component evolution

### Team Collaboration
- **Shared Understanding**: Common vocabulary and patterns
- **Knowledge Transfer**: Documentation supports team transitions
- **Consistent Quality**: All team members follow same standards

## Related Documentation

- `docs/CRITICAL_RULES.md` - Mandatory requirements for all development
- `docs/CODING_STANDARDS.md` - Detailed coding conventions
- `docs/DESIGN_SYSTEM.md` - UI design guidelines and patterns
- `docs/ARCHITECTURE_GUIDE.md` - System architecture patterns
- `docs/CUSTOM_COMPONENTS.md` - Component tracking and promotion system

## Tags

`#vertex` `#architecture` `#design-patterns` `#best-practices` `#component-hierarchy` `#accessibility` `#documentation` `#quality-standards`
