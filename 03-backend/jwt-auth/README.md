# 🎫 JWT authentication + RBAC

**Time:** 4–5 h · **Needs:** [`../express/`](../express/README.md) cleared · **You finish with:** sign-in that issues a short-lived access token and a refresh token, verification middleware, and role checks you wrote.

> 🧠 **The one idea:** a JWT is **signed, not encrypted**. Anyone holding it can read every claim inside. The signature only proves *you* issued it and nobody altered it. So: never put a secret in a token, and always verify the signature before trusting a single field.

```
 header.payload.signature      ← three base64 segments, joined by dots
   │       │         │
   │       │         └── HMAC(header.payload, YOUR SECRET)  ← proves authorship
   │       └──────────── the claims: sub, role, exp   ← 👀 READABLE BY ANYONE
   └──────────────────── algorithm + type
```

🧪 Paste a token into <https://jwt.io> and read your own payload. Now you will never store a password in one.

---

## 1. 📖 The lesson

### Authentication vs authorisation — two different jobs

| | 🪪 Authentication | 🚦 Authorisation |
|---|---|---|
| Question | *Who are you?* | *May you do this?* |
| Failure | `401 Unauthorized` | `403 Forbidden` |
| Done by | Verifying the token | Checking the role/permission |
| Lives in | `requireAuth` middleware | `requireRole('MANAGER')` middleware |

### The claims that matter

| Claim | Means | Note |
|---|---|---|
| `sub` | Subject — the user id | The standard place for "who" |
| `exp` | Expiry (seconds since 1970) | Verified automatically by the library |
| `iat` | Issued at | Useful for "log out everywhere" |
| `iss` / `aud` | Issuer / audience | Verify both when several services share a secret |
| `role` | A custom claim | Convenient, but stale the moment you demote someone |

### Why two tokens

| | 🎟 Access token | 🔁 Refresh token |
|---|---|---|
| Lifetime | Minutes (`15m`) | Days (`7d`) |
| Sent | On every request | Only to `/auth/refresh` |
| If stolen | Useless shortly | Serious — it mints new access tokens |
| Stored | Memory | `httpOnly`, `Secure`, `SameSite` cookie |
| Secret | `JWT_SECRET` | `JWT_REFRESH_SECRET` — **a different value** |

### 📍 Where to store the access token — pick your trade-off honestly

| Place | 🔓 XSS risk | 🎯 CSRF risk | Verdict |
|---|---|---|---|
| `localStorage` | 🔴 Any injected script reads it | 🟢 None | Common, and the usual way tokens get stolen |
| JS variable in memory | 🟡 Script can reach it while running | 🟢 None | Good — gone on refresh, so pair with a refresh cookie |
| `httpOnly` cookie | 🟢 JavaScript cannot read it | 🔴 Needs `SameSite`/CSRF token | Best for refresh tokens |

🎯 **The pragmatic answer:** access token in memory, refresh token in an `httpOnly` `Secure` `SameSite=Strict` cookie. Nothing is perfect; this makes a single XSS less catastrophic.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Continue your Express app | `cd ../express/drill` |
| ☐ | 2⃣ Install | `npm install jsonwebtoken@9.0.3 bcrypt` and `npm install -D @types/jsonwebtoken@9.0.10` |
| ☐ | 3⃣ Generate two **different** secrets | `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"` — run it twice |
| ☐ | 4⃣ Put them in `.env` | `JWT_SECRET`, `JWT_REFRESH_SECRET` |
| ☐ | 5⃣ Build the six pieces | below |
| ☐ | 6⃣ Test every path with `curl` | the table below |

| # | Build | Teaches |
|---|---|---|
| 1 | `POST /auth/login` — verify a **bcrypt-hashed** password, return both tokens | Never store a plain password |
| 2 | `requireAuth` middleware reading `Authorization: Bearer <token>` | Verification, and `401` |
| 3 | `requireRole(...roles)` middleware | Authorisation, and `403` |
| 4 | `POST /auth/refresh` exchanging a refresh token for a new access token | The refresh cycle |
| 5 | A protected route needing only auth, and one needing `MANAGER` | The two failure codes, distinctly |
| 6 | Specific handling for `TokenExpiredError` vs `JsonWebTokenError` | A client can act on the first, not the second |

```ts
// Pieces 2 + 3 — the two middlewares. Note which code each returns.
import jwt from 'jsonwebtoken';
import type { Request, Response, NextFunction } from 'express';

export interface AuthPayload { sub: string; role: 'STAFF' | 'MANAGER' | 'ADMIN' }

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Missing bearer token' });
  }

  try {
    const token = header.slice('Bearer '.length);          // strip the prefix!
    req.auth = jwt.verify(token, env.JWT_SECRET) as AuthPayload;
    return next();
  } catch (err) {
    // 🎯 Two different failures the client treats differently
    if (err instanceof jwt.TokenExpiredError) {
      return res.status(401).json({ error: 'Token expired', code: 'TOKEN_EXPIRED' });
    }
    return res.status(401).json({ error: 'Invalid token' });
  }
}

export function requireRole(...allowed: AuthPayload['role'][]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.auth) return res.status(401).json({ error: 'Not authenticated' });
    if (!allowed.includes(req.auth.role)) {
      // 403, NOT 401 — we know who they are, they simply may not
      return res.status(403).json({ error: 'Insufficient role' });
    }
    return next();
  };
}

// Usage — read it as a sentence: authenticate, then authorise, then handle.
app.patch('/entries/:id/approve', requireAuth, requireRole('MANAGER', 'ADMIN'), approve);
```

### Test every path

| 🎯 Proving | Command | Expect |
|---|---|---|
| No token | `curl -i localhost:3001/entries` | `401` |
| Rubbish token | `curl -i localhost:3001/entries -H "Authorization: Bearer abc"` | `401 Invalid token` |
| Valid token, wrong role | `curl -i -X PATCH localhost:3001/entries/1/approve -H "Authorization: Bearer $STAFF"` | `403` |
| Valid token, right role | same with `$MANAGER` | `200` |
| Expired token | set `JWT_EXPIRES_IN=1s`, log in, wait, call | `401 TOKEN_EXPIRED` |

---

## 3. 🚪 The gate

> From an empty route file: issue a short-lived access token and a long-lived refresh token signed with **different** secrets, write verification and role middleware that return `401` and `403` *correctly*, handle expiry as its own case, and explain where you would store each token and what attack that choice accepts.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why it is bad | ✅ Instead |
|---|---|---|
| A secret in the token payload | Anyone can base64-decode it | Claims are public. Keep secrets server-side |
| `jwt.decode()` instead of `jwt.verify()` | `decode` checks **nothing** | Always `verify` |
| One secret for both tokens | A leaked access secret mints refresh tokens | Two distinct values |
| `403` when nobody is logged in | The client cannot tell it should log in | `401` for "who are you", `403` for "no" |
| Long-lived access tokens ("simpler") | A stolen token works for weeks | Minutes, plus refresh |
| Storing passwords at all, or hashing with MD5/SHA-1 | Trivially reversible at scale | `bcrypt`/`argon2`, never a fast hash |
| Trusting the `role` claim forever | A demoted user keeps their powers until expiry | Short expiry, or check the database for sensitive actions |
| Tokens in the URL | Logged by every proxy and in browser history | The `Authorization` header |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| JWT (RFC 7519) | <https://datatracker.ietf.org/doc/html/rfc7519> |
| Introduction to JWTs | <https://jwt.io/introduction> |
| `jsonwebtoken` API | <https://github.com/auth0/node-jsonwebtoken> |
| OWASP cheat sheet — JWT for Java/any stack | <https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html> |
| OWASP cheat sheet — password storage | <https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html> |
| Passport local strategy | <https://www.passportjs.org/concepts/authentication/strategies/> |

➡️ **Next:** [`../sso-entra-msal/`](../sso-entra-msal/README.md)
