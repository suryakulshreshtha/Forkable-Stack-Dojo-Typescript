# 🧩 TypeScript

**Time:** 4–6 h · **Needs:** Node 26 · **You finish with:** a typed module with zero `any`, compiled by `tsc`, and the ability to read any `tsconfig.json`.

> 🧠 **The one idea:** TypeScript does not run. It *checks*, then deletes itself. Every type you write vanishes before the browser or Node ever sees the code. That is why a type error is free to fix and a runtime error is not.

```
  app.ts  ──tsc──►  app.js  ──node──►  it runs
    │                  │
  types here      no types here (erased)
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | Why it earns its keep |
|---|---|---|
| **Type annotation** | `let n: number = 5` | The compiler now rejects `n = "five"` |
| **Inference** | `let n = 5` is already `number` | Annotate *boundaries* (parameters, returns), let bodies infer |
| **`interface` vs `type`** | Both name a shape | `interface` can be re-opened and extended; `type` can do unions. Pick one per codebase and stop debating |
| **Union** | `'draft' \| 'submitted' \| 'approved'` | Three legal values instead of "any string". Catches typos at compile time |
| **Narrowing** | `if (typeof x === 'string')` | Inside the `if`, TypeScript *knows* it is a string |
| **Generic** | `function first<T>(items: T[]): T` | One function, any element type, no `any` |
| **Constraint** | `<T extends { id: number }>` | "Any type, as long as it has an `id`" |
| **Utility types** | `Partial<T>`, `Pick<T,K>`, `Omit<T,K>`, `Record<K,V>` | Derive types from types; one source of truth |
| **`unknown` vs `any`** | `unknown` must be checked before use | `any` switches checking off. `unknown` keeps it on |
| **`strict`** | A `tsconfig` flag group | The entire reason to use TypeScript. Off, you have slower JavaScript |

### ⚠️ The four that cause real bugs

```ts
// 1. any — the escape hatch that spreads
const data: any = await res.json();
data.user.naem.toUpperCase();   // compiles fine 💀 crashes at runtime

// 2. unknown — the honest version
const safe: unknown = await res.json();
if (typeof safe === 'object' && safe !== null && 'user' in safe) {
  // now you may use it
}

// 3. Optional vs undefined — different promises
interface User { nickname?: string }           // key may be absent
interface User2 { nickname: string | undefined } // key must exist, may be undefined

// 4. Non-null assertion — you overruling the compiler
const el = document.getElementById('app')!;    // "trust me, it exists"
// If you are wrong, it is a runtime crash. Each ! is a promise you made.
```

---

## 2. 🛠 The drill

Build a tiny typed "timesheet" module. Nothing is pre-written — create every file.

| ✅ | Step | Command (macOS and Windows) |
|---|---|---|
| ☐ | 1⃣ New folder | `mkdir drill && cd drill` |
| ☐ | 2⃣ Start a project | `npm init -y` |
| ☐ | 3⃣ Install TypeScript 7 | `npm install -D typescript@7.0.2` |
| ☐ | 4⃣ Create a config | `npx tsc --init` |
| ☐ | 5⃣ Turn strictness on | in `tsconfig.json` set `"strict": true` |
| ☐ | 6⃣ Write `entry.ts` | the five tasks below |
| ☐ | 7⃣ Type-check only | `npx tsc --noEmit` |
| ☐ | 8⃣ Compile for real | `npx tsc` and read the `.js` output |

### Write these five, in order

```ts
// 1. A union for status — not `string`
type Status = 'draft' | 'submitted' | 'approved' | 'rejected';

// 2. An interface for one entry
interface TimeEntry {
  id: number;
  hours: number;
  status: Status;
  note?: string;           // optional on purpose
}

// 3. A generic that only accepts things with an id
function byId<T extends { id: number }>(items: T[], id: number): T | undefined {
  return items.find((item) => item.id === id);
}

// 4. A derived type — no copy-paste of fields
type NewEntry = Omit<TimeEntry, 'id' | 'status'>;

// 5. Narrowing, with an exhaustive switch
function label(status: Status): string {
  switch (status) {
    case 'draft':     return 'Not sent yet';
    case 'submitted': return 'Waiting for approval';
    case 'approved':  return 'Done';
    case 'rejected':  return 'Needs changes';
    default: {
      const never: never = status;   // 🪄 add a 5th status and THIS line errors
      return never;
    }
  }
}
```

🪄 **Try the magic trick:** add `'cancelled'` to `Status` and run `npx tsc --noEmit`. The `never` line fails and points you at every switch you forgot to update. That is exhaustiveness checking, and it is the single most useful TypeScript pattern there is.

### 🧪 Prove you understand `any`

Delete `strict` from `tsconfig.json`, retype task 3's parameter as `any`, and introduce a typo. Watch it compile. Put `strict` back. **That** is what the flag buys you.

---

## 3. 🚪 The gate

> **From an empty folder:** set up a strict TypeScript project, write a generic function with an `extends` constraint, derive a second type from an existing one with a utility type, and make an exhaustive `switch` fail at compile time when you add a case — without looking any of it up.

---

## 4. 🆕 What TypeScript 7 changed

| 🔄 Change | What it means for you |
|---|---|
| `tsc` is now a **Go binary** (stable since July 2026) | Type-checking is roughly **8–12× faster**. Same language, same syntax |
| Compiler **transformer plugins** no longer work | If a project uses `ts-patch` or custom transformers, it stays on TypeScript 6 until those are replaced |
| No stable **programmatic API** yet | Tools that call the compiler as a library may lag. Microsoft has said this lands in 7.1 |
| TypeScript 6.0 was the last JavaScript-based compiler | It is the bridge release if you cannot move yet |

*(Version 7.0.2 read from the npm registry on 2026-11-18 — see [VERSIONS.md](../../VERSIONS.md).)*

---

## 5. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why it hurts | ✅ Instead |
|---|---|---|
| `any` to silence an error | Switches off checking for everything downstream | `unknown` + a check, or write the real type |
| Annotating everything | Noise; inference is usually better | Annotate parameters and returns only |
| `strict: false` | You now have JavaScript with extra build steps | Leave it on. Fix the errors — they are real |
| `as` to force a type | A cast is a claim, not a check | Validate at runtime (Zod) and let the type follow |
| `!` everywhere | Each one is an unchecked promise | Handle the `undefined` case properly |
| Types imported from a `.js` file at runtime | Types do not exist at runtime | `import type { X }` for type-only imports |

---

## 6. 📚 Official docs

| Topic | Where |
|---|---|
| The Handbook (read it start to finish, once) | <https://www.typescriptlang.org/docs/handbook/intro.html> |
| Every `tsconfig` option, explained | <https://www.typescriptlang.org/tsconfig/> |
| Utility types reference | <https://www.typescriptlang.org/docs/handbook/utility-types.html> |
| TypeScript release notes | <https://devblogs.microsoft.com/typescript/> |

➡️ **Next:** [`../git-workflows/`](../git-workflows/README.md)
