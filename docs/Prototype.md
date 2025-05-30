# Finsplore Prototype Demonstration (Sprint 1)

## Key takeaways
- Improve visual hierarchy and spacing across all screens.
- Add meaningful icons to input fields (email, password, visibility) to enhance usability.
- Enhance the chatbot interface with read receipts, typing indicators, and personality 
- Ensure clear labelling and structure for dashboard sections (e.g. goals, transactions).
- Improve contrast and use accessible colour schemes for better readability.
- Add filters for selecting specific bank accounts when viewing transactions.
- Include goal-tracking information directly on the dashboard.
- Add a profile access section in the bottom navigation bar.
- External login methods (Google, Apple) are not required at this stage.
- Loans, credit cards, and micro-investing features are deferred to future sprints.


https://github.com/user-attachments/assets/61d1cf0d-5522-4287-9a7c-5fe4c7941867



We start with a clean, simple authentication page where users can easily sign up or log in. The design follows the client’s branding, with a cool teal background that gives a modern and trustworthy feel. At this stage, we’ve kept the signup process straightforward—no Google or Apple login options for now, as per client discussion. However, users are required to complete an identity check during signup for added security.


After logging in, users are redirected to the main dashboard. Here, they’re prompted to connect their bank accounts through the CDR framework, which allows them to link multiple accounts. Once connected, transactions are automatically synced, building a real-time financial profile. 
One of the updates we’re particularly proud of is our new visual styling for different bank accounts. Based on the client designer’s feedback, we make each bank account instantly recognizable and visually engaging—helping users better navigate and interact with their financial data. 
The dashboard also provides a snapshot of net worth, including assets and liabilities, along with a list of recent transactions. Quick access buttons are available at the top of the page to help user set goals, managing recurring bills, and viewing transaction summaries. Once user input their goal, it will display at the middle of the page.

Next is the Categorisation and Visualisation page. Users can explore their financial activity with a dynamic dashboard that shows income and outcome trends over time. They can adjust the timeline to view data on a weekly, monthly, or quarterly basis. Transactions are automatically categorized using AI, and users have the ability to manually adjust or customize categories, which is a key requirement from our client. User can also filter categories and view the transaction in different accounts. Filters allow users to drill down into specific categories or accounts for a deeper view.

Finally, we have the AI Assistant. This brings the intelligence of Finsplore to life with two main components. The first is the Agent, which handles direct user interactions. For example, when a user taps on “Recurring Bills,” they instantly see all upcoming bills like rent, mobile, and subscriptions. The second component is the Advisor, which focuses on improving the user’s personal financial wellbeing. It analyzes transaction patterns and spending behavior, offering personalized recommendations. It also supports natural language queries. For instance, a user can ask, “What were my food expenses last month?” and the Advisor will respond with a tailored detailed breakdown of their spendig base on data in food category. Based on client feedback, we also gave our chatbot a friendly touch—adding a profile photo and real-time message status updates (like typing indicators and delivery confirmations) to make interactions feel more human and conversational.

---

> Note: This document was originally produced with the assistance of OpenAI’s ChatGPT; the content has been subsequently reviewed, revised in detail, and refined through editing according to requirements.