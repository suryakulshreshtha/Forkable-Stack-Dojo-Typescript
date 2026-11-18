# ⚙️ 03 · Backend

**Five dojos. 19–26 hours. You finish with:** a typed, documented, authenticated REST API talking to SQL Server, with role-based access control you wrote yourself.

| Dojo | Teaches | Time | Needs |
|---|---|---|---|
| [`express/`](express/README.md) | Routing, middleware chains, error handling, Express 5 async | 4–5 h | `../01-foundations/http-fundamentals/` |
| [`prisma-azuresql/`](prisma-azuresql/README.md) | Schema, migrations, type-safe queries against SQL Server | 5–7 h | Docker **or** an Azure SQL database |
| [`jwt-auth/`](jwt-auth/README.md) | Sign, verify, expire, refresh; RBAC middleware | 4–5 h | `express/` done |
| [`sso-entra-msal/`](sso-entra-msal/README.md) | Enterprise sign-in with MSAL Node and Microsoft Entra ID | 4–6 h | `jwt-auth/` + an Azure tenant |
| [`swagger-openapi/`](swagger-openapi/README.md) | Describe the API in OpenAPI and serve it at `/api-docs` | 2–3 h | `express/` done |

🔐 Every dojo here needs environment variables. All of them are listed in [`../docs/03-env-files-and-secrets.md`](../docs/03-env-files-and-secrets.md) — nothing is left as "set up your env".

🚪 **Shelf gate:** ship a role-protected CRUD endpoint, backed by a migrated database, documented in OpenAPI, that returns the right status code for every failure mode — from an empty folder.
