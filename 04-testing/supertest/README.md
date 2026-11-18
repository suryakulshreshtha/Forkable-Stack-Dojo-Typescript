# 🔌 Supertest

**Time:** 2–3 h · **Needs:** Jest + the Express dojo · **You finish with:** integration tests that make real HTTP requests to your app without starting a server or opening a port.

> 🧠 **The one idea:** Supertest boots your Express app **in-process**, on an ephemeral port, for the duration of one test. Real routing, real middleware, real JSON — no `localhost:3001`, no port conflicts, no server to remember to kill.

```
 your test ──► supertest(app) ──► real middleware chain ──► real handler ──► real response
                     └── no manual listen(), no fixed port, torn down automatically
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is |
|---|---|
| `request(app)` | Wrap the Express app — **export `app` separately from `server.listen()`** |
| `.get()` / `.post()` | The HTTP verb |
| `.send(body)` | JSON request body |
| `.set(header, value)` | Headers, e.g. `Authorization` |
| `.expect(status)` | Assert the status code |
| `response.body` | The parsed JSON, for Jest assertions |

### 🔑 The one refactor that makes this possible

```ts
// ❌ app.ts that calls listen() — Supertest cannot import this without starting a server
const app = express();
app.listen(3001);

// ✅ split them
// app.ts
export const app = express();
// …routes…

// server.ts  ← the only file that listens. Tests import app.ts, never this.
import { app } from './app';
app.listen(env.PORT);
```

### What belongs at this layer

| ✅ Test here | ❌ Not here |
|---|---|
| Status codes for every path | Pure business logic (a unit test is faster) |
| The exact JSON response shape | Browser rendering (Playwright) |
| Auth and role enforcement | CSS and layout |
| Validation errors (`422` + field names) | Third-party APIs (mock those) |
| Database writes actually persisting | — |

🎯 **This is the highest-value layer per minute spent.** It catches the bugs that actually reach users — wrong status code, leaked field, missing role check — in milliseconds, with no browser.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install | `npm install -D supertest@7.3.2 @types/supertest@7.2.1` |
| ☐ | 2⃣ Split `app.ts` from `server.ts` | above |
| ☐ | 3⃣ Write the six tests below | — |
| ☐ | 4⃣ Run | `npm test` |

| # | Test | Asserts |
|---|---|---|
| 1 | `GET /entries` with no token | `401` |
| 2 | `GET /entries` with a valid token | `200` + an array |
| 3 | `POST /entries` with a valid body | `201` + the created object |
| 4 | `POST /entries` with `hours: "eight"` | `422` + which field failed |
| 5 | `PATCH /entries/:id/approve` as STAFF | `403` |
| 6 | `PATCH /entries/:id/approve` as MANAGER | `200` + the new status |

```ts
import request from 'supertest';
import { app } from '../src/app';

const staff = signTestToken({ sub: '1', role: 'STAFF' });
const manager = signTestToken({ sub: '2', role: 'MANAGER' });

describe('POST /entries', () => {
  it('creates an entry and returns 201', async () => {
    const res = await request(app)
      .post('/entries')
      .set('Authorization', `Bearer ${staff}`)
      .send({ hours: 8, note: 'Sprint planning' })
      .expect(201);

    expect(res.body).toMatchObject({ hours: 8, status: 'DRAFT' });
    expect(res.body.id).toBeDefined();
  });

  it('rejects a non-numeric hours with 422 naming the field', async () => {
    const res = await request(app)
      .post('/entries')
      .set('Authorization', `Bearer ${staff}`)
      .send({ hours: 'eight' })
      .expect(422);

    expect(JSON.stringify(res.body)).toContain('hours');   // the client needs to know WHICH field
  });
});

describe('role enforcement', () => {
  it('forbids STAFF from approving (403, not 401)', () =>
    request(app)
      .patch('/entries/1/approve')
      .set('Authorization', `Bearer ${staff}`)
      .expect(403));

  it('allows MANAGER to approve', () =>
    request(app)
      .patch('/entries/1/approve')
      .set('Authorization', `Bearer ${manager}`)
      .expect(200));
});
```

🧪 **Prove it tests the real chain:** comment out `requireRole` on the approve route. Test 5 fails immediately — a privilege-escalation bug caught in under a second, by a test with no browser and no server. Put it back.

🧹 **Leaking handles.** If Jest prints *"did not exit one second after the test run"*, something is still open — usually a database connection. Close it:

```ts
afterAll(async () => { await prisma.$disconnect(); });
```

---

## 3. 🚪 The gate

> From an existing Express app: split `app` from `server`, then write integration tests proving the correct status code for unauthenticated, unauthorised, invalid-body and happy-path requests — with no server started by hand and no open handles at the end.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| `app.listen()` in the file you import | Split `app.ts` / `server.ts` |
| Leaving DB connections open | `afterAll` disconnect |
| Tests depending on each other's data | Seed and reset per test |
| Asserting only the status | Assert the body shape too |
| Mocking the database here | Use a real test database — that is the point of this layer |
| Hard-coded ids that exist only on your machine | Create the record in the test |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Supertest | <https://github.com/ladjs/supertest> |
| Express testing guidance | <https://expressjs.com/en/guide/migrating-5.html> |
| Jest setup and teardown | <https://jestjs.io/docs/setup-teardown> |

➡️ **Next:** [`../playwright/`](../playwright/README.md)
