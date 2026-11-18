# 📘 Swagger / OpenAPI

**Time:** 2–3 h · **Needs:** [`../express/`](../express/README.md) cleared · **You finish with:** a browsable, try-it-out API reference at `/api-docs`, generated from your code.

> 🧠 **The one idea:** **OpenAPI** is the specification (a JSON/YAML description of your API). **Swagger** is the tooling around it. The specification is the valuable part — from it you get documentation, client SDKs, mock servers and contract tests, for free.

```
 your routes ──annotations──► OpenAPI document ──┬──► Swagger UI page (humans)
                                                  ├──► generated client SDKs
                                                  ├──► mock server for the frontend
                                                  └──► contract tests in CI
```

---

## 1. 📖 The lesson

| 🧩 Part of the spec | What it describes |
|---|---|
| `info` | Title, version, description |
| `servers` | Base URLs (local, staging, production) |
| `paths` | Every endpoint, by path and method |
| `parameters` | Path, query and header inputs |
| `requestBody` | What you accept, with a schema |
| `responses` | **Every** status code you return, each with a shape |
| `components.schemas` | Reusable models, referenced with `$ref` |
| `securitySchemes` | How auth works (`bearerAuth` for your JWTs) |

🎯 **The hallmark of a bad spec:** only `200` documented. The `400`, `401`, `403`, `404` and `422` are precisely what a consumer needs to handle, and precisely what gets left out.

### Two ways to keep a spec honest

| | 📝 Annotations in code (`swagger-jsdoc`) | 📄 Spec-first (write the YAML, generate types) |
|---|---|---|
| Drift | Lower — the docs sit beside the handler | Higher discipline, but the contract leads |
| Good for | Adding docs to an existing API | Designing before implementing; multiple teams |
| Risk | Comments can still lie | Implementation can still diverge |

🔒 **The only real defence against drift is a test.** Validate real responses against the schema in CI. A comment nobody runs is a wish, not documentation.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Continue your Express app | `cd ../express/drill` |
| ☐ | 2⃣ Install | `npm install swagger-ui-express@5.0.1 swagger-jsdoc@6.3.0` |
| ☐ | 3⃣ Build the five pieces | below |
| ☐ | 4⃣ Open it | <http://localhost:3001/api-docs> |
| ☐ | 5⃣ Use **Try it out** on every endpoint | if it fails there, your docs are wrong |

| # | Build | Teaches |
|---|---|---|
| 1 | `swagger.ts` with `info`, `servers` from env, and `bearerAuth` | Spec skeleton |
| 2 | A `TimeEntry` schema in `components.schemas` | Reuse via `$ref` |
| 3 | Annotations on GET and POST `/entries`, documenting **every** status | Honest responses |
| 4 | Serve it at `/api-docs`, and the raw JSON at `/api-docs.json` | Humans and machines |
| 5 | Mark protected routes with `security: [{ bearerAuth: [] }]` | Auth in the contract |

```ts
// Piece 1 — the spec skeleton
import swaggerJsdoc from 'swagger-jsdoc';

export const spec = swaggerJsdoc({
  definition: {
    openapi: '3.0.3',
    info: { title: 'Stack Dojo API', version: '1.0.0' },
    servers: [{ url: env.API_BASE_URL }],
    components: {
      securitySchemes: {
        bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
      },
      schemas: {
        TimeEntry: {
          type: 'object',
          required: ['id', 'hours', 'status'],
          properties: {
            id: { type: 'integer', example: 1 },
            hours: { type: 'number', format: 'double', example: 8 },
            status: { type: 'string', enum: ['DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED'] },
            note: { type: 'string', nullable: true },
          },
        },
      },
    },
  },
  apis: ['./src/routes/*.ts'],      // where the annotations below live
});
```

```ts
/**
 * @openapi
 * /entries:
 *   post:
 *     summary: Create a time entry
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [hours]
 *             properties:
 *               hours: { type: number, example: 8 }
 *               note:  { type: string, example: Sprint planning }
 *     responses:
 *       201: { description: Created, content: { application/json: { schema: { $ref: '#/components/schemas/TimeEntry' } } } }
 *       401: { description: Missing or invalid token }
 *       422: { description: Validation failed }
 */
router.post('/entries', requireAuth, createEntry);
```

```ts
// Piece 4 — serve both faces of the same document
import swaggerUi from 'swagger-ui-express';

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(spec));
app.get('/api-docs.json', (_req, res) => res.json(spec));   // for codegen and tests
```

🧪 **The drift test, in one line.** In the Supertest dojo, fetch `/api-docs.json`, then assert that every path in it answers *something* — and that a real `201` response matches the `TimeEntry` schema. Now your docs cannot quietly rot.

---

## 3. 🚪 The gate

> From an existing API: produce a valid OpenAPI 3 document that includes a reusable schema, a bearer security scheme, and **every** status code each endpoint can return — then drive every endpoint successfully from the Swagger UI "Try it out" button.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| Documenting only `200` | Document every code you can return |
| Repeating the same object inline | One `components.schemas` entry, referenced with `$ref` |
| Hard-coded `servers` URL | From `API_BASE_URL` |
| Annotations that drifted from the code | A CI test that validates responses against the spec |
| Exposing `/api-docs` publicly in production | Protect it, or publish it deliberately as a product decision |
| `example` values copied from real data | Invent them. Real data in docs is a leak |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| OpenAPI Specification | <https://swagger.io/specification/> |
| Basic structure (v3) | <https://swagger.io/docs/specification/v3_0/basic-structure/> |
| `swagger-jsdoc` | <https://github.com/Surnet/swagger-jsdoc> |
| `swagger-ui-express` | <https://github.com/scottie1984/swagger-ui-express> |

➡️ **Next shelf:** [`../../04-testing/`](../../04-testing/README.md)
