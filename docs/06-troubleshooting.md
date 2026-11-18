# 🧯 06 · Troubleshooting

**How to use this page:** search it for the *exact words* of your error (`⌘F` / `Ctrl+F`). Errors are grouped by where they come from.

> 🧒 **First, three things that fix a surprising share of problems:**
>
> 1. 🔄 **Open a new terminal.** PATH is read once per window ([`02-path-explained.md`](02-path-explained.md)).
> 2. 📁 **Check where you are.** `pwd` — most "file not found" errors are the wrong folder.
> 3. 👀 **Read the last line of the error, not the first.** The real message is usually at the bottom.

---

## 🧰 Node, npm and PATH

| ❌ Error | 🔍 Cause | 🛠 Fix |
|---|---|---|
| `command not found: node` | Not installed, or not on PATH | New terminal → [`02-path-explained.md`](02-path-explained.md) |
| `'npm' is not recognized...` | Same, Windows wording | New PowerShell → [`02-path-explained.md`](02-path-explained.md) |
| `EACCES: permission denied` | Global install into a system folder | Use a version manager. **Never** `sudo npm install -g` |
| `Unsupported engine` / `engine node not compatible` | Your Node is too old for the package | `node --version`, then `nvm use 26` / `fnm use 26` |
| `ERESOLVE unable to resolve dependency tree` | Two packages want different versions of a third | Read which two. Fix the version. `--force` hides it, it does not solve it |
| `Cannot find module 'x'` | Not installed, or you are in the wrong folder | `pwd`, then `npm install` |
| `Module not found: Can't resolve '@/components/x'` | Path alias not configured | Check `paths` in `tsconfig.json` |
| `node_modules` is huge / behaving oddly | Corrupted install | `rm -rf node_modules package-lock.json && npm install` (Windows: `Remove-Item -Recurse -Force node_modules, package-lock.json`) |
| Two lockfiles in one project | Someone mixed npm and yarn | Keep the one CI uses, delete the other, reinstall |

## 🎨 Next.js and React

| ❌ Error | 🔍 Cause | 🛠 Fix |
|---|---|---|
| `Error: EADDRINUSE: address already in use :::3000` | Something already owns port 3000 | `lsof -ti:3000 \| xargs kill -9` (macOS) · `Get-NetTCPConnection -LocalPort 3000` then `Stop-Process -Id <pid>` (Windows) |
| `You're importing a component that needs useState...` | A Client hook in a Server Component | Add `'use client'` as the file's first line |
| `Hydration failed because the initial UI does not match` | Server and client rendered different HTML | Usually `Date.now()`, `Math.random()` or `localStorage` during render |
| `process.env.X is undefined` in the browser | No `NEXT_PUBLIC_` prefix | [`03-env-files-and-secrets.md`](03-env-files-and-secrets.md) §6 |
| Env change has no effect | Next reads env at **start** | Stop the dev server and start it again |
| `Too many re-renders` | State set during render | Move it into an event handler or `useEffect` |

## ⚙️ Express, Prisma and the database

| ❌ Error | 🔍 Cause | 🛠 Fix |
|---|---|---|
| `Cannot connect to the Docker daemon` | Docker Desktop is not running | Open it, wait, then `docker ps` |
| SQL Server container exits instantly | Password rejected by SQL Server's complexity rules | 8+ chars, upper, lower, digit, symbol. `docker logs <name>` shows the real reason |
| `P1001: Can't reach database server` | Wrong host/port, or the container is not up | `docker ps`, then re-check `DATABASE_URL` |
| `P1000: Authentication failed` | Wrong user or password in `DATABASE_URL` | Re-copy it from your `.env` |
| `P3009: migrate found failed migrations` | A migration crashed halfway | Fix the SQL, then `npx prisma migrate resolve` |
| `PrismaClient is unable to run in the browser` | Imported Prisma into client-side code | Keep it server-side only |
| `Error: self signed certificate` | Local SQL Server TLS | Add `trustServerCertificate=true` **for local only** |
| `CORS policy: No 'Access-Control-Allow-Origin'` | API does not allow the frontend origin | Set `CORS_ORIGIN` to exactly `http://localhost:3000` |
| `jwt malformed` | Not a token (often `undefined` or `"Bearer "` left attached) | Log what you are verifying; strip the `Bearer ` prefix |
| `jwt expired` | Working as designed | Refresh it. Do **not** extend expiry to "fix" it |
| `invalid signature` | Verifying with a different secret than you signed with | One `JWT_SECRET`, loaded once |

## 🧪 Testing

| ❌ Error | 🔍 Cause | 🛠 Fix |
|---|---|---|
| `Cannot find module 'react'` in Jest | Wrong test environment | `testEnvironment: 'jsdom'` + `jest-environment-jsdom` |
| `ReferenceError: document is not defined` | Node environment for a DOM test | Same fix |
| `Jest did not exit one second after...` | An open handle (server, DB, timer) | Close it in `afterAll`. `--detectOpenHandles` names it |
| `Unable to find an element with the text` | Element not rendered yet, or split across nodes | `await screen.findByText(...)`; check with `screen.debug()` |
| Playwright: `browserType.launch: Executable doesn't exist` | Browsers not downloaded | `npx playwright install` |
| Playwright: `Timeout 30000ms exceeded` | Selector never matched, or the app is not running | Open the trace: `npx playwright show-trace` |
| Tests pass alone, fail together | Shared state between tests | Reset data per test; stop reusing one record |

## 🧹 Lint and hooks

| ❌ Error | 🔍 Cause | 🛠 Fix |
|---|---|---|
| `husky - command not found` | Hooks not installed after clone | `npm install`, then `npx husky init` |
| Commit blocked with 0 errors, 3 warnings | `--max-warnings=0` is deliberate | Fix the warnings. Do not raise the limit |
| ESLint: `Cannot read config file` | ESLint 9/10 flat config vs old `.eslintrc` | Use `eslint.config.js`. See [`../05-quality/eslint-husky/README.md`](../05-quality/eslint-husky/README.md) |
| Prettier and ESLint fight over formatting | Overlapping rules | Let Prettier own formatting; disable the stylistic ESLint rules |

## 🚢 Docker and Azure

| ❌ Error | 🔍 Cause | 🛠 Fix |
|---|---|---|
| Image is over 1 GB | Single-stage build, dev dependencies included | Multi-stage build + `.dockerignore` ([`../06-devops/docker-multistage/README.md`](../06-devops/docker-multistage/README.md)) |
| `exec /app/server: no such file or directory` | Built for the wrong CPU architecture | `docker build --platform linux/amd64` when pushing from Apple silicon to x86 |
| `unauthorized: authentication required` on push | Not logged in to the registry | `az acr login --name <acr>` |
| Container App shows nothing | App listening on the wrong port | It must listen on the port the ingress targets, on `0.0.0.0`, not `127.0.0.1` |
| Deploy succeeds, app 503s | Crashing on boot, usually a missing env var | Read the logs: `az containerapp logs show` |

---

## 🆘 Still stuck? Ask well

Anyone helping you needs these five things. Gathering them usually reveals the answer by itself.

| ✅ | Include |
|---|---|
| ☐ | The **exact** error text, copied, not retyped or summarised |
| ☐ | The command you ran, and the folder you ran it in (`pwd`) |
| ☐ | `node --version`, `npm --version`, your OS |
| ☐ | What you expected instead |
| ☐ | What you already tried |
