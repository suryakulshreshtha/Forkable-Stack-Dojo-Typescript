# 📌 Versions

Every version in this repository was read from a **primary source** on **2026-11-18**, not from memory and not from a blog post. The method for each is below, so you can re-run it yourself.

> 🔁 **Re-check before you trust.** These numbers age. Run the commands in §1 again, or `npm outdated` inside any dojo you have installed.

---

## 1. 🔬 Method

| What | How it was read | When |
|---|---|---|
| npm package versions | `npm view <package> version` against the public npm registry | 2026-11-18 |
| npm deprecation notices | `npm view <package> deprecated` | 2026-11-18 |
| Prisma release tags | `npm view prisma dist-tags` | 2026-11-18 |
| Node.js LTS status | `schedule.json` from the Node.js Release working group (<https://github.com/nodejs/Release>), compared against today's date | 2026-11-18 |
| Recoil archive status | The repository's own archive notice, plus `npm view recoil time.modified` | 2026-11-18 |

```bash
# Reproduce the package table yourself
for p in next react typescript express @prisma/client @playwright/test tailwindcss jotai; do
  echo "$p $(npm view "$p" version)"
done
```

---

## 2. 🧱 Language and runtime

| Item | Version | Notes |
|---|---|---|
| **Node.js** | **26** | **Active LTS since 2026-10-28.** Maintenance begins 2027-10-20; end-of-life 2029-04-30. Pinned in [`.nvmrc`](.nvmrc) |
| Node.js 24 | — | In **Maintenance** since 2026-10-20 (EOL 2028-04-30). Fine for existing projects, not the default here |
| Node.js 22 | — | In **Maintenance** since 2025-10-21 (EOL 2027-04-30). Note: a stack requiring "Node ≥ 22" is now on a maintenance line |
| **TypeScript** | **7.0.2** | First stable release with the **Go-based native compiler** (stable since July 2026); roughly 8–12× faster type-checking. ⚠️ Compiler *transformer plugins* are incompatible, and the stable programmatic API is not in 7.0 |
| TypeScript 6.x | — | The last JavaScript-based compiler. The bridge release if you depend on transformer plugins |

---

## 3. 📦 npm packages

Read with `npm view <package> version` on 2026-11-18.

### Frontend

| Package | Version |
|---|---|
| `next` | 16.4.6 *(declares `engines: node >=20.9.0`)* |
| `react` | 19.3.1 |
| `react-dom` | 19.3.1 |
| `tailwindcss` | 4.3.5 |
| `shadcn` (CLI) | 4.23.0 |
| `@radix-ui/react-dialog` | 1.3.1 |
| `jotai` | 3.0.2 |
| `recoil` | 0.7.7 ⚠️ **archived — see §5** |
| `zustand` | 5.1.0 *(listed for comparison only)* |

### Backend

| Package | Version |
|---|---|
| `express` | 5.3.0 |
| `@prisma/client` | 7.10.1 |
| `prisma` (CLI) | 7.10.1 ⚠️ **pin this — see §4** |
| `mssql` | 12.7.14 |
| `jsonwebtoken` | 9.0.3 |
| `passport` | 0.7.0 |
| `@azure/msal-node` | 7.2.2 |
| `passport-azure-ad` | — ⚠️ **deprecated — see §5** |
| `swagger-ui-express` | 5.0.1 |
| `swagger-jsdoc` | 6.3.0 |
| `zod` | 4.6.7 |

### Testing and quality

| Package | Version |
|---|---|
| `jest` | 30.5.2 |
| `jest-environment-jsdom` | 30.5.2 |
| `ts-jest` | 29.4.15 |
| `@testing-library/react` | 16.3.3 |
| `supertest` | 7.3.2 |
| `@playwright/test` | 1.65.1 |
| `vitest` | 5.1.1 *(alternative to Jest; not used in the drills)* |
| `eslint` | 10.15.0 |
| `@eslint/js` | 10.0.1 |
| `typescript-eslint` | 8.73.0 |
| `prettier` | 3.10.1 |
| `husky` | 9.1.7 |
| `lint-staged` | 17.6.1 |

### Types and tooling

| Package | Version |
|---|---|
| `@types/node` | 26.6.6 |
| `@types/express` | 5.0.6 |
| `@types/jsonwebtoken` | 9.0.10 |
| `@types/supertest` | 7.2.1 |
| `tsx` | 4.23.15 |
| `cross-env` | 10.1.0 |
| `concurrently` | 10.0.7 |

---

## 4. ⚠️ Pin Prisma deliberately

On 2026-11-18, `npm view prisma dist-tags` showed a **pre-release on the `next` tag** (`8.0.0-rc.10`), with `7.10.1` as the preceding stable. A bare `npm install prisma` can therefore pull a release candidate depending on which tag the registry resolves.

✅ **Every drill in this repo pins explicitly:**

```bash
npm install @prisma/client@7.10.1
npm install -D prisma@7.10.1
```

---

## 5. 🪦 Deprecations and archives — verified, not assumed

### Recoil — archived

| Fact | Source |
|---|---|
| The GitHub repository `facebookexperimental/Recoil` was **archived by its owner on 2025-01-01** and is read-only | The repository's own archive notice |
| Last npm publish: **2024-02-12** | `npm view recoil time.modified` |
| Latest version: **0.7.7** | `npm view recoil version` |

➡️ **What this repo does:** [`02-frontend/state-management/`](02-frontend/state-management/README.md) teaches the atomic model with **Jotai 3.0.2**, and shows Recoil's API only so you can read and migrate existing code. Community forks of Recoil exist; this repo does not teach them, because a fork's maintenance is its maintainers' promise, not a verified fact.

### `passport-azure-ad` — deprecated

| Fact | Source |
|---|---|
| npm reports the package as **deprecated and no longer supported**, directing users to Microsoft's replacement guidance | `npm view passport-azure-ad deprecated` |

➡️ **What this repo does:** [`03-backend/sso-entra-msal/`](03-backend/sso-entra-msal/README.md) uses **`@azure/msal-node` 7.2.2**. Passport is still taught, but only for the local username/password strategy.

### Ant Design — a choice, not a deprecation

Ant Design is actively maintained. This repo teaches **shadcn/ui + Radix** instead as a deliberate stack decision (own the component source rather than depend on a library). Stated plainly so nobody mistakes a preference for a warning.

---

## 6. 🔍 What is *not* version-verified here

Honesty requires naming the gaps.

| Item | Status |
|---|---|
| Docker Desktop, Azure CLI, PowerShell exact versions | Not pinned. Each dojo links the official install page instead — these move independently of this repo |
| SonarQube edition version numbers | Not pinned; product names have changed over the years, so the dojo links current docs rather than quoting a version |
| Azure service behaviour, quotas, free-tier terms | Not quoted as numbers anywhere in this repo. Azure changes these; read the linked Microsoft page |
| Docker Desktop licence thresholds | Deliberately not quoted. The dojo points at Docker's own licence page |
| MSAL Node exact option names in the sample code | Shape is from MSAL Node 7.2.2's documented API; the dojo says to confirm against the official docs before production use |
| `winget` package IDs | Shown with a `winget search` fallback, because IDs are not guaranteed stable |
