### **AI Prompt: ADR Generation Template**

**Your Role:** You are an expert Solution Architect working on Vertex sustainability platform projects. Your task is to generate a comprehensive Architecture Decision Record (ADR) for `[Decision Title]`. You will be given source documents containing technical requirements, feature specifications, and architectural considerations.

**Context for Cursor AI:** This ADR will document architectural decisions for Vertex applications following the three-tier architecture:
1. **Angular Frontend** (`vertex-[domain]-ui`) - User interface using vertex-ui-shared components
2. **BFF Service** (`vertex-[domain]-bff`) - Backend-for-Frontend API for UI-specific data transformation
3. **Core API** (`vertex-[domain]-api`) - Domain CRUD operations with Clean Architecture/CQRS

**Your Instructions:** Use the provided source material to populate the following ADR template. Focus on architectural decisions that impact the technical implementation using the Vertex architecture patterns. Adhere strictly to the structure and instructions for each section. If information is not available in the source documents, use placeholders like `[TBD - To Be Determined]` or `[Information not provided in source documents]`. Maintain a clear, concise, and technical tone that development teams can easily understand and implement.

---

### **ADR Title**

**Naming Convention:**
`[Instructions: Follow the established naming structure. If associated with a JIRA Epic, use format: [JIRA-Epic-ID]-[Short-Description]. If no JIRA Epic exists, use: YYYYMMDD-[Short-Description]. Examples: "PROJ-1234-Event-Streaming-Architecture" or "20241201-Caching-Strategy-Implementation"]`

**Title:** `[ADR Title following naming convention]`

---

### **1. Status**

`[Instructions: Specify the current status of this ADR. Use one of the following statuses based on the decision lifecycle.]`

**Status:** `[Proposed | In Review | Approved | Superseded | Rejected]`

**Date:** `[Date when status was last updated]`

**Decision Makers:** `[List key stakeholders who approved/will approve this decision]`

---

### **2. Context**

`[Instructions: Provide comprehensive background information that led to this architectural decision. Explain the current situation, constraints, and forces that influence the decision. Include business requirements, technical limitations, and any relevant context from the source documents.]`

**2.1. Background**
`[Describe the current situation and why this decision is needed]`

**2.2. Problem Statement**
`[Clearly articulate the specific problem or challenge that requires an architectural decision]`

**2.3. Constraints & Requirements**
`[List technical, business, regulatory, or resource constraints that influence the decision]`
- **Technical Constraints:** `[e.g., Performance requirements, existing system limitations]`
- **Business Constraints:** `[e.g., Budget, timeline, compliance requirements]`
- **Architectural Constraints:** `[e.g., Must align with Vertex three-tier architecture]`

**2.4. Stakeholders**
`[Identify who is impacted by this decision]`
- **Primary:** `[Teams/roles directly affected]`
- **Secondary:** `[Teams/roles indirectly affected]`

---

### **3. Decision**

`[Instructions: State the architectural decision clearly and concisely. Describe what will be implemented, including specific technologies, patterns, or approaches chosen.]`

**3.1. Decision Statement**
`[A clear, one-sentence summary of the decision made]`

**3.2. Solution Overview**
`[Detailed description of the chosen solution, including:]`
- **Technology Stack:** `[Specific technologies, frameworks, libraries chosen]`
- **Architecture Pattern:** `[Design patterns, architectural styles adopted]`
- **Implementation Approach:** `[High-level implementation strategy]`
- **Integration Points:** `[How this decision integrates with existing Vertex components]`

**3.3. Technical Specifications**
`[Include relevant technical details such as:]`
- **Data Models:** `[Key entities, relationships, or schema changes. CRITICAL: Specify which vertex-dotnet-api-sdk base class to use (NamedEntityBase, EntityBase, MinimalEntityBase, EntityAuditBase)]`
- **Repository Pattern:** `[How repositories will implement IEFRepository<TEntity> from vertex-dotnet-api-sdk]`
- **Resource ID Strategy:** `[VARCHAR(54) format: <application>_<assetType>_<guid>]`
- **API Design:** `[Endpoint patterns, data formats, versioning approach]`
- **Database Changes:** `[Schema modifications, migration strategies]`
- **Security Considerations:** `[Authentication, authorization, data protection]`

---

### **4. Reasoning**

`[Instructions: Explain why this decision was made. Include the evaluation criteria used, how alternatives were assessed, and the key factors that led to this choice.]`

**4.1. Evaluation Criteria**
`[List the criteria used to evaluate options, such as:]`
- **Performance:** `[Response time, throughput, scalability requirements]`
- **Maintainability:** `[Code complexity, team expertise, long-term support]`
- **Cost:** `[Development cost, operational cost, licensing]`
- **Risk:** `[Technical risk, business risk, security risk]`
- **Alignment:** `[Consistency with Vertex standards and patterns]`

**4.2. Key Decision Factors**
`[Explain the most important factors that influenced the decision]`

**4.3. Trade-offs Accepted**
`[Document what was sacrificed or compromised to achieve the chosen solution]`

---

### **5. Alternatives Considered**

`[Instructions: Document the alternative solutions that were evaluated but not chosen. For each alternative, explain why it was rejected.]`

**5.1. Alternative 1: [Alternative Name]**
- **Description:** `[Brief description of the alternative]`
- **Pros:** `[Advantages of this approach]`
- **Cons:** `[Disadvantages that led to rejection]`
- **Rejection Reason:** `[Primary reason why this was not chosen]`

**5.2. Alternative 2: [Alternative Name]**
- **Description:** `[Brief description of the alternative]`
- **Pros:** `[Advantages of this approach]`
- **Cons:** `[Disadvantages that led to rejection]`
- **Rejection Reason:** `[Primary reason why this was not chosen]`

**5.3. Alternative N: [Alternative Name]**
`[Continue for each significant alternative considered]`

---

### **6. Consequences**

`[Instructions: Document the implications of this decision, both positive and negative. Include immediate impacts and long-term consequences.]`

**6.1. Positive Consequences**
`[Benefits and advantages gained from this decision]`
- **Technical Benefits:** `[Performance improvements, scalability gains, etc.]`
- **Business Benefits:** `[Cost savings, faster delivery, better user experience]`
- **Team Benefits:** `[Improved developer experience, better maintainability]`

**6.2. Negative Consequences**
`[Challenges, limitations, or technical debt introduced]`
- **Technical Debt:** `[Any shortcuts taken or future work required]`
- **Operational Overhead:** `[Additional monitoring, maintenance, or support needs]`
- **Learning Curve:** `[Team training or knowledge gaps that need addressing]`

**6.3. Risk Mitigation**
`[Strategies to address identified risks and negative consequences]`

---

### **7. Implementation Plan**

`[Instructions: Outline how this decision will be implemented, including phases, dependencies, and success criteria.]`

**7.1. Implementation Phases**
- **Phase 1:** `[Initial implementation steps]`
- **Phase 2:** `[Follow-up implementation steps]`
- **Phase N:** `[Final implementation steps]`

**7.2. Dependencies**
`[List any dependencies on other teams, systems, or decisions]`
- **Technical Dependencies:** `[Required infrastructure, services, or components]`
- **Team Dependencies:** `[Required collaboration or handoffs]`
- **External Dependencies:** `[Third-party services, vendor decisions, etc.]`

**7.3. Success Criteria**
`[Define how success will be measured]`
- **Technical Metrics:** `[Performance benchmarks, quality metrics]`
- **Business Metrics:** `[User satisfaction, delivery timelines]`

**7.4. Rollback Plan**
`[Describe how to revert this decision if implementation fails]`

---

### **8. Monitoring & Review**

`[Instructions: Define how the success of this decision will be monitored and when it should be reviewed.]`

**8.1. Monitoring Strategy**
`[How the implementation will be monitored for success]`
- **Key Metrics:** `[Specific metrics to track]`
- **Monitoring Tools:** `[Tools and dashboards for tracking]`
- **Alert Thresholds:** `[When to raise concerns]`

**8.2. Review Schedule**
`[When this decision should be reviewed or reassessed]`
- **Short-term Review:** `[3-6 months post-implementation]`
- **Long-term Review:** `[Annual or major version review]`
- **Trigger Events:** `[Circumstances that would prompt an early review]`

---

### **9. References**

`[Instructions: Include all relevant references, documentation, and supporting materials.]`

**9.1. Related Documentation**
- **PRD:** `[Link to Product Requirements Document]`
- **TDD:** `[Link to Technical Design Document]`
- **API Documentation:** `[Links to relevant API specifications]`
- **Vertex Standards:** `[References to applicable Vertex coding standards and patterns]`

**9.2. External References**
- **Technology Documentation:** `[Links to official documentation for chosen technologies]`
- **Research Materials:** `[Articles, papers, or studies that influenced the decision]`
- **Industry Standards:** `[Relevant industry standards or best practices]`

**9.3. Related ADRs**
- **Supersedes:** `[List any ADRs this decision replaces]`
- **Related:** `[List related ADRs that provide additional context]`
- **Dependencies:** `[List ADRs that this decision depends on]`

**9.4. JIRA & Project Links**
- **Epic:** `[Link to related JIRA Epic]`
- **User Stories:** `[Links to relevant user stories or requirements]`
- **Technical Tasks:** `[Links to implementation tasks]`

---

### **10. Appendices**

`[Instructions: Include any additional supporting materials such as diagrams, code samples, or detailed technical specifications.]`

**10.1. Architecture Diagrams**
`[Include or reference relevant architecture diagrams showing the decision's impact]`

**10.2. Code Examples**
`[Include relevant code snippets or configuration examples if applicable]`

**10.3. Performance Analysis**
`[Include performance testing results or analysis if relevant]`

**10.4. Security Analysis**
`[Include security assessment or threat model if applicable]`

---

### **ADR Checklist**

`[Instructions: Use this checklist to ensure the ADR is complete before submission]`

- [ ] Title follows naming convention (JIRA Epic ID or date format)
- [ ] Status is clearly indicated with date and decision makers
- [ ] Context provides sufficient background for understanding the decision
- [ ] Decision is clearly stated with technical specifications
- [ ] Reasoning explains why this decision was made
- [ ] At least 2-3 alternatives were considered and documented
- [ ] Consequences (both positive and negative) are identified
- [ ] Implementation plan includes phases and dependencies
- [ ] Monitoring and review strategy is defined
- [ ] All relevant references and links are included
- [ ] ADR has been reviewed by relevant stakeholders
- [ ] ADR aligns with Vertex architecture standards and patterns
