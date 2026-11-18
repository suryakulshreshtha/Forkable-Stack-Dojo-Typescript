# 🐳 Docker multi-stage builds

**Time:** 4–5 h · **Needs:** Docker Desktop · **You finish with:** an image a fraction of its naive size, running as a non-root user, with a health check.

> 🧠 **The one idea:** an image is a **stack of read-only layers**. Each instruction adds one. Layers are cached, and a changed layer invalidates every layer after it. Everything about writing a good Dockerfile follows from those two facts.

```
 ❌ single stage                        ✅ multi-stage
 ┌──────────────────────┐              ┌──────────────────────┐
 │ source + dev deps    │              │ STAGE 1 "builder"    │  ← compiles, then is DISCARDED
 │ build tools          │              │ source + dev deps    │
 │ compiled output      │              └──────────┬───────────┘
 │ node_modules (all)   │                         │ COPY only what runs
 └──────────────────────┘              ┌──────────▼───────────┐
      ~1.2 GB shipped                  │ STAGE 2 "runner"     │
                                        │ prod deps + output   │
                                        └──────────────────────┘
                                             ~180 MB shipped
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | The consequence |
|---|---|---|
| **Image** | A template | Immutable; you rebuild, never edit |
| **Container** | A running instance | Disposable. Anything written inside is lost |
| **Layer** | One instruction's result | Cached, and shared between images |
| **Layer cache** | Reuse of unchanged layers | **Order your Dockerfile from least to most frequently changed** |
| **Multi-stage** | Several `FROM`s; copy between them | Build tools never reach production |
| **`.dockerignore`** | What is excluded from the build context | Without it you upload `node_modules` and `.env` 🚨 |
| **Non-root `USER`** | Dropping privileges | A container escape starts from a weaker position |
| **`HEALTHCHECK`** | How the platform knows it is alive | Orchestrators restart unhealthy containers |

### 🎯 The caching rule, which is 90% of build speed

```dockerfile
# ❌ Every source edit re-runs npm ci (slow, every single time)
COPY . .
RUN npm ci

# ✅ Dependencies only reinstall when the manifests change
COPY package*.json ./
RUN npm ci
COPY . .
```

Source changes constantly; `package.json` rarely. Put the stable thing first and your rebuilds go from minutes to seconds.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Pick an app | your Express API from `03-backend/express/drill` |
| ☐ | 2⃣ Naive Dockerfile first | one stage, `COPY . .` |
| ☐ | 3⃣ Build and measure | `docker build -t dojo:naive . && docker images dojo` |
| ☐ | 4⃣ 📝 **Write the number down** | you will compare |
| ☐ | 5⃣ Now multi-stage | below |
| ☐ | 6⃣ Build and measure again | `docker build -t dojo:slim . && docker images dojo` |
| ☐ | 7⃣ Run it | `docker run --rm -p 3001:3001 --env-file .env dojo:slim` |
| ☐ | 8⃣ Look inside | `docker run --rm -it dojo:slim sh` then `whoami` |

```dockerfile
# syntax=docker/dockerfile:1

# ---------- STAGE 1: build ----------
FROM node:26-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci                       # dev deps included — we need them to compile

COPY . .
RUN npm run build                # produces dist/

# ---------- STAGE 2: run ----------
FROM node:26-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force   # production deps only

COPY --from=builder /app/dist ./dist              # 🎯 only the built output crosses over

# Run as a non-root user. node:alpine ships one called `node`.
USER node

EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3001/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "dist/server.js"]
```

```gitignore
# .dockerignore — as important as the Dockerfile itself
node_modules
.git
.env
.env.*
!.env.example
dist
coverage
playwright-report
*.md
```

🧪 **Measure, do not trust.** Compare `docker images dojo` for both tags. The difference is dev dependencies, build tools and source you were shipping for no reason. Then run `docker history dojo:slim` to see exactly which instruction cost what — this is how you find the 400 MB layer you did not expect.

🔐 **Why `USER node` matters:** by default a container runs as root. Root inside a container is not root on the host, but combined with a kernel or runtime flaw it is a far better starting point for an attacker than an unprivileged user. One line, meaningful risk reduction.

🍎 **Apple silicon warning:** images you build on an M-series Mac are `arm64`. Pushing one to an `amd64` cloud service gives you `exec format error`. Build with `--platform linux/amd64` when the target is x86.

---

## 3. 🚪 The gate

> From an empty Dockerfile: build a multi-stage image for a TypeScript service, measure the size difference against a single-stage build and explain it, run as non-root with a working health check, write a `.dockerignore` that keeps `.env` out of the build context — and explain, line by line, why your Dockerfile is in the order it is.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why it hurts | ✅ Instead |
|---|---|---|
| `COPY . .` before `npm ci` | Cache busted on every edit | Manifests first |
| No `.dockerignore` | `node_modules` and `.env` in the image | Write one first |
| Single stage | Build tools shipped to production | Multi-stage |
| Running as root | Weaker blast radius | `USER node` |
| `:latest` base image | Unreproducible builds | Pin the version |
| Secrets via `ENV` in the Dockerfile | Baked into the image and visible in `docker history` | Inject at runtime |
| No `HEALTHCHECK` | The platform cannot tell a hung app from a healthy one | Add one |
| Building `arm64` for an `amd64` target | `exec format error` | `--platform linux/amd64` |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Multi-stage builds | <https://docs.docker.com/build/building/multi-stage/> |
| Dockerfile reference | <https://docs.docker.com/reference/dockerfile/> |
| Build cache | <https://docs.docker.com/build/cache/> |
| Node.js in Docker (official guide) | <https://docs.docker.com/guides/nodejs/> |
| `.dockerignore` | <https://docs.docker.com/build/concepts/context/#dockerignore-files> |

➡️ **Next:** [`../azure-container-apps/`](../azure-container-apps/README.md)
