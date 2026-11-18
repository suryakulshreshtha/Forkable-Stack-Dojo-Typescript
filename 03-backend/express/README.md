# 🚂 Express

**Time:** 4–5 h · **Needs:** [`../../01-foundations/http-fundamentals/`](../../01-foundations/http-fundamentals/README.md) cleared · **You finish with:** a typed Express 5 API with a middleware chain, validated input and one error handler that catches everything.

> 🧠 **The one idea:** Express is a **queue of functions**, and each one gets `(req, res, next)`. It either answers the request or calls `next()` to pass it along. Routing is just the first function that decides to answer. That is the whole framework.

```
 request ──► [cors] ──► [json parser] ──► [auth] ──► [route handler] ──► response
                 │           │              │              │
                 └───────────┴──────────────┴──── throw ────┴──► [error handler] ──► response
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | The detail that matters |
|---|---|---|
| **Middleware** | `(req, res, next) => {}` | Order is everything. A parser registered *after* a route cannot help it |
| **Route handler** | Middleware that answers | Last stop for that path |
| **`next()`** | "I am done, carry on" | Forget it and the request hangs forever with no error |
| **`next(err)`** | "Something broke" | Skips straight to the error handler |
| **Error handler** | `(err, req, res, next) => {}` | **Four** arguments. Three and Express treats it as ordinary middleware |
| **Router** | A mountable group of routes | `app.use('/api/v1', router)` |
| **`res` ends the cycle** | `res.json()`, `res.send()`, `res.end()` | Calling two of them throws `ERR_HTTP_HEADERS_SENT` |

### 🆕 What Express 5 changed

| Change | Why you care |
|---|---|
| **Rejected promises are forwarded automatically** | An `async` handler that throws now reaches your error handler. In Express 4 it hung — which is why every tutorial had a `catchAsync` wrapper |
| Stricter path syntax | Some v4 wildcard routes need rewriting |
| `req.query` parsing changed | Check assumptions if you port v4 code |

```ts
// Express 5: this is now safe. In Express 4 it would hang forever.
app.get('/entries/:id', async (req, res) => {
  const entry = await db.find(req.params.id);   // if this rejects…
  if (!entry) throw new NotFoundError('entry');  // …or this throws…
  res.json(entry);
});                                              // …the error handler gets it. ✅
```

*(Express 5.3.0 read from the npm registry on 2026-11-18.)*

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Folder and project | `mkdir drill && cd drill && npm init -y` |
| ☐ | 2⃣ Dependencies | `npm install express@5.3.0 zod@4.6.7 dotenv` |
| ☐ | 3⃣ Dev dependencies | `npm install -D typescript@7.0.2 tsx@4.23.15 @types/express@5.0.6 @types/node` |
| ☐ | 4⃣ Env file | `cp .env.example .env` then fill it in |
| ☐ | 5⃣ Build the six pieces | below |
| ☐ | 6⃣ Run it | `npx tsx watch src/server.ts` |

| # | Build | Teaches |
|---|---|---|
| 1 | `src/env.ts` that validates the environment with Zod and **crashes at boot** if something is missing | Fail fast, not at 3am |
| 2 | A request-logger middleware printing method, path, status and duration | The middleware signature |
| 3 | A `/entries` router with GET, POST, PATCH, DELETE | Routers and correct status codes |
| 4 | Zod validation on POST, returning `422` with the field errors | Never trust a request body |
| 5 | An `AppError` class carrying a `statusCode` | Errors that know their own HTTP meaning |
| 6 | **One** four-argument error handler, registered **last** | Central error handling |

```ts
// Piece 1 — env.ts. Import this FIRST, before anything reads process.env.
import 'dotenv/config';
import { z } from 'zod';

const schema = z.object({
  PORT: z.coerce.number().default(3001),
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  CORS_ORIGIN: z.string().url(),
});

const parsed = schema.safeParse(process.env);
if (!parsed.success) {
  console.error('❌ Invalid environment:', z.treeifyError(parsed.error));
  process.exit(1);          // crash NOW, with a readable reason
}
export const env = parsed.data;
```

```ts
// Pieces 5 + 6 — errors that know their status, and the one handler that formats them
export class AppError extends Error {
  constructor(message: string, public statusCode = 500, public code?: string) {
    super(message);
  }
}

// ⚠️ FOUR arguments. Registered AFTER every route. Both or it silently never runs.
app.use((err: unknown, req: Request, res: Response, _next: NextFunction) => {
  const isKnown = err instanceof AppError;
  const status = isKnown ? err.statusCode : 500;

  if (!isKnown) console.error(err);     // unexpected: log the whole thing

  res.status(status).json({
    error: isKnown ? err.message : 'Internal server error',   // never leak internals
    ...(env.NODE_ENV === 'development' && !isKnown
      ? { stack: (err as Error).stack }
      : {}),
  });
});
```

🧪 **Prove the ordering rule:** move `app.use(express.json())` to *after* your routes. POST a body. `req.body` is `undefined`. Move it back. Fixed. You have just learned the single most common Express bug by causing it on purpose.

---

## 3. 🚪 The gate

> From an empty folder: a typed Express 5 API that validates its environment at boot, logs every request, validates bodies with Zod returning `422`, and funnels every error — thrown, rejected, or passed to `next()` — through exactly one four-argument error handler that never leaks a stack trace in production.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Symptom | ✅ Fix |
|---|---|---|
| Error handler with 3 arguments | Errors fall through; the request hangs | Four arguments, always |
| Error handler registered first | It never runs | Register it **last** |
| `express.json()` after the routes | `req.body` is `undefined` | Register parsers before routes |
| Forgetting `next()` | The request hangs with no error | Answer, or call `next()` |
| `res.json()` twice | `ERR_HTTP_HEADERS_SENT` | `return res.json(...)` |
| Returning the raw error to the client | Leaks stack traces and SQL | Generic message for `5xx`, detail only in dev |
| Trusting `req.body` | Crashes, or worse | Validate every input |
| `app.use(cors())` with no options | Any origin can call your API | Set an explicit origin |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Express 5 API reference | <https://expressjs.com/en/5x/api.html> |
| Migrating 4 → 5 | <https://expressjs.com/en/guide/migrating-5.html> |
| Error handling | <https://expressjs.com/en/guide/error-handling.html> |
| Production best practice (security) | <https://expressjs.com/en/advanced/best-practice-security.html> |
| Zod | <https://zod.dev> |

➡️ **Next:** [`../prisma-azuresql/`](../prisma-azuresql/README.md)
