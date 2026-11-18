# 🧹 ESLint + Prettier + Husky

**Time:** 2–3 h · **Needs:** Node 26 · **You finish with:** a repo that formats itself and blocks a commit that would fail CI.

> 🧠 **The one idea:** these are two different jobs, and conflating them causes endless pain. **Prettier** decides how code *looks* (and it is not up for debate). **ESLint** decides what code is *allowed to do*. Let each own its half.

```
 ✍️ you write  ──►  💅 Prettier formats  ──►  🔍 ESLint judges  ──►  🪝 Husky blocks the commit
                     (whitespace, quotes)     (bugs, bad patterns)    (before CI ever sees it)
```

---

## 1. 📖 The lesson

| 🧩 Tool | Owns | Does **not** own |
|---|---|---|
| **Prettier** | Line width, quotes, semicolons, indentation | Whether your code is correct |
| **ESLint** | Unused variables, unsafe `any`, missing `await`, bad hook usage | How it is indented |
| **typescript-eslint** | Type-aware rules (the valuable ones) | — |
| **Husky** | Running things on `git commit` | Deciding what passes |
| **lint-staged** | Running them only on **staged** files | — |

### 🆕 Flat config — the change that breaks old tutorials

ESLint 9 and 10 use **`eslint.config.js`**, not `.eslintrc.json`. If a tutorial shows `extends: ["eslint:recommended"]` inside a JSON file, it predates this.

```js
// eslint.config.js — ESLint 10. Note: an exported ARRAY, and real imports.
import js from '@eslint/js';
import tseslint from 'typescript-eslint';

export default [
  js.configs.recommended,
  ...tseslint.configs.recommendedTypeChecked,   // 🎯 type-aware: the rules worth having
  {
    languageOptions: {
      parserOptions: { projectService: true },  // gives ESLint your tsconfig
    },
    rules: {
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-floating-promises': 'error',   // catches a forgotten await
      'no-console': ['warn', { allow: ['warn', 'error'] }],
    },
  },
  { ignores: ['dist/**', '.next/**', 'coverage/**'] },
];
```

🎯 **`no-floating-promises` alone justifies type-aware linting.** A forgotten `await` is invisible to the eye, passes tests, and fails in production at the worst moment.

### Why `--max-warnings=0`

A warning nobody must fix is a warning everybody ignores. Three become thirty, and the signal is gone. Two honest options exist: make it an **error**, or **delete the rule**. "Warning" is a decision deferred forever.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install | `npm install -D eslint@10.15.0 @eslint/js@10.0.1 typescript-eslint@8.73.0 prettier@3.10.1` |
| ☐ | 2⃣ Hooks | `npm install -D husky@9.1.7 lint-staged@17.6.1` |
| ☐ | 3⃣ Initialise Husky | `npx husky init` |
| ☐ | 4⃣ Write `eslint.config.js` | above |
| ☐ | 5⃣ Wire the hook | below |
| ☐ | 6⃣ 🧪 **Try to commit bad code** | the test below |

```json
// package.json
{
  "scripts": {
    "lint": "eslint . --max-warnings=0",
    "format": "prettier --write .",
    "typecheck": "tsc --noEmit"
  },
  "lint-staged": {
    "*.{ts,tsx}": ["prettier --write", "eslint --max-warnings=0"],
    "*.{json,md,css}": ["prettier --write"]
  }
}
```

```bash
# .husky/pre-commit  — runs on every commit, on staged files only
npx lint-staged
```

🧪 **Prove the hook works** (do this, do not assume):

```ts
// make a file with three deliberate problems
const unused = 1;                       // unused variable
function bad(x: any) { return x.y.z; }   // explicit any
async function f() { bad(1); doAsync(); }  // floating promise
```

```bash
git add . && git commit -m "this should be blocked"
```

✅ The commit is **rejected**, with the file and line. That is a CI failure you never had to wait for.

⏱ **Why lint-staged matters:** linting a large repo takes 30+ seconds; linting your three staged files takes under one. A slow hook gets bypassed with `--no-verify`, and then it protects nothing.

---

## 3. 🚪 The gate

> From an empty repo: a working flat ESLint config with type-aware rules, Prettier owning formatting with no rule conflicts, and a pre-commit hook that actually blocks a commit containing an unused variable, an `any`, and a floating promise — demonstrated, not assumed.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| `.eslintrc.json` with ESLint 10 | `eslint.config.js` (flat config) |
| ESLint and Prettier both formatting | Prettier owns formatting; drop the stylistic ESLint rules |
| Linting the whole repo in the hook | `lint-staged` |
| Living with warnings | Error, or delete the rule |
| Habitual `git commit --no-verify` | Fix the hook until it is fast and trustworthy |
| Only `recommended`, not type-checked | Add `recommendedTypeChecked` — that is where the bug-finding lives |
| Hooks not running after clone | They install on `npm install`; otherwise `npx husky init` |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| ESLint | <https://eslint.org/docs/latest/> |
| Flat config migration | <https://eslint.org/docs/latest/use/configure/migration-guide> |
| typescript-eslint | <https://typescript-eslint.io/getting-started/> |
| Prettier + linters together | <https://prettier.io/docs/en/integrating-with-linters.html> |
| Husky | <https://typicode.github.io/husky/> |
| lint-staged | <https://github.com/lint-staged/lint-staged> |

➡️ **Next:** [`../sonarqube/`](../sonarqube/README.md)
