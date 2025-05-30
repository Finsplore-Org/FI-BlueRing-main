# Sprint Planning   

## Sprint Planning [1](https://unimelbcloud-my.sharepoint.com/:w:/g/personal/wenxdeng_student_unimelb_edu_au/EXE_TLGQfZhFmWBL9ZdTXnkBIZEUytbzLjgPtr1Py_dhyQ?e=ETyfYw)


**Location:** Melbourne Connect, Floor 7  
**Date:** Thu 27 Mar  
**Time:** 1:00 PM – 3:00 PM

### Attendees

- Wenxi Deng  
- Xinxin Guo  
- Can Wang  
- Xingchen Li  
- Longfei Zhang  

### Agenda Details

#### 1. Project Overview & Goal Clarification
- Reviewed the Finsplore project background  
- Discussed the client’s expectations and long-term vision  
- Defined clear goals for Sprint 1 (See the checklist on Canvas)

#### 2. Define Stakeholder
- Confirmed key stakeholders:  
  - Client  
  - Developers  
  - Users  
  - Financial Advisors  
  - Regulatory Bodies

#### 3. Backlog Item Identification
- Brainstormed initial features and tasks based on client brief

#### 4. Breakdown and Assign Tasks
- Broke down Sprint 1 goals into manageable tasks (See Task Boards)  
- Assigned tasks based on team members’ strengths and preferences

#### 5. Project Tools & Workflow Setup
- Confirmed tools: GitHub, Slack, Figma  
- Agreed on version control strategy and task tracking methods

### Action Items

- [ ] **Can Wang** – Write initial User Stories based on the client's vision  
- [ ] **Wenxi Deng** – Create the Motivational Model (DO/BE/FEEL)  
- [ ] **Wenxi Deng** – Break down and assign tasks  
- [ ] **Longfei Zhang** – Set up and organise the GitHub Repository  
- [ ] **Xingchen Li** – Establish branching strategy and commit conventions  
- [ ] **Wenxi Deng** – Update GitHub Task Boards with Sprint 1 tasks  
- [ ] **Xinxin Guo** – Document the personas  
- [ ] **Xinxin Guo** – Document Project Background and scope  
- [ ] **All** – Contact mentor/client to clarify any open questions


## Sprint Planning 2
### Sprint detail
* Sprint Number: 2
* Start Date: 2025-04-10
* End Date: 2025-05-02
* Sprint Goal: Complete implementation of core functionalities including login & signup, transaction visibility, answering pre-build question, connecting multiple bank accounts, displaying income/expense summary & categorisation & transaction history and identity verification.

### Sprint Backlog

| ID   | User Story                                                                 | Priority | Estimation | Dependency    | Assignee(s)        | Status        |
|------|----------------------------------------------------------------------------|----------|------------|----------------|--------------------|---------------|
| US1  | As a user, I want to ask simple financial questions via an AI chatbot so that I can quickly understand my spending habits.                          | High     | 5 SP       |               |       Xingchen Li & Xinxin Guo        | Done   |
| US3  | As a user, I want to securely connect my bank account so that I can safely retrieve my financial data.                 | High     | 13 SP       | US5 |      Wenxi Deng      | Done   |
| US4  | Collect identity documents before granting access | My identity is submitted and stored for review                 | High     | 13 SP       | US5 |      Xingchen Li & Xinxin Guo      | Done   |
| US5  | As a user, I want to sign up or log in securely so that my account is protected and I can access it easily.                        | High     | 8 SP       | Prerequisite      |        Xingchen Li & Xinxin Guo           | Done             |
| US7  | As a user, I want to access a summary of my financial accounts (e.g. income, expenses, net worth) so that I can track my financial health and adjust my spending accordingly.                                               | High   | 5 SP      | US3            |         Xinxin Guo          |      Done        |
| US11 | As a user, I want to connect multiple bank accounts so that I can see a consolidated view of my finances                                            | High   | 5 SP       | US3            |         Wenxi Deng          | Done             |
| US19  | As a user, I want to categorise my transactions manually or automatically so that I can better understand my spending behavior.                                               | High   | 5 SP       | US3            |         Xingchen Li & Longfei Zhang & Xinxin Guo & Can Wang         | In Progress             |
| US20   | As a user, I want to view my transaction history with filters and search so that I can review my past financial activity conveniently.                                                  | High   | 3 SP       | US3            |         Xinchen Li & Xinxin Guo          | Done             |
| Prerequisite    | Frontend & backend setup (architecture-level)                             | High     | 13 SP      |               | Xingchen & Xinxin Guo   | Done   |
|  | Research on AI model (for chatbot)                                        | High   | 5 SP       |            |Can Wang                | Done            |
|  | Research and set up Basiq API                                        | High   | 5 SP       |            |Wenxi Deng                | Done           |

### Tasks Breakdown

| User Story | Task ID | Task | Estimation | Status | Dependency | Assignee |
|------------|---------|------|------------|--------|------------|----------|
| US1 | T1 | Design chatbot UI interface | 1 SP | Done |  | Xingchen Li |
|  | T2 | Build AI chatbot backend endpoint | 2 SP | Done |  | Xinxin Guo |
|  | T3 | Connect chatbot frontend with backend | 1 SP | Done |  | Xinxin Guo |
|  | T4 | Test AI chatbot flow | 1 SP | Done |  | Longfei Zhang |
| US3 | T5 | Design bank linking UI | 2 SP | Done |  | Xingchen Li & Wenxi Deng |
|  | T6 | Implement bank linking API integration | 8 SP | Done | US5 | Wenxi Deng |
|  | T35 | Integrate bank linking API with frontend | 1 SP | Done |  | Wenxi Deng |
|  | T32 | Test this functionality | 1 SP | Done |  | Longfei Zhang |
| US4 | T7 | Design information collection UI | 2 SP | Done |  | Xingchen Li |
|  | T8 | Store user information in database | 8 SP | Done | US5 | Xinxin Guo |
|  | T9 | Integrate with login flow | 1 SP | Done | US5 | Xingchen Li |
|  | T10 | Encrypt sensitive information | 1 SP | Done |  | Xinxin Guo |
|  | T11 | Test information collection function | 1 SP | Done |  | Longfei Zhang |
| US5 | T12 | Design login/signup UI | 1 SP | Done |  | Xingchen Li |
|  | T13 | Implement backend logic | 5 SP | Done | Prerequisite | Xinxin Guo |
|  | T36 | Integrate with frontend | 1 SP | Done |  | Xinxin Guo |
|  | T14 | Test login/logout flows | 1 SP | Done |  | Xingchen Li |
| US7 | T15 | Design accounts summary UI | 2 SP | Done |  | Xingchen Li / Longfei Zhang |
|  | T16 | Fetch the data from database/basiq | 1 SP | Done | US3 | Xinxin Guo |
|  | T17 | Display summary in dashboard (Integration) | 1 SP | Done |  | Wenxi Deng |
|  | T18 | Test this function | 1 SP | Done |  | Longfei Zhang |
| US11 | T19 | Support multi-account linking in UI | 1 SP | Done | US3 | Wenxi Deng |
|  | T20 | Update backend to store multiple accounts | 2 SP | Done | US3 | Wenxi Deng |
|  | T21 | Test this functionionality | 1 SP | Done |  | Longfei Zhang |
| US19 | T22 | Design transaction categorization UI | 1 SP | In Progress |  | Xingchen Li / Longfei Zhang |
|  | T23 | Implement auto-categorization logic | 2 SP | In Progress | US3 | Can Wang |
|  | T24 | Store categories per transaction | 1 SP | Not Started | Prerequisite | Xinxin Guo |
|  | T25 | Test categorization | 1 SP | Not Started |  | Longfei Zhang |
| US20 | T26 | Design filter/search bar UI for transactions | 1 SP | Done |  | Xingchen Li |
|  | T27 | Build filter/search backend API | 1 SP | Done | US3 | Xinxin Guo |
|  | T28 | Test transaction displaying | 1 SP | Done |  | Longfei Zhang |
| Prerequisite | T29 | Set up frontend Flutter project | 5 SP | Done |  | Xingchen Li |
|  | T30 | Set up backend Spring Boot project | 5 SP | Done |  | Xinxin Guo |
|  | T31 | Ensure backend connects to PostgreSQL | 3 SP | Done |  | Xinxin Guo |
|  | T33 | Research on AI model | 5 SP | Done |  | Can Wang |
|  | T34 | Research and set up Basiq API | 5 SP | Done |  | Wenxi Deng |

### Risks
- Implementing authentication may **introduce security vulnerabilities** if token/session handling is not done properly.
- Dashboard API optimisation may require **significant backend restructuring**, which could delay related features.
- Categorisation logic may become too complex for Sprint 2 if transaction data structure is inconsistent.

### Sprint Commitments
- Ensure **secure user authentication** (signup, login) is fully implemented and tested.
- Optimise dashboard performance to achieve **load time under 2 seconds**.
- Implement and verify **password reset functionality** (admin and user flow).
- Display **transaction history** with filter/search capabilities.
- Provide a **visual summary of income/expenses** with categorisation support.
- Establish a **working backend structure** for future AI chatbot integration.
- Conduct initial **AI model research** to inform chatbot development.


## Sprint Planning 3
### Sprint detail
* Sprint Number: 3
* Start Date: 2025-05-02
* End Date: 2025-05-30
* Sprint Goal: Deliver core financial management features, including budgeting, goal tracking, personalisation categories, displaying accounts summary and AI chatbot enhancements.

### Sprint Backlog

| ID   | User Story                                                                 | Priority | Estimation | Dependency    | Assignee(s)        | Status        |
|------|----------------------------------------------------------------------------|----------|------------|----------------|--------------------|---------------|
| US10  | As a user, I want to create a monthly budget, so that I can plan my spending and save more effectively.                          | High     | 8 SP       |       US7        |       Longfei Zhang & Xinxin Guo        | Not Started   |
| US12  | As a user, I want to set and track financial goals, so that I can save for specific purposes like a vacation.                 | High     | 8 SP       | US10 |      Wenxi Deng & Longfei Zhang      | Not Started   |
| US14  | As a user, I want to see small ways to save money each month, so that I can start building my savings without feeling overwhelmed.                 | Medium     | 5 SP       | US7 |      Xinxin Guo & Longfei Zhang      | Not Started   |
| US16  | As a user, I want to customize expense categories, so that I can track and adjust my family's finances more easily.                 | High     | 8 SP       | US19 |      Xingchen Li & Wenxi Deng      | Not Started   |
| US17  | As a user, I want to receive bill reminders in an AI assistant, so that I never miss payments.                 | High     | 5 SP       | US1, US3 |      Xingchen Li & Xinxin Guo      | Not Started   |
| US2  | As a user, I want to ask financial questions in natural language, so that I can interact with the chatbot more intuitively.                 | High     | 8 SP       |  |      Can Wang      | Not Started   |
| US19  | As a user, I want to categorise my transactions manually or automatically so that I can better understand my spending behavior.                                               | High   | 5 SP       | US3            |         Xingchen Li & Longfei Zhang & Xinxin Guo & Can Wang         |      In Progress        |


### Tasks Breakdown

| User Story | Task ID | Task | Estimation | Status | Dependency | Assignee |
|------------|---------|------|------------|--------|------------|----------|
| US10 | T37 | Design frontend UI for entering monthly budget | 2 SP | Not Started |  | Longfei Zhang |
|  | T38 | Implement backend logic to store budget in database | 3 SP | Not Started | US7 | Xinxin Guo |
|  | T39 | Connect frontend and backend for budget feature | 2 SP | Not Started | US7 | Longfei Zhang |
|  | T40 | Write test cases and validate monthly budget flow | 1 SP | Not Started |  | Longfei Zhang |
| US12 | T41 | Design frontend UI to input financial goals | 2 SP | Not Started |  | Longfei Zhang |
|  | T42 | Implement backend logic to store and retrieve goal data | 3 SP | Not Started | US10 | Wenxi Deng |
|  | T43 | Connect frontend UI with backend goal APIs | 2 SP | Not Started |  | Longfei Zhang |
|  | T44 | Test goal creation and tracking logic | 1 SP | Not Started |  | Longfei Zhang |
| US14 | T45 | Design UI to display monthly saving tips or suggestions | 2 SP | Not Started |  | Longfei Zhang |
|  | T46 | Implement backend logic to generate/save suggestions | 2 SP | Not Started | US7, US10 | Xinxin Guo |
|  | T47 | Display how much the user has saved based on suggestions followed | 1 SP | Not Started | US7 | Longfei Zhang |
| US16 | T48 | Design UI for managing categories (add, edit, delete) | 2 SP | Not Started |  | Xingchen Li |
|  | T49 | Implement backend API for category management | 3 SP | Not Started | US19 | Wenxi Deng |
|  | T50 | Connect frontend UI with backend | 2 SP | Not Started |  | Xingchen Li |
|  | T51 | Test category customization | 1 SP | Not Started |  | Longfei Zhang |
| US17 | T52 | Design AI assistant UI for bill reminder display | 1 SP | Not Started | US1 | Xingchen Li |
|  | T53 | Implement logic to fetch upcoming bills from user transaction data | 2 SP | Not Started | US3 | Xinxin Guo |
|  | T54 | Integrate to generate bill reminders | 2 SP | Not Started |  | Xingchen Li |
|  | T55 | Test reminder generation and display in assistant chat | 1 SP | Not Started |  | Longfei Zhang |
| US2 | T56 | Integrate AI model to process user queries | 3 SP | Not Started | US1  | Can Wang |
|  | T57 | Connect chatbot to financial data (e.g. income, summary) | 3 SP | Not Started | US3 | Can Wang |
|  | T58 | Test conversation flow in AI chatbot | 2 SP | Not Started |  | Can Wang |
| US19 | T22 | Design transaction categorization UI | 1 SP | In Progress |  | Xingchen Li / Longfei Zhang |
|  | T23 | Implement auto-categorization logic | 2 SP | In Progress | US3 | Can Wang |
|  | T24 | Store categories per transaction | 1 SP | Not Started | Prerequisite | Xinxin Guo |
|  | T25 | Test categorization | 1 SP | Not Started |  | Longfei Zhang |

### Dependencies & Risks
- **Dependencies:**
  - US2 tasks rely on working chatbot backend and NLP logic.
  - US10 and US14 both rely on the transaction details in Database.
  - US12 and US14 both rely on knowing the budget.
  - US16 tasks depend on the transaction categorization system.
  - US17 tasks depend on the AI chatbot UI and transaction details.

- **Risks:**
  - Complexity in integrating AI features may delay testing.
  - Backend infrastructure limitations could delay multiple tasks.
  - Tasks not completed in Sprint 2 are moved to Sprint 3, which may delay or even prevent the completion of tasks in Sprint 3.


### Sprint Commitments
- Complete all core features related to budgeting and financial goals.
- Ensure chatbot and verification logic are implemented and testable.
- Update all documentation, ensuring it aligns with the team progress.
- Ensure to meet the client's needs, to be based on the client's needs and feedback to develop.

# Sprint Review

## Sprint 1
### Sprint Details

- **Sprint Number:** Sprint 1
- **Start Date:** 2025-03-10
- **End Date:** 2025-04-10
- **Duration:** 25 days
- **Agile Framework:** Scrum

### Attendees

- Development Team: Wenxi Deng, Xinxin Guo, Can Wang, Xingchen Li, Longfei Zhang
- Scrum Master: Wenxi Deng
- Product Owner: Can Wang  
- Stakeholders: Ria Gupta, Poorvith Gowda

### Sprint Goal

To establish a solid foundation for the Finsplore project by:

- Defining the project background, client goals, and scope of work
- Gathering and documenting functional and non-functional requirements as user stories
- Setting up a collaborative development environment using GitHub and Slack
- Creating an initial user story map to guide future development
- Designing and validating a low-fidelity prototype through client feedback
- Ensuring proper documentation and alignment with assessment criteria for Sprint 1

This sprint focuses on aligning the team, validating key user scenarios with industry partners, and preparing for implementation in Sprint 2.

### Completed Work
| Category | Description | Status | Notes |
|----------|-------------|--------|-------|
| **Project Background & Scope** | Defined client (Finsplore), project motivation, and clear scope | ✅ Completed | Documented in Wiki under Project Background |
| **Requirements Analysis** | Gathered and documented functional and non-functional requirements as user stories | ✅ Completed | Added to GitHub Wiki; AI-generated user stories documented with prompt reference |
| **Development Environment & Tool Setup** | Set up GitHub repository, README, branch strategy, and collaboration tools | ✅ Completed | GitHub Project board active; team aligned on naming conventions and version control |
| **User Story Mapping & Sprint 2 Planning** | Created story map with user flows and Sprint 2 priorities | ✅ Completed | Prioritized core features, identified dependencies, and structured map shared |
| **Prototype Validation** | Validated key user stories through client meeting and feedback | ✅ Completed | Figma prototype walkthrough conducted; feedback incorporated into Sprint 2 planning |
| **Prototype Video** | Recorded and submitted 4-minute prototype validation video | ✅ Completed | Covers login, dashboard, categorization, and chatbot interaction |

### Demonstration
- **What was demonstrated:**  
  Figma prototype walkthrough including:  
  - Login Page  
  - Dashboard (net worth, bank balance, recent transactions)  
  - AI Chatbot Interaction Interface  
  - Spending Overview / Category Visualisation

- **Demo Format:**  
  Live demonstration via Zoom during the client meeting

- **Feedback Received:**  
  - Add icons for input fields (email, password, visibility toggle)  
  - Improve UI layout using Material 3 design principles and better spacing  
  - Use colour theory to indicate debit/credit transactions (e.g., red/green)  
  - Merge transaction and categorisation pages into a unified experience  
  - Add filtering by bank account on transaction view  
  - Introduce a profile section in the bottom navigation  
  - Display current goal on dashboard  
  - Add typing indicator and read receipts to chatbot for more realism  
  - Consider chatbot personality design (avatar, tone, name)

### Retrospective Insights
#### What went well: 
- Proactive communication and collaboration across team  
- Timely feedback from mentor and client helped improve design  
- All base documentation (scope, personas, requirements) completed early

#### What could be improved:
- Earlier alignment on UI structure to avoid rework  
- Respond to client messages in a timely manner

### Action Items
- [ ] **Update UI Design with Feedback from Client**  
  - Add icons to input fields (email, password, visibility)  
  - Improve spacing, layout, and hierarchy using Material 3 guidelines  
  - Assigned to: Wenxi
  - Due: April 10

- [ ] **Merge Transaction and Category Pages**  
  - Display both transaction list and categories in one view  
  - Add filter by bank account at the top  
  - Use colour indicators (red/green) for transaction types  
  - Assigned to: Wenxi Deng 
  - Due: April 10

- [ ] **Add Goal Display to Dashboard**  
  - Display current goal below the net worth section  
  - Ensure proper section title and visual clarity  
  - Assigned to: Wenxi Deng  
  - Due: April 10

- [ ] **Add Profile Section to Bottom Navigation Bar**  
  - Include placeholder profile/settings page  
  - Assigned to: Wenxi Deng 
  - Due: April 10

- [ ] **Improve Chatbot UI**  
  - Add read receipt and typing indicator  
  - Add chatbot avatar or icon to simulate a personality  
  - Consider background color adjustment for contrast  
  - Assigned to: Wenxi Deng 
  - Due: April 10

- [ ] **Record a demo for prototype**
  - Assigned to: Xinxin Guo
  - Due: April 10


### Next Steps:
- Continue improving Figma design for accessibility and professionalism
- Plan on Sprint 2 based on the feedback and learnings


## Sprint 2
### Sprint Details

- **Sprint Number:** Sprint 2
- **Start Date:** 2025-04-10
- **End Date:** 2025-05-02
- **Duration:** 15 days
- **Agile Framework:** Scrum

### Attendees

- Development Team: Wenxi Deng, Xinxin Guo, Can Wang, Xingchen Li, Longfei Zhang
- Scrum Master: Wenxi Deng
- Product Owner: Can Wang  
- Stakeholders: Aarushi, Poorvith

### Sprint Goal
Complete implementation of core functionalities including login & signup, transaction visibility, answering pre-build question, connecting multiple bank accounts, displaying income/expense summary & categorisation & transaction history and identity verification.

### Completed Work

| ID   | User Story                                  | Status | Notes                                                                 |
|------|---------------------------------------------|--------|-----------------------------------------------------------------------|
| US1 | As a user, I want to ask simple financial questions via an AI chatbot so that I can quickly understand my spending habits.   | ✅ Completed   | Fully implemented and demoed   |
| US3 | As a user, I want to securely connect my bank account so that I can safely retrieve my financial data.    | ✅ Completed   | Successfully integrated with the Basiq API.                                         |
| US4 | As an admin, I want to collect identity documents before granting access so that my identity is submitted and stored for review.       | ✅ Completed  | Adjust User Stories with client (Only need to collect the ID information, no need to verify) |
| US5 | As a user, I want to sign up or log in securely so that my account is protected and I can access it easily.    | ✅ Completed   | Fully implemented and demoed, with email verification                                           |
| US7 | As a user, I want to access a summary of my financial accounts (e.g. income, expenses, net worth) so that I can track my financial health and adjust my spending accordingly.      | ✅ Completed   | Successfully fetch transactions details from Basiq API                        | 
| US11 | As a user, I want to connect multiple bank accounts so that I can see a consolidated view of my finances.   | ✅ Completed   | Successfully integrated with the Basiq API.   |
| US20 | As a user, I want to view my transaction history with filters and search so that I can review my past financial activity conveniently.  | ✅ Completed   |  Successfully fetch transaction data from Basiq API system  |
| Prerequisite| Frontend & backend setup (architecture-level)   | ✅ Completed   |  |
| Prerequisite| Research on AI model (for chatbot)   | ✅ Completed   |  |
| Prerequisite| Research and set up Basiq API   | ✅ Completed   |  |


### Incomplete Work
| ID   | User Story                                  | Reason for Incompletion                           | Next Steps                                  |
|------|---------------------------------------------|---------------------------------------------------|----------------------------------------------|
| US19 | As a user, I want to categorize my transactions manually or automatically so that I can better understand my spending behavior.   | Basiq sandbox lack categories details.   | Move to the next sprint |


### Demonstration

- **What was demonstrated:**  
  - Bank account connection and transaction retrieval  
  - Secure user login & registration  
  - AI chatbot UI + response flow  
  - Demo mobile UI (incomplete but functional)

- **Demo Format:** Figma design and mobile app

- **Feedback received:** 
- Basiq API does not require identity verification, but manual ID capture is recommended
- Categories should be assigned by custom logic (AI/NLP) and stored in database
- AI chatbot should translate queries to backend functions without sending user data to OpenAI API
- UI improvements suggested (clarity in % display, improved contrast, better chat interface)

### Sprint Metrics & Insights
- **Velocity:** 67 SP completed  
- **Burndown Chart Analysis:** 13 SP incomplete  
- **Quality Metrics:** No major bugs, integration stable; AI chatbot is demo-only without full backend processing

### Stakeholder Feedback
- [ ] **Login / Registration**
* Secure login and registration process is well implemented.
* ID verification is not strictly required, but storing user ID (e.g., passport number) is recommended for legitimacy tracking.

- [ ] **Basiq API Integration**
* Confirmed Basiq’s identity API does not enforce mandatory ID verification.
* Suggested deferring full ID verification and simply recording ID values for now.

- [ ] **AI Chatbot**
* Do not transmit customer data to third-party AI services.
* Use AI (e.g., OpenAI or Anthropic) only to parse user queries.
* Recommended architecture: AI → SQL Parser → Internal Logic → Display Result.
* Add support for multiple chat sessions and session history (like CommBank).
* Chatbot should not process raw data – AI acts as translator only.

- [ ] **Transaction Categorisation**
* Use AI to perform transaction classification.
* Allow users to override assigned categories.
* Store final category mappings in internal database.
* Follow WeMoney flow (e.g., allow bulk edits, custom categories).

- [ ] **UI/UX Feedback** (Figma vs Mobile App)
* Preferred the new light-themed mobile version with: Clearer spacing and layout & Better background contrast
* Readable and visually clear percentage formatting
* **Icons** and simplified visual design (no heavy shadows) are encouraged.
* Use **Material 3** design standards where applicable.

### Retrospective Insights

**What went well:**
- Smooth demo of backend integration and chatbot prototype
- Stakeholders appreciated effort on data privacy and AI plans
- Team responded well to fast-paced sprint despite initial delay

**What could be improved:**
- Clarify ambiguous stories before committing (e.g., identity verification)
- Strengthen frontend-backend coordination for consistent demo readiness

**Action Items:**
- [ ] Investigate custom AI logic for transaction classification – Assigned to: Can Wang
- [ ] Improve chatbot query handling & local function routing – Assigned to: Can Wang & Xingchen Li  
- [ ] Document feasibility of end-to-end encryption – Assigned to: Xinxin Guo
- [ ] Adjust the features based on client feedback - Assigned to: All

### Next Steps
- Plan Sprint 3 to focus on financial management features
- Expand chatbot capabilities with integrated backend query mapping  
- Finalise UI design for goal setting, dashboard insights, and transaction filtering

### Notes
Overall, this sprint was successful, with key goals met.
Next sprint should focus on implementing some financial management features.




# Sprint Retrospective

## Sprint Retrospective 01

**Location:** Zoom  
**Date:** Thu 17 April  
**Time:** 2:00 pm 

### Attendees

- Wenxi Deng  
- Xinxin Guo  
- Can Wang  
- Xingchen Li  
- Longfei Zhang

### Start / Stop / Continue 
- **Start**  
  - Sharing the Task board during stand-ups so that progress is clearly visualized and aligned with updates.
  - Documenting AI usage clearly (including prompt inputs, AI-generated outputs, and human refinement steps).
  - Responding to client feedback on Slack in a timely manner.
  - Using Fibonacci numbers to estimate task effort & complexity.
  - Consistently updating task status on the GitHub board to ensure everyone is aware of real-time progress and dependencies.
  - Capture live client feedback during prototype validation sessions (e.g., record client's interaction and verbal reactions when they use the prototype).
  - Use the GitHub Projects Kanban board as the single source of truth for tasks (and link it in the Wiki instead of duplicating full task stories manually).

- **Stop**  
  - Relying on volunteers to speak during stand-ups; instead, Scrum Master should follow a structured order. 
  - Estimating task effort & complexity in days.
  - Discontinuation of overdue responses to clients, resulting in lack of timely feedback
  - Forgetting to update task status on the GitHub Project board, which causes misalignment between actual progress and board visibility.
  - Stop duplicating full user stories manually across Wiki and GitHub board (to avoid inconsistency and double maintenance workload).

- **Continue**    
  - Timely task assignment and clear division of responsibilities as demonstrated in Sprint 1.
  - Open and timely communication within the team, as well as with the mentor and client when issues arise.
  - Proactive learning and upskilling, especially with unfamiliar tools like Spring Boot and Flutter.


## Sprint Retrospective 02

**Location:** Zoom  
**Date:** Thu 1 May  
**Time:** 2:00 pm 

### Attendees

- Wenxi Deng  
- Xinxin Guo  
- Can Wang  
- Xingchen Li  
- Longfei Zhang

### Start / Stop / Continue 
- **Start**  
  - Carefully assessing team capacity when selecting and committing to backlog items, to ensure workload is realistic and achievable within the sprint (avoiding rushed or incomplete user stories like US20).
  - Encouraging code/design reviews earlier in the sprint, rather than clustering review work at the end.
  - Promptly updating task progress on the GitHub board to reflect current status, helping avoid last-minute conflicts and untracked dependencies.
  - Scheduling mid-sprint checkpoints to review progress against sprint goals and adjust workload if needed.
  - Ensure everyone is ready for the next sprint. (developing environment is set up and ready for development)

- **Stop**  
  - Overcommitting to too many high-complexity tasks without fully considering team bandwidth.
  - Delaying status updates until the end of the sprint; lack of timely progress visibility leads to blockers or duplicated efforts.

- **Continue**    
  - Strong ownership of individual responsibilities on assigned tasks.
  - Transparent communication of blockers and seeking help early when stuck.
  - Collaborative integration efforts, especially across frontend-backend and chatbot development.

---

> Note: This document was originally produced with the assistance of OpenAI’s ChatGPT; the content has been subsequently reviewed, revised in detail, and refined through editing according to requirements.