# Vertex UI Component Development Guide

**Date**: October 14, 2024  
**Context**: Comprehensive guide for developing custom components in Vertex UI applications following design system requirements  
**Status**: ✅ Completed

## Problem Statement

Need to develop custom UI components for the vertex-ui-disclosure-management project while:
- Following strict Vertex design system hierarchy (vertex-ui-shared → Quartz → Custom)
- Maintaining WCAG 2.1 AA accessibility compliance
- Creating reusable, well-documented components
- Following proper component architecture and placement strategies

## Solution Overview

Established comprehensive component development workflow following Vertex Critical Rules with proper component hierarchy, accessibility standards, and documentation practices.

## Component Architecture Established

### 1. Component Hierarchy (MANDATORY)
```
1. @se-sustainability-business/vertex-ui-shared (ALWAYS FIRST)
2. Quartz components (if vertex-ui-shared doesn't have it)  
3. Custom reusable components (LAST RESORT - document in CUSTOM_COMPONENTS.md)
```

### 2. Component Placement Strategy
- **Application-Wide**: `src/app/shared/components/[component-name]/` - Reusable across routes
- **Route-Specific**: `src/routes/[route]/shared/[component-name]/` - Route-specific logic
- **Single-Use**: `src/routes/[route]/[component-name]/` - One parent component only

### 3. Naming Conventions
- **Application-Specific Selectors**: Use `vx-dm-` prefix for disclosure management components
- **Component Classes**: Follow `VxDmComponentName` pattern
- **Files**: Use kebab-case with component suffix

## Major Components Developed

### VxFileUpload Component
**Location**: `src/app/shared/components/vx-file-upload/`

**Features Implemented**:
- Full drag-and-drop support with visual feedback
- Click-to-upload functionality (entire drop zone clickable)
- Keyboard accessibility (Enter/Space activation)
- Comprehensive file validation (size, type, count)
- Multiple/single file selection modes
- Error handling with user-friendly messages
- WCAG 2.1 AA accessibility compliance
- Configurable labels, descriptions, and limits

**Key Implementation Details**:
```typescript
export interface VxFileUploadConfig {
  accept?: string;
  multiple?: boolean;
  maxFileSize?: number;
  maxFiles?: number;
  label?: string;
  description?: string;
  dragLabel?: string;
}

@Component({
  selector: 'vx-file-upload',
  standalone: true,
  // Full accessibility and drag-drop implementation
})
```

### VxDmTable Component
**Location**: `src/shared/components/vx-dm-table/`

**Features Implemented**:
- Generic TypeScript implementation with type safety (`<T>`)
- Angular CDK table foundation for performance
- Integrated vertex-ui-shared components (sorting, filtering, pagination)
- Configurable column definitions with custom templates
- Multiple table densities (comfortable, standard, compact)
- Row selection with accessibility support
- Global search with customizable logic
- Advanced filtering using vertex-ui-shared FilterConfig
- Full height layout mode for constrained containers
- Responsive design with mobile optimizations

**Production Usage Results**:
- **Code reduction**: ~200 lines eliminated from report-list component
- **Template simplification**: 250+ lines reduced to 85 lines
- **Bundle size**: Reduced from 12.5KB to 11.9KB
- **Performance**: Improved through centralized logic

### VxDmExperienceSelector Component
**Location**: `src/routes/reports/reports/shared/vx-dm-experience-selector/`

**Features Implemented**:
- Development-only visibility using `isDevMode()` check
- Persistent experience selection via localStorage
- VxDmSelect integration for consistent styling
- Smart navigation preservation
- Route-aware URL parameter handling

## Accessibility Implementation

### WCAG 2.1 AA Compliance Requirements
- ✅ **ESLint Configuration**: Configured `...angular.configs.templateAccessibility`
- ✅ **Storybook Integration**: Installed and configured `@storybook/addon-a11y`
- ✅ **Testing Tools**: Implemented axe DevTools for manual testing
- ✅ **ARIA Attributes**: Proper `role`, `aria-expanded`, `aria-disabled` usage
- ✅ **Keyboard Navigation**: All interactive elements keyboard accessible

### Key Accessibility Patterns Implemented
```typescript
// Example: File upload accessibility
@HostListener('keydown', ['$event'])
onKeyDown(event: KeyboardEvent): void {
  if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault();
    this.fileInput.nativeElement.click();
  }
}

// ARIA attributes for screen readers
[attr.aria-expanded]="isDragOver"
[attr.aria-disabled]="disabled"
role="button"
tabindex="0"
```

## Translation System Integration

### Required Translation Usage
- **ALL user-facing text**: Use `{{ 'module.key' | translate }}`
- **Translation keys**: Follow `module.key` format (e.g., 'inventory.title', 'shared.save')
- **Import requirement**: `TranslatePipe` from `@se-sustainability-business/vertex-ui-shared/translate`
- **File location**: Translation files in `public/i18n/en.json` (alphabetically sorted)

### Implementation Example
```typescript
// Component imports
import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate';

// Template usage
{{ 'disclosureManagement.upload.dragDropLabel' | translate }}
{{ 'shared.buttons.cancel' | translate }}
```

## Design System Adherence

### Card Component Pattern
**User Preference**: Use Vertex 'card' component structure instead of manual Tailwind classes

```html
<!-- ✅ CORRECT: Vertex card pattern -->
<div class="card">
  <div class="card-body">
    <!-- Content -->
  </div>
</div>

<!-- ❌ INCORRECT: Manual styling -->
<div class="rounded-xl border border-gray-100 bg-white p-6 shadow-sm">
  <!-- Content -->
</div>
```

### Component Hierarchy Implementation
```html
<!-- ✅ CORRECT: Use vertex-ui-shared first -->
<vx-button>Action</vx-button>
<vx-form-field>
  <vx-input placeholder="Enter text"></vx-input>
</vx-form-field>

<!-- ❌ INCORRECT: Raw HTML elements -->
<button class="btn">Action</button>
<input type="text" placeholder="Enter text">
```

## Documentation and Tracking

### Component Documentation System
- **CUSTOM_COMPONENTS.md**: Comprehensive tracking of all custom components
- **Promotion Tracking**: Components evaluated for vertex-ui-shared inclusion
- **Usage Analytics**: Track reusability scores and usage counts
- **Storybook Stories**: All components require Storybook documentation

### Template Structure
```markdown
## ComponentName
- **Project**: vertex-[domain]-ui
- **Purpose**: [Problem solved and why vertex-ui-shared wasn't sufficient]
- **Reusability Score**: [High/Medium/Low]
- **Promotion Candidate**: [Yes/No]
- **Features**: [Key functionality]
- **Code Example**: [Usage examples]
```

## Best Practices Established

### ✅ DO
- Check vertex-ui-shared Storybook first
- Use application-specific prefixes (`vx-dm-`)
- Follow proper component placement strategy
- Include comprehensive TypeScript interfaces
- Create Storybook stories for all components
- Document in CUSTOM_COMPONENTS.md
- Meet WCAG 2.1 AA standards
- Use vertex-ui-shared components internally

### ❌ DON'T
- Create custom components when vertex-ui-shared/Quartz has them
- Use raw HTML form elements directly
- Skip accessibility testing
- Create components without proper documentation
- Bypass ESLint accessibility rules
- Use hardcoded strings for user-facing text

## Build and Development Workflow

### Build Commands
- **Standard Build**: `npm run build` (not `ng build`)
- **Development**: Standard Angular CLI commands
- **Testing**: Jest for unit tests, Storybook for component testing

## Follow-up Actions Completed

- [x] Component hierarchy guidelines documented
- [x] Accessibility standards implemented
- [x] Translation system integrated
- [x] Design system patterns established
- [x] Documentation system created
- [x] Best practices codified

## Related Documentation

- `docs/CUSTOM_COMPONENTS.md` - Component tracking and promotion system
- `docs/DESIGN_SYSTEM.md` - UI design guidelines and patterns
- `docs/CODING_STANDARDS.md` - Development standards and conventions
- `docs/CRITICAL_RULES.md` - Mandatory requirements for all development

## Tags

`#vertex` `#angular` `#ui-components` `#accessibility` `#design-system` `#wcag` `#custom-components` `#component-architecture`
