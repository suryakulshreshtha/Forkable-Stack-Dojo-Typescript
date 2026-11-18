# 🧭 00 · What this repo is

**Five minutes. Read it once.**

---

## 🎯 The promise

Twenty-three folders. Each one teaches **one tool**, with:

| 🧩 Part | What it is |
|---|---|
| 📖 **The lesson** | What the tool is for, in plain words, with the one idea you must not miss |
| 🛠 **The drill** | Something small you build yourself. Not copy-paste — you type it |
| 🚪 **The gate** | One sentence: what you must be able to *do* before moving on |
| 📚 **Official docs** | A link to the real documentation, because tutorials go stale and docs do not |

---

## 🧱 How a dojo is laid out

```
03-backend/jwt-auth/
├── README.md        ← the lesson, the drill, the gate
├── .env.example     ← every variable this dojo needs, with safe placeholder values
└── (your files)     ← you create these; nothing is pre-built for you
```

🧒 **Why nothing is pre-built.** A finished example teaches you to read. An empty folder teaches you to build. The README tells you exactly what to create and why — the typing is the point.

---

## 🗺 Three ways to use this repo

| 🚶 Path | Who | How |
|---|---|---|
| **Front to back** | You want the whole stack | `01-foundations/` → `06-devops/`, in order. Roughly 80–100 hours |
| **One shelf** | You need the backend by Friday | Just `03-backend/`. Each dojo there stands alone |
| **One dojo** | You hit Prisma at work today | Open that folder. It assumes nothing from the others |

📈 Tick things off in [PROGRESS.md](../PROGRESS.md) as you clear gates.

---

## 🚪 The gate rule

> **If you cannot do the gate from an empty file, you have not finished the dojo.**

Nobody is marking this. That is precisely why it works — the only person you can fool is yourself, and the gate is written so that fooling yourself is obvious.

| 🚫 "Done" | ✅ Done |
|---|---|
| I read the Prisma docs | I can model a table, migrate it, and query it type-safely from a blank folder |
| I understand JWTs | I can sign, verify and expire a token, and explain where to store it and why |
| I have used Docker | I can explain each line of my Dockerfile and why the image is 180 MB not 1.2 GB |

---

## ✍️ What this repo refuses to do

| ❌ It will not | ✅ Instead |
|---|---|
| Show one command and say "or the Windows equivalent" | Both commands, side by side, every time |
| Say "set up your environment variables" | Name **every** variable, say what it does, and show the file to put it in — [`03-env-files-and-secrets.md`](03-env-files-and-secrets.md) |
| Teach a tool its own maintainers archived | Name the replacement and say what happened — see §5 of the [root README](../README.md) |
| State a version from memory | Record the number, the method and the date in [VERSIONS.md](../VERSIONS.md) |
| Hide that something is unverified | Say so, in the sentence, in brackets |

---

## ➡️ Next

| 🧭 Your situation | Go to |
|---|---|
| `node --version` does not print `v26.x.x` | [`01-workstation-setup.md`](01-workstation-setup.md) |
| Something is installed but "not found" | [`02-path-explained.md`](02-path-explained.md) |
| Ready to start | [`../01-foundations/typescript/README.md`](../01-foundations/typescript/README.md) |
| You want your own repo like this | [`04-create-a-repo-from-scratch.md`](04-create-a-repo-from-scratch.md) |
