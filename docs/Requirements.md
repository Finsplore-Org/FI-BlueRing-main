## 📌 Overview
This document outlines the **Functional Requirements (FR)** and **Non-Functional Requirements (NFR)** for *Finsplore*, an AI-driven financial assistant. These requirements are derived from the user stories defined in the product backlog and serve to provide a clear and structured reference for development. This document also contain the do/be/feel motivational model.

---

# ✅ Functional Requirements (FR)

| ID   | Requirement                                                                 |
|------|------------------------------------------------------------------------------|
| FR1  | The system must allow users to ask financial questions via a chatbot.       |
| FR2  | The chatbot must support natural language understanding.                    |
| FR3  | The system must allow users to securely connect their bank accounts.        |
| FR4  | The system must provide visual insights for transaction data.               |
| FR5  | The system must support user authentication through a secure login.         |
| FR6  | The system must log users out automatically after a period of inactivity.   |
| FR7  | The system must display a summary of income and expenses.                   |
| FR8  | The system must allow users to compare financial data over time.            |
| FR9  | The system must send alerts for significant transactions.                   |
| FR10 | The system must allow users to create and manage monthly budgets.           |
| FR11 | The system must support multiple bank account connections.                  |
| FR12 | The system must allow users to set and track financial goals.               |
| FR13 | The system must provide end-to-end encryption for financial data.           |
| FR14 | The system must suggest small saving tips monthly.                          |
| FR15 | The system must explain financial terms in plain language.                  |
| FR16 | The system must allow customization of expense categories.                  |
| FR17 | The system must send bill reminders through the AI assistant.               |
| FR18 | The system must allow users to update profile and contact details.          |

---

# 🔒 Non-Functional Requirements (NFR)

| ID    | Requirement                                                                                          |
|-------|------------------------------------------------------------------------------------------------------|
| NFR1  | The system must ensure user data privacy and comply with relevant data protection regulations (e.g., GDPR). |
| NFR2  | The system must use encryption (e.g., HTTPS, AES-256) for data transmission and storage.            |
| NFR3  | The chatbot must respond to user queries within 2 seconds on average.                               |
| NFR4  | The system must be available 99.9% of the time (high availability).                                  |
| NFR5  | The system must support at least 10,000 concurrent users without performance degradation.            |
| NFR6  | The user interface must be responsive and support mobile, tablet, and desktop devices.              |
| NFR7  | All financial insights and visualizations must update within 5 seconds after retrieving data.        |
| NFR8  | The system must log all user actions for audit and security monitoring.                              |
| NFR9  | The system must automatically back up user data daily.                                               |
| NFR10 | The system must be user-friendly and understandable for people with no financial background.        |

---

## App Startup Time
- **Cold Start:** App launch time should be **< 2s**.  
- **Warm Start:** App resumes from background in **< 500ms**.  
- **Optimization:**  
  - Lazy loading for non-essential components.  
  - Minimize bundle size using tree shaking.(vite or webpack)

## API Response Time
- **Max Response Time:** API calls should complete within **< 500ms**.  
- **Caching:** strong cache and negotiate cache.

# Availability (Uptime & Reliability)

## Server live time
To ensure the app is always available, the server should have **99.99% uptime**, meaning it can only be down for **a maximum of 52.6 minutes per year**. This helps users access the app without frequent disruptions.  

# Security

## Authentication & Authorization
- **OAuth 2.0 & JWT:** Secure user login using **OAuth 2.0** and **JSON Web Tokens (JWT)** for session management, google oauth.
- **Role-Based Access Control (RBAC):** Restrict access to sensitive financial data based on user roles.

## Data Protection and Encrption
- **HTTPS:** All communications between the app and the server must use **HTTPS** to prevent data interception.
- **AES Encryption:** Store sensitive user data (e.g., passwords, financial transactions) using **AES-256 encryption**.

## XSS & SQLIA & CSPF protection
**make sure never use user's input as code.**
- **SQL Injection:** Use **parameterized queries** to prevent database attacks.
- **Cross-Site Scripting (XSS):** Sanitize user inputs and use **Content Security Policy (CSP)** to block malicious scripts code.
- **Cross-Site Request Forgery (CSRF):** Implement **CSRF tokens** to protect user actions from unauthorized requests.

# Compatibility

To ensure the app works seamlessly across different devices, platforms, and API versions, we focus on the following areas:

## Cross-Platform Compatibility (iOS & Android)
- **Multiple Platforms Support:** Ensure the app is compatible with both **iOS** and **Android** devices, maintaining a consistent user experience across both operating systems.

## API Versioning
- **Backward Compatibility:** Ensure that the API can support **older app versions**, allowing users to interact with the system without issues when updating to newer versions.
- **Semantic Versioning:** Use **semantic versioning** for the API (e.g., `v1`, `v2`) to clearly indicate breaking or non-breaking changes, ensuring app versions can still communicate with the API correctly.

---

---

> Note: This document was originally produced with the assistance of OpenAI’s ChatGPT; the content has been subsequently reviewed, revised in detail, and refined through editing according to requirements.