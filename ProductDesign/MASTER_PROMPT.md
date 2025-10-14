# 🚀 Master Vertex Project Creation Prompt

> **Use this prompt to kickstart a complete Vertex project creation workflow**

## 📋 Prerequisites
- [ ] Product documentation placed in `ProductDesign/docs/`
- [ ] Domain name identified (single, lowercase word)
- [ ] Business requirements clearly defined

---

## 🎯 Complete Project Creation Prompt

```
Hi Cursor! I'm ready to create a new Vertex project. Please follow this complete workflow:

## STEP 1: ANALYZE REQUIREMENTS
First, analyze all the documentation in ProductDesign/docs/ and identify:
1. The core business problem being solved
2. Target user personas
3. A single, lowercase domain name for the project (e.g., 'inventory', 'reporting', 'analytics')
4. Key features and requirements

## STEP 2: CREATE PRD
Using ProductDesign/PRD_Template.md, create a comprehensive Product Requirements Document:
- Extract user stories and personas from the source documents
- Define clear success metrics and KPIs
- Specify the technical architecture using Vertex three-tier pattern
- Identify the domain name and project structure
- Save as: ProductDesign/[DOMAIN_NAME]_PRD.md

## STEP 3: CREATE ADRs FOR MAJOR DECISIONS
Create Architecture Decision Records (ADRs) for the biggest features and cross-cutting concerns to explain how everything works and ties together. Use a lightweight ADR format (title, status, context, decision, consequences, alternatives). Save each ADR as `docs/adrs/ADR-XXXX-[short-slug].md` (e.g., `ADR-0001-domain-bounded-contexts.md`).

Focus ADRs on decisions such as:
- System architecture boundaries and service responsibilities (UI ↔ BFF ↔ Core API)
- Data model strategy and key aggregates/entities
- Integration patterns (sync vs async, eventing, messaging)
- AuthN/AuthZ approach and tenant/organization scoping
- API versioning, pagination, and error-handling conventions
- Reporting/analytics strategy and performance considerations
- Any notable trade-offs impacting UX, scalability, or maintainability

Also include an index file at `docs/adrs/README.md` listing ADRs with short summaries.

## STEP 4: CREATE TDD  
Using ProductDesign/TDD_Template.md, create a Technical Design Document:
- Define the three-tier architecture (vertex-[domain]-ui, vertex-[domain]-bff, vertex-[domain]-api)
- Specify data models using vertex-dotnet-api-sdk base classes (NamedEntityBase, EntityBase, etc.)
- Design API endpoints and data flow with IEFRepository pattern
- Reference Vertex coding standards and patterns
- Save as: ProductDesign/[DOMAIN_NAME]_TDD.md

## STEP 5: CREATE PROGRESS TRACKING
Create three progress tracking documents using templates in docs/PROGRESS_TEMPLATES/:

1. **Core API Progress** (docs/progress-core-api.md)
   - Copy from docs/PROGRESS_TEMPLATES/core-api-template.md
   - Replace [DOMAIN] placeholders with actual domain name
   - Break down Core API tasks based on TDD requirements
   - Prioritize: data models → CRUD operations → business logic → testing

2. **BFF Progress** (docs/progress-bff.md)
   - Copy from docs/PROGRESS_TEMPLATES/bff-template.md  
   - Replace [DOMAIN] placeholders with actual domain name
   - Define data transformation and aggregation requirements
   - Plan Refit interface for Core API communication

3. **Frontend Progress** (docs/progress-ui.md)
   - Copy from docs/PROGRESS_TEMPLATES/ui-template.md
   - Replace [DOMAIN] placeholders with actual domain name
   - Plan component structure and user flows
   - Define integration with BFF service

## STEP 6: IMPLEMENTATION READINESS
After creating all documents, provide:
1. **Implementation Order Summary**: Core API → BFF → Frontend
2. **Domain Summary**: Confirm the domain name and project structure
3. **Next Steps**: Provide the specific prompts to start each implementation phase

## DELIVERABLES CHECKLIST
- [ ] ProductDesign/[DOMAIN_NAME]_PRD.md
- [ ] ProductDesign/[DOMAIN_NAME]_TDD.md  
- [ ] docs/adrs/README.md (index of ADRs)
- [ ] docs/adrs/ADR-XXXX-*.md (ADRs for major decisions)
- [ ] docs/progress-core-api.md
- [ ] docs/progress-bff.md
- [ ] docs/progress-ui.md

When you're done, I'll be ready to start implementation with the Core API service first!
```

---

## 🔄 Follow-up Implementation Prompts

### Start Core API Implementation
```
Ready to implement the Core API! 

🚨 **CRITICAL**: Review docs/CRITICAL_RULES.md before starting implementation!

Please:
1. Review docs/progress-core-api.md 
2. Copy vertex-api-template to vertex-[domain]-api
3. Replace all Template placeholders with [Domain] names
4. 🚨 **MANDATORY**: Use vertex-dotnet-api-sdk base classes (NamedEntityBase, EntityBase) for ALL entities
5. 🚨 **MANDATORY**: Implement repositories using IEFRepository<TEntity> pattern
6. 🚨 **MANDATORY**: Use DbUp for database migrations (NEVER use EF Core migrations)
7. Start with Phase 1 tasks and mark progress as we go
8. Focus on data models and basic CRUD operations first
9. 🚨 **FORBIDDEN**: Do NOT use `dotnet ef migrations` - use DbUp SQL scripts in DBMigrations/yyyymmdd/ only

Let's begin with the project setup and structure!
```

### Start BFF Implementation (After Core API Complete)
```
The Core API is complete! Time for the BFF service.

Please:
1. Review docs/progress-bff.md
2. Copy vertex-bff-template to vertex-[domain]-bff  
3. Create Refit interfaces for the Core API
4. Implement data transformation logic for the frontend
5. Start with Phase 1 tasks and mark progress as we go

Let's begin with the BFF project setup!
```

### Start Frontend Implementation (After BFF Complete)
```
Both APIs are ready! Time for the Angular frontend.

🚨 **CRITICAL**: ALL UI components MUST use vertex-ui-shared. NEVER create custom UI components!
🚨 **CRITICAL**: ALL user-facing text MUST use the translation system!
🚨 **CRITICAL**: ALL applications MUST meet WCAG 2.1 AA accessibility standards!

Please:
1. Review docs/progress-ui.md
2. Copy vertex-ui-template to vertex-[domain]-ui
3. Create components and services for the domain
4. Integrate with the BFF service
5. 🚨 **MANDATORY**: Follow component hierarchy: 1) vertex-ui-shared, 2) Quartz, 3) Custom reusable (check docs/CRITICAL_RULES.md)
6. 🚨 **MANDATORY**: Use `{{ 'module.key' | translate }}` for ALL user-facing text
7. 🚨 **MANDATORY**: Import TranslatePipe in all components with user-facing text
8. 🚨 **MANDATORY**: Configure ESLint with `...angular.configs.templateAccessibility`
9. 🚨 **MANDATORY**: Install `@storybook/addon-a11y` for accessibility testing
10. 🚨 **MANDATORY**: Test with axe DevTools browser extension
11. 🚨 **FORBIDDEN**: One-off HTML scattered in templates, custom components when libraries have them
12. 🚨 **MANDATORY**: If custom components needed, create in `src/app/shared/components/` and document in `CUSTOM_COMPONENTS.md`
13. 🚨 **FORBIDDEN**: Hardcoded strings for user-facing text
14. 🚨 **FORBIDDEN**: Bypassing accessibility rules or missing ARIA attributes
15. Start with Phase 1 tasks and mark progress as we go

Let's begin with the frontend project setup!
```

---

## 📚 Reference Documents

During implementation, reference these key documents:
- `docs/CODING_STANDARDS.md` - Coding conventions and patterns
- `docs/ARCHITECTURE_GUIDE.md` - System architecture details
- `docs/PROJECT_CREATION_GUIDE.md` - Step-by-step implementation guide
- `docs/examples/COMMON_PATTERNS.md` - Implementation examples
- `docs/RECOMMENDED_ADDITIONS.md` - Future enhancements (not for initial implementation)

**Ready to create your Vertex project? Use the master prompt above to get started!**
