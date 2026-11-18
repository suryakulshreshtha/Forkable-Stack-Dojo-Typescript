# 🔐 03 · Env files and secrets — every single one

**Read this when:** any dojo says "create a `.env`". Every variable this repo ever asks for is listed here, with what it does and a safe example.

> 🧒 **Starting from zero.** You do not need to know what an environment variable is. §1 explains it with a hotel key card.

---

## 📑 Contents

| # | Section |
|---|---|
| 1 | [🏨 What an environment variable is](#1--what-an-environment-variable-is) |
| 2 | [📄 `.env` vs `.env.example` — the two-file rule](#2--env-vs-envexample--the-two-file-rule) |
| 3 | [🛠 Creating a `.env`, step by step](#3--creating-a-env-step-by-step) |
| 4 | [🎲 Generating a real secret](#4--generating-a-real-secret) |
| 5 | [📋 THE MASTER LIST — every variable in this repo](#5--the-master-list--every-variable-in-this-repo) |
| 6 | [🌐 The `NEXT_PUBLIC_` trap](#6--the-next_public_-trap) |
| 7 | [🔌 How the variable actually reaches your code](#7--how-the-variable-actually-reaches-your-code) |
| 8 | [🚨 You committed a secret. Now what?](#8--you-committed-a-secret-now-what) |
| 9 | [📚 Official sources](#9--official-sources) |

---

## 1. 🏨 What an environment variable is

A hotel gives you a key card. The card is not printed on the door, and it is not part of the building — it is handed to you **when you arrive**, and it works for your stay only.

Your app is the building. A secret is the key card.

| 🏨 Hotel | 💻 Your app |
|---|---|
| The building | Your code, which goes in Git |
| The key card | A password, token or connection string |
| Printing the code on the door | ❌ Hard-coding a secret in your source file |
| Handing you a card at check-in | ✅ Passing it in through an environment variable |
| Re-cutting the card for the next guest | ✅ Different values for dev, test and production — same code |

🔑 **The whole point:** the *same code* runs on your laptop, in CI and in production, and only the values change. That is why you never type a password into a `.ts` file.

---

## 2. 📄 `.env` vs `.env.example` — the two-file rule

Every dojo that needs configuration has **two** files, and the difference matters enormously.

| 📄 File | Contains | In Git? | Who makes it |
|---|---|---|---|
| **`.env.example`** | Variable **names** + fake placeholder values | ✅ **Yes**, committed | The repo ships it |
| **`.env`** | The same names + your **real** values | ❌ **Never**, ignored | **You**, locally |

```
 .env.example  (in Git, safe to read)        .env  (never in Git, real values)
 ┌────────────────────────────────┐          ┌────────────────────────────────┐
 │ JWT_SECRET=replace-me          │   copy   │ JWT_SECRET=8f3c9a1e7b2d4f6...  │
 │ DATABASE_URL=sqlserver://...   │  ──────► │ DATABASE_URL=sqlserver://lo... │
 │ PORT=3001                      │          │ PORT=3001                      │
 └────────────────────────────────┘          └────────────────────────────────┘
```

✅ This repo's [`.gitignore`](../.gitignore) already ignores `.env` and explicitly **un-ignores** `.env.example`. You do not need to configure anything — just never rename one into the other.

---

## 3. 🛠 Creating a `.env`, step by step

Say a dojo tells you to set up `03-backend/jwt-auth/.env`.

| ✅ | Step | 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|---|---|
| ☐ | 1⃣ Go to the dojo | `cd 03-backend/jwt-auth` | `cd 03-backend\jwt-auth` |
| ☐ | 2⃣ Copy the template | `cp .env.example .env` | `Copy-Item .env.example .env` |
| ☐ | 3⃣ Open it | `code .env` | `code .env` |
| ☐ | 4⃣ Replace every placeholder | *(edit in your editor and save)* | *(edit in your editor and save)* |
| ☐ | 5⃣ Prove Git is ignoring it | `git check-ignore -v .env` | `git check-ignore -v .env` |
| ☐ | 6⃣ Prove it again, visually | `git status` | `git status` |

**Step 5 expected output** — a line naming the `.gitignore` rule that caught it:

```
../../.gitignore:12:.env    .env
```

🚨 **If step 5 prints nothing, stop.** Nothing printed means the file is **not** ignored and your next `git add .` will commit your secrets. Do not continue until it prints a rule.

### ✍️ Writing rules inside a `.env`

| ✅ Do | ❌ Don't | 🤔 Why |
|---|---|---|
| `PORT=3001` | `PORT = 3001` | Spaces around `=` become part of the name or value |
| `JWT_SECRET=abc123` | `JWT_SECRET="abc123"` | Quotes are usually kept as part of the value |
| `NAME=Surya Kulshreshtha` | — | Spaces *inside* a value are fine, no quotes needed |
| `# a comment` | `PORT=3001 # the port` | A trailing comment can end up inside the value |
| One variable per line | Two on one line | The file is parsed line by line |
| End the file with a newline | — | Some parsers drop the last line without one |

---

## 4. 🎲 Generating a real secret

A secret must be **long and random**. `password123` is not a secret, and neither is your dog's name.

| 🎯 What | 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|---|
| 32 random bytes, hex | `openssl rand -hex 32` | `-join ((1..64) \| ForEach-Object { '{0:x}' -f (Get-Random -Max 16) })` |
| 32 random bytes, base64 | `openssl rand -base64 32` | `[Convert]::ToBase64String((1..32 \| ForEach-Object { Get-Random -Max 256 }))` |
| Works anywhere Node is installed | `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"` | `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"` |

💡 **Use the Node one-liner if in doubt** — it is identical on both operating systems, and you already have Node.

| 🔐 Rule | Why |
|---|---|
| A different secret per environment (dev / test / prod) | A leaked dev secret must not open production |
| Never reuse a secret between two projects | One breach becomes two |
| Rotate if it was ever pasted into chat, a ticket, a screenshot or a commit | Assume anything that left your machine is public |
| Minimum 32 bytes for signing keys | Short keys are brute-forceable |

---

## 5. 📋 THE MASTER LIST — every variable in this repo

Every variable any dojo in this repo asks for. 🔴 = a real secret, never commit, never log. 🟢 = safe to see.

### ⚙️ `03-backend/express/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `PORT` | 🟢 | `3001` | Which port the API listens on. Pick something other than 3000 so the frontend can have it |
| `NODE_ENV` | 🟢 | `development` | `development`, `test` or `production`. Changes error verbosity and library behaviour |
| `CORS_ORIGIN` | 🟢 | `http://localhost:3000` | Which browser origin may call this API. Never `*` once you use cookies |

### 🗄 `03-backend/prisma-azuresql/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `DATABASE_URL` | 🔴 | `sqlserver://localhost:1433;database=dojo;user=sa;password=YOUR_PASSWORD;encrypt=true;trustServerCertificate=true` | The one string Prisma uses to connect. Contains a password, so it is a secret |
| `MSSQL_SA_PASSWORD` | 🔴 | `Str0ng!Passw0rd` | The password for the local SQL Server container. Must satisfy SQL Server's complexity rules or the container exits immediately |
| `DB_SERVER` | 🟢 | `localhost` | Used by the raw `mssql` driver exercise, not by Prisma |
| `DB_PORT` | 🟢 | `1433` | SQL Server's default port |
| `DB_DATABASE` | 🟢 | `dojo` | Database name |
| `DB_USER` | 🟢 | `sa` | Local container only. In Azure, use a least-privilege user, never `sa` |
| `DB_PASSWORD` | 🔴 | `Str0ng!Passw0rd` | Same value as `MSSQL_SA_PASSWORD` locally |

> 🧠 **`trustServerCertificate=true` is for your laptop only.** It tells the driver "do not verify the TLS certificate". Against Azure SQL you remove it and keep `encrypt=true`, or you have encryption without authentication — which is not encryption you can trust.

### 🎫 `03-backend/jwt-auth/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `JWT_SECRET` | 🔴 | *(from §4)* | Signs and verifies access tokens. Anyone with this can mint a token as any user |
| `JWT_EXPIRES_IN` | 🟢 | `15m` | Access-token lifetime. Short on purpose |
| `JWT_REFRESH_SECRET` | 🔴 | *(a different §4 value)* | Signs refresh tokens. **Must differ** from `JWT_SECRET` |
| `JWT_REFRESH_EXPIRES_IN` | 🟢 | `7d` | Refresh-token lifetime |

### 🏢 `03-backend/sso-entra-msal/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `AZURE_TENANT_ID` | 🟢 | `00000000-0000-0000-0000-000000000000` | Which Entra ID directory to sign users into |
| `AZURE_CLIENT_ID` | 🟢 | `11111111-1111-1111-1111-111111111111` | Your app registration's ID. Public by design |
| `AZURE_CLIENT_SECRET` | 🔴 | *(from the Azure portal)* | Proves your server *is* that app. Expires — note the date when you create it |
| `AZURE_REDIRECT_URI` | 🟢 | `http://localhost:3001/auth/callback` | Where Entra sends the user back. Must match the app registration **exactly**, including the trailing slash |
| `AZURE_CLOUD_INSTANCE` | 🟢 | `https://login.microsoftonline.com/` | The identity endpoint. Differs in sovereign clouds |
| `SESSION_SECRET` | 🔴 | *(from §4)* | Signs the session cookie that holds the sign-in state |

### 📘 `03-backend/swagger-openapi/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `API_BASE_URL` | 🟢 | `http://localhost:3001` | The `servers` entry written into the generated OpenAPI document |

### 🎨 `02-frontend/nextjs-app-router/.env.local`

> ⚠️ Next.js uses **`.env.local`**, not `.env`, for your machine's values. Read §6 before you put anything in here.

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `NEXT_PUBLIC_API_URL` | 🟢 | `http://localhost:3001` | The API address the **browser** calls. Visible to anyone — see §6 |
| `NEXT_PUBLIC_APP_NAME` | 🟢 | `Stack Dojo` | Display name, baked into the bundle |
| `API_INTERNAL_URL` | 🟢 | `http://localhost:3001` | Server-side only address. No `NEXT_PUBLIC_`, so it never reaches the browser |
| `AUTH_COOKIE_NAME` | 🟢 | `dojo_session` | Cookie name the middleware looks for |

### 🎭 `04-testing/playwright/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `BASE_URL` | 🟢 | `http://localhost:3000` | What `page.goto('/')` resolves against |
| `CI` | 🟢 | *(unset locally)* | When set, Playwright retries and runs headless. CI providers set this for you |
| `TEST_USER_EMAIL` | 🟢 | `test@example.com` | A seeded test account. Never a real person's login |
| `TEST_USER_PASSWORD` | 🔴 | *(a throwaway value)* | Test-only password. Still a secret, because test accounts get abused |

### 🧹 `05-quality/sonarqube/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `SONAR_HOST_URL` | 🟢 | `http://localhost:9000` | Your SonarQube server |
| `SONAR_TOKEN` | 🔴 | *(generated in SonarQube)* | Lets the scanner upload results as you. Treat it like a password |
| `SONAR_PROJECT_KEY` | 🟢 | `stack-dojo` | Which project the results belong to |

### 🚢 `06-devops/*/.env`

| Variable | 🔒 | Example | What it does |
|---|---|---|---|
| `AZURE_SUBSCRIPTION_ID` | 🟢 | `22222222-2222-2222-2222-222222222222` | Which subscription gets billed |
| `AZURE_RESOURCE_GROUP` | 🟢 | `rg-stack-dojo` | The folder your Azure resources live in. Deleting it deletes them all |
| `AZURE_LOCATION` | 🟢 | `centralindia` | Which region. Affects price and latency |
| `ACR_NAME` | 🟢 | `acrstackdojo` | Your container registry name. Globally unique, letters and numbers only |
| `ACR_PASSWORD` | 🔴 | *(from the registry)* | Pushes images as you. Prefer a managed identity in real projects |
| `CONTAINER_APP_NAME` | 🟢 | `ca-stack-dojo` | The Container App to deploy to |
| `IMAGE_TAG` | 🟢 | `v1` or a commit SHA | Which image version to run. Avoid `latest` — it makes rollbacks guesswork |

🧾 **Count:** 9 dojos need configuration; **39 variables**, of which **10 are real secrets** 🔴.

---

## 6. 🌐 The `NEXT_PUBLIC_` trap

This single rule prevents the most common leak in Next.js projects.

| Prefix | Where it ends up | Safe for secrets? |
|---|---|---|
| `NEXT_PUBLIC_SOMETHING` | **Baked into the JavaScript the browser downloads** | 🚫 **Never** |
| `SOMETHING` (no prefix) | Stays on the server | ✅ Yes |

```
  NEXT_PUBLIC_API_URL=http://localhost:3001   →  🌍 shipped to every visitor's browser
  DATABASE_URL=sqlserver://...                →  🔒 server only, never sent
```

🧨 **What going wrong looks like:** you add `NEXT_PUBLIC_DATABASE_URL` because something could not see it, deploy, and your database password is now inside a file any visitor can download and read. There is no un-deploying that — the credential must be rotated.

🧪 **Prove it to yourself** (a drill in the Next.js dojo): put a dummy `NEXT_PUBLIC_CANARY=hello-world` in `.env.local`, build, then search the build output for `hello-world`. You will find it. Search for a non-prefixed variable's value. You will not.

---

## 7. 🔌 How the variable actually reaches your code

Different tools load `.env` files differently. This is the part tutorials skip, and then "the variable is undefined".

| 🧰 Tool | Loads automatically? | File it reads | How you read it |
|---|---|---|---|
| **Next.js** | ✅ Yes, built in | `.env.local`, then `.env.development`, then `.env` | `process.env.NEXT_PUBLIC_API_URL` |
| **Node 26** | ✅ Yes, with a flag | whatever you pass | `node --env-file=.env server.js` |
| **Express + dotenv** | ❌ No | `.env` | `import 'dotenv/config'` as the **very first** import |
| **Prisma CLI** | ✅ Yes | `.env` beside `schema.prisma` | `env("DATABASE_URL")` inside the schema |
| **Jest** | ❌ No | — | load it in a setup file listed in `setupFiles` |
| **Playwright** | ❌ No | — | load it at the top of `playwright.config.ts` |
| **Docker** | ❌ No | — | `docker run --env-file .env ...` |
| **Azure Pipelines** | ❌ No | — | pipeline variables and variable groups, never a committed file |

🪜 **Load order matters.** With dotenv, `import 'dotenv/config'` must run **before** any module that reads `process.env` at import time. Put it on line 1. A config file that reads `process.env.JWT_SECRET` on line 3 of another module will otherwise see `undefined`, and you will blame the wrong file for an hour.

### ✅ Fail fast instead of guessing

A missing variable should crash at startup with a clear message, not fail mysteriously at 3am:

```ts
const required = ['JWT_SECRET', 'DATABASE_URL'] as const;

for (const key of required) {
  if (!process.env[key]) {
    throw new Error(`Missing required environment variable: ${key}`);
  }
}
```

🧠 The `jwt-auth` dojo has you write this, and the `express` dojo has you reach for **Zod** to validate the whole environment at boot.

---

## 8. 🚨 You committed a secret. Now what?

It happens. Speed matters more than embarrassment.

| ⏱ Order | ✅ Do this | 🤔 Why |
|---|---|---|
| **1st** | **Rotate the secret.** Generate a new one, change it in the service that issued it | The old value is compromised the moment it is pushed. Treat it as public, immediately |
| **2nd** | Remove it from the working tree and commit that | Stops it spreading further |
| **3rd** | Make sure `.gitignore` covers it: `git check-ignore -v .env` | Stops the repeat |
| **4th** | *Only then* consider rewriting history | Optional, and it does **not** un-leak anything |

🛑 **The mistake to avoid:** spending an hour rewriting Git history and never rotating the credential. Forks, clones, CI caches and GitHub's own cached views may still hold the old commit. **Rotation is the fix. History rewriting is housekeeping.**

| 🧰 If you must rewrite | Where |
|---|---|
| GitHub's own guidance on removing sensitive data | <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository> |

---

## 9. 📚 Official sources

| Topic | Where |
|---|---|
| Next.js environment variables and `NEXT_PUBLIC_` | <https://nextjs.org/docs/app/guides/environment-variables> |
| Node's built-in `--env-file` | <https://nodejs.org/api/cli.html> |
| Prisma connection strings (SQL Server) | <https://www.prisma.io/docs/orm/overview/databases/sql-server> |
| Microsoft Entra ID app registration | <https://learn.microsoft.com/en-us/entra/identity-platform/> |
| Azure SQL connection and encryption | <https://learn.microsoft.com/en-us/azure/azure-sql/> |
| Removing sensitive data from a repository | <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository> |
