# 🚨 CRITICAL VERTEX DEVELOPMENT RULES

> **WARNING**: These rules are MANDATORY and MUST NEVER be violated. Failure to follow these rules will result in inconsistent applications that don't align with Vertex platform standards.

## 🎯 Purpose

This document contains the most critical rules that every developer and AI agent MUST follow when working on Vertex projects. These rules ensure:
- Consistency across the platform
- Proper use of shared libraries
- Adherence to established architecture patterns
- Maintainable and scalable applications

---

## 🎨 Frontend Development Rules

### Rule #1: ALWAYS Use vertex-ui-shared Components

**🚨 CRITICAL**: When building Angular UIs, you MUST ALWAYS use components from `@se-sustainability-business/vertex-ui-shared`. 

#### ✅ REQUIRED Components to Use:

| UI Element | MUST Use | Import Path |
|------------|----------|-------------|
| **Buttons** | `VxButtonComponent` | `@se-sustainability-business/vertex-ui-shared/button` |
| **Data Tables** | `VxTableComponent` | `@se-sustainability-business/vertex-ui-shared/table` |
| **Form Fields** | `VxFormFieldComponent` | `@se-sustainability-business/vertex-ui-shared/form-field` |
| **Text Inputs** | `VxInputComponent` | `@se-sustainability-business/vertex-ui-shared/input` |
| **Dropdowns** | `VxSelectComponent` | `@se-sustainability-business/vertex-ui-shared/select` |
| **Checkboxes** | `VxCheckboxComponent` | `@se-sustainability-business/vertex-ui-shared/checkbox` |
| **Translations** | `TranslatePipe` | `@se-sustainability-business/vertex-ui-shared/translate` |

#### 🏆 Component Selection Priority:

**COMPONENT HIERARCHY (USE IN THIS ORDER):**
1. **🥇 vertex-ui-shared components** - ALWAYS use first if available
2. **🥈 Quartz components** - Use if vertex-ui-shared doesn't have the component
3. **🥉 Custom reusable components** - Only if neither above exists

#### ✅ Custom Component Creation Rules:

**WHEN CREATING CUSTOM COMPONENTS (LAST RESORT):**
- **MUST** create as standalone, reusable Angular components in `src/app/shared/components/`
- **MUST** follow vertex-ui-shared component patterns and naming conventions  
- **MUST** include proper TypeScript interfaces for inputs/outputs
- **MUST** include Storybook stories for documentation and testing
- **MUST** document in `CUSTOM_COMPONENTS.md` for potential promotion to vertex-ui-shared
- **MUST** use composition over duplication (extend existing components when possible)
- **MUST** create a comprehensive test page in `src/routes/demo/[component-name]/` for development testing
  - Test page should demonstrate all component states, configurations, and interactions
  - Route should be prefixed with `demo/` to identify as development-only (e.g., `demo/my-component-test`)
  - Include interactive controls to test loading states, different configurations, and edge cases
  - Implement real-time event logging to verify all component events fire correctly
  - Test page can be excluded from production builds via build process optimization

**CUSTOM COMPONENT TRACKING:**
```markdown
## [ComponentName] 
- **File**: `src/app/shared/components/[component-name]/`
- **Purpose**: [What problem does this solve?]
- **Reusability Score**: [High/Medium/Low] 
- **Promotion Candidate**: [Yes/No - Should this be added to vertex-ui-shared?]
- **Usage Count**: [How many places use this component?]
- **Dependencies**: [What vertex-ui-shared components does it use internally?]
```

#### ❌ FORBIDDEN - NEVER Do These:

- ❌ **NEVER** create custom components when vertex-ui-shared or Quartz has them
- ❌ **NEVER** use raw HTML `<button>`, `<input>`, `<select>` elements directly in templates
- ❌ **NEVER** use third-party UI libraries (Angular Material, PrimeNG, etc.)
- ❌ **NEVER** duplicate functionality that exists in vertex-ui-shared or Quartz
- ❌ **NEVER** create one-off HTML structures scattered throughout component templates
- ❌ **NEVER** create custom table, button, or form components without checking both libraries first

#### 🔍 Validation Process:

**BEFORE implementing ANY UI component:**
1. Check Storybook: https://vertex-components-non.sb.se.com
2. Verify the component exists in vertex-ui-shared
3. Use the exact import path from the table above
4. Review the component's documentation and examples

---

## 🌐 Translation & Internationalization Rules

### Rule #2: ALWAYS Use vertex-ui-shared Translation System

**🚨 CRITICAL**: All Angular applications MUST use the vertex-ui-shared translation system consistently.

#### ✅ REQUIRED Translation Components:

**MANDATORY IMPORTS:**
```typescript
import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate';

@Component({
  imports: [TranslatePipe],  // REQUIRED: Always import TranslatePipe
  template: `{{ 'app.welcome' | translate }}`
})
```

#### ✅ REQUIRED Translation Key Format:

**MANDATORY KEY STRUCTURE:**
- **Format**: `module.key` or `module.nested.key`
- **Module Names**: Use your app name (e.g., `inventory`, `reporting`) or `shared` for common strings

**Examples:**
```typescript
// ✅ CORRECT
{{ 'inventory.items.title' | translate }}
{{ 'shared.buttons.save' | translate }}
{{ 'reporting.charts.revenue' | translate }}

// ❌ FORBIDDEN
{{ 'Save' | translate }}           // No module prefix
{{ 'items-title' | translate }}    // Wrong format
```

#### ✅ REQUIRED Parameter Usage:

**MANDATORY INTERPOLATION SYNTAX:**
```typescript
// Translation file (en.json)
{
  "welcome": "Hello {{ name }}, you have {{ count }} items"
}

// Component usage
{{ 'inventory.welcome' | translate: { name: userName, count: itemCount } }}
```

#### ✅ REQUIRED File Structure:

**MANDATORY DIRECTORY STRUCTURE:**
```
public/i18n/
└── en.json                    # App-specific translations
```

**MANDATORY FILE FORMAT:**
```json
{
  "buttons": {
    "add": "Add Item",
    "delete": "Delete Item"
  },
  "messages": {
    "welcome": "Welcome to {{ appName }}",
    "itemCount": "{{ count }} items found"
  },
  "title": "Inventory Management"
}
```

#### ✅ REQUIRED Package Scripts:

**MANDATORY PACKAGE.JSON SCRIPTS:**
```json
{
  "scripts": {
    "i18n:sort": "sort-json public/i18n/en.json",
    "i18n:check": "vx-check-json-sort public/i18n/en.json"
  }
}
```

#### ✅ Translation Development Checklist:

**BEFORE EVERY COMMIT:**
- [ ] All user-facing strings use `{{ key | translate }}`
- [ ] Translation keys follow `module.key` format
- [ ] Translation file is alphabetically sorted (`npm run i18n:sort`)
- [ ] Translation file passes validation (`npm run i18n:check`)
- [ ] No hardcoded user-facing strings in templates
- [ ] TranslatePipe imported in all components using translations

#### ❌ FORBIDDEN Translation Practices:

**NEVER DO THESE:**
- Use hardcoded strings for user-facing text
- Create custom translation pipes or services  
- Use translation keys without module prefixes
- Bypass the TranslatePipe for user-facing content
- Use third-party translation libraries (ngx-translate, etc.)
- Put translation files anywhere other than `public/i18n/`
- Use unsorted translation files

#### 🔧 Translation Service Usage (Advanced):

**FOR PROGRAMMATIC TRANSLATIONS:**
```typescript
import { TranslateService } from '@se-sustainability-business/vertex-ui-shared/translate';

constructor(private translateService: TranslateService) {}

// Single translation
this.translateService.get('inventory.message').subscribe(text => {
  console.log(text);
});

// Multiple translations
this.translateService.multi(['key1', 'key2']).subscribe(([text1, text2]) => {
  // Handle translations
});
```

---

## ♿ Accessibility Rules

### Rule #3: ALWAYS Follow Accessibility Standards

**🚨 CRITICAL**: All Angular applications MUST meet WCAG 2.1 AA accessibility standards and European Accessibility Act requirements.

#### ✅ REQUIRED ESLint Configuration:

**MANDATORY ACCESSIBILITY LINTING:**
```javascript
// eslint.config.js
{
  files: ['**/*.html'],
  extends: [
    ...angular.configs.templateRecommended,
    ...angular.configs.templateAccessibility,  // REQUIRED: Accessibility linting
  ],
}
```

#### ✅ REQUIRED Storybook Configuration:

**MANDATORY ACCESSIBILITY ADDON:**
```javascript
// .storybook/main.ts
addons: [
  '@storybook/addon-a11y',  // REQUIRED: Real-time accessibility testing
],
```

**MANDATORY PACKAGE DEPENDENCIES:**
```json
{
  "devDependencies": {
    "@storybook/addon-a11y": "^9.0.9"
  }
}
```

#### ✅ REQUIRED Manual Testing:

**MANDATORY BROWSER TOOLS:**
- **axe DevTools** extension for [Chrome](https://chromewebstore.google.com/detail/axe-devtools-web-accessib/lhdoppojpmngadmnindnejefpokejbdd) or [Firefox](https://addons.mozilla.org/en-US/firefox/addon/axe-devtools/)
- **Full page scanning** in all states (dialogs open, overlays, different user flows)
- **Keyboard navigation testing** (Tab, Enter, Arrow keys, Escape)

#### ✅ REQUIRED Component Patterns:

**MANDATORY ARIA ATTRIBUTES:**
```typescript
@Component({
  host: {
    // Semantic roles
    role: 'button|combobox|tab|treeitem|progressbar',
    
    // State communication
    '[attr.aria-expanded]': 'opened()',
    '[attr.aria-selected]': 'selected()',
    '[attr.aria-disabled]': 'disabled()',
    
    // Relationships
    '[attr.aria-controls]': 'controlsId()',
    '[attr.aria-labelledby]': 'labelId()',
    
    // Keyboard navigation
    '[attr.tabindex]': 'disabled() ? -1 : 0',
    '(keydown.enter)': 'activate()',
  }
})
```

#### ✅ REQUIRED Standards Coverage:

**WCAG 2.1 AA COMPLIANCE:**
- **Perceivable**: Alt text, ARIA labels, color contrast, semantic HTML
- **Operable**: Keyboard navigation, focus management, no seizure triggers
- **Understandable**: Consistent behavior, clear instructions, error identification
- **Robust**: Valid HTML, ARIA compliance, screen reader compatibility

#### ✅ Accessibility Development Checklist:

**BEFORE EVERY COMMIT:**
- [ ] ESLint accessibility rules pass (`npm run lint`)
- [ ] Storybook accessibility addon shows no violations
- [ ] axe DevTools browser scan shows no issues
- [ ] All interactive elements accessible via keyboard
- [ ] Focus indicators visible and logical
- [ ] Screen reader testing completed (if major UI changes)
- [ ] Color contrast meets WCAG AA standards
- [ ] No accessibility errors in browser console

#### ❌ FORBIDDEN Accessibility Practices:

**NEVER DO THESE:**
- Use `tabindex` values other than `-1`, `0`
- Create interactive elements without keyboard support
- Use color alone to convey information
- Implement custom focus management without ARIA support
- Bypass ESLint accessibility rules with eslint-disable
- Skip axe DevTools testing for UI changes
- Use non-semantic HTML for interactive elements
- Create unlabeled form controls or buttons

#### 🔧 Legal Compliance Requirements:

**EUROPEAN ACCESSIBILITY ACT:**
- All Schneider Electric UIs must conform to accessibility standards
- Accessibility violations can result in legal compliance issues
- Document accessibility issues in Jira if cannot be immediately fixed
- Link accessibility tickets in PR descriptions when relevant

#### 🛠️ Required Tools & Setup:

**DEVELOPMENT ENVIRONMENT:**
1. **ESLint**: Configure with `...angular.configs.templateAccessibility`
2. **Storybook**: Install and configure `@storybook/addon-a11y`
3. **Browser Extension**: Install axe DevTools
4. **Testing**: Include accessibility in PR checklist

---

## 🗄️ Backend Development Rules

### Rule #4: ALWAYS Use vertex-dotnet-api-sdk Base Classes

**🚨 CRITICAL**: When creating .NET entities, you MUST ALWAYS inherit from vertex-dotnet-api-sdk base classes.

#### ✅ REQUIRED Base Classes:

| Entity Type | MUST Use | When to Use |
|-------------|----------|-------------|
| **Named Entities** | `NamedEntityBase` | Entities with a Name property (most common) |
| **Standard Entities** | `EntityBase` | Entities without Name but need full audit tracking |
| **Simple Entities** | `MinimalEntityBase` | Simple entities with minimal tracking |
| **Audit Entities** | `EntityAuditBase` | Alternative audit pattern |

#### ✅ REQUIRED Repository Pattern:

| Component | MUST Use | Implementation |
|-----------|----------|----------------|
| **Repository Interface** | `IEFRepository<TEntity>` | `public interface IInventoryRepository : IEFRepository<InventoryItem>` |
| **Repository Implementation** | `EFRepository<TEntity>` | `public class InventoryRepository : EFRepository<InventoryItem>` |

#### ❌ FORBIDDEN - NEVER Do These:

- ❌ **NEVER** create entities without base class inheritance
- ❌ **NEVER** create custom repository patterns outside `IEFRepository`
- ❌ **NEVER** implement manual audit fields (CreatedDate, ModifiedDate, etc.)
- ❌ **NEVER** use `int` or `string` for entity IDs (use ResourceId format)

---

## 💾 Database Migration Rules

### Rule #5: ALWAYS Use DbUp for Database Migrations

**🚨 CRITICAL**: You MUST ALWAYS use DbUp for database schema migrations. NEVER use Entity Framework Core migrations.

#### ✅ REQUIRED Migration Approach:

| Component | MUST Use | Purpose |
|-----------|----------|---------|
| **Migration Tool** | `DbUp` | Database schema versioning and deployment |
| **Migration Scripts** | `.sql files` | SQL scripts in date-specific DBMigrations/ subdirectories |
| **Migration Handler** | `SqlMigrationHandler` | From templates - handles DbUp execution |
| **Directory Structure** | `DBMigrations/yyyymmdd/` | Date-specific subdirectories for organization |
| **Naming Convention** | `001-<DBAction>.sql` | Sequential numbering within date folder |

#### ✅ REQUIRED Implementation Pattern:

```csharp
// Use the SqlMigrationHandler from templates
public class SqlMigrationHandler : IMigrationHandler
{
    public Task<int> RunMigrationAsync()
    {
        var upgrader = DeployChanges.To
            .SqlDatabase(_connectionString)
            .WithScriptsAndCodeEmbeddedInAssembly(Assembly.GetExecutingAssembly())
            .WithTransaction()
            .LogTo(_logger)
            .Build();
        
        // DbUp automatically processes scripts in alphabetical order:
        // 1. DBMigrations/20250822/001-CreateInventoryTable.sql
        // 2. DBMigrations/20250822/002-CreateIndexes.sql  
        // 3. DBMigrations/20250823/001-AddProductColumn.sql
        
        var dbUpResult = upgrader.PerformUpgrade();
        return Task.FromResult(dbUpResult.Successful ? 0 : 1);
    }
}
```

#### ✅ REQUIRED Migration Script Example:

**File**: `DBMigrations/20250822/001-CreateInventoryTable.sql`
```sql
-- Migration: Create Inventory Items table
-- Date: 2025-08-22
-- Author: [Developer Name]

CREATE TABLE InventoryItems (
    Inventory_Item_Id VARCHAR(54) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(1000) NULL,
    Quantity DECIMAL(18,2) NOT NULL DEFAULT 0,
    Created_User_Id VARCHAR(54) NOT NULL,
    Created_Ts DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    Updated_User_Id VARCHAR(54) NOT NULL,
    Last_Change_Ts DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- Add indexes
CREATE INDEX IX_InventoryItems_Name ON InventoryItems(Name);
CREATE INDEX IX_InventoryItems_Created_Ts ON InventoryItems(Created_Ts);
```

#### ✅ REQUIRED Naming Conventions:

| Component | Format | Example |
|-----------|--------|---------|
| **Date Directory** | `yyyymmdd` | `20250822` |
| **Script Name** | `000-<DBAction>.sql` | `001-CreateInventoryTable.sql` |
| **Script Numbering** | Sequential within date folder | `001`, `002`, `003`, etc. |
| **Action Description** | PascalCase, descriptive | `CreateInventoryTable`, `AddProductColumn` |

#### ❌ FORBIDDEN - NEVER Do These:

- ❌ **NEVER** use `dotnet ef migrations add [MigrationName]`
- ❌ **NEVER** use `dotnet ef database update`
- ❌ **NEVER** use Entity Framework Core migration commands
- ❌ **NEVER** create Migration classes in EF Core
- ❌ **NEVER** use `Add-Migration` or `Update-Database` PowerShell commands

#### 🔍 Why DbUp Instead of EF Core Migrations?

| Aspect | DbUp ✅ | EF Core Migrations ❌ |
|--------|---------|----------------------|
| **SQL Control** | Full control over SQL | Generated SQL may be suboptimal |
| **Database Objects** | Supports all DB objects | Limited to EF-mapped entities |
| **Deployment** | Production-ready deployment | Complex deployment scenarios |
| **Version Control** | Simple .sql files | Binary migration files |
| **Rollback** | Custom rollback scripts | Limited rollback support |
| **Performance** | Optimized SQL | May generate inefficient SQL |

---

## 📁 Architecture Rules

### Rule #6: ALWAYS Follow Three-Tier Architecture

**🚨 CRITICAL**: You MUST ALWAYS implement the three-tier architecture pattern.

#### ✅ REQUIRED Structure:

| Tier | Project Name | Purpose |
|------|--------------|---------|
| **Frontend** | `vertex-[domain]-ui` | Angular application using vertex-ui-shared |
| **BFF** | `vertex-[domain]-bff` | Backend-for-Frontend API for UI-specific logic |
| **Core API** | `vertex-[domain]-api` | Domain CRUD operations with Clean Architecture |

#### ✅ REQUIRED Communication Flow:

```
Angular UI → BFF API → Core API → Database
```

#### ❌ FORBIDDEN - NEVER Do These:

- ❌ **NEVER** create monolithic applications
- ❌ **NEVER** have UI communicate directly with Core API
- ❌ **NEVER** bypass the BFF layer
- ❌ **NEVER** combine multiple domains in a single project

---

## 🔄 Implementation Validation

### Critical Rules Checklist

**BEFORE submitting any code, verify ALL of these:**

#### Frontend Checklist:
- [ ] ✅ All UI components imported from `@se-sustainability-business/vertex-ui-shared`
- [ ] ✅ No raw HTML form elements (`<button>`, `<input>`, `<select>`)
- [ ] ✅ No third-party UI libraries installed or used
- [ ] ✅ Using `TranslatePipe` for all user-facing text
- [ ] ✅ Using `bootstrapVertexApplication` for app initialization

#### Backend Checklist:
- [ ] ✅ All entities inherit from appropriate vertex-dotnet-api-sdk base class
- [ ] ✅ All repositories implement `IEFRepository<TEntity>`
- [ ] ✅ Using ResourceId format: `<application>_<assetType>_<guid>`
- [ ] ✅ All CQRS handlers use MediatR pattern
- [ ] ✅ FluentValidation used for all input validation

#### Database Migration Checklist:
- [ ] ✅ Using DbUp for all database migrations
- [ ] ✅ SQL scripts in DBMigrations/yyyymmdd/ date-specific subdirectories
- [ ] ✅ Script naming follows 001-<DBAction>.sql pattern within date folders
- [ ] ✅ Scripts are sequentially numbered within each date directory
- [ ] ✅ SqlMigrationHandler implemented from template
- [ ] ❌ NOT using `dotnet ef migrations` commands
- [ ] ❌ NOT using Entity Framework Core migration classes

#### Architecture Checklist:
- [ ] ✅ Three-tier structure: UI → BFF → Core API
- [ ] ✅ Project naming: `vertex-[domain]-[type]`
- [ ] ✅ Proper namespace structure: `SE.Sustainability.Vertex.[Domain].[Layer]`
- [ ] ✅ Clean Architecture layers maintained
- [ ] ✅ No direct UI-to-Core API communication

---

## 🛠️ Tools for Enforcement

### Storybook Reference
- **vertex-ui-shared Components**: https://vertex-components-non.sb.se.com
- Use this to verify component availability before implementation

### Code Review Checklist
Use this checklist during code reviews to ensure compliance:

```markdown
## Critical Rules Review Checklist

### Frontend Review:
- [ ] All components from vertex-ui-shared?
- [ ] No custom UI components duplicating shared functionality?
- [ ] Proper translation usage?

### Backend Review:
- [ ] All entities inherit from SDK base classes?
- [ ] Repository pattern using IEFRepository?
- [ ] ResourceId format correct?

### Architecture Review:
- [ ] Three-tier pattern followed?
- [ ] No BFF bypassing?
- [ ] Proper project naming?
```

---

## 🚨 Escalation Process

If you encounter a situation where these critical rules seem to conflict with requirements:

1. **STOP** - Do not proceed with implementation
2. **Document** the specific conflict
3. **Escalate** to the Vertex architecture team
4. **Wait** for official guidance before proceeding

**Remember**: These rules exist to maintain platform consistency and quality. Deviations require architectural review and approval.

---

## 📝 Rule Updates

This document should be updated when:
- New critical rules are identified
- Existing rules need clarification
- New shared components become available
- Architecture patterns evolve

**Last Updated**: [DATE]
**Next Review**: [DATE + 3 months]
