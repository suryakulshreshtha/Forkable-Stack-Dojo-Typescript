# 🧰 Tools

What each tool is for, and the one command that installs it. Full setup with explanations: [`docs/01-workstation-setup.md`](docs/01-workstation-setup.md).

> 🧒 **Install nothing up front.** You need Node and Git to start. Every other tool is installed by the dojo that needs it, so you always know *why* it is on your machine.

---

## 🚦 Needed to begin

| Tool | What it does | 🍎 macOS | 🪟 Windows |
|---|---|---|---|
| **Node.js 26** | Runs JavaScript outside the browser | `brew install node` or `nvm install 26` | `winget install OpenJS.NodeJS.LTS` or `fnm install 26` |
| **Git** | Version control | `brew install git` | `winget install --id Git.Git -e --source winget` |
| **VS Code** | Editor | `brew install --cask visual-studio-code` | `winget install Microsoft.VisualStudioCode` |

## 📦 Installed per dojo (via `npm install`)

| Tool | Dojo | What it does |
|---|---|---|
| TypeScript | `01-foundations/typescript` | Type checking |
| Next.js · React | `02-frontend/*` | The app framework and UI library |
| Tailwind · shadcn/ui · Radix | `02-frontend/*` | Styling and accessible components |
| Jotai | `02-frontend/state-management` | Shared client state |
| Express · Zod | `03-backend/express` | HTTP server and input validation |
| Prisma | `03-backend/prisma-azuresql` | Database schema, migrations, queries |
| `jsonwebtoken` · `bcrypt` | `03-backend/jwt-auth` | Tokens and password hashing |
| `@azure/msal-node` | `03-backend/sso-entra-msal` | Microsoft Entra ID sign-in |
| `swagger-jsdoc` · `swagger-ui-express` | `03-backend/swagger-openapi` | API documentation |
| Jest · ts-jest | `04-testing/jest` | Unit tests |
| Testing Library · `user-event` | `04-testing/react-testing-library` | Component tests |
| Supertest | `04-testing/supertest` | API integration tests |
| Playwright | `04-testing/playwright` | Browser tests |
| ESLint · Prettier · Husky · lint-staged | `05-quality/eslint-husky` | Linting, formatting, commit hooks |

## 🖥 Installed on your machine (not via npm)

| Tool | Dojo | 🍎 macOS | 🪟 Windows |
|---|---|---|---|
| **Docker Desktop** | `03-backend/prisma-azuresql`, all of `06-devops` | <https://docs.docker.com/desktop/setup/install/mac-install/> | `wsl --install` first, then <https://docs.docker.com/desktop/setup/install/windows-install/> |
| **Azure CLI** | `06-devops/azure-*` | `brew install azure-cli` | `winget install Microsoft.AzureCLI` |
| **PowerShell 7** | `06-devops/powershell-iac` | `brew install --cask powershell` | `winget install Microsoft.PowerShell` |
| **SonarQube** (container) | `05-quality/sonarqube` | `docker run -d --name sonarqube -p 9000:9000 sonarqube:community` | same |
| **GitHub CLI** (`gh`) | optional, used throughout | `brew install gh` | `winget install GitHub.cli` |

> 🔎 **If a `winget install` says no package was found,** the ID has changed. Run `winget search <name>` and use what it prints. Package IDs are not guaranteed stable, which is why this file shows the search as the fallback.

## ✅ Verify everything

| Tool | Command | Want |
|---|---|---|
| Node | `node --version` | `v26.x.x` |
| npm | `npm --version` | any |
| Git | `git --version` | any |
| Docker (installed **and** running) | `docker ps` | a table |
| Azure CLI | `az version` | JSON |
| PowerShell | `pwsh --version` | `7.x` |
| GitHub CLI | `gh auth status` | logged in |

🧯 Anything failing → [`docs/01-workstation-setup.md`](docs/01-workstation-setup.md) §11, then [`docs/02-path-explained.md`](docs/02-path-explained.md).
