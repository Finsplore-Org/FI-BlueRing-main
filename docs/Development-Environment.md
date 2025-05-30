# Code Standard
Use Prettier for code formatting

Use ESLint for linting

Use 4 spaces for indentation
### Naming Convention
- **Use `kebab-case` for folders and filenames**  
  -  `user-profile.js`

- **Use `PascalCase` for components and classes**  
  -  `UserProfile.js`

- **Use `camelCase` for variables and functions**  
  -  `fetchUserData`

- **Use `SCREAMING_SNAKE_CASE` for constants**  
  -  `MAX_RETRY_COUNT`

# Branching Guidelines
## 1. Branching Strategy  
We use a **simplified Git Flow**.

### 1.1 Main Branches  (protected main)
- **`main`**: The stable production branch.  
- **`dev`**: The main development branch. All feature branches are merged here before going to `main`.  

### 1.2 Supporting Branches  
- **Feature Branches (`feature/xxx`)**: Used for developing new features. Merged into `dev` when completed.  
  - Example: `feature/authentication`, `feature/payment-integration`  
- **Bug Fix Branches (`fix/xxx`)**: Used to fix bugs in development. Merged into `dev`.  
  - Example: `fix/login-error`, `fix/crash-ios`  
- **Hotfix Branches (`hotfix/xxx`)**: Used to fix critical production issues. Merged into both `main` and `develop`.  
  - Example: `hotfix/payment-bug`, `hotfix/security-patch`  

---

# Commit Guidelines
| Type | Description |
|------|------------|
| feat | New feature |
| fix  | Bug fix |
| docs | Documentation updates |
| refactor | Code restructuring (without changing behavior) |
| style | Code formatting (no logic changes) |
| test | Adding or updating tests |
| chore | Build, dependencies, or CI updates | 


git commit -m "feat: add dark mode toggle for better user experience"

# Versioning
v(major).(minor).(patch)

v1.0.0 → Initial release

v1.1.0 → Minor feature updates

v1.1.1 → Bug fixes

# Work Flow

## 1. Branch Management
- `main`: Stable branch  (protected)
- `dev`: Development branch  
- `feature/*`: Feature development branch  
- `bugfix/*`: Bug fix branch  
- `hotfix/*`: Hotfix branch  

## 2. Development Flow
1. Pull the latest code from `dev`  
2. Create a `feature/*` branch for development  
3. Commit and push changes to the remote repository  
4. Create a Pull Request (PR) for Code Review  
5. Merge into `dev` after approval and delete the branch  

## 3. Code Review
- At least 1-2 reviewers must approve the PR  
- Ensure adherence to Code Standards, clean logic, and no redundant code  

## 4. Testing & Deployment
- Run local tests before pushing  
- Deploy to Staging for QA testing  
- CI/CD automates deployment to production  
- Rollback quickly if issues arise  

## 5. Task Management
- Use GitHub for issue tracking  
- Task types: `feature` / `bug` / `improvement` / `docs`  

---

> Note: This document was originally produced with the assistance of OpenAI’s ChatGPT; the content has been subsequently reviewed, revised in detail, and refined through editing according to requirements.