## Background
In today’s fast-paced financial world, people struggle to make informed financial decisions. Our client, Finsplore, is seeking an  AI-powered chatbot leverages users’ financial data with CDR to provide personalized insights, helping them manage their finances smarter and more efficiently.  

Traditional chatbots provide general advice but fail to consider individual financial situations. Users need a tool that understands their financial status and offers tailored recommendations.

With the rise of AI in finance, a personalized financial assistant can improve budgeting, reduce debt, and enhance savings strategies. This project empowers users to make data-driven financial decisions effortlessly

## Goal:
To develop an AI-powered financial assistant that leverages users' financial data to provide personalized insights and help them make smarter financial decisions.

## Client Motivation

Finsplore’s primary motivation is to create a personalized financial assistant that leverages real transaction data intelligently. The client envisions an app that goes beyond simple advice by using AI to classify users’ financial transactions into meaningful categories such as income, essential expenses, discretionary spending, and savings. 

This classified financial data will then serve two purposes:
- **Visualization**: Users should be able to view clear and insightful summaries of their financial behavior, helping them better understand their spending and saving patterns.
- **Enhanced AI Responses**: The AI assistant will use the categorized data to generate highly personalized financial advice, offering recommendations that are specific to each user’s actual financial situation rather than generic tips.

By combining automatic transaction classification, data visualization, and AI-driven conversations, Finsplore aims to deliver a smarter, more relevant financial management tool that empowers users to make better financial decisions with confidence.


## Expected Outcome:
Users can securely log in and verify their identity.

The app connects to bank accounts and retrieves financial data.

The chatbot analyzes financial status and provides personalized budgeting, savings, and spending advice.

Users receive real-time insights to improve financial management.

All financial data is securely stored and encrypted to ensure privacy and security.

## Scope

### In Scope

| Feature | Justification |
|:---|:---|
| **User Authentication & Identity Verification**<br>- Secure login/sign-up system (e.g., email/password, third-party login)<br>- Identity verification (document upload)<br>- Profile management | **Client priority**: Secure user access is essential for protecting sensitive financial data. **Technical feasibility**: Email/password and document uploads are achievable within MVP timeline without needing complex systems like full KYC or OAuth. |
| **Bank Integration & Financial Data Collection**<br>- Secure connection to users' bank accounts (via Basiq)<br>- Retrieve financial data (assets, deposits, expenses, transactions)<br>- Use AI-powered tools to automatically classify transactions | **MVP focus**: Access to real financial data is necessary for personalized advice. **Technical feasibility**: Basiq API integration is manageable within the timeline. Automatic classification improves personalization without needing advanced forecasting. |
| **User Interaction & AI-driven Conversations**<br>- Ask users structured questions to assess their financial situation (financial goals, assets, expenses, employment status, etc.)<br>- Use AI to generate personalized insights and financial advice<br>- Provide responses tailored to user-specific data (especially categorized financial data) | **Client priority**: Delivering actionable financial advice is the main goal. **MVP focus**: Structured interactions ensure enough user data is collected to generate useful AI-driven insights without overcomplicating chatbot conversations. |
| **Privacy & Security Measures**<br>- Encrypt user financial data | **Regulatory constraint**: Compliance with CDR and user privacy expectations. **Technical feasibility**: Basic encryption measures are achievable and necessary to maintain user trust. |


### Out of Scope 



| Feature | Justification |
|:---|:---|
| **Executing Trades or Managing Funds** | Regulatory risk: Managing users’ money involves significant legal complexity and licensing. Out of MVP scope. |
| **Certified Tax or Legal Recommendations** | Professional liability: We are not licensed financial advisors. Providing general insights reduces risk exposure. |
| **Support for Banks Outside Australia** | Technical feasibility: Basiq API initially covers Australian banks. Expanding internationally would require complex rework. |
| **Deep Financial Forecasting Models** | Timeline constraint: Advanced forecasting requires sophisticated data modeling, which is not feasible in MVP. |
| **Biometric Verification, OAuth, and Full KYC** | Technical complexity: Implementing biometric and OAuth increases scope significantly. Focus is on document-based verification for MVP. |
| **Special Handling of Joint Accounts** | Simplification: Treating joint accounts as normal accounts reduces complexity and keeps the MVP achievable. |


## Constraints
Timeline Constraint: The project is expected to deliver a functional MVP within [insert your timeline, e.g., 12 weeks]. Therefore, features requiring significant backend infrastructure (e.g., trade execution, deep forecasting) are out of scope.

Regulatory Constraint: Must comply with Australian CDR standards, but avoid areas requiring a financial services license (e.g., funds management, certified advice).

Technical Constraint: Limited to bank integrations available through Basiq; no custom integration with unsupported banks.

Resource Constraint: Limited development resources available (team size, skill sets), focusing effort on core functionalities.

---


> Note: This document was originally produced with the assistance of OpenAI’s ChatGPT; the content has been subsequently reviewed, revised in detail, and refined through editing according to requirements.