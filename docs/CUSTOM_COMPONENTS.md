# Custom Components Tracking

This document tracks custom components created across Vertex projects for potential promotion to `vertex-ui-shared`.

## Purpose

When teams create custom reusable components (because neither `vertex-ui-shared` nor Quartz has the needed component), they should be documented here. This helps:

1. **Avoid Duplication**: See if another team already created a similar component
2. **Identify Promotion Candidates**: Components used across multiple projects should be added to `vertex-ui-shared`
3. **Maintain Quality**: Ensure custom components follow consistent patterns
4. **Track Usage**: Understand which components are most valuable to the platform

## Component Documentation Template

For each custom component, copy and fill out this template:

```markdown
## ComponentName

- **Project**: vertex-[domain]-ui
- **File**: `src/app/shared/components/[component-name]/`
- **Purpose**: [What problem does this solve? Why wasn't vertex-ui-shared or Quartz sufficient?]
- **Created By**: [Team/Developer]
- **Created Date**: [YYYY-MM-DD]
- **Reusability Score**: [High/Medium/Low]
- **Promotion Candidate**: [Yes/No - Should this be added to vertex-ui-shared?]
- **Usage Count**: [How many places use this component?]
- **Dependencies**: [What vertex-ui-shared components does it use internally?]
- **Features**: [Key functionality and inputs/outputs]
- **Storybook**: [Link to component story]

### Code Example:
[Brief usage example]

### Screenshots:
[If applicable, add screenshots or descriptions]

### Notes:
[Any additional context, limitations, or future improvements]
```

---

## Tracked Components

## VxFileUpload

- **Project**: vertex-ui-disclosure-management
- **File**: `src/app/shared/components/vx-file-upload/`
- **Purpose**: Comprehensive file upload component with enhanced drag-and-drop functionality, file validation, and full WCAG 2.1 AA accessibility compliance. Created because vertex-ui-shared does not have a file upload component with these advanced features.
- **Created By**: AI Assistant
- **Created Date**: 2025-01-16
- **Reusability Score**: High
- **Promotion Candidate**: Yes - This component provides essential file upload functionality that would be valuable across multiple Vertex applications
- **Usage Count**: 1 (Currently used in document-repository component, but highly reusable)
- **Dependencies**: CommonModule, FormsModule (no vertex-ui-shared dependencies - purely native Angular)
- **Features**:
  - Full drag-and-drop support with visual feedback
  - Click-to-upload functionality (entire drop zone is clickable)
  - Keyboard accessibility (Enter/Space key activation)
  - File validation (size, type, count limits)
  - Multiple or single file selection modes
  - Error handling with user-friendly messages
  - WCAG 2.1 AA accessibility compliance
  - Configurable labels, descriptions, and limits
  - File removal capability
  - Real-time file size calculations
- **Storybook**: `src/shared/components/vx-file-upload/vx-file-upload.stories.ts`

### Code Example
```html
<vx-file-upload
  [config]="{
    accept: '.pdf,.doc,.docx,.jpg,.png',
    multiple: true,
    maxFileSize: 50 * 1024 * 1024, // 50MB
    maxFiles: 10,
    label: 'Drop files here or click to upload',
    description: 'PDF, Word, or Image files up to 50MB'
  }"
  [value]="selectedFiles"
  [disabled]="isUploading"
  (valueChange)="onFilesChanged($event)"
  (filesSelected)="onNewFilesSelected($event)"
  (fileRemoved)="onFileRemoved($event)"
  (validationError)="onValidationErrors($event)">
</vx-file-upload>
```

### Screenshots
- Interactive drop zone with hover states
- Clear file list with individual remove buttons  
- Validation error messages with file-specific details
- Accessibility-compliant keyboard navigation

### Notes
- Implements all enhanced drag/drop functionality from original document repository
- Handles global drag prevention to avoid browser file navigation
- Uses Angular signals for reactive state management
- Built with standalone component architecture
- Supports customization through comprehensive configuration interface
- Ready for promotion to vertex-ui-shared once testing is complete

## VxDmTable

- **Project**: vertex-ui-disclosure-management
- **File**: `src/shared/components/vx-dm-table/`
- **Purpose**: Generic, reusable data table component with advanced features including sorting, filtering, pagination, search, and row selection. Created because vertex-ui-shared does not have a comprehensive table component with these enterprise-level features that integrates seamlessly with existing Vertex UI components.
- **Created By**: AI Assistant
- **Created Date**: 2025-01-16
- **Reusability Score**: High
- **Promotion Candidate**: Yes - This component provides essential data table functionality that would be valuable across all Vertex applications
- **Usage Count**: 3 (Production use in report-list and documents-panel components, test implementation in demo/table-test)
- **Dependencies**: Angular CDK Table, vertex-ui-shared (SortHeaderComponent, FiltersComponent, PaginatorComponent, PaginatorPipe), vertex-ui-shared utilities (applyFilters, pagingSignal)
- **Features**:
  - Generic TypeScript implementation with type safety (`<T>`)
  - Angular CDK table foundation for performance and accessibility
  - Integrated vertex-ui-shared components (sorting, filtering, pagination)
  - Configurable column definitions with custom templates
  - Multiple table densities (comfortable, standard, compact)
  - Row selection (single/multiple) with accessibility support
  - Global search with customizable logic and clear button functionality
  - Advanced filtering using vertex-ui-shared FilterConfig
  - **Full height layout mode** with `@Input() fullHeight` for constrained containers
  - **Optimized pagination positioning** outside scrollable content area
  - Responsive design with mobile optimizations
  - Loading and empty states with intelligent context detection
  - Row click handling and custom row classes
  - Export functionality for processed data
  - Full keyboard navigation and WCAG 2.1 AA compliance
  - Cross-browser consistency for search input behavior

### Code Example

```typescript
// Column Configuration
const columns: VxDmTableColumn<ReportListItem>[] = [
  {
    id: 'name',
    label: 'Report Name',
    sortable: true,
    valueAccessor: (row) => row.name,
    cellTemplate: nameTemplate // Optional custom template
  },
  {
    id: 'status',
    label: 'Status',
    sortable: true,
    cellTemplate: statusBadgeTemplate
  },
  {
    id: 'actions',
    label: 'Actions',
    sortable: false,
    cellTemplate: actionsTemplate,
    width: '120px'
  }
];

// Table Configuration
const tableConfig: VxDmTableConfig<ReportListItem> = {
  columns,
  rowClickable: true,
  showPagination: true,
  showSearch: true,
  searchPlaceholder: 'Search reports...',
  showFilters: true,
  filters: reportFilters,
  selectable: true,
  selectionMode: 'multiple',
  density: 'standard',
  emptyState: {
    title: 'No reports found',
    message: 'Create your first report to get started.',
    icon: 'document'
  }
};
```

```html
<vx-dm-table
  [data]="reports"
  [config]="tableConfig"
  [loading]="isLoading"
  [selectedRows]="selectedReports"
  [showSearchFilter]="true"
  [fullHeight]="true"
  (rowClick)="onReportClick($event)"
  (selectionChange)="onSelectionChange($event)"
  (sortChange)="onSortChange($event)"
  (filterChange)="onFilterChange($event)"
  (searchChange)="onSearchChange($event)"
  (pageChange)="onPageChange($event)">
</vx-dm-table>
```

### Screenshots

- Fully integrated Vertex UI design with consistent styling
- Advanced filtering with vertex-ui-shared FiltersComponent
- Professional pagination with configurable page sizes
- Row selection with accessible checkboxes
- Custom cell templates for complex data (status badges, action buttons)
- Responsive layout adapting to different screen sizes
- Loading states and empty state management

### Notes

- Built with generic TypeScript for type safety across different data models
- Leverages Angular CDK Table for optimal performance and accessibility
- Seamlessly integrates with entire vertex-ui-shared ecosystem
- Supports all enterprise table features expected in business applications
- Designed to replace scattered HTML table implementations across projects
- Ready for promotion to vertex-ui-shared as the standard table component
- Follows reactive programming patterns with Angular signals
- Comprehensive event system for complex user interactions
- Fully documented with TypeScript interfaces and JSDoc comments

### Production Usage

**✅ ACTIVE IMPLEMENTATIONS:**

1. **`report-list.component.ts`** *(Production)*
   - **8 columns** with mixed data types and custom templates
   - **Custom templates** for status badges, progress bars, and action buttons
   - **Advanced filtering** with vertex-ui-shared FilterConfig
   - **Row click navigation** to report details
   - **Action buttons** with event prevention (export, duplicate, delete)
   - **Full height layout** with optimized pagination positioning
   - **Demonstrates**: Real-world enterprise table usage with complex interactions

2. **`documents-panel.component.ts`** *(Production)*
   - **5 columns** with file metadata and custom action templates
   - **Document-specific filters** for file type, upload date, and category
   - **Full height layout** with independent scrolling
   - **File management actions** (download, delete) with confirmation dialogs
   - **Demonstrates**: Document management use case with specialized filtering

3. **`demo/table-test.component.ts`** *(Development/Testing)*
   - **Comprehensive test page** at `http://localhost:4200/demo/table-test`
   - **All features demonstration** including selection, density changes, etc.
   - **Test data generation** with 50 sample records
   - **Interactive controls** for testing all configuration options

**RECENT ENHANCEMENTS (2025-01-17):**
- **Full Height Layout**: Added `@Input() fullHeight` for optimal space utilization in constrained containers
- **Enhanced Search UX**: Fixed duplicate clear buttons by using `type="text"` instead of `type="search"`
- **Improved Pagination UX**: Moved pagination outside scrollable area for better accessibility
- **Document Filters**: Added comprehensive filtering for documents (file type, date, category)
- **Cross-browser Consistency**: Eliminated native browser search controls for uniform experience

**MIGRATION RESULTS:**
- **Code reduction**: ~200 lines eliminated from report-list component
- **Template simplification**: 250+ lines reduced to 85 lines
- **Bundle size**: Report-list chunk reduced from 12.5KB to 11.9KB
- **Functionality**: 100% feature parity maintained + enhanced features
- **Performance**: Improved through centralized table logic and CSS optimizations
- **UX Improvements**: Better space utilization and consistent behavior across browsers

**STYLE IMPROVEMENTS:**
- **Design System Compliance**: Replaced manual Tailwind styling with proper vertex-ui-shared components
- **Button Consistency**: All action buttons now use `qz-button` directive following component hierarchy
- **Card Pattern**: Containers now use vertex `card/card-body` structure per user preference
- **Alert Integration**: Selection summary replaced with `vx-alert-banner` component
- **Accessibility**: Enhanced through proper design system component usage and full height optimizations
- **Maintainability**: Reduced custom styling, easier long-term maintenance

## VxDmProgressButton

- **Project**: vertex-ui-disclosure-management
- **File**: `src/shared/components/vx-dm-progress-button/`
- **Purpose**: Reusable button component that displays progress percentage with an integrated visual progress bar at the bottom. Created for Manual Publish workflow (ESG-13441) to provide visual feedback on completion toward publishable state. Can be reused for any progress-based action throughout the application.
- **Created By**: AI Assistant
- **Created Date**: 2024-10-15
- **Reusability Score**: High
- **Promotion Candidate**: Yes - This component provides valuable progress visualization that would benefit other Vertex applications with multi-step workflows
- **Usage Count**: 1 (Will be used in Reports Workspace for manual publish, but highly reusable)
- **Dependencies**: Angular CommonModule only (no external dependencies)
- **Features**:
  - Visual progress bar at bottom of button (fills left-to-right based on percentage)
  - Displays progress percentage in button text ("Publish (75% Complete)")
  - Dynamic progress bar colors based on completion level (gray → blue → purple → green)
  - Configurable button variants (primary, secondary, outline, ghost)
  - Three size options (sm, md, lg)
  - Loading state with spinner animation
  - Disabled state support
  - Full keyboard accessibility (Enter/Space key activation)
  - Screen reader announcements for progress updates
  - Follows Quartz SB design system (Schneider green: #3DCD58)
  - Responsive design with mobile optimizations
  - Dark mode support

### Code Example
```html
<!-- Basic usage with progress -->
<vx-dm-progress-button
  [progress]="75"
  (clicked)="onPublishClick()">
</vx-dm-progress-button>

<!-- Advanced configuration -->
<vx-dm-progress-button
  [progress]="reportCompletionPercentage"
  [text]="'Submit Report'"
  [showPercentage]="true"
  [disabled]="isProcessing"
  [loading]="isPublishing"
  [variant]="'primary'"
  [size]="'md'"
  (clicked)="onPublishClick()">
</vx-dm-progress-button>

<!-- Without percentage display -->
<vx-dm-progress-button
  [progress]="100"
  [text]="'Complete Setup'"
  [showPercentage]="false"
  (clicked)="onComplete()">
</vx-dm-progress-button>
```

### Visual Design
- **Progress Bar**: 4px thick line at bottom of button (per mockup requirements)
- **Colors by Progress Level**:
  - 0-24% Complete: Muted gray `#717182` (less inviting)
  - 25-74% Complete: Ocean blue `#0075A3` (moderate progress)
  - 75-99% Complete: Accent purple `#AB6DE4` (almost there!)
  - 100% Complete: Primary green `#3DCD58` (ready!)
- **Button States**: Hover effects, disabled opacity, loading spinner
- **Accessibility**: WCAG 2.1 AA compliant with proper ARIA attributes

### Screenshots
- Button with 25% progress showing blue progress bar
- Button with 100% progress showing green progress bar  
- Loading state with spinner
- Disabled state with reduced opacity

### Notes
- **Design System Compliance**: Fully adheres to Quartz SB design guidelines
- **No External Dependencies**: Pure Angular implementation for easy maintenance
- **Type Safety**: Full TypeScript typing with input/output signals
- **Performance**: Smooth CSS transitions for progress bar updates (400ms easing)
- **Testability**: Comprehensive unit tests included (16 test cases)
- **Accessibility**: Screen reader support, keyboard navigation, focus management
- **Ready for Promotion**: Well-documented, tested, and follows all Vertex patterns

---

## VxDmExperienceSelector

- **Project**: vertex-ui-disclosure-management
- **File**: `src/routes/reports/reports/shared/vx-dm-experience-selector/`
- **Purpose**: Multi-experience UI selector for switching between different report interface options during development. Route-specific component providing seamless navigation between experimental UI implementations with persistent user preferences.
- **Created By**: AI Assistant
- **Created Date**: 2025-01-17
- **Reusability Score**: Low (Route-specific functionality)
- **Promotion Candidate**: No - This is development tooling specific to reports route experimentation
- **Usage Count**: 1 (Reports route breadcrumb area, development environment only)
- **Dependencies**: VxDmSelect, UserSettingsService, Angular Router, Angular Reactive Forms
- **Features**:
  - Development-only visibility using `isDevMode()` check
  - Persistent experience selection via localStorage through UserSettingsService
  - VxDmSelect integration for consistent form component styling  
  - Reactive form control with automatic synchronization
  - Smart navigation preservation (maintains current report context)
  - Route-aware URL parameter handling for experience switching
  - Proper TypeScript typing with ExperienceOption interface

### Code Example
```typescript
// Component automatically integrates with UserSettingsService and Router
// No template usage - currently injected via BreadcrumbDomService
// Future: Replace DOM injection with proper Angular component rendering
```

### Screenshots
- Compact select dropdown in header area (development only)
- Consistent styling with other VxDmSelect components
- Seamless experience switching without losing navigation context

### Notes
- **Route-Specific Placement**: Demonstrates proper location for route-specific components
- **Development Tooling**: Only visible in development environment for UI experimentation
- **Architectural Pattern**: Shows integration of custom components with shared services
- **Future Enhancement**: TODO for replacing DOM injection with proper component rendering
- **Component Naming**: Follows `vx-dm-` prefix convention for application-specific components
- **Location Strategy**: Placed in `reports/shared/` following route-specific component guidelines

---

## Review Process

### Monthly Review
- **Product Team**: Reviews components for promotion candidates
- **Architecture Team**: Evaluates component patterns and quality
- **UI/UX Team**: Assesses design consistency and user experience

### Promotion Criteria
A component should be promoted to `vertex-ui-shared` if:
- **High Reusability**: Used or could be used by 3+ projects
- **Stable API**: Inputs/outputs are well-defined and unlikely to change
- **Quality Standards**: Follows vertex-ui-shared patterns and includes proper documentation
- **Accessibility**: Meets WCAG 2.1 AA standards
- **Testing**: Has comprehensive Storybook stories and tests

### Promotion Process
1. **Identification**: Component meets promotion criteria
2. **Proposal**: Team creates proposal with component details
3. **Review**: Architecture and Product teams review
4. **Implementation**: vertex-ui-shared team adds component
5. **Migration**: Projects update to use shared component
6. **Cleanup**: Remove custom implementations

---

## Best Practices for Custom Components

### When to Create Custom Components
Only create custom components when:
1. **Checked vertex-ui-shared**: Component doesn't exist in Storybook
2. **Checked Quartz**: Component doesn't exist in Quartz library
3. **Business Need**: Specific business logic requires custom implementation
4. **Reusable**: Component will be used in multiple places

### Component Standards
All custom components MUST:
- Follow vertex-ui-shared naming conventions (`VxComponentName`)
- **Use application-specific selector prefixes**: Components specific to `vertex-ui-disclosure-management` must use `vx-dm-` prefix (e.g., `selector: 'vx-dm-component-name'`)
- **Follow proper component placement strategy** (see Component Location Guidelines below)
- Include proper TypeScript interfaces
- Have Storybook stories for documentation
- Meet WCAG 2.1 AA accessibility standards
- Use vertex-ui-shared components internally when possible
- Be documented in this file

### Component Location Guidelines

**PLACEMENT STRATEGY:**

#### ✅ Application-Wide Components
- **Location**: `src/app/shared/components/[component-name]/`
- **When**: Component is reusable across multiple routes/features
- **Examples**: `VxDmTable`, `VxDmInput`, `VxFileUpload`

#### ✅ Route-Specific Components  
- **Location**: `src/routes/[route-name]/[route-path]/shared/[component-name]/`
- **When**: Component is only used within a specific route or feature area
- **Examples**: `VxDmExperienceSelectorComponent` in `src/routes/reports/reports/shared/vx-dm-experience-selector/`

#### ✅ Single-Use Components
- **Location**: `src/routes/[route-name]/[component-name]/` (alongside the consuming component)
- **When**: Component is used by only one parent component
- **Examples**: Route-specific panels, dialogs, or specialized widgets

**DECISION CRITERIA:**
- **Cross-Route Usage**: Can this component be used by multiple routes? → Application-Wide
- **Route-Specific Logic**: Does this component contain route-specific business logic? → Route-Specific  
- **Single Parent**: Is this component only used by one parent component? → Single-Use
- **Future Reusability**: Could this reasonably be used elsewhere in the future? → Application-Wide

### Anti-Patterns to Avoid
❌ **NEVER**:
- Create one-off HTML scattered in templates
- Duplicate existing vertex-ui-shared functionality
- Create components without proper interfaces
- Skip documentation or Storybook stories
- Bypass accessibility requirements

---

## Contact

Questions about custom components? Contact:
- **Architecture Team**: For technical guidance
- **Product Team**: For promotion decisions  
- **UI/UX Team**: For design consistency
