# ▲ Next.js App Router

**Time:** 6–8 h · **Needs:** `../react/` cleared · **You finish with:** an app with authenticated and public route groups, a shared layout, middleware that redirects, and a correct Server/Client boundary.

> 🧠 **The one idea:** **folders are routes**, and every component is a **Server** Component until you say otherwise. `'use client'` is not a decoration — it is the line where your code starts being shipped to a stranger's browser.

```
 app/
 ├── layout.tsx            → wraps EVERY page (html, body, providers)
 ├── page.tsx              → /
 ├── (auth)/               → a GROUP: organises, adds NOTHING to the URL
 │   ├── layout.tsx        → wraps only the auth pages
 │   └── login/page.tsx    → /login          ← note: no "(auth)" in the URL
 └── (app)/
     ├── layout.tsx        → wraps only the signed-in pages
     └── timesheets/
         ├── page.tsx      → /timesheets
         └── [id]/page.tsx → /timesheets/42  ← dynamic segment
```

---

## 1. 📖 The lesson

### The files with reserved names

| 📄 File | What it does | Runs where |
|---|---|---|
| `page.tsx` | Makes a route publicly reachable | Server by default |
| `layout.tsx` | Wraps children; **keeps state across navigation** | Server by default |
| `template.tsx` | Like a layout but **remounts** each navigation | Server by default |
| `loading.tsx` | Shown automatically while the page streams | — |
| `error.tsx` | Catches render errors in that subtree | **Must** be a Client Component |
| `not-found.tsx` | Renders for `notFound()` and unmatched routes | Server |
| `route.ts` | An API endpoint instead of a page | Server only |
| `middleware.ts` | Runs **before** a request reaches any route | Edge runtime, project root |

### Server vs Client — the decision you make constantly

| | 🖥 Server Component (default) | 💻 Client Component (`'use client'`) |
|---|---|---|
| Can read secrets, hit a DB directly | ✅ Yes | 🚫 **Never** |
| Can use `useState`, `useEffect`, `onClick` | ❌ No | ✅ Yes |
| Ships JavaScript to the browser | ❌ No — smaller, faster page | ✅ Yes — it is in the bundle |
| Can be `async` and `await` data | ✅ Yes | ❌ No |
| Good for | Fetching, layouts, static content | Forms, buttons, anything interactive |

🎯 **The rule that keeps bundles small:** push `'use client'` as **far down the tree as possible**. A page that needs one interactive button should not become a Client Component — the *button* should.

```
 ❌ 'use client' at the top of page.tsx     ✅ 'use client' on <LikeButton> only
    → the whole page ships to the browser      → the page stays on the server,
                                                  one tiny component ships
```

### Route groups — the parenthesis

`(auth)` and `(app)` are **groups**. They give a set of routes their own layout **without appearing in the URL**. That is how one app serves a bare login screen and a sidebar-wrapped dashboard with no conditional rendering anywhere.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ New app | `npx create-next-app@16.4.6 drill --typescript --app --tailwind --eslint` |
| ☐ | 2⃣ Run it | `cd drill && npm run dev` → <http://localhost:3000> |
| ☐ | 3⃣ Create `.env.local` | `cp .env.example .env.local` then fill it in ([`../../docs/03-env-files-and-secrets.md`](../../docs/03-env-files-and-secrets.md)) |
| ☐ | 4⃣ Build the six pieces below | — |

| # | Build | Teaches |
|---|---|---|
| 1 | `(auth)/login/page.tsx` and `(app)/timesheets/page.tsx` | Route groups: no `(auth)` in the URL |
| 2 | A different `layout.tsx` in each group | Nested layouts replacing conditional chrome |
| 3 | `(app)/timesheets/[id]/page.tsx` reading `params` | Dynamic segments |
| 4 | A Server Component that `await`s data, with `loading.tsx` beside it | Streaming and Suspense for free |
| 5 | One interactive `<SubmitButton>` marked `'use client'` — **and nothing above it** | The boundary, drawn correctly |
| 6 | `middleware.ts` redirecting `/timesheets/*` to `/login` when the auth cookie is absent | Protecting routes before they render |

```ts
// Piece 6 — middleware.ts, at the project root (not in app/)
import { NextResponse, type NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const session = request.cookies.get(process.env.AUTH_COOKIE_NAME ?? 'dojo_session');

  if (!session) {
    const loginUrl = new URL('/login', request.url);
    loginUrl.searchParams.set('from', request.nextUrl.pathname);   // come back after login
    return NextResponse.redirect(loginUrl);
  }
  return NextResponse.next();
}

export const config = { matcher: ['/timesheets/:path*'] };   // only these paths pay the cost
```

🧪 **The canary experiment (do this one):** put `NEXT_PUBLIC_CANARY=hello-world` and `SERVER_ONLY=goodbye-world` in `.env.local`, use both in a page, run `npm run build`, then search the output: `grep -r "hello-world" .next/` finds it. `grep -r "goodbye-world" .next/static/` does not. You have just proved to yourself what `NEXT_PUBLIC_` means.

---

## 3. 🚪 The gate

> From a fresh `create-next-app`: build two route groups with separate layouts, a dynamic route, a streaming Server Component with a `loading.tsx`, one correctly-placed Client Component, and middleware that protects a path — then point at any file and say whether it runs on the server or the browser, and why.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why it hurts | ✅ Instead |
|---|---|---|
| `'use client'` at the top of a page | The entire subtree ships to the browser | Push it down to the interactive leaf |
| A secret in a `NEXT_PUBLIC_` variable | Published to every visitor, permanently | Server-side variable; rotate immediately if it shipped |
| `middleware.ts` inside `app/` | It is silently ignored | Project root, beside `package.json` |
| Expecting a `.env.local` edit to apply live | Env is read at server start | Restart the dev server |
| `useState` in a Server Component | Build error | `'use client'`, or move the state down |
| Fetching in a Client Component out of habit | Slower, and leaks the endpoint | `await` it in the Server Component and pass it down |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| App Router documentation | <https://nextjs.org/docs/app> |
| File conventions (every reserved filename) | <https://nextjs.org/docs/app/api-reference/file-conventions> |
| Server and Client Components | <https://nextjs.org/docs/app/getting-started/server-and-client-components> |
| Middleware | <https://nextjs.org/docs/app/api-reference/file-conventions/middleware> |
| Environment variables | <https://nextjs.org/docs/app/guides/environment-variables> |

➡️ **Next:** [`../component-library/`](../component-library/README.md)
