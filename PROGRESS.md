# 📈 Progress

Tick a box only when you can do its **gate from an empty file**. Nobody is checking — which is exactly why it works.

> 🗓 Started: `____-__-__` · Last updated: `____-__-__`

---

## 🧱 01 · Foundations

| ✅ | Dojo | Gate |
|---|---|---|
| ☐ | [`typescript/`](01-foundations/typescript/README.md) | Strict project + generic with a constraint + derived type + exhaustive `switch` that fails on a new case |
| ☐ | [`git-workflows/`](01-foundations/git-workflows/README.md) | Cause and resolve a conflict; open, review and squash-merge a PR from the CLI |
| ☐ | [`http-fundamentals/`](01-foundations/http-fundamentals/README.md) | Serve GET + POST with no framework; correct status for success, created, bad body, failed validation, not found |

## 🎨 02 · Frontend

| ✅ | Dojo | Gate |
|---|---|---|
| ☐ | [`react/`](02-frontend/react/README.md) | Form + list sharing lifted state; a custom hook; explain any re-render |
| ☐ | [`nextjs-app-router/`](02-frontend/nextjs-app-router/README.md) | Two route groups, dynamic route, streaming server component, one correctly-placed client component, middleware |
| ☐ | [`component-library/`](02-frontend/component-library/README.md) | Form + table + dialog, operated entirely by keyboard; explain `asChild` |
| ☐ | [`tailwind/`](02-frontend/tailwind/README.md) | Responsive card with hover/focus-visible/disabled states and your own `@theme` colour |
| ☐ | [`state-management/`](02-frontend/state-management/README.md) | Shared + derived atoms across three unrelated components; translate a Recoil snippet to Jotai |

## ⚙️ 03 · Backend

| ✅ | Dojo | Gate |
|---|---|---|
| ☐ | [`express/`](03-backend/express/README.md) | Env validated at boot, Zod `422`s, one four-argument error handler that never leaks a stack |
| ☐ | [`prisma-azuresql/`](03-backend/prisma-azuresql/README.md) | Two related models, read the generated SQL, paginated query with a relation, a transaction |
| ☐ | [`jwt-auth/`](03-backend/jwt-auth/README.md) | Access + refresh with different secrets; `401` vs `403` correct; expiry handled as its own case |
| ☐ | [`sso-entra-msal/`](03-backend/sso-entra-msal/README.md) | Register an app, complete the auth-code flow, issue your own JWT from the claims |
| ☐ | [`swagger-openapi/`](03-backend/swagger-openapi/README.md) | Valid OpenAPI 3 with `$ref` schema, bearer scheme, every status code; drive it from Try it out |

## 🧪 04 · Testing

| ✅ | Dojo | Gate |
|---|---|---|
| ☐ | [`jest/`](04-testing/jest/README.md) | `it.each` table, one justified mock, fake-timer retry test |
| ☐ | [`react-testing-library/`](04-testing/react-testing-library/README.md) | Role/label queries only; tests survive an internal refactor |
| ☐ | [`supertest/`](04-testing/supertest/README.md) | `app`/`server` split; 401 / 403 / 422 / happy path; no open handles |
| ☐ | [`playwright/`](04-testing/playwright/README.md) | One full journey, no `waitForTimeout`, debug a break using only the trace viewer |

## 🧹 05 · Quality

| ✅ | Dojo | Gate |
|---|---|---|
| ☐ | [`eslint-husky/`](05-quality/eslint-husky/README.md) | Flat config with type-aware rules; hook actually blocks a bad commit |
| ☐ | [`sonarqube/`](05-quality/sonarqube/README.md) | Local scan with coverage; explain each finding and why new-code gating is better |

## 🚢 06 · DevOps

| ✅ | Dojo | Gate |
|---|---|---|
| ☐ | [`docker-multistage/`](06-devops/docker-multistage/README.md) | Multi-stage, non-root, health-checked image; explain the size difference and the instruction order |
| ☐ | [`azure-container-apps/`](06-devops/azure-container-apps/README.md) | Public URL, scale to zero, secret by reference, read logs, full teardown |
| ☐ | [`azure-pipelines/`](06-devops/azure-pipelines/README.md) | Three stages with real gating; watch a bad commit stopped at verify |
| ☐ | [`powershell-iac/`](06-devops/powershell-iac/README.md) | Parameterised script, `-WhatIf` plan, safe to run three times, `-Destroy` works |

---

## 🏁 Shelf gates

| ✅ | Shelf | Gate |
|---|---|---|
| ☐ | 01 · Foundations | Typed generic + Git recovery + `401` vs `403`, from memory |
| ☐ | 02 · Frontend | Protected route group, form → shared state → table, every file's server/client boundary justified |
| ☐ | 03 · Backend | Role-protected CRUD on a migrated database, documented, correct status for every failure |
| ☐ | 04 · Testing | For any bug, name the layer that should have caught it — and write that test first |
| ☐ | 05 · Quality | A repo that refuses your own bad commit; read a Sonar finding critically |
| ☐ | 06 · DevOps | Laptop → public URL → redeploy on merge → one-command teardown |

🎓 **All 23 cleared?** You can build, prove and ship a modern TypeScript stack. Write down what you would teach differently — that is the real sign you learned it.
