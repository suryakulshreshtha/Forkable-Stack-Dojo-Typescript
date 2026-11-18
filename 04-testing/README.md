# 🧪 04 · Testing

**Four dojos. 12–16 hours. You finish with:** a test suite with the right *shape* — many fast tests, few slow ones — and the judgement to know which kind a given question needs.

> 🧠 **The shape matters more than the count.** 500 end-to-end tests is not thoroughness, it is a 40-minute pipeline nobody trusts.

```
        /\        🎭  E2E (Playwright)        a handful    slow, real browser, highest confidence
       /  \       🔌  Integration (Supertest) dozens      real HTTP + real DB, no browser
      /____\      🧩  Component (RTL)         many        renders, no network
     /______\     ⚙️  Unit (Jest)             hundreds    pure logic, milliseconds
```

| Dojo | Teaches | Time | Needs |
|---|---|---|---|
| [`jest/`](jest/README.md) | Unit tests, mocks, spies, fake timers, what *not* to mock | 3–4 h | Node 26 |
| [`react-testing-library/`](react-testing-library/README.md) | Query by role, behaviour over implementation | 3–4 h | `jest/` + React |
| [`supertest/`](supertest/README.md) | Real HTTP against Express, no server running | 2–3 h | `jest/` + the Express dojo |
| [`playwright/`](playwright/README.md) | One real browser journey, traces, fixtures | 4–5 h | A running app |

🚪 **Shelf gate:** for any given bug, say which layer should have caught it — and write that test *first*, watching it fail before you fix anything.
