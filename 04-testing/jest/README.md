# ⚙️ Jest

**Time:** 3–4 h · **Needs:** Node 26 · **You finish with:** a fast unit suite, deliberate mocks, and control over time.

> 🧠 **The one idea:** a unit test pins **behaviour**, not implementation. If renaming a private function breaks twenty tests, those tests were describing your code's *insides*, and they will fight every refactor you ever attempt.

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | The detail |
|---|---|---|
| `describe` / `it` | Grouping and naming | The name should read as a sentence about behaviour |
| `expect(...).toBe()` | Strict equality (`Object.is`) | For primitives |
| `.toEqual()` | Deep structural equality | For objects and arrays |
| `.toStrictEqual()` | Deep + types + no `undefined` keys | The strictest, and usually what you meant |
| `jest.fn()` | A recording stand-in | Was it called? With what? How often? |
| `jest.spyOn()` | Wrap a real function, keep or replace it | Observe without rewriting |
| `jest.mock('module')` | Replace a whole module | **Hoisted** above your imports |
| Fake timers | Fast-forward the clock | Tests that wait are tests that flake |
| `beforeEach` | Fresh state per test | The cure for "passes alone, fails together" |

### 🎯 What to mock, and what never to

| Mock it ✅ | Never mock it ❌ |
|---|---|
| Network calls | The thing you are testing |
| The system clock | Pure functions (they are already fast) |
| Randomness | Your own data structures |
| Email/SMS/payment side effects | The database, in an *integration* test — use a real one |
| Slow third-party SDKs | Everything (you end up testing your mocks) |

🧠 **If a test needs five mocks to run, the code has five dependencies.** The test is telling you something about the design, not about testing.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install | `npm install -D jest@30.5.2 ts-jest@29.4.15 @types/jest` |
| ☐ | 2⃣ Config | `npx ts-jest config:init` |
| ☐ | 3⃣ Script | add `"test": "jest"` to `package.json` |
| ☐ | 4⃣ Write the five below | — |
| ☐ | 5⃣ Run | `npm test` then `npm test -- --coverage` |

| # | Test this | Teaches |
|---|---|---|
| 1 | A pure `totalHours(entries)` — including the empty array and negatives | Edge cases are where bugs live |
| 2 | A `canApprove(user, entry)` rule with every role/status combination | `it.each` for tables of cases |
| 3 | A function that calls `fetch`, with `fetch` mocked | Mocking a boundary |
| 4 | A retry-with-backoff function, using fake timers | Testing time without waiting |
| 5 | A function that throws, asserted with `.rejects.toThrow()` | Failure is behaviour too |

```ts
// 2 — one case per row, not one test per row written by hand
it.each([
  ['MANAGER', 'SUBMITTED', true],
  ['MANAGER', 'DRAFT',     false],
  ['STAFF',   'SUBMITTED', false],
  ['ADMIN',   'SUBMITTED', true],
])('role %s with status %s → %s', (role, status, expected) => {
  expect(canApprove({ role }, { status })).toBe(expected);
});

// 4 — three retries with backoff, tested in microseconds
jest.useFakeTimers();
it('retries three times then gives up', async () => {
  const flaky = jest.fn().mockRejectedValue(new Error('boom'));
  const promise = retryWithBackoff(flaky, { attempts: 3 });

  await jest.runAllTimersAsync();      // ⏩ fast-forward every pending timer

  await expect(promise).rejects.toThrow('boom');
  expect(flaky).toHaveBeenCalledTimes(3);
});
```

🧪 **Watch a test earn its keep:** write test 1, make it pass, then deliberately change `reduce` to start at `1` instead of `0`. The test fails and tells you exactly what broke. That is the only reason tests exist.

📉 **On coverage:** 100% coverage proves every line *ran*, not that any assertion was meaningful. A test with no `expect` still counts toward coverage. Chase meaningful assertions; treat the number as a smoke detector, not a goal.

---

## 3. 🚪 The gate

> From an empty project: configure Jest with TypeScript, write a table-driven test with `it.each`, mock one external boundary, test a retry using fake timers rather than real waiting, and explain for each mock why mocking it was correct.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| Testing private internals | Test the public behaviour |
| `toBe` on objects | `toEqual` / `toStrictEqual` |
| `await new Promise(r => setTimeout(r, 1000))` | Fake timers |
| Shared state between tests | `beforeEach` to reset |
| Mocking everything | Mock boundaries only |
| Chasing a coverage number | Chase assertions that would catch a real bug |
| `it('works')` | `it('returns 0 for an empty list')` |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Getting started | <https://jestjs.io/docs/getting-started> |
| Mock functions | <https://jestjs.io/docs/mock-functions> |
| Timer mocks | <https://jestjs.io/docs/timer-mocks> |
| Expect API | <https://jestjs.io/docs/expect> |
| ts-jest | <https://kulshekhar.github.io/ts-jest/> |

➡️ **Next:** [`../react-testing-library/`](../react-testing-library/README.md)
