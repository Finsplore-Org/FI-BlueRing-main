**Test Case ID:** FI_US1_FINCHAT_001  
**Title:** Verify that users can enter "How much money did I spend this month?" To obtain the total consumption of the current month  
**Requirement ID:** US1  
**Preconditions:**  
- The user has logged in to the chat interface 
- The current month's consumption data of this user exists in the system

**Test Steps:**  
1. The user enters in the dialog box: "How much did I spend this month?"
2. The chatbot handles problems and invokes consumption record data
3. The chatbot returns the total amount

**Test Data:**  
- April 1st：$50  
- April 10th：$200  

**Expected Result:**  
- The chatbot replied: "You spent a total of $250 this month."  

**Acceptance Criteria:**
When the user inputs to inquire about the total consumption for this month, the system should return the correct total amount. If there is no record, a prompt "No record for now" will be returned.

**Testing Strategy:**
Functional testing + boundary testing (in cases without data)  
**Actual Result:** _ The chatbot replied: "You spent a total of $250 this month."_  
**Status:** _Pass _  
**Priority:** High  
**Tester:** _ (Longfei Zhang) _  
**Test Date:** _ April 30th _  
**Comments:** If there is no consumption record, it should prompt "No record for now".

<br><br>  
**Test Case ID:** FI_US1_FINCHAT_002  
**Title:** Verify that users can enter "In which categories did I spend the most last week?" To obtain the classification statistics  
**Requirement ID:** US1  
**Preconditions:**  
- The system has recorded the classified consumption data of last week 

**Test Steps:**  
1. User input: "In which categories did I spend the most last week?"
2. The chatbot recognizes the time range and classification dimensions
3. Return the consumption summary of each category, arranged in descending order by amount 

**Test Data:**  
- Catering：$150  
- Transportation：$80  
- Entertainment：$120  

**Expected Result:**  
- The chatbot replied: "Last week, the category you spent the most on was' catering ', spending a total of $150."  

**Acceptance Criteria**: The chatbot should return the spending breakdown by category for the past week, sorted by amount in descending order, and highlight the category with the highest spending.  
**Testing Strategy**: Data-Driven Testing + Category-Based Testing  
**Actual Result:** _（The chatbot replied: "Last week, the category you spent the most on was' catering ', spending a total of $150." ）_  
**Status:** _Pass _  
**Priority:** High  
**Tester:** _(Longfei Zhang)_  
**Test Date:** _April 30th_  
**Comments:** The complete classification details can be further listed

<br><br>  
**Test Case ID:** FI_US3_BANKLINK_001  
**Title:** Verify that the user can successfully connect a valid bank account via secure authentication  
**Requirement ID:** US3  
**Preconditions:**  
- The user is logged into the system  
- The bank supports secure OAuth/Open Banking connection  

**Test Steps:**  
1. User navigates to “Connect Bank Account”  
2. User selects their bank from the list  
3. User is redirected to the bank’s secure login page  
4. User enters valid credentials and authorizes access  
5. System confirms successful connection  

**Test Data:**  
- Bank: TestBank  
- Credentials: Valid username/password  

**Expected Result:**  
- User is redirected back to the app with confirmation: “Bank account connected successfully.”  
- Bank account appears in user profile  

**Acceptance Criteria**: Users should be able to successfully authorize and link their bank accounts, and the linked account should be visible in their profile.  
**Testing Strategy**: End-to-End Testing + Integration Testing (OAuth callback verification)  
**Actual Result**: Bank account connected successfully and displayed in profile.  
**Status:** _Pass _  
**Priority:** High  
**Tester:** _(Longfei Zhang)_  
**Test Date:** _May 1st_  
**Comments:** N/A  

<br><br>  
**Test Case ID:** FI_US3_BANKLINK_002  
**Title:** Verify that the system handles invalid bank login credentials gracefully  
**Requirement ID:** US3  
**Preconditions:**  
- The user is at the bank login step  

**Test Steps:**  
1. User selects their bank  
2. User is redirected to the login page  
3. User enters incorrect username or password  
4. Bank rejects login  
5. System returns appropriate error message  

**Test Data:**  
- Bank: TestBank  
- Credentials: Invalid username/password  

**Expected Result:**  
- Chatbot displays: “Login failed. Please check your credentials and try again.”  
- User remains on login screen  

**Acceptance Criteria**: If bank login fails, the system should return a clear error message and keep the user on the login page.  
**Testing Strategy**: Negative Path Testing + Security Testing  
**Actual Result**: Chatbot displays: “Login failed. Please check your credentials and try again.”  
**Status:** _Pass _  
**Priority:** Medium  
**Tester:** _(Longfei Zhang)_  
**Test Date:** _(May 1st)_  
**Comments:** Should include a retry option  

<br><br>  
**Test Case ID:** FI_US3_BANKLINK_003  
**Title:** Verify that bank account data is transmitted over a secure encrypted channel  
**Requirement ID:** US3  
**Preconditions:**  
- The user attempts to connect a bank account  

**Test Steps:**  
1. User initiates bank connection  
2. Monitor the network communication between app and bank API  
3. Verify that all requests use HTTPS and data is encrypted  

**Test Data:**  
- Sample API calls from app to bank endpoint  

**Expected Result:**  
- All transmissions occur over HTTPS  
- No sensitive data exposed in plain text  

**Acceptance Criteria**: All communications with the bank must use HTTPS, with no plaintext transmission of sensitive data.  
**Testing Strategy**: Security Testing + Network Packet Analysis  
**Actual Result**: All transmissions encrypted via HTTPS; no data exposed.  
**Status:** _Pass _  
**Priority:** High  
**Tester:** _(Longfei Zhang)_  
**Test Date:** _(May 1st)_  
**Comments:** Penetration/security test should be conducted

<br><br>  
**Test Case ID:** SEC_US4_IDVERIFY_001  
**Title:** Verify that access is granted only after a valid identity document is submitted  
**Requirement ID:** US4  

**Preconditions:**  
- Admin user has logged into the system  
- System is ready to receive documents  

**Test Steps:**  
1. Upload a valid government-issued ID (e.g., passport, ID card)  
2. Submit the document for verification  
3. Await verification result  
4. Try to access protected admin features  

**Test Data:**  
- Document: Passport (valid)  
- Format: PDF  

**Expected Result:**  
- Document is accepted  
- Verification status changes to “Verified”  
- Admin is granted access  

**Acceptance Criteria**: The system should accept valid identity documents and allow access to admin features after successful verification.  
**Testing Strategy**: Document Upload Testing + Permission Verification  
**Actual Result**: Access granted after successful document verification.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** SEC_US4_IDVERIFY_002  
**Title:** Verify that unsupported file formats are rejected  
**Requirement ID:** US4  

**Preconditions:**  
- Admin is logged in  
- No document uploaded yet  

**Test Steps:**  
1. Attempt to upload a file in unsupported format (e.g., .exe or .txt)  
2. Submit for verification  

**Test Data:**  
- Document: test.exe  
- Format: EXE  

**Expected Result:**  
- System displays error: “Unsupported file format”  
- Document is rejected  
- Access is not granted  

**Acceptance Criteria**: Unsupported file formats should be rejected, and the system should show an appropriate error message.  
**Testing Strategy**: Negative Testing + File Format Filtering  
**Actual Result**: System displays “Unsupported file format” and blocks access.  
**Status:** _Pass _  
**Priority**: Medium  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** SEC_US4_IDVERIFY_003  
**Title:** Verify that access is denied if no identity document is uploaded  
**Requirement ID:** US4  

**Preconditions:**  
- Admin is logged in  
- No documents have been uploaded  

**Test Steps:**  
1. Attempt to proceed to the admin section without uploading a document  

**Test Data:**  
- N/A  

**Expected Result:**  
- System blocks access  
- Message shown: “Please submit an identity document for verification”  

**Acceptance Criteria**: If no identity document is uploaded, access should be denied, and the user should be prompted to submit one.  
**Testing Strategy**: Access Control Testing  
**Actual Result**: Access denied with message: “Please submit an identity document for verification.”  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** AUTH_US5_SIGNUP_001  
**Title:** Verify that a user can sign up successfully with valid information  
**Requirement ID:** US5  

**Preconditions:**  
- User is not registered in the system  

**Test Steps:**  
1. Navigate to the sign-up page  
2. Enter a valid email, strong password, and confirm password  
3. Accept terms and click "Sign Up"  

**Test Data:**  
- Email: testuser@example.com  
- Password: Test@1234  

**Expected Result:**  
- User receives confirmation (or email verification request)  
- Account is created successfully  
- User is redirected or prompted to log in  

**Acceptance Criteria**: User should be able to create an account with valid email and password, receiving confirmation.  
**Testing Strategy**: Functional testing for form validation and account creation flow.  
**Actual Result**: User signed up successfully and redirected to login.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  
 
<br><br>  
**Test Case ID:** AUTH_US5_LOGIN_002  
**Title:** Verify that a user can log in with valid credentials  
**Requirement ID:** US5  

**Preconditions:**  
- User account already exists and is verified  

**Test Steps:**  
1. Navigate to login page  
2. Enter correct email and password  
3. Click "Log In"  

**Test Data:**  
- Email: testuser@example.com  
- Password: Test@1234  

**Expected Result:**  
- User is authenticated  
- Access is granted to dashboard or home page  

**Acceptance Criteria**: System authenticates user and grants access to the dashboard.  
**Testing Strategy**: Positive login test, authentication validation.  
**Actual Result**: User logged in and directed to the home page.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** AUTH_US5_LOGIN_003  
**Title:** Verify that login fails with incorrect password  
**Requirement ID:** US5  

**Preconditions:**  
- User account exists  

**Test Steps:**  
1. Navigate to login page  
2. Enter valid email but incorrect password  
3. Click "Log In"  

**Test Data:**  
- Email: testuser@example.com  
- Password: wrongPass123  

**Expected Result:**  
- System shows error message: “Incorrect email or password”  
- Access is denied  

**Acceptance Criteria**: Incorrect password should trigger an error message and deny access.  
**Testing Strategy**: Negative test case, error handling.  
**Actual Result**: Error displayed: “Incorrect email or password”.  
**Status:** _Pass _  
**Priority**: Medium  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** AUTH_US5_SIGNUP_004  
**Title:** Verify that the system prompts for required fields during sign-up  
**Requirement ID:** US5  

**Preconditions:**  
- User on sign-up page  

**Test Steps:**  
1. Leave email or password field blank  
2. Click "Sign Up"  

**Test Data:**  
- Email: (empty)  
- Password: Test@1234  

**Expected Result:**  
- System shows validation message: “Email is required”  
- Sign-up is blocked  

**Acceptance Criteria**: System should prompt for missing fields like email or password.  
**Testing Strategy**: Form validation testing.  
**Actual Result**: Validation error shown for missing fields.  
**Status:** _Pass _  
**Priority**: Medium  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** AUTH_US5_LOGIN_005  
**Title:** Verify that users are redirected to dashboard/home after successful login  
**Requirement ID:** US5  

**Preconditions:**  
- Valid user credentials  

**Test Steps:**  
1. Log in with correct credentials  
2. Observe post-login navigation  

**Expected Result:**  
- User is redirected to the correct landing page (e.g., dashboard)  

**Acceptance Criteria**: User should be redirected to the dashboard after login.  
**Testing Strategy**: Post-authentication redirection flow test.  
**Actual Result**: Redirected to dashboard after login.  
**Status:** _Pass _  
**Priority**: Medium  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US7_SUMMARY_001  
**Title:** Verify that the user can view financial summary including income, expenses, and net worth  
**Requirement ID:** US7  

**Preconditions:**  
- User has logged in  
- System has financial data for the user  

**Test Steps:**  
1. Navigate to "My Financial Summary" or dashboard  
2. View income, expenses, and net worth data  

**Test Data:**  
- Income: $5,000  
- Expenses: $3,200  
- Net Worth: $15,000  

**Expected Result:**  
- System displays:  
  - Income: $5,000  
  - Expenses: $3,200  
  - Net Worth: $15,000  

**Acceptance Criteria**: System should display income, expenses, and net worth accurately.  
**Testing Strategy**: UI and data validation test.  
**Actual Result**: Summary displayed correctly.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US7_SUMMARY_002  
**Title:** Verify that the system handles missing financial data gracefully  
**Requirement ID:** US7  

**Preconditions:**  
- User has logged in  
- No financial data is available  

**Test Steps:**  
1. Navigate to the summary section  

**Expected Result:**  
- System displays:  
  - "No financial data available yet. Please link your accounts or add records."  

**Acceptance Criteria**: If no data exists, system should show a friendly message.  
**Testing Strategy**: Edge case test for null data state.  
**Actual Result**: Message displayed: “No financial data available yet.”  
**Status:** _Pass _  
**Priority**: Medium  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US7_SUMMARY_003  
**Title:** Verify that the summary reflects recent updates to income or expenses  
**Requirement ID:** US7  

**Preconditions:**  
- User has existing financial summary  
- New expense/income is added  

**Test Steps:**  
1. Add a new income record of $1,000  
2. Refresh or revisit summary section  

**Test Data:**  
- Initial Income: $5,000  
- New Income Added: $1,000  

**Expected Result:**  
- Updated income displayed: $6,000  

**Acceptance Criteria**: Adding a new income or expense should update the summary.  
**Testing Strategy**: Regression and state update test.  
**Actual Result**: Summary reflects updated income.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US11_BANKLINK_001  
**Title:** Verify that the user can successfully connect multiple bank accounts  
**Requirement ID:** US11  

**Preconditions:**  
- User is logged in  
- Banks are available via integration (e.g., via Plaid/OpenBanking API)  

**Test Steps:**  
1. Navigate to "Linked Accounts" or "Add Bank Account"  
2. Select Bank A and authenticate  
3. Repeat process for Bank B  
4. Confirm both accounts appear in the list  

**Test Data:**  
- Bank A: Chase  
- Bank B: Wells Fargo  

**Expected Result:**  
- Both accounts are listed as “Connected”  
- Account balances are retrieved and displayed  

**Acceptance Criteria**: User should be able to connect more than one account successfully.  
**Testing Strategy**: Multi-step flow and integration testing.  
**Actual Result**: Multiple accounts connected and displayed.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US11_BANKLINK_002  
**Title:** Verify that linked accounts are consolidated into a single financial view  
**Requirement ID:** US11  

**Preconditions:**  
- User has successfully linked multiple bank accounts  

**Test Steps:**  
1. Navigate to "Dashboard" or "Financial Summary"  
2. View consolidated total balance  

**Test Data:**  
- Bank A Balance: $5,000  
- Bank B Balance: $3,000  

**Expected Result:**  
- Total Balance Displayed: $8,000  
- Individual balances are shown with bank labels  

**Acceptance Criteria**: Balances from all linked accounts should be summed and shown clearly.  
**Testing Strategy**: Aggregation logic test.  
**Actual Result**: Combined balance displayed correctly.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US11_BANKLINK_003  
**Title:** Verify that disconnecting an account removes its data from the summary  
**Requirement ID:** US11  

**Preconditions:**  
- User has two bank accounts linked  

**Test Steps:**  
1. Disconnect Bank B  
2. Return to financial summary  

**Test Data:**  
- Bank A: $5,000  
- Bank B: $3,000  

**Expected Result:**  
- Bank B no longer appears  
- Total balance updates to only show Bank A: $5,000  

**Acceptance Criteria**: After disconnection, account and data should be removed from the view.  
**Testing Strategy**: Data removal validation.  
**Actual Result**: Disconnected bank removed; total updated.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US11_BANKLINK_004  
**Title:** Verify that the system shows an error if a bank account cannot be connected  
**Requirement ID:** US11  

**Preconditions:**  
- Bank integration API is temporarily down or user credentials are incorrect  

**Test Steps:**  
1. Attempt to connect to Bank C  
2. Enter incorrect login credentials or simulate API failure  

**Expected Result:**  
- System displays error: “Unable to connect to the bank. Please try again later.”  
- No account is added  

**Acceptance Criteria**: On failure, display meaningful error without linking the account.  
**Testing Strategy**: Fault injection test.  
**Actual Result**: Error shown: “Unable to connect to the bank.”  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  

**Test Case ID:** FIN_US20_TXNHIST_001  
**Title:** Verify that the user can view their full transaction history  
**Requirement ID:** US20  

**Preconditions:**  
- User is logged in  
- Transaction history exists  

**Test Steps:**  
1. Navigate to “Transaction History”  
2. Scroll through the list  

**Expected Result:**  
- Transactions are listed in reverse chronological order  
- Each transaction displays date, merchant, amount, and category  

**Acceptance Criteria**: All transactions should be listed in reverse chronological order.  
**Testing Strategy**: Timeline sorting and completeness test.  
**Actual Result**: Full transaction history visible.  
**Status:** _Pass _  
**Priority**: High  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US20_TXNHIST_002  
**Title:** Verify that the user can filter transactions by date range  
**Requirement ID:** US20  

**Preconditions:**  
- User has transactions over multiple months  

**Test Steps:**  
1. Set date filter: March 1 – March 31  
2. Apply filter  

**Expected Result:**  
- Only transactions within March are displayed  
- Summary updates accordingly  

**Acceptance Criteria**: Only transactions within selected range should be shown.  
**Testing Strategy**: Date filter function validation.  
**Actual Result**: Filter applied correctly, March transactions shown.  
**Status:** _Pass _  
**Priority**: Medium  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US20_TXNHIST_003  
**Title:** Verify that the user can search transactions by keyword  
**Requirement ID:** US20  

**Preconditions:**  
- User has transactions with various merchants  

**Test Steps:**  
1. Enter search keyword: “Starbucks”  
2. Apply search  

**Expected Result:**  
- Only transactions matching “Starbucks” are shown  
- Search highlights matched keyword  

**Acceptance Criteria**: Search results should match merchant names or descriptions.  
**Testing Strategy**: Search index and keyword highlighting test.  
**Actual Result**: Only “Starbucks” transactions shown.  
**Status:** _Pass _  
**Priority**: Medium  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  
**Test Case ID:** FIN_US20_TXNHIST_004  
**Title:** Verify that the system handles no results from search gracefully  
**Requirement ID:** US20  

**Preconditions:**  
- User inputs keyword not present in any transaction  

**Test Steps:**  
1. Search for: “Private Jet”  
2. View results  

**Expected Result:**  
- System displays: “No transactions found for your search.”  

**Acceptance Criteria**: Display message when no transactions match the search.  
**Testing Strategy**: No-match scenario validation.  
**Actual Result**: Message shown: “No transactions found for your search.”  
**Status:** _Pass _  
**Priority**: Low  
**Tester**: Longfei Zhang  
**Test Date**: May 1st  

<br><br>  

> Note: This document was originally produced with the assistance of OpenAI’s ChatGPT; the content has been subsequently reviewed, revised in detail, and refined through editing according to requirements.