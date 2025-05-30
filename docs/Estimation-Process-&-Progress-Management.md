# Estimation Process
Our team uses **Story Points** based on the **Fibonacci sequence** (1, 2, 3, 5, 8, 13...) to estimate task complexity and effort. This nonlinear scale helps us reflect uncertainty and relative difficulty more accurately.

We conduct **Planning Poker** during sprint planning to align understanding across team members:

- Each team member privately selects a Fibonacci number that represents their estimate of the task effort.
- All estimates are revealed simultaneously.
- If there is significant variance (e.g., one person estimates 2, another 8), the team discusses reasoning and revises their understanding.
- A final consensus is reached and the task is assigned a story point value.

This process ensures:
- Equal voice in estimation
- Early identification of misunderstandings
- Improved shared ownership of tasks



# Workflow Documentation

We use a standard 4-stage workflow for task progression:

| Workflow Stage | Description                                                                                     | Entry Criteria                                               | Exit Criteria                                                  |
|----------------|-------------------------------------------------------------------------------------------------|--------------------------------------------------------------|----------------------------------------------------------------|
| **To Do**       | Backlog tasks that are refined and ready to begin                                 | - Clear title & description<br>- Estimated with story points<br>- Assigned to a team member | - Moved into active sprint     |
| **In Progress** | Task is actively being worked on                                                                | - Developer is working on<br>- All dependencies resolved      | - Functionality completed<br>- Ready for code/design review   |
| **In Review**   | Task completed and pending review                                   | - Developer complete tasks             | - Reviewer signs off<br>- Acceptance criteria are met         |
| **Done**        | Task has been reviewed, tested, and accepted; contributes to a sprint deliverable               | - Reviewed and approved                       | - Moved to release branch or included in demo                 |