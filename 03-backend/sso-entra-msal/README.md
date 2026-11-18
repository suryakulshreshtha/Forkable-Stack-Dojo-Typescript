# 🏢 Enterprise SSO — Microsoft Entra ID with MSAL Node

**Time:** 4–6 h · **Needs:** [`../jwt-auth/`](../jwt-auth/README.md) cleared, an Azure tenant you can register an app in · **You finish with:** "Sign in with Microsoft" working end to end, and an understanding of why your own login form disappears in corporate software.

> ⚠️ **Do not use `passport-azure-ad`.** npm reports it as **deprecated and no longer supported**, pointing to Microsoft's own replacement guidance. Tutorials and older codebases are full of it. This dojo uses **`@azure/msal-node` 7.2.2**, Microsoft's maintained library.
>
> *(Deprecation read from npm package metadata on 2026-11-18 — see [VERSIONS.md](../../VERSIONS.md).)*

> 🧠 **The one idea:** with SSO your app **never sees the password**. You redirect the user to Microsoft, Microsoft authenticates them (MFA, conditional access, device compliance — none of it your problem), and sends back a **code**. Your server swaps that code for tokens. Your app's job is to trust a token, not to check a password.

```
 1. user clicks "Sign in with Microsoft"
 2. your server  ──redirect──►  login.microsoftonline.com
 3.                              user signs in + MFA  (you never see this)
 4. Microsoft  ──redirect back with ?code=…──►  your /auth/callback
 5. your server  ──POST code + client secret──►  Microsoft
 6. Microsoft  ──► ID token (who they are) + access token (what they may call)
 7. your server issues ITS OWN session or JWT  ← back to the previous dojo
```

---

## 1. 📖 The lesson

### The vocabulary, which is most of the difficulty

| 🧩 Term | Plain meaning |
|---|---|
| **Entra ID** | Microsoft's identity directory. Formerly Azure Active Directory (Azure AD) — the same thing, renamed |
| **Tenant** | One organisation's directory. `AZURE_TENANT_ID` names it |
| **App registration** | Telling Entra "this app exists and may ask me to sign people in" |
| **Client ID** | Your app's public identifier |
| **Client secret** | Proves your *server* is that app. 🔴 Secret, and **it expires** |
| **Redirect URI** | Where Entra sends the user back. Must match the registration **exactly** |
| **Authority** | `https://login.microsoftonline.com/<tenant>` |
| **Scope** | What you are asking permission for (`openid`, `profile`, `User.Read`) |
| **ID token** | *Who the user is.* For your app |
| **Access token** | *What you may call* on their behalf (e.g. Microsoft Graph). Not for your own API's authorisation |
| **Confidential client** | An app with a server that can keep a secret — what you are building |
| **Public client** | A SPA or mobile app that cannot keep a secret — must use PKCE |

🎯 **The mistake almost everyone makes once:** using the Microsoft **access token** to authorise calls to *your own* API. It was issued for Graph, not for you. Validate the **ID token**, then issue your own session/JWT (the previous dojo) and authorise against that.

### MFA, conditional access and password policy are now free

That is the real reason enterprises insist on SSO. Your `jwt-auth` dojo would need to build password reset, lockout, MFA enrolment, breach detection and audit logging. With SSO, the identity provider already did all of it, and the security team already trusts it.

---

## 2. 🛠 The drill

### Part A · Register the app (in the Azure portal)

| ✅ | Step | Where |
|---|---|---|
| ☐ | 1⃣ Open Entra ID → **App registrations** → **New registration** | <https://portal.azure.com> |
| ☐ | 2⃣ Name it, e.g. `stack-dojo-local` | — |
| ☐ | 3⃣ Supported account types: **this directory only** for a first attempt | — |
| ☐ | 4⃣ Redirect URI: platform **Web**, value `http://localhost:3001/auth/callback` | ⚠️ Exactly this, trailing slash included or excluded consistently |
| ☐ | 5⃣ Copy the **Application (client) ID** and **Directory (tenant) ID** | → `.env` |
| ☐ | 6⃣ **Certificates & secrets** → **New client secret** → copy the **value** | 🔴 Shown once. Note its expiry date |
| ☐ | 7⃣ **API permissions** → add `openid`, `profile`, `email`, `User.Read` | Grant consent if your account can |

### Part B · The code

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install | `npm install @azure/msal-node@7.2.2 express-session` |
| ☐ | 2⃣ Env | `cp .env.example .env`, fill all six variables |
| ☐ | 3⃣ Build the five pieces | below |
| ☐ | 4⃣ Sign in from a browser | <http://localhost:3001/auth/login> |

| # | Build | Teaches |
|---|---|---|
| 1 | A `ConfidentialClientApplication` configured from env | Confidential client setup |
| 2 | `GET /auth/login` → redirect to Microsoft | Starting the auth-code flow |
| 3 | `GET /auth/callback` → swap the code for tokens | Completing it server-side |
| 4 | Issue **your own** JWT from the ID token's claims | The handoff to your own authorisation |
| 5 | `GET /auth/logout` clearing your session | Local vs federated sign-out |

```ts
// Piece 1 — configuration. Every value comes from .env; nothing is hard-coded.
import { ConfidentialClientApplication } from '@azure/msal-node';

export const msal = new ConfidentialClientApplication({
  auth: {
    clientId: env.AZURE_CLIENT_ID,
    clientSecret: env.AZURE_CLIENT_SECRET,        // 🔴 server only, never shipped
    authority: `${env.AZURE_CLOUD_INSTANCE}${env.AZURE_TENANT_ID}`,
  },
});

const SCOPES = ['openid', 'profile', 'email', 'User.Read'];
```

```ts
// Pieces 2–4 — the round trip. API shape as of MSAL Node 7.2.2; confirm option
// names against the official docs linked below before you copy this into real work.
app.get('/auth/login', async (req, res, next) => {
  try {
    const url = await msal.getAuthCodeUrl({
      scopes: SCOPES,
      redirectUri: env.AZURE_REDIRECT_URI,
    });
    res.redirect(url);                 // the user leaves your app here
  } catch (err) { next(err); }
});

app.get('/auth/callback', async (req, res, next) => {
  try {
    const result = await msal.acquireTokenByCode({
      code: String(req.query.code),
      scopes: SCOPES,
      redirectUri: env.AZURE_REDIRECT_URI,   // must match the login call exactly
    });

    // ✅ The ID token's claims say who they are.
    const { username, name } = result.account ?? {};

    // 🎯 Now issue YOUR OWN token — do not reuse Microsoft's access token for your API.
    const appToken = jwt.sign(
      { sub: username, name, role: await lookUpRole(username) },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN },
    );

    res.cookie(env.AUTH_COOKIE_NAME, appToken, {
      httpOnly: true, secure: env.NODE_ENV === 'production', sameSite: 'strict',
    });
    res.redirect('/timesheets');
  } catch (err) { next(err); }
});
```

🧠 **Note `lookUpRole()`.** Entra tells you *who* the person is. It does not know your app's roles unless you configure app roles or group claims. Mapping identity → permission is **your** job, and it belongs in your database.

---

## 3. 🚪 The gate

> Register an app in Entra ID yourself, complete the authorisation-code flow server-side, exchange the code for tokens, issue your own JWT from the resulting claims, and explain out loud: why the client secret can never live in the frontend, why the redirect URI must match exactly, and why Microsoft's access token is the wrong thing to authorise your own API with.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Symptom | ✅ Fix |
|---|---|---|
| Using `passport-azure-ad` | Deprecated, unsupported | `@azure/msal-node` |
| Client secret in frontend code or a `NEXT_PUBLIC_` variable | Anyone can impersonate your app | Server only. Rotate immediately if exposed |
| Redirect URI mismatch | `AADSTS50011` | Make the registration and `.env` byte-identical |
| Authorising your API with Microsoft's access token | Works until it does not; wrong audience | Validate the ID token, issue your own |
| Forgetting the secret expires | Sign-in breaks months later, "with no changes" | Note the expiry; set a calendar reminder |
| Local sign-out only | User clicks logout, logs straight back in | Understand local vs federated sign-out |
| Implicit flow from a tutorial | Long superseded | Authorisation code flow; PKCE for SPAs |
| Testing SSO with no tenant access | Blocked at step 1 | Personal Microsoft accounts and work tenants behave differently; use a tenant you control |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Microsoft identity platform | <https://learn.microsoft.com/en-us/entra/identity-platform/> |
| MSAL Node (library docs) | <https://learn.microsoft.com/en-us/entra/msal/node/> |
| MSAL Node source and samples | <https://github.com/AzureAD/microsoft-authentication-library-for-js> |
| Authorisation code flow | <https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow> |
| Register an application | <https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app> |
| ID tokens and their claims | <https://learn.microsoft.com/en-us/entra/identity-platform/id-token-claims-reference> |

➡️ **Next:** [`../swagger-openapi/`](../swagger-openapi/README.md)
