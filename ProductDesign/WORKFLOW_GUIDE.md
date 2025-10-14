# Vertex Project Creation Workflow

> **Purpose**: Step-by-step workflow for creating new Vertex projects using Cursor AI.

## 🎯 Overview

This workflow ensures systematic creation of Vertex projects with proper documentation, planning, and implementation order.

## 📋 Workflow Steps

### Phase 1: Requirements & Design
1. **Product Team**: Place product documentation in `ProductDesign/docs/`
2. **Create PRD**: Use Cursor to generate Product Requirements Document
3. **Create TDD**: Use Cursor to generate Technical Design Document
4. **Create Progress Plans**: Generate three separate progress tracking documents

### Phase 2: Implementation (Ordered)
1. **Core API Service** (First - provides data foundation)
2. **BFF Service** (Second - transforms core data for UI)
3. **Angular Frontend** (Third - consumes BFF data)

---

## 🚀 Phase 1: Requirements & Design

### Step 1: Product Documentation
**Product Team Action:**
- Place all product documentation, requirements, market research, etc. in `ProductDesign/docs/`
- Examples: user stories, wireframes, business requirements, competitive analysis

### Step 2: Generate PRD
**Cursor Prompt:**
```
I need you to create a Product Requirements Document (PRD) using the template in ProductDesign/PRD_Template.md. 

Please analyze all the documentation in ProductDesign/docs/ and use it to populate the PRD template. Make sure to:
1. Identify a clear, lowercase domain name for the project
2. Extract user personas and requirements
3. Define clear success metrics
4. Specify the technical architecture using Vertex standards

Save the completed PRD as ProductDesign/[DOMAIN_NAME]_PRD.md
```

### Step 3: Generate TDD
**Cursor Prompt:**
```
Now create a Technical Design Document (TDD) using the template in ProductDesign/TDD_Template.md based on the PRD you just created.

Please:
1. Use the domain name from the PRD
2. Define the three-tier architecture (Angular UI, BFF, Core API)
3. Specify data models and API endpoints
4. Include database schema design
5. Reference the Vertex coding standards and patterns

Save the completed TDD as ProductDesign/[DOMAIN_NAME]_TDD.md
```

### Step 4: Generate Progress Plans
**Cursor Prompt:**
```
Based on the PRD and TDD, create three separate progress tracking documents:

1. docs/progress-core-api.md - Tasks for the Core API service
2. docs/progress-bff.md - Tasks for the BFF service  
3. docs/progress-ui.md - Tasks for the Angular frontend

Use the templates in docs/PROGRESS_TEMPLATES/ and break down all work into specific, actionable tasks. The Core API should be completed first since it provides the data foundation for the other services.

Order the tasks by dependency and complexity, with core CRUD operations first, then business logic, then integrations.
```

---

## 🏗️ Phase 2: Implementation

### Implementation Order

#### 1. Core API Service (vertex-[domain]-api)
**Start Prompt:**
```
I'm ready to start implementing the Core API service for [DOMAIN]. 

Please:
1. Copy and customize the vertex-api-template for the [DOMAIN] domain
2. Replace all Template placeholders with [DOMAIN] names
3. Implement the data models from the TDD
4. Create the database entities and migrations
5. Implement basic CRUD operations following the CQRS pattern

Track progress in docs/progress-core-api.md and mark tasks as completed as we go.
```

#### 2. BFF Service (vertex-[domain]-bff)
**Start Prompt:**
```
Now that the Core API is complete, let's implement the BFF service for [DOMAIN].

Please:
1. Copy and customize the vertex-bff-template for the [DOMAIN] domain
2. Create Refit interfaces to communicate with the Core API
3. Implement data transformation logic for the UI
4. Create dashboard/aggregation endpoints as needed
5. Set up proper error handling and logging

Track progress in docs/progress-bff.md and mark tasks as completed.
```

#### 3. Angular Frontend (vertex-[domain]-ui)
**Start Prompt:**
```
Finally, let's implement the Angular frontend for [DOMAIN].

Please:
1. Copy and customize the vertex-ui-template for the [DOMAIN] domain
2. Create components based on the user flows in the PRD
3. Implement services to communicate with the BFF
4. Add proper routing and navigation
5. Use vertex-ui-shared components consistently
6. Implement proper error handling and user feedback

Track progress in docs/progress-ui.md and mark tasks as completed.
```

---

## 📊 Progress Tracking

Each progress file should be updated as work is completed:
- Mark tasks as `✅ Completed`, `🚧 In Progress`, or `📋 Pending`
- Add notes about decisions or changes
- Reference specific commits or pull requests
- Update estimates and timelines

## 🔄 Iteration

After initial implementation:
1. Review and test integration between services
2. Gather feedback from stakeholders
3. Plan additional features or improvements
4. Update progress files with new tasks

---

**Note**: This workflow ensures systematic development with proper documentation and dependency management. Always complete the Core API first to establish the data foundation.
