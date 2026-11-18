# 🗄 Prisma + Azure SQL

**Time:** 5–7 h · **Needs:** Docker Desktop (local route) **or** an Azure SQL database · **You finish with:** a migrated schema, a seeded database, and type-safe queries where a typo is a compile error.

> 🧠 **The one idea:** your `schema.prisma` is the **single source of truth**. From it, Prisma generates both the SQL migration *and* the TypeScript types. Change one line, run one command, and both your database and your editor's autocomplete know about it.

```
 schema.prisma ──prisma migrate dev──► SQL migration ──► your database
       │
       └────────prisma generate──────► TypeScript types ──► autocomplete + compile errors
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | Why it matters |
|---|---|---|
| **Model** | A table, described in `schema.prisma` | Readable by a human, unlike raw DDL |
| **Migration** | A timestamped `.sql` file Prisma writes for you | Reviewable, committable, replayable. **Never edit the database by hand** |
| **`migrate dev`** | Create + apply a migration (development) | Can reset your data when it must |
| **`migrate deploy`** | Apply existing migrations (production/CI) | Never generates, never resets. The only one you run in CI |
| **Client** | The generated query API | `prisma.timeEntry.findMany()` — fully typed |
| **Relation** | `@relation` between models | Prisma handles the join |
| **`select` / `include`** | Choose columns / pull relations | Fetching everything by default is how APIs get slow |
| **Connection pool** | Reused connections | Azure SQL has hard connection limits. One `PrismaClient`, app-wide |

### 🔌 Two ways to run the database

| | 🐳 Local SQL Server in Docker | ☁️ Azure SQL |
|---|---|---|
| Cost | Free | Billed (check the current free offer) |
| Speed | Instant, offline | Network latency |
| Realism | Very close | Exact |
| Use for | Every drill in this dojo | The `06-devops/` deployment |

### Start SQL Server locally

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$env:PW" -p 1433:1433 --name dojo-sql -d mcr.microsoft.com/mssql/server:2022-latest` | same command, one line |
| Check: `docker ps` | Check: `docker ps` |
| Logs if it died: `docker logs dojo-sql` | `docker logs dojo-sql` |

> ⚠️ **Apple silicon:** Microsoft's SQL Server image is x86. If it will not start, add `--platform linux/amd64` and expect it to be slower, or use Azure SQL instead.
>
> 🔐 **The password must satisfy SQL Server's complexity rules** (8+ characters, upper, lower, digit, symbol) or the container exits immediately with no obvious reason. `docker logs` tells you. Put the value in `MSSQL_SA_PASSWORD` in your `.env` — never inline in the command where it lands in your shell history.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Project | `mkdir drill && cd drill && npm init -y` |
| ☐ | 2⃣ Install (pinned — see the warning) | `npm install @prisma/client@7.10.1` and `npm install -D prisma@7.10.1` |
| ☐ | 3⃣ Initialise | `npx prisma init --datasource-provider sqlserver` |
| ☐ | 4⃣ Env | `cp .env.example .env` and set `DATABASE_URL` |
| ☐ | 5⃣ Write the schema | below |
| ☐ | 6⃣ First migration | `npx prisma migrate dev --name init` |
| ☐ | 7⃣ 🔍 **Read the SQL it generated** | `prisma/migrations/*/migration.sql` — this is the dojo's real lesson |
| ☐ | 8⃣ Inspect your data | `npx prisma studio` |
| ☐ | 9⃣ Write the five queries | below |

> 🚨 **Pin Prisma deliberately.** On 2026-11-18 the registry's `next` tag for `prisma` was an **8.0 release candidate**. Plain `npm install prisma` can pull a pre-release. Pin `@7.10.1` as above.

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlserver"
  url      = env("DATABASE_URL")     // ← read from .env, never hard-coded
}

model User {
  id      Int         @id @default(autoincrement())
  email   String      @unique
  name    String
  role    Role        @default(STAFF)
  entries TimeEntry[]                  // one-to-many
}

model TimeEntry {
  id        Int      @id @default(autoincrement())
  hours     Decimal  @db.Decimal(5, 2)  // ⚠️ money and hours are NEVER Float
  note      String?                     // nullable
  status    Status   @default(DRAFT)
  userId    Int
  user      User     @relation(fields: [userId], references: [id])
  createdAt DateTime @default(now())

  @@index([userId, status])             // the index your list query will need
}

enum Role   { STAFF MANAGER ADMIN }
enum Status { DRAFT SUBMITTED APPROVED REJECTED }
```

### The five queries to write

```ts
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();      // ⚠️ ONE instance for the whole app

// 1. Create, with a relation
await prisma.timeEntry.create({
  data: { hours: 8, userId: 1, note: 'Sprint planning' },
});

// 2. Read a list — only the columns you need, newest first
await prisma.timeEntry.findMany({
  where: { userId: 1, status: 'SUBMITTED' },
  select: { id: true, hours: true, status: true },
  orderBy: { createdAt: 'desc' },
  take: 20,
});

// 3. Read with the relation included
await prisma.timeEntry.findMany({
  where: { status: 'SUBMITTED' },
  include: { user: { select: { name: true, email: true } } },
});

// 4. Update by id
await prisma.timeEntry.update({ where: { id: 1 }, data: { status: 'APPROVED' } });

// 5. A transaction — both succeed or neither does
await prisma.$transaction([
  prisma.timeEntry.update({ where: { id: 1 }, data: { status: 'APPROVED' } }),
  prisma.timeEntry.update({ where: { id: 2 }, data: { status: 'APPROVED' } }),
]);
```

🧪 **Prove the type safety:** change `select: { hours: true }` to `select: { hrs: true }`. Run `npx tsc --noEmit`. It fails *before* you run anything. Then rename `note` to `comment` in the schema, run `npx prisma migrate dev --name rename-note`, and watch every usage in your editor light up red. That feedback loop is the reason to use an ORM like this.

🔢 **Why `Decimal` and not `Float`:** binary floating point cannot represent `0.1` exactly. Add up enough `Float` hours and your timesheet total is `39.99999999`. Money and hours are always `Decimal`.

---

## 3. 🚪 The gate

> From an empty folder: model two related tables with an enum and an index, run a migration and **read the SQL it produced**, write a filtered-and-paginated list query with a relation included, wrap two writes in a transaction, and explain why `migrate deploy` — not `migrate dev` — belongs in CI.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why it hurts | ✅ Instead |
|---|---|---|
| `new PrismaClient()` per request | Exhausts the connection pool; Azure SQL starts refusing | One instance, exported from one module |
| Editing the database by hand | The next migration conflicts | Change the schema, migrate |
| Editing a committed migration file | Everyone else's database diverges | Write a new migration |
| `migrate dev` in CI or production | It can reset data | `migrate deploy` |
| `Float` for hours or money | Rounding errors that compound | `Decimal` with explicit precision |
| `findMany()` with no `take` | Loads the whole table one day | Always paginate |
| `include` everywhere | Fetches data nobody displays | `select` the columns you need |
| `trustServerCertificate=true` against Azure | Encryption without verification | Local only; remove it in the cloud |
| `DATABASE_URL` committed | It contains a password | `.env`, ignored. [`../../docs/03-env-files-and-secrets.md`](../../docs/03-env-files-and-secrets.md) |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Prisma documentation | <https://www.prisma.io/docs> |
| SQL Server connector and connection strings | <https://www.prisma.io/docs/orm/overview/databases/sql-server> |
| Migrations in development and production | <https://www.prisma.io/docs/orm/prisma-migrate> |
| Prisma schema reference | <https://www.prisma.io/docs/orm/reference/prisma-schema-reference> |
| SQL Server in a Docker container | <https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker> |
| Azure SQL documentation | <https://learn.microsoft.com/en-us/azure/azure-sql/> |

➡️ **Next:** [`../jwt-auth/`](../jwt-auth/README.md)
