# 🌐 HTTP fundamentals

**Time:** 2 h · **Needs:** Node 26 · **You finish with:** a working HTTP server written with Node's built-in `http` module — no Express, no dependencies.

> 🧠 **The one idea:** HTTP is **text, and it is stateless**. The server forgets you the instant it replies. Every session, cookie, token and login exists only to re-answer "who are you?" on every single request.

```
 ┌────────┐   request: method + path + headers + body    ┌────────┐
 │ client │ ──────────────────────────────────────────►  │ server │
 │        │ ◄──────────────────────────────────────────  │        │
 └────────┘   response: status + headers + body          └────────┘
                 …then the server forgets you entirely
```

---

## 1. 📖 The lesson

### Methods — the verb

| Method | Means | Safe? | Idempotent? | Typical status |
|---|---|---|---|---|
| `GET` | Read | ✅ changes nothing | ✅ | `200` |
| `POST` | Create / act | ❌ | ❌ twice = two records | `201` |
| `PUT` | Replace whole | ❌ | ✅ twice = same result | `200` |
| `PATCH` | Change part | ❌ | ❌ usually not | `200` |
| `DELETE` | Remove | ❌ | ✅ gone is gone | `204` |

🧠 **Idempotent** = calling it twice leaves the world as it was after once. It is why a browser will happily retry a `GET` and must never silently retry a `POST`.

### Status codes — the answer shape

| Family | Meaning | The ones you will actually use |
|---|---|---|
| **2xx** ✅ | It worked | `200` OK · `201` Created · `204` No Content |
| **3xx** ↪️ | Look elsewhere | `301` moved for good · `302` moved for now · `304` not modified |
| **4xx** 🙋 | **You** got it wrong | `400` malformed · `401` not authenticated · `403` authenticated but not allowed · `404` not here · `409` conflict · `422` validation failed · `429` too many requests |
| **5xx** 💥 | **The server** got it wrong | `500` unhandled · `502` bad upstream · `503` unavailable · `504` upstream timeout |

🎯 **`401` vs `403` — asked in every interview:**

| | `401 Unauthorized` | `403 Forbidden` |
|---|---|---|
| Means | "I do not know who you are" | "I know who you are. No." |
| Caused by | Missing or expired token | Valid token, insufficient role |
| Client should | Log in / refresh the token | Stop asking. Retrying changes nothing |

### Headers — the metadata

| Header | Direction | What it does |
|---|---|---|
| `Content-Type` | both | What the body *is* (`application/json`) |
| `Authorization` | request | `Bearer <token>` — how JWTs travel |
| `Accept` | request | What the client can understand |
| `Set-Cookie` | response | Server asks the browser to remember something |
| `Cache-Control` | response | How long this may be reused |
| `Access-Control-Allow-Origin` | response | CORS: which origins may read this |

🚨 **CORS is a browser rule, not a server error.** The request reached your server and your server answered. The *browser* refused to hand the response to JavaScript because the origin was not allowed. `curl` will work perfectly while the browser fails — which is exactly why the error confuses people.

---

## 2. 🛠 The drill

Write a REST-shaped server with **zero dependencies**, so you can see what Express does for you later.

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Folder | `mkdir drill && cd drill` |
| ☐ | 2⃣ Create `server.mjs` | the code below |
| ☐ | 3⃣ Run it | `node server.mjs` |
| ☐ | 4⃣ Call it | the `curl` table below |

```js
import { createServer } from 'node:http';

const entries = [{ id: 1, hours: 8 }];

const server = createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  res.setHeader('Content-Type', 'application/json');

  // GET /entries  → 200 and the list
  if (req.method === 'GET' && url.pathname === '/entries') {
    res.writeHead(200);
    return res.end(JSON.stringify(entries));
  }

  // POST /entries → 201 and the created item
  if (req.method === 'POST' && url.pathname === '/entries') {
    let body = '';
    for await (const chunk of req) body += chunk;        // the body ARRIVES IN PIECES
    try {
      const parsed = JSON.parse(body);
      if (typeof parsed.hours !== 'number') {
        res.writeHead(422);
        return res.end(JSON.stringify({ error: 'hours must be a number' }));
      }
      const created = { id: entries.length + 1, hours: parsed.hours };
      entries.push(created);
      res.writeHead(201, { Location: `/entries/${created.id}` });
      return res.end(JSON.stringify(created));
    } catch {
      res.writeHead(400);
      return res.end(JSON.stringify({ error: 'body must be valid JSON' }));
    }
  }

  res.writeHead(404);
  res.end(JSON.stringify({ error: 'not found' }));
});

server.listen(3001, () => console.log('http://localhost:3001'));
```

### Prove every status code yourself

| 🎯 What you are proving | Command | Expect |
|---|---|---|
| Reading works | `curl -i http://localhost:3001/entries` | `200` + JSON |
| Creating works | `curl -i -X POST http://localhost:3001/entries -H "Content-Type: application/json" -d '{"hours":8}'` | `201` + `Location` |
| Bad JSON is the client's fault | `curl -i -X POST http://localhost:3001/entries -H "Content-Type: application/json" -d 'not json'` | `400` |
| Valid JSON, invalid data | `curl -i -X POST http://localhost:3001/entries -H "Content-Type: application/json" -d '{"hours":"eight"}'` | `422` |
| Unknown route | `curl -i http://localhost:3001/nope` | `404` |
| See only the headers | `curl -I http://localhost:3001/entries` | status + headers |

> 🪟 **Windows note:** PowerShell aliases `curl` to `Invoke-WebRequest`, which takes different arguments. Use `curl.exe` explicitly, and swap the single quotes around the JSON for escaped double quotes.

🧠 **The lesson hiding in the code:** `for await (const chunk of req)` exists because an HTTP body arrives as a **stream**, in pieces. `express.json()` and `app.use(bodyParser)` are doing exactly this loop for you. You will never be mystified by "why is `req.body` undefined" again — it is because nobody ran that loop.

---

## 3. 🚪 The gate

> From an empty file: serve `GET` and `POST`, parse a JSON body by hand from the request stream, and return the correct status code for each of success, created, malformed body, failed validation and unknown route — explaining out loud why each is `2xx`, `4xx` or `5xx`.

---

## 4. 📚 Official docs

| Topic | Where |
|---|---|
| Node's `http` module | <https://nodejs.org/api/http.html> |
| HTTP status codes (MDN) | <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status> |
| HTTP methods (MDN) | <https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods> |
| CORS, properly explained | <https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS> |
| HTTP semantics (RFC 9110) | <https://datatracker.ietf.org/doc/html/rfc9110> |

➡️ **Next shelf:** [`../../02-frontend/`](../../02-frontend/README.md)
