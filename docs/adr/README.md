# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records for the Disclosure Management platform.

## Index of ADRs

### Core Architecture Decisions

| ADR | Title | Status | Date | Summary |
|-----|-------|--------|------|---------|
| [ADR-0001](ADR-0001-domain-bounded-contexts.md) | Domain Bounded Contexts | Approved | - | Defines domain boundaries and bounded contexts for the Disclosure Management system |
| [ADR-0002](ADR-0002-data-model-strategy.md) | Data Model Strategy | Approved | - | Establishes data modeling patterns and entity relationships |
| [ADR-0003](ADR-0003-api-design-patterns.md) | API Design Patterns | Approved | - | Defines API endpoint conventions, versioning, and communication patterns |
| [ADR-0004](ADR-0004-frontend-architecture-patterns.md) | Frontend Architecture Patterns | Approved | - | Establishes Angular component patterns and state management approaches |
| [ADR-0005](ADR-0005-document-upload-ai-integration.md) | Document Upload AI Integration | Approved | - | Defines integration patterns for AI-powered document processing |

### Feature-Specific Decisions

| ADR | Title | Status | Date | Summary |
|-----|-------|--------|------|---------|
| [ADR-ESG-13441](ADR-ESG-13441-manual-publish-workflow.md) | Manual Publish Workflow | Approved | 2024-10-15 | Implements manual publishing for reports, replacing automatic publishing with user-controlled workflow |

## ADR Status Definitions

- **Proposed**: Decision has been drafted but not yet reviewed
- **In Review**: Decision is under review by stakeholders
- **Approved**: Decision has been accepted and is being/has been implemented
- **Superseded**: Decision has been replaced by a newer ADR
- **Rejected**: Decision was considered but not approved

## Creating a New ADR

To create a new ADR, use the template in `ProductDesign/ADR_Template.md` and follow these guidelines:

1. **Naming Convention**: Use `ADR-[JIRA-ID]-[short-description].md` or `ADR-YYYYMMDD-[short-description].md`
2. **Complete All Sections**: Fill out all sections of the template
3. **Review Process**: Submit for architecture team review before marking as "Approved"
4. **Update This Index**: Add the new ADR to the appropriate section above

## Related Documentation

- [Product Requirements Document (PRD)](../../ProductDesign/DisclosureManagement_PRD.md)
- [Technical Design Document (TDD)](../../ProductDesign/DisclosureManagement_TDD.md)
- [Coding Standards](../CODING_STANDARDS.md)
- [Architecture Guide](../ARCHITECTURE_GUIDE.md)

