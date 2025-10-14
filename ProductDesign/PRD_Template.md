### **AI Prompt: PRD Generation Template**

**Your Role:** You are an expert Product Manager working on Vertex sustainability platform projects. Your task is to generate a comprehensive Product Requirements Document (PRD) for a new product called `[Product Name]`. You will be given one or more source documents containing a product overview, market research, and feature ideas.

**Context for Cursor AI:** This PRD will be used to guide the creation of a Vertex application following the three-tier architecture:
1. **Angular Frontend** (`vertex-[domain]-ui`) - User interface using vertex-ui-shared components
2. **BFF Service** (`vertex-[domain]-bff`) - Backend-for-Frontend API for UI-specific data transformation
3. **Core API** (`vertex-[domain]-api`) - Domain CRUD operations with Clean Architecture/CQRS

**Your Instructions:** Use the provided source material to populate the following PRD template. Focus on requirements that can be translated into technical implementations using the Vertex architecture patterns. Adhere strictly to the structure and instructions for each section. If information is not available in the source documents, use placeholders like `[TBD - To Be Determined]` or `[Information not provided in source documents]`. Maintain a clear, concise, and professional tone that technical teams can easily understand and implement.

---

### **[Product Name] PRD**

**Domain Identification for Technical Implementation:**
`[Instructions: Identify a single, lowercase domain name that will be used for project naming (e.g., 'inventory', 'reporting', 'analytics'). This will become the foundation for all technical artifacts: vertex-[domain]-ui, vertex-[domain]-bff, vertex-[domain]-api.]`
*   **Domain Name:** `[e.g., inventory]`
*   **Project Names:** `vertex-[domain]-ui, vertex-[domain]-bff, vertex-[domain]-api`

### **1. Background**

**1.1. Problem Statement**
`[Instructions: Analyze the source documents to identify the core user pain point. Clearly articulate the problem the product aims to solve. Describe who is affected by this problem and what the negative consequences are if it remains unsolved. Frame it as a clear, compelling statement.]`

**1.2. Market Opportunity**
`[Instructions: Synthesize information about the industry and market. Include key statistics like market size and projected growth. Identify the specific gap in the market that [Product Name] will fill. List key competitors and briefly explain what they are missing or how our approach will be different.]`

**1.3. User Personas**
`[Instructions: Identify the primary and secondary target users from the source material. For each persona, create a brief profile using the following structure. Extract or infer this information from descriptions of the target audience.]`

*   **Persona 1: [Persona Title, e.g., Aspiring Artist]**
    *   **Characteristics:** `[Describe their key demographics, behaviors, and tech-savviness.]`
    *   **Needs:** `[List what they require from a solution to solve their problem.]`
    *   **Challenges:** `[List the primary obstacles they currently face.]`

*   **Persona 2: [Persona Title, e.g., Avid Music Fan]**
    *   **Characteristics:** `[Describe their key demographics, behaviors, and tech-savviness.]`
    *   **Needs:** `[List what they require from a solution to solve their problem.]`
    *   **Challenges:** `[List the primary obstacles they currently face.]`

### **2. Vision & Strategy**

**2.1. Vision Statement**
`[Instructions: Formulate a high-level, aspirational statement that describes the ultimate goal and impact of [Product Name]. This should describe the future state the product will create for its users and the market.]`

**2.2. Product Origin**
`[Instructions: Briefly summarize how the idea for [Product Name] was conceived. Mention any initial brainstorming, research, or pilot studies that validated the concept, as described in the source material.]`

**2.3. Strategic Alignment**
`[Instructions: Explain how the objectives of [Product Name] align with the broader company mission and goals. Mention any potential synergies with other existing projects or products within the company.]`

### **3. Objectives & Success Metrics**

**3.1. SMART Goals**
`[Instructions: Define 3-5 high-level goals for the product using the SMART (Specific, Measurable, Achievable, Relevant, Time-bound) framework. If the source material provides goals, reframe them into this structure. If not, create plausible goals based on the product vision.]`

*   **Specific:** `[Clearly state what will be achieved.]`
*   **Measurable:** `[Describe how success will be measured.]`
*   **Achievable:** `[Explain why this goal is realistic, mentioning key levers for success.]`
*   **Relevant:** `[Connect the goal to the overall product vision.]`
*   **Time-bound:** `[Specify a deadline or timeframe, e.g., "within 6 months post-launch".]`

**3.2. Key Performance Indicators (KPIs)**
`[Instructions: List the specific metrics that will be tracked to measure the success of the SMART goals. Include target numbers and timeframes if available.]`
*   `[e.g., Monthly Active Users (MAUs): Target 100,000 within 6 months.]`
*   `[e.g., New User Sign-ups: Target 10,000 in Q1.]`
*   `[e.g., Revenue Growth: Generate $X in the first year.]`

**3.3. Qualitative Objectives**
`[Instructions: Describe the non-numerical goals related to user experience, community, and brand perception.]`
*   `[e.g., Foster a vibrant and engaged user community.]`
*   `[e.g., Achieve a high level of user satisfaction and positive feedback.]`

**3.4. Risk Mitigation**
`[Instructions: Identify potential risks (business, technical, market) from the source material. For each risk, outline a mitigation strategy and a contingency plan.]`
*   **Risk:** `[Describe a potential risk.]`
    *   **Strategy:** `[Describe the proactive plan to prevent the risk.]`
    *   **Contingency:** `[Describe the reactive plan if the risk occurs.]`

### **4. Features**

**4.1. Core Features**
`[Instructions: List and briefly describe the essential, high-level features of the product. This should define the core functionality required for the MVP (Minimum Viable Product).]`
*   **Feature 1:** `[Description]`
*   **Feature 2:** `[Description]`
*   **Feature 3:** `[Description]`

**4.2. User Benefits**
`[Instructions: For each user persona, explain how the core features will directly benefit them. Translate features into value.]`
*   **Benefits for [Persona 1 Title]:** `[List benefits]`
*   **Benefits for [Persona 2 Title]:** `[List benefits]`

**4.3. Feature Prioritization (MoSCoW Method)**
`[Instructions: Categorize the features mentioned in the source material using the MoSCoW framework.]`
*   **Must Have:** `[Core features essential for the initial launch.]`
*   **Should Have:** `[Important features that are not vital for launch but should be in the first few updates.]`
*   **Could Have:** `[Desirable features that will be included if time and resources permit.]`
*   **Won't Have (For this release):** `[Features explicitly out of scope for the initial launch to manage expectations.]`

**4.4. Future Enhancements**
`[Instructions: List potential features or major improvements planned for future versions of the product, based on the product roadmap or vision.]`

### **5. User Experience & Design**

**5.1. User Journey**
`[Instructions: Describe the key user flows. Outline the steps a user takes from first encountering the product to becoming an engaged user.]`
*   **Onboarding:** `[Describe the sign-up and first-time user experience.]`
*   **Core Engagement Loop:** `[Describe the primary actions a user will take repeatedly.]`

**5.2. UI/UX Principles**
`[Instructions: List the guiding principles for the design. Extract keywords from the source document like "simple," "intuitive," "modern," "clean," etc.]`

**5.3. Accessibility**
`[Instructions: State the commitment to accessibility. Mention adherence to standards like WCAG (Web Content Accessibility Guidelines) if specified.]`

### **6. Milestones**

**6.1. Development Phases**
`[Instructions: Outline the major phases of the project with estimated durations, if available.]`
*   **Discovery Phase:** `(e.g., market research, requirements gathering) - [Duration]`
*   **Design Phase:** `(e.g., wireframes, mockups, prototypes) - [Duration]`
*   **Development Phase:** `(e.g., frontend and backend coding) - [Duration]`
*   **Testing Phase:** `(e.g., QA, UAT, bug fixing) - [Duration]`
*   **Launch Phase:** `(e.g., deployment, marketing rollout) - [Duration]`

**6.2. Launch Plan**
`[Instructions: Summarize the go-to-market strategy.]`
*   **Marketing & Comms:** `[e.g., Pre-launch campaigns, influencer outreach, PR.]`
*   **Support & Training:** `[e.g., Creating help docs, training support staff.]`
*   **Post-Launch:** `[e.g., Plan for monitoring KPIs and gathering feedback.]`

### **7. Technical Requirements**

**7.1. Tech Stack (Vertex Standard)**
`[Instructions: Use the standard Vertex tech stack unless specific requirements demand otherwise. This ensures consistency across the platform.]`
*   **Frontend:** Angular 20+ with @se-sustainability-business/vertex-ui-shared component library
*   **BFF Backend:** .NET 8 Web API with Clean Architecture, CQRS (MediatR), SE.Sustainability.Vertex.Api.Sdk
*   **Core Backend:** .NET 8 Web API with Clean Architecture, CQRS (MediatR), Entity Framework Core
*   **Database:** SQL Server with DbUp migrations
*   **Cloud Services:** Azure (App Service, SQL Database, Service Bus, Application Insights)

**7.2. System Architecture Overview**
`[Instructions: Follow the standard Vertex three-tier architecture unless specific requirements necessitate deviation.]`
*   **Three-Tier Architecture:** Angular frontend → BFF API → Core API → SQL Database
*   **Authentication:** OAuth2/OIDC via vertex-dotnet-api-sdk
*   **Communication:** RESTful APIs with JSON, Refit for service-to-service communication
*   **Event Handling:** Azure Service Bus for asynchronous processing
*   **Monitoring:** Application Insights for logging and telemetry

**7.3. Performance & Scalability Requirements**
`[Instructions: List any non-functional requirements related to performance.]`
*   **Response Time:** `[e.g., <200ms for key API calls]`
*   **Uptime:** `[e.g., 99.9%]`
*   **Scalability:** `[e.g., Must support X concurrent users.]`

**7.4. Integration Requirements**
`[Instructions: List any third-party services or systems that [Product Name] must integrate with.]`
*   `[e.g., Payment Gateways (Stripe, PayPal)]`
*   `[e.g., Social Media APIs (Facebook, Twitter)]`
*   `[e.g., Analytics Tools (Google Analytics, Mixpanel)]`

**7.5. Security & Privacy**
`[Instructions: Outline key security measures and privacy compliance requirements.]`
*   `[e.g., End-to-end data encryption.]`
*   `[e.g., Compliance with GDPR, CCPA.]`