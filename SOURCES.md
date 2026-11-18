# 📚 Sources

Everything this repository states as fact traces back to one of the sources below. **Official documentation only** for commands, behaviour and versions. Where no official source exists, the claim is labelled as an opinion or a stack decision rather than a fact.

🗓 Version numbers and deprecation notices were read on **2026-11-18** by the methods in [VERSIONS.md](VERSIONS.md). The documentation links below are the official docs sites for each tool; they were not individually re-fetched on that date, so if one has moved, the project's docs root is the place to start.

---

## 🧱 Language and runtime

| Topic | Source |
|---|---|
| Node.js releases, LTS status and EOL dates | <https://nodejs.org/en/about/previous-releases> · schedule JSON: <https://github.com/nodejs/Release> |
| Node.js API (including `--env-file`) | <https://nodejs.org/api/> |
| Node.js downloads and version managers | <https://nodejs.org/en/download> |
| TypeScript handbook and `tsconfig` reference | <https://www.typescriptlang.org/docs/> · <https://www.typescriptlang.org/tsconfig/> |
| TypeScript release announcements | <https://devblogs.microsoft.com/typescript/> |
| nvm | <https://github.com/nvm-sh/nvm> |
| fnm | <https://github.com/Schniz/fnm> |

## 🎨 Frontend

| Topic | Source |
|---|---|
| Next.js App Router, file conventions, middleware, env vars | <https://nextjs.org/docs> |
| React (learn, hooks reference, "You Might Not Need an Effect") | <https://react.dev> |
| Tailwind CSS (docs, theme, upgrade guide) | <https://tailwindcss.com/docs> |
| shadcn/ui | <https://ui.shadcn.com/docs> |
| Radix Primitives and composition (`asChild`) | <https://www.radix-ui.com/primitives/docs/overview/introduction> |
| Jotai | <https://jotai.org/docs/introduction> |
| Recoil (archived, linked for reference only) | <https://recoiljs.org> |
| WAI-ARIA Authoring Practices | <https://www.w3.org/WAI/ARIA/apg/> |

## ⚙️ Backend and data

| Topic | Source |
|---|---|
| Express 5 API, migration guide, error handling, security practice | <https://expressjs.com/en/5x/api.html> |
| Prisma ORM, SQL Server connector, Migrate | <https://www.prisma.io/docs> |
| SQL Server in Docker | <https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker> |
| Azure SQL | <https://learn.microsoft.com/en-us/azure/azure-sql/> |
| JWT specification (RFC 7519) | <https://datatracker.ietf.org/doc/html/rfc7519> |
| `jsonwebtoken` | <https://github.com/auth0/node-jsonwebtoken> |
| Passport strategies | <https://www.passportjs.org/concepts/authentication/strategies/> |
| Microsoft identity platform and MSAL Node | <https://learn.microsoft.com/en-us/entra/identity-platform/> · <https://learn.microsoft.com/en-us/entra/msal/node/> |
| OAuth 2.0 authorisation code flow (Microsoft) | <https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow> |
| OpenAPI Specification | <https://swagger.io/specification/> |
| Zod | <https://zod.dev> |
| HTTP semantics (RFC 9110), status codes, methods, CORS | <https://datatracker.ietf.org/doc/html/rfc9110> · <https://developer.mozilla.org/en-US/docs/Web/HTTP> |

## 🧪 Testing and quality

| Topic | Source |
|---|---|
| Jest (getting started, mocks, timers, expect) | <https://jestjs.io/docs/getting-started> |
| Testing Library (queries, guiding principles, `user-event`) | <https://testing-library.com/docs/> |
| Supertest | <https://github.com/ladjs/supertest> |
| Playwright (locators, best practices, traces, auth, CI) | <https://playwright.dev/docs/intro> |
| ESLint and flat-config migration | <https://eslint.org/docs/latest/> |
| typescript-eslint | <https://typescript-eslint.io/getting-started/> |
| Prettier | <https://prettier.io/docs/> |
| Husky · lint-staged | <https://typicode.github.io/husky/> · <https://github.com/lint-staged/lint-staged> |
| SonarQube (docs, Clean as You Code, hotspots) | <https://docs.sonarsource.com/> |
| OWASP cheat sheets (password storage, JWT) | <https://cheatsheetseries.owasp.org/> |

## 🚢 Delivery

| Topic | Source |
|---|---|
| Docker (multi-stage builds, Dockerfile reference, build cache, Node guide) | <https://docs.docker.com/> |
| Docker Desktop install and licence terms | <https://docs.docker.com/desktop/> |
| Azure Container Apps (secrets, scaling, CLI) | <https://learn.microsoft.com/en-us/azure/container-apps/> |
| Azure Container Registry | <https://learn.microsoft.com/en-us/azure/container-registry/> |
| Azure CLI reference | <https://learn.microsoft.com/en-us/cli/azure/> |
| Azure Pipelines and YAML schema | <https://learn.microsoft.com/en-us/azure/devops/pipelines/> |
| GitHub Actions and security hardening | <https://docs.github.com/en/actions> |
| PowerShell (scripting, `Az` module, `ShouldProcess`) | <https://learn.microsoft.com/en-us/powershell/> |
| Bicep | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/> |

## 🐙 Git and GitHub

| Topic | Source |
|---|---|
| Git reference and Pro Git | <https://git-scm.com/docs> · <https://git-scm.com/book/en/v2> |
| GitHub flow and Git basics | <https://docs.github.com/en/get-started> |
| Authentication, SSH, removing sensitive data | <https://docs.github.com/en/authentication> |
| Rulesets and branch protection | <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets> |
| `gh` CLI manual | <https://cli.github.com/manual/> |
| `.gitignore` templates | <https://github.com/github/gitignore> |
| Choosing a licence | <https://choosealicense.com> |

## 🖥 Shell and PATH

| Topic | Source |
|---|---|
| zsh startup files | <https://zsh.sourceforge.io/Doc/Release/Files.html> |
| PowerShell environment variables and profiles | <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables> |
| Homebrew (install, FAQ, PATH) | <https://brew.sh> · <https://docs.brew.sh/FAQ> |

---

## 🚫 Not used as sources of fact

Blog posts, aggregator articles, AI-generated summaries and Stack Overflow answers were not used to establish any claim in this repository. Where something could not be verified from an official source, it is marked as unverified in [VERSIONS.md](VERSIONS.md) §6 or phrased as a judgement rather than a fact.

Opinions in this repo — "E2E suites should stay small", "prefer `unknown` to `any`", "warnings should be errors" — are **opinions**, offered with reasoning so you can disagree on the merits.
