# 🧩 React Testing Library

**Time:** 3–4 h · **Needs:** Jest + a React app · **You finish with:** component tests that survive a refactor because they only know what a user knows.

> 🧠 **The one idea:** test the component the way a **person** meets it. Find things by their visible text and accessible role, interact the way a user would, assert on what appears. Never reach for a CSS class or a component's internal state.

```
 ❌ "the div with class .btn-primary has state.loading === true"
 ✅ "the button labelled Submit is disabled and says Saving…"
```

---

## 1. 📖 The lesson

### Queries, in the order you should reach for them

| Priority | Query | Why |
|---|---|---|
| 1️⃣ | `getByRole('button', { name: /submit/i })` | How assistive tech finds it. Tests accessibility *for free* |
| 2️⃣ | `getByLabelText('Hours')` | The correct way to find a form field |
| 3️⃣ | `getByPlaceholderText`, `getByText` | Fine when no label exists |
| 4️⃣ | `getByTestId` | Last resort. An admission nothing else identified it |

### `get` vs `query` vs `find` — pick by intent

| Prefix | Returns | Use when |
|---|---|---|
| `getBy…` | Element, **throws** if absent | It must be there now |
| `queryBy…` | Element or `null` | You are asserting **absence** |
| `findBy…` | A **Promise** | It will appear after async work — always `await` |

### The two that fix most flakiness

```ts
// ✅ userEvent, not fireEvent — it simulates a real interaction sequence
await userEvent.click(screen.getByRole('button', { name: /submit/i }));

// ✅ findBy for anything that arrives later; no arbitrary timeouts
expect(await screen.findByText(/saved/i)).toBeInTheDocument();
```

🎯 **`fireEvent` vs `userEvent`:** `fireEvent.click` dispatches one synthetic event. `userEvent.click` does what a human does — pointer down, focus change, pointer up, click — which is why it catches bugs `fireEvent` sails past.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install | `npm install -D @testing-library/react@16.3.3 @testing-library/user-event @testing-library/jest-dom jest-environment-jsdom@30.5.2` |
| ☐ | 2⃣ Config | `testEnvironment: 'jsdom'` in the Jest config |
| ☐ | 3⃣ Setup file | `import '@testing-library/jest-dom'` |
| ☐ | 4⃣ Test the four below | the form and table you built in the React dojo |

| # | Test | Teaches |
|---|---|---|
| 1 | The form renders its fields, found **by label** | Accessible queries |
| 2 | Typing and submitting adds a row to the table | Behaviour across components |
| 3 | Submitting empty shows a validation message | `findBy` for async UI |
| 4 | The submit button is disabled while saving | State as the user perceives it |

```tsx
it('adds an entry to the table when the form is submitted', async () => {
  render(<TimesheetPage />);

  await userEvent.type(screen.getByLabelText(/hours/i), '8');
  await userEvent.type(screen.getByLabelText(/note/i), 'Sprint planning');
  await userEvent.click(screen.getByRole('button', { name: /submit/i }));

  // Asserting on the ROW the user sees — not on any internal state
  expect(await screen.findByRole('row', { name: /sprint planning/i })).toBeInTheDocument();
});

it('shows a validation message when hours is empty', async () => {
  render(<TimesheetPage />);
  await userEvent.click(screen.getByRole('button', { name: /submit/i }));
  expect(await screen.findByText(/hours is required/i)).toBeInTheDocument();
});
```

🧪 **Prove the refactor-resistance:** rename the component, split it in two, move its state into Jotai, swap the `<div>`s for `<section>`s. The tests above still pass — because none of them knew any of that. Then change the button's label and watch them fail, correctly, because that **is** a user-visible change.

🔍 **When a query fails,** RTL prints the whole accessible tree. Read it: the usual cause is a missing `<label>`, which means a real user with a screen reader could not find the field either. The test found an accessibility bug, not a testing problem.

---

## 3. 🚪 The gate

> Test a form-and-table flow using only role- and label-based queries, with `userEvent` for interaction and `findBy` for async results — then refactor the component's internals and watch every test still pass.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| `container.querySelector('.btn')` | `getByRole('button', { name: … })` |
| `getByTestId` as a first move | Fix the accessible name; test IDs last |
| `fireEvent` for user actions | `userEvent` |
| `getBy…` for something async | `await findBy…` |
| `waitFor` with a fixed timeout | `findBy…`, which polls properly |
| Asserting on state or props | Assert on rendered output |
| Forgetting `await` on `userEvent` | Always `await` — it is async |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| React Testing Library | <https://testing-library.com/docs/react-testing-library/intro/> |
| Which query should I use? | <https://testing-library.com/docs/queries/about/#priority> |
| `user-event` | <https://testing-library.com/docs/user-event/intro/> |
| Guiding principles | <https://testing-library.com/docs/guiding-principles/> |
| `jest-dom` matchers | <https://github.com/testing-library/jest-dom> |

➡️ **Next:** [`../supertest/`](../supertest/README.md)
