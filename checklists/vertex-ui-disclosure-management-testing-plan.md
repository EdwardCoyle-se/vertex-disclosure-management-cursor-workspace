# Vertex UI Disclosure Management - Documents Panel Testing Plan

## Overview

This testing plan provides a focused, incremental approach to implementing tests for the vertex-ui-disclosure-management Angular application, **specifically targeting the documents panel functionality**. This plan prioritizes getting basic test coverage around the documents panel and its behavior with small, easily-saved implementation steps.

## Testing Infrastructure & Standards

### Current Setup

- **Testing Framework**: Jasmine + Karma (configured via vertex-ui-shared)
- **Coverage Tool**: karma-coverage
- **CI Integration**: karma-junit-reporter
- **Target Coverage**: >85% for frontend components (per Vertex standards)
- **Test Pattern**: Arrange-Act-Assert (AAA)

### Key Testing Principles from Vertex Documentation

- **Signal-based Testing**: Test Angular signals and computed values
- **Component Architecture**: Test standalone components with proper imports
- **Service Testing**: Mock dependencies and test both success/error scenarios
- **Integration Testing**: Include vertex-ui-shared components directly in tests
- **Incremental Coverage**: Start with basic functionality, build up over time

### Testing Focus & Scope

**🎯 Primary Focus**: Documents Panel functionality and related components
**📈 Coverage Strategy**: Incremental - basic coverage first, comprehensive later
**🔧 Integration Approach**: Include vertex-ui-shared components directly (no mocking)
**♿ Accessibility**: Functional tests first, axe-core accessibility testing to be added later

## Testing Categories & Priorities

## 🎯 Documents Panel Testing - Core Focus

### Step 1: Documents Panel Component (`documents-panel.component.ts`)

**Implementation Priority**: Start here - Core business functionality
**Complexity**: High - File operations, table management, dialog interactions
**Testing Strategy**: Incremental - basic functionality first, edge cases later

#### Phase 1A: Basic Component Setup & Initialization (Start Here)

- [ ] **Component Creation & Initialization**
  - [ ] Component renders without errors with required inputs
  - [ ] Default signal values are set properly (documents, isLoading, error)
  - [ ] Effect for loading documents triggers on reportId change
  - [ ] Component integrates with vertex-ui-shared table component

#### Phase 1B: Document Loading & Service Integration

- [ ] **Document Loading & Display**
  - [ ] `loadDocuments()` calls DocumentService correctly with reportId
  - [ ] Loading state management during API calls (isLoading signal)
  - [ ] Error handling for failed document loads (error signal)
  - [ ] Documents list populated in table correctly
  - [ ] Empty state displayed when no documents exist

#### Phase 1C: Basic File Operations

- [ ] **File Download**
  - [ ] `downloadDocument()` creates download link correctly
  - [ ] Download handles success/error states
  - [ ] File download triggers with correct metadata

- [ ] **File Delete Workflow**
  - [ ] `deleteDocument()` shows confirmation dialog
  - [ ] `performDeleteDocument()` calls service and refreshes list
  - [ ] Delete confirmation dialog state management

#### Phase 1D: Upload Dialog Integration

- [ ] **Upload Dialog Basic Flow**
  - [ ] `openUploadDialog()` shows upload dialog
  - [ ] `onUploadComplete()` handles success cases
  - [ ] `onUploadCancelled()` closes dialog properly
  - [ ] Document list refreshes after successful upload

#### Phase 1E: Utility Functions & Edge Cases

- [ ] **Utility Functions**
  - [ ] `formatFileSize()` formats bytes correctly (0, small, large numbers)
  - [ ] `getTotalFileSize()` calculates total correctly
  - [ ] `formatDate()` handles valid/invalid dates
  - [ ] `getCategoryDisplayName()` handles undefined categories

### Step 2: Upload Dialog Component (`vx-dm-upload-dialog.component.ts`)

**Implementation Priority**: After documents panel basic tests
**Focus**: File upload functionality integration

#### Phase 2A: Upload Dialog Component

- [ ] **Component Creation & UI**
  - [ ] Component renders with proper template
  - [ ] File upload area displays correctly
  - [ ] Upload dialog integrates with vertex-ui-shared dialog components

- [ ] **Upload Functionality**
  - [ ] File selection handling
  - [ ] Upload success/error handling
  - [ ] Result emission to parent component

### Step 3: Supporting Components (Document Panel Dependencies)

**Implementation Priority**: Components specifically used by documents panel

#### VxDmTableComponent (Documents Table Integration)

**Priority**: Test as used by documents panel
**Focus**: Integration with documents data, not comprehensive table testing

- [ ] **Documents Table Integration**
  - [ ] Table renders document data correctly
  - [ ] Column templates display file information
  - [ ] Table pagination works with document lists
  - [ ] Basic sorting functionality

#### VxDmConfirmationDialogComponent (Delete Confirmation)

**Priority**: Test as used by documents panel
**Focus**: Delete confirmation workflow integration

- [ ] **Confirmation Dialog for Document Delete**
  - [ ] Dialog displays delete confirmation correctly
  - [ ] Confirm/cancel buttons work properly
  - [ ] Dialog integrates with documents panel state

### Step 4: Supporting Services (Document Panel Dependencies)

**Implementation Priority**: Services specifically used by documents panel

#### DocumentService (`document.service.ts`)

**Priority**: Essential for documents panel functionality
**Focus**: Document operations used by documents panel

- [ ] **Document CRUD Operations (Documents Panel Focused)**
  - [ ] `getReportDocuments()` - Test success/error scenarios
  - [ ] `uploadDocument()` - Test basic upload functionality  
  - [ ] `downloadDocument()` - Test download with proper response handling
  - [ ] `deleteDocument()` - Test delete operation and response

- [ ] **Service Integration**
  - [ ] Service properly configured with HTTP client
  - [ ] Error handling returns observable error states
  - [ ] Success responses return expected data structures

## 🚫 Out of Scope (For Later Implementation)

The following components and services are **not included** in this focused documents panel testing plan and should be addressed in future testing iterations:

### Deferred Components

- Dashboard Component
- Reports Components (create, list)
- Framework Components (library, detail)
- BffService (broader API functionality beyond documents)
- Authentication & Configuration Services
- Other Shared UI Components not used by documents panel

### Deferred Testing Areas

- **Comprehensive Table Testing**: Full VxDmTableComponent functionality beyond document display
- **Form Components**: Input, Select, Textarea components
- **Comprehensive Integration Testing**: Cross-component workflows
- **Performance Testing**: Large dataset handling
- **E2E Testing**: Full user workflows

### Future Accessibility Testing

📝 **Note for Future Implementation**: Add axe-core accessibility testing after functional test coverage is established. This should include:

- Automated accessibility testing with `@storybook/addon-a11y`
- axe-core integration in unit tests
- Keyboard navigation testing
- Screen reader compatibility testing

## 🛠️ Incremental Implementation Strategy

### Phase 1: Setup & DocumentService (Start Here - 1-2 days)

#### Step 1A: Testing Infrastructure Setup

- [ ] **Basic Testing Setup**
  - [ ] Create shared test utilities folder (`src/shared/testing/`)
  - [ ] Create mock factory for DocumentService
  - [ ] Create sample document test data
  - [ ] Verify karma test runner works

#### Step 1B: DocumentService Testing

- [ ] **Core Document Service Tests**
  - [ ] Test `getReportDocuments()` with mock HTTP responses
  - [ ] Test `downloadDocument()` basic functionality
  - [ ] Test `deleteDocument()` basic functionality
  - [ ] Test error handling for network failures

### Phase 2: Documents Panel Core (2-3 days)

#### Step 2A: Basic Component Rendering

- [ ] **Documents Panel Component Creation**
  - [ ] Component renders without errors
  - [ ] Basic input handling (reportId)
  - [ ] Signal initialization (documents, isLoading, error)
  - [ ] Integration with vertex-ui-shared table

#### Step 2B: Document Loading Flow

- [ ] **Document Loading Tests**
  - [ ] `loadDocuments()` calls DocumentService correctly
  - [ ] Loading state management (isLoading signal)
  - [ ] Documents populate in table
  - [ ] Error state handling

### Phase 3: File Operations (2-3 days)

#### Step 3A: Download & Delete

- [ ] **File Operation Tests**
  - [ ] Download document creates proper link
  - [ ] Delete shows confirmation dialog
  - [ ] Delete operation calls service and refreshes list
  - [ ] Action availability methods work correctly

#### Step 3B: Upload Integration

- [ ] **Upload Dialog Integration**
  - [ ] Upload dialog opens/closes correctly
  - [ ] Upload completion refreshes document list
  - [ ] Upload cancellation handles properly

### Phase 4: Polish & Edge Cases (1-2 days)

#### Step 4A: Utility Functions

- [ ] **Utility Function Tests**
  - [ ] `formatFileSize()` handles various sizes
  - [ ] `getTotalFileSize()` calculates correctly
  - [ ] Date formatting handles edge cases

#### Step 4B: Upload Dialog Component

- [ ] **Upload Dialog Component Tests**
  - [ ] Component renders with vertex-ui-shared integration
  - [ ] File upload basic functionality
  - [ ] Result emission to parent

### Phase 5: Integration & Cleanup (1 day)

#### Step 5A: Integration Testing

- [ ] **Component Integration**
  - [ ] Documents panel + upload dialog integration
  - [ ] Documents panel + confirmation dialog integration
  - [ ] End-to-end document workflow (view → upload → delete)

#### Step 5B: Test Coverage Review

- [ ] **Coverage & Documentation**
  - [ ] Review test coverage for documents panel functionality
  - [ ] Document any testing patterns created
  - [ ] Note areas for future enhancement

## ⏱️ Realistic Timeline

**Total Estimated Time**: 7-10 days
**Approach**: Small, easily-saved increments
**Goal**: Basic test coverage around documents panel functionality

Each phase can be completed and saved independently, allowing for flexible scheduling and incremental progress.

## 📏 Testing Standards & Patterns

### Test File Structure

```text
src/
├── [component-folder]/
│   ├── component.ts
│   ├── component.html
│   ├── component.css
│   └── component.spec.ts    # ← Test file here
├── services/
│   ├── service.ts
│   └── service.spec.ts      # ← Test file here
└── shared/
    └── testing/             # ← Shared test utilities
        ├── test-helpers.ts
        ├── mock-factories.ts
        └── test-data.ts
```

### Test Naming Conventions

- **Test files**: `*.spec.ts`
- **Test suites**: Describe component/service name
- **Test cases**: Use clear, behavior-focused descriptions
- **Mock objects**: Prefix with `mock` or `stub`

### Test Structure Pattern

```typescript
describe('ComponentName', () => {
  let component: ComponentName;
  let fixture: ComponentFixture<ComponentName>;
  let mockService: jasmine.SpyObj<ServiceName>;

  beforeEach(async () => {
    // Setup TestBed configuration
    // Create component fixture
    // Setup mocks and spies
  });

  describe('Component Creation', () => {
    it('should create', () => {
      expect(component).toBeTruthy();
    });
  });

  describe('Feature Group', () => {
    it('should behave correctly when...', () => {
      // Arrange
      // Act  
      // Assert
    });
  });
});
```

### Mock Strategies

- **Services**: Use `jasmine.createSpyObj()` for service mocks (DocumentService, BffService)
- **HTTP**: Use Angular's `HttpTestingController` for service testing
- **Signals**: Create mock signals with `signal()` for testing
- **vertex-ui-shared**: **Include directly** (do not mock) for integration testing

### Coverage Requirements

- **Initial Goal**: Basic functional coverage for documents panel
- **Long-term Target**: 85% per Vertex standards (future enhancement)
- **Focus Areas**: Core document operations and user workflows
- **Approach**: Incremental coverage improvement over time

## 🔍 Accessibility Testing (Future Implementation)

**📝 Note**: Accessibility testing with axe-core is planned for future implementation after functional test coverage is established.

**Future Accessibility Testing Requirements**:

- [ ] Configure `@storybook/addon-a11y` for real-time testing
- [ ] Add axe-core testing in unit tests
- [ ] ESLint accessibility rules enforcement
- [ ] Keyboard navigation testing for document operations
- [ ] Screen reader compatibility testing
- [ ] Focus management testing for dialogs

## 📊 Success Metrics

### Quantitative Targets

- [ ] **Initial Coverage**: Basic functional coverage for documents panel components
- [ ] **Test Performance**: Document panel tests complete in <10 seconds
- [ ] **Test Reliability**: Tests run consistently without flakiness
- [ ] **CI Integration**: New tests integrate with existing CI/CD pipeline

### Qualitative Targets

- [ ] **Test Maintainability**: Tests are easy to understand and modify
- [ ] **Regression Protection**: Tests catch document panel regressions
- [ ] **Documentation**: Tests demonstrate document panel usage patterns
- [ ] **Foundation**: Creates testing foundation for future component testing

## 📋 Implementation Checklist

### Pre-Implementation Setup

- [ ] Review this focused testing plan approach
- [ ] Verify vertex-ui-shared integration strategy
- [ ] Confirm documents panel is priority component
- [ ] Set up basic testing utilities for document testing

### During Implementation

- [ ] Follow the incremental 5-phase approach
- [ ] Save progress after each small step
- [ ] Focus on documents panel functionality only
- [ ] Build test foundation for future component expansion

### Post-Implementation

- [ ] Review documents panel test coverage
- [ ] Document testing patterns created for documents functionality
- [ ] Identify next components for testing (based on priority)
- [ ] Create foundation for expanding to other components

## 🚀 Ready to Start Implementation

Based on your feedback, this plan now focuses specifically on:

✅ **Documents Panel Priority**: Starting with documents panel and related components only
✅ **Incremental Approach**: Small, easily-saved steps over 7-10 days  
✅ **Integration Testing**: Including vertex-ui-shared components directly (no mocking)
✅ **Functional Focus**: Basic test coverage first, comprehensive testing later
✅ **Future Accessibility**: axe-core accessibility testing noted for later implementation

## 🎯 Next Steps

**Ready to begin with Phase 1 (DocumentService testing)**:

1. Set up basic testing infrastructure
2. Create DocumentService mock and test data
3. Test core document operations used by documents panel

**Implementation can start immediately** with Step 1A (Testing Infrastructure Setup) and proceed incrementally through the 5-phase plan.

---

**Let's begin!** Should we start with Phase 1 (DocumentService testing) or would you like me to jump directly to documents panel component testing?
