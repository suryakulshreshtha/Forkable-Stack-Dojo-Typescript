# 🎭 Playwright

**Time:** 4–5 h · **Needs:** a running app · **You finish with:** one trustworthy end-to-end journey, a trace you can replay, and a clear sense of why there should be few of these.

> 🧠 **The one idea:** E2E tests are the only ones that prove the *whole system* works — and the slowest, flakiest and most expensive to maintain. So they get the **critical journeys only**: sign in, do the one thing the product exists for, see the result.

```
 ✅ 5 E2E tests that always pass  →  a signal people act on
 ❌ 200 E2E tests, 6 flaky       →  a red pipeline everyone learns to ignore
```

---

## 1. 📖 The lesson

### Why Playwright flakes less than what came before

| 🔧 Feature | What it removes |
|---|---|
| **Auto-waiting** | Elements are waited for automatically — no `sleep`, no explicit waits |
| **Web-first assertions** | `expect(locator).toBeVisible()` retries until timeout |
| **Locators are lazy** | Resolved at use, not at creation — stale element errors disappear |
| **Browser contexts** | A fresh, isolated profile per test, in milliseconds |
| **Trace viewer** | A recording with DOM snapshots, network and console at every step |

### Locators, best to worst

| Priority | Locator | Why |
|---|---|---|
| 1️⃣ | `getByRole('button', { name: 'Submit' })` | What a user and a screen reader see |
| 2️⃣ | `getByLabel('Hours')` | Form fields |
| 3️⃣ | `getByText('Saved')` | Visible content |
| 4️⃣ | `getByTestId('submit')` | When the DOM gives you nothing else |
| 🚫 | `page.locator('.css-1x9f3h')` | A generated class. Breaks on the next build |

### 🚨 The number one cause of flaky E2E tests

```ts
await page.waitForTimeout(2000);   // ❌ a guess. Too short on CI, too slow locally
await expect(page.getByText('Saved')).toBeVisible();   // ✅ waits for the actual condition
```

Every fixed sleep is a bet on someone else's machine speed. Playwright's assertions retry, so you never need to place that bet.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install | `npm init playwright@latest` |
| ☐ | 2⃣ Browsers (the step people miss) | `npx playwright install` |
| ☐ | 3⃣ Env | `cp .env.example .env` and set `BASE_URL` |
| ☐ | 4⃣ Write the three journeys below | — |
| ☐ | 5⃣ Run headless | `npx playwright test` |
| ☐ | 6⃣ Watch it drive the browser | `npx playwright test --headed` |
| ☐ | 7⃣ Debug step by step | `npx playwright test --ui` |
| ☐ | 8⃣ Read a trace | `npx playwright show-report` |

| # | Journey | Why it earns an E2E slot |
|---|---|---|
| 1 | Sign in → land on the timesheet page | If this breaks, nothing else matters |
| 2 | Create an entry → see it in the table | The product's reason to exist |
| 3 | Manager approves an entry → status changes | The cross-role flow no lower test covers |

```ts
// playwright.config.ts — the settings that matter
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  use: {
    baseURL: process.env.BASE_URL ?? 'http://localhost:3000',
    trace: 'on-first-retry',          // 🎯 a full recording of any flake, no extra cost
    screenshot: 'only-on-failure',
  },
  retries: process.env.CI ? 2 : 0,    // retry on CI only; locally a flake should annoy you
  webServer: {                        // Playwright starts your app and waits for it
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

```ts
// e2e/timesheet.spec.ts
import { test, expect } from '@playwright/test';

test('a staff member submits an entry and sees it listed', async ({ page }) => {
  await page.goto('/login');

  await page.getByLabel('Email').fill(process.env.TEST_USER_EMAIL!);
  await page.getByLabel('Password').fill(process.env.TEST_USER_PASSWORD!);
  await page.getByRole('button', { name: 'Sign in' }).click();

  // Assert the navigation happened, by what the user can see
  await expect(page.getByRole('heading', { name: 'Timesheets' })).toBeVisible();

  await page.getByLabel('Hours').fill('8');
  await page.getByLabel('Note').fill('Sprint planning');
  await page.getByRole('button', { name: 'Submit' }).click();

  // Web-first assertion: retries until the row appears, or fails with a trace
  await expect(page.getByRole('row', { name: /sprint planning/i })).toBeVisible();
});
```

🧪 **Learn the trace viewer — it is the real skill.** Break a selector on purpose, let the test fail, then `npx playwright show-report` and click the failed step. You get the DOM at that instant, the network calls, the console, and a before/after screenshot. Debugging E2E failures without it is guesswork; with it, it is reading.

🔐 **Speed tip for later:** logging in through the UI in every test is slow. Playwright can sign in once and save the storage state, then reuse it. Read the authentication guide below once you have three or more tests.

---

## 3. 🚪 The gate

> From a fresh Playwright install: write one complete multi-page journey using role- and label-based locators, with **no** `waitForTimeout` anywhere, configured so Playwright starts the app itself and captures a trace on retry — then debug a deliberately broken selector using only the trace viewer.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why | ✅ Instead |
|---|---|---|
| `waitForTimeout` | Guessing at timing | Web-first assertions |
| CSS-class locators | Generated classes change every build | `getByRole` / `getByLabel` |
| Testing every form in E2E | A 40-minute pipeline nobody trusts | Push detail down to RTL/Supertest |
| Tests sharing one user and dataset | Order-dependent failures | Isolated data per test |
| Forgetting `npx playwright install` | "Executable doesn't exist" | Run it after installing |
| Retrying locally to get green | Hides a real race condition | Retries on CI only; fix local flakes |
| Signing in through the UI every test | Minutes of waste | Saved storage state |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Getting started | <https://playwright.dev/docs/intro> |
| Locators | <https://playwright.dev/docs/locators> |
| Web-first assertions | <https://playwright.dev/docs/best-practices> |
| Trace viewer | <https://playwright.dev/docs/trace-viewer> |
| Authentication (reuse sign-in) | <https://playwright.dev/docs/auth> |
| CI setup | <https://playwright.dev/docs/ci> |

➡️ **Next shelf:** [`../../05-quality/`](../../05-quality/README.md)
