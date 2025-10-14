# Report Workspace Component Refactoring - Vertex/Quartz Standards Compliance

## **Context & Background**

The Report Workspace is the core authoring environment for Disclosure Management, where ESG professionals complete framework-compliant reports (CDP, CSRD/ESRS, SEC Climate Rule). This component represents the primary user interaction point for disclosure report completion and must exemplify professional-grade authoring capabilities while maintaining full compliance with Vertex platform standards.

## **Current State Analysis**

### **Existing Functionality (Must Preserve)**
- **Question Navigation**: Hierarchical question tree with expand/collapse functionality
- **Multi-format Answer Support**: Text, numeric, boolean, currency, date input types with validation
- **Real-time Progress Tracking**: Live completion percentage calculations and status updates  
- **Search & Filtering**: Question search by text/code and status-based filtering (answered/unanswered)
- **Document Integration**: Contextual document management access and workflow integration
- **Form State Management**: Angular reactive forms with proper validation and state persistence
- **Collaboration Features**: Progress visibility and workflow coordination capabilities
- **Responsive Design**: Professional layout supporting different screen sizes and workflows

### **Current Technical Implementation**
- **Component Type**: Angular standalone component with signal-based state management
- **State Management**: Signals for reactive updates (`workspaceData`, `selectedQuestion`, `filteredQuestions`)
- **API Integration**: BFF service integration for report workspace data and answer persistence
- **Form Handling**: Angular reactive forms with custom validation logic
- **Navigation**: Router-based navigation with parameter handling

## **Standards Compliance Requirements**

### **🚨 CRITICAL - Vertex UI Shared Components (ADR-0004)**
**MANDATORY**: Replace all custom UI elements with vertex-ui-shared components following strict hierarchy:

1. **Primary**: `@se-sustainability-business/vertex-ui-shared` components (ALWAYS FIRST)
2. **Secondary**: Quartz components (if vertex-ui-shared doesn't provide it)  
3. **Last Resort**: Custom components (document in CUSTOM_COMPONENTS.md)

### **Required Component Replacements**

#### **Form Elements (CRITICAL)**
- **Labels**: Replace all native labels with `<vx-label>` from vertex-ui-shared/form-label
- **Text Inputs**: Replace `input` with `qzInput` directive from vertex-ui-shared/input
- **Select Dropdowns**: Replace native `<select>` with `<vx-select>` from vertex-ui-shared/select  
- **Radio Groups**: Replace custom radio with `<vx-radio-group>` from vertex-ui-shared/radio-group
- **Buttons**: Replace all buttons with `qz-button` from vertex-ui-shared/button
- **Textareas**: Apply `qzInput` directive to all textarea elements

#### **UI Components (CRITICAL)**
- **Loading States**: Replace custom loading with `<vx-loading-state>` from shared components
- **Empty States**: Replace custom empty states with `<vx-empty-state>` from shared components  
- **Alert Messages**: Replace custom alerts with `<vx-alert-banner>` from shared components
- **Status Indicators**: Replace custom status with `<vx-status-badge>` and `<vx-status-indicator>`
- **Progress Indicators**: Use vertex-ui-shared progress components for completion tracking

### **Translation Requirements (CRITICAL)**
- **ALL user-facing text** must use `{{ 'module.key' | translate }}` pattern
- **Translation keys** must follow `module.key` format (e.g., 'workspace.selectQuestion', 'workspace.answerRequired')
- **Import TranslatePipe**: `import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate'`
- **Translation file**: Create/update `public/i18n/en.json` with alphabetically sorted keys

### **Accessibility Requirements (CRITICAL)**
- **WCAG 2.1 AA compliance**: All interactive elements must meet accessibility standards
- **ARIA attributes**: Proper `role`, `aria-label`, `aria-expanded`, `aria-disabled` usage
- **Keyboard navigation**: All functionality accessible via keyboard shortcuts
- **Screen reader support**: Semantic markup and proper heading hierarchy

### **Component Architecture Standards (ADR-0004)**
- **Smart/Dumb Separation**: Report-workspace.component.ts as smart component, extract presentational components
- **Signal-based State**: Continue using Angular signals for reactive state management
- **Standalone Components**: Maintain Angular 20+ standalone component architecture
- **Service Layer**: Preserve existing BFF service integration patterns

## **Refactoring Scope**

### **Phase 1: Component Library Migration**
1. **Form Elements**: Replace all form controls with vertex-ui-shared equivalents
2. **UI Components**: Replace loading, empty states, alerts, status indicators
3. **Button Standardization**: Convert all buttons to use qz-button with proper importance levels
4. **Translation Implementation**: Add translation pipe to all user-facing text

### **Phase 2: Component Architecture**  
1. **Component Extraction**: Create focused dumb components for reusable sections
2. **Accessibility Enhancement**: Add proper ARIA labels and keyboard navigation
3. **Style Cleanup**: Remove custom Tailwind classes where vertex-ui-shared provides styling
4. **Type Safety**: Ensure proper TypeScript typing throughout

### **Phase 3: Integration & Testing**
1. **Functionality Validation**: Ensure all existing features work with new components
2. **Performance Optimization**: Validate no performance regression from component changes  
3. **Cross-browser Testing**: Verify compatibility across supported browsers
4. **Accessibility Testing**: Validate WCAG 2.1 AA compliance with axe DevTools

## **Key Files to Modify**

### **Primary Target Files**
- `src/routes/reports/report-workspace.component.ts` - Smart component refactoring
- `src/routes/reports/report-workspace.component.html` - Template migration to vertex-ui-shared
- `src/routes/reports/report-workspace.component.css` - Style cleanup and consolidation

### **Supporting Files**
- `public/i18n/en.json` - Translation keys for all user-facing text
- `CUSTOM_COMPONENTS.md` - Documentation of any custom components created
- Component extraction files (if creating new presentational components)

## **Success Criteria**

### **Functional Requirements**
- ✅ All existing functionality preserved without regression  
- ✅ Same user workflows and interaction patterns maintained
- ✅ Form validation and state management working correctly
- ✅ API integration and data persistence functioning as before
- ✅ Navigation and routing behavior unchanged

### **Standards Compliance**
- ✅ 100% vertex-ui-shared component usage where available
- ✅ All user-facing text using translation pipes
- ✅ WCAG 2.1 AA compliance validated
- ✅ No ESLint/TypeScript errors or warnings
- ✅ Clean Architecture and component separation maintained

### **Code Quality**
- ✅ Proper TypeScript typing throughout  
- ✅ Clean, maintainable component structure
- ✅ Consistent naming conventions and code organization
- ✅ Comprehensive error handling and loading states
- ✅ Professional UI appearance matching Vertex design system

## **Domain Context Reference**

### **Disclosure Management Overview**
The platform enables organizations to create complete, framework-compliant ESG disclosure reports by:
- Selecting from standardized frameworks (CDP, CSRD/ESRS, SEC Climate Rule)
- Leveraging existing data from Indicator Management systems  
- Completing comprehensive disclosure reports with professional authoring capabilities
- Integrating supporting documents and evidence for regulatory compliance

### **Report Workspace Role**
This component serves as the professional authoring environment where users:
- Navigate hierarchical question structures with parent/child relationships
- Complete answers using appropriate input types (text, numeric, boolean, date, currency)
- Track completion progress in real-time across complex framework requirements
- Collaborate with team members on report completion workflows
- Access contextual document management and evidence integration

### **User Experience Goals**
- **Professional Grade**: Match quality of leading document editing platforms
- **Efficiency Focused**: 90% reduction in disclosure preparation time compared to manual processes  
- **Collaboration Enabled**: Team-based workflows with clear progress tracking
- **Compliance Ready**: Audit trails and regulatory submission preparation

---

*This refactoring maintains all existing functionality while elevating the component to exemplify Vertex platform standards and provide a professional-grade user experience for ESG disclosure authoring.*
