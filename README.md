# COMP90082 2025 SM1 FI-BlueRing Finsplore

**Make financial decisions faster**

Finsplore is an early-stage fintech platform designed to simplify personal financial management for students, young professionals, and anyone seeking clarity in their financial journey. Our mission is to provide intuitive financial tracking tools alongside personalized guidance to empower users to make faster, smarter financial decisions.

## 🌟 Key Features 
 1: Implement a function that user can track income, expenses and categorise transactions  
 
 2: Implement a powerful AI assistant to answer financial questions and simulate potential decisions using real-time financial data  
 
 3: Implement interactive financial dashboards  
 
 4: Integrate secure data handling mechanisms  
 


## 🚀 Getting Started

### Prerequisites



## 👥 Team Contributions

| Member Name          | Role                | Key Contributions                          |
|---------------------|---------------------|-------------------------------------------|
| Wenxi deng          | Scrum Master        | - Orchestrated daily stand-up meetings to ensure seamless communication among team members, effectively identifying and resolving potential bottlenecks in a timely manner. <br> - Skillfully managed the sprint backlog, prioritizing tasks according to project requirements and team capacity. <br> - Facilitated retrospectives after each sprint, gathering valuable feedback from the team and implementing process improvements to enhance overall efficiency. |
| Longfei zhang       | QA Leader           | - Developed and executed a comprehensive quality assurance plan, which included creating test cases for all project features. This helped in detecting and fixing numerous bugs before product release. <br> - Worked closely with the development team to provide detailed bug reports and collaborate on effective solutions, ensuring that all product updates met the highest quality standards. |
| Xinxin Guo          | Architecture Lead   | - Guided the development team in implementing the architecture, providing technical support and mentorship, and ensuring that all code adhered to the architectural guidelines. <br> - Conducted in-depth technology research and evaluation, selecting the most suitable frameworks and technologies for the project, which optimized development resources and improved performance. |
| Xingchen Li         | Dev Leader          | - Led a team of developers to successfully complete the implementation of all core product features on schedule. Under their leadership, the team maintained high productivity and quality. <br> - Managed the development workflow, coordinating with other teams to ensure smooth integration of features. |
| Can Wang            | Product Owner       | - Collaborated closely with the development team, providing detailed requirements and user stories, and ensuring that the development work was in line with the overall product strategy. <br> - Gathered and analyzed user feedback, driving product enhancements that increased user satisfaction. |

## 👩🏻‍💻 How to Run the Application

### Backend
To start the backend application, simply run the `FinsploreApplication` class.  
Here's how:
1. Navigate to the backend directory.
2. Locate the `FinsploreApplication` class.
3. Execute it via your preferred IDE or from the terminal with the command:
   ```
   mvn spring-boot:run
   ```

### Frontend
Running the frontend application requires some initial setup. Follow these detailed steps:

1. **Install Flutter**  
   - Visit the official Flutter installation guide: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install).
   - Follow the instructions to download and set up Flutter on your machine.
   - 
2. **Verify Flutter Installation**  
   - After installing Flutter, run the following command in your terminal to verify that the installation is successful:
     ```bash
     flutter doctor
     ```
   - Ensure all checks pass (including Flutter, Dart, IDEs, iOS toolchain, etc.) before proceeding.
   - 
3. **Navigate to the Frontend Directory**  
   - Open a terminal or your IDE and move to the project's `frontend` directory:
     ```bash
     cd frontend
     ```

4. **Open the Frontend Main File**  
   - Locate the `main.dart` file in the path: `frontend/lib/main.dart`.
   - Open it using your IDE (e.g., **VSCode**, **Android Studio**, or **IntelliJ IDEA**).

5. **Run the Frontend Application**  
   - Start the Xcode iOS Simulator. 
     You can start the simulator from Xcode’s menu or using the following terminal command:
     ```bash
     open -a Simulator
     ```
     Ensure the device is properly set up and running.

   - Inside your IDE: Press "Run/Debug" button.

6. **Launch the Application**  
   - The frontend application will build and launch in the simulator (or connected device). 

## 🛠️ Changelog
### Sprint 2 Updates

✅ **Completed**
- Integrated Basiq API for fetching transaction data and displaying.
- Developed secure login and user registration flow.
- Connected frontend with backend APIs (basic user flow working).
- Built initial AI chatbot prototype (basic interaction + mock demo).
- Updated UI design (applied feedback from mentor and client, improved Figma prototype).
- Added bank account linking and transaction fetching to backend.
- Store user ID information to database.

⚠️ **In Progress**
- AI-driven transaction categorization (requires custom categorization model).
- Goal setting and tracking page (UI completed; backend logic under development).
- Chatbot integration with real backend data (currently using demo stubs).
- Advanced dashboard features (summary cards, visual analytics).


## 🤖 Development Note

This project was partially reviewed and improved with the assistance of ChatGPT.
Enhancements include:
- Improved code formatting.
- Addition of detailed inline comments and Javadoc explanations.
- Suggesting better coding practices where applicable.
- Provided some concepts for solving certain technical challenges.

Final adjustments and implementation were reviewed by the development team.
