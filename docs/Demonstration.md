
## Demonstration Video:
We’re only able to provide a demonstration video of our mobile app because the app hasn’t been fully deployed yet. Publishing a mobile app involves extra steps like building it for different devices, meeting app store requirements, and sometimes waiting for approval. These steps can take time and will be done in next sprint.

Instead, we’ve made a clear and detailed video that shows how the app works and what features are finished so far. This lets clients understand and review our work.

https://github.com/user-attachments/assets/1f980b3c-f93a-4f7d-be5e-265b63434b14


## Client Feedback
### **Login / Registration**
* Secure login and registration process is well implemented.
* ID verification is not strictly required, but storing user ID (e.g., passport number) is recommended for legitimacy tracking.

### **Basiq API Integration**
* Confirmed Basiq’s identity API does not enforce mandatory ID verification.
* Suggested deferring full ID verification and simply recording ID values for now.

### **AI Chatbot**
* Do not transmit customer data to third-party AI services.
* Use AI (e.g., OpenAI or Anthropic) only to parse user queries.
* Recommended architecture: AI → SQL Parser → Internal Logic → Display Result.
* Add support for multiple chat sessions and session history (like CommBank).
* Chatbot should not process raw data – AI acts as translator only.

### **Transaction Categorisation**
* Use AI to perform transaction classification.
* Allow users to override assigned categories.
* Store final category mappings in internal database.
* Follow WeMoney flow (e.g., allow bulk edits, custom categories).

### **UI/UX Feedback** (Figma vs Mobile App)
* Preferred the new light-themed mobile version with: Clearer spacing and layout & Better background contrast
* Readable and visually clear percentage formatting
* **Icons** and simplified visual design (no heavy shadows) are encouraged.
* Use **Material 3** design standards where applicable.