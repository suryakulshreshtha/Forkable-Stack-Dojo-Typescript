# ⚛️ React

**Time:** 5–7 h · **Needs:** Node 26 · **You finish with:** a component tree you can reason about, a custom hook you wrote, and the ability to say *why* something re-rendered.

> 🧠 **The one idea:** you never update the screen. You update **state**, and React works out the new screen. Your job is to describe what the UI looks like *for a given state* — never to reach in and change it.

```
  state changes  ──►  React re-runs your component  ──►  compares output  ──►  patches the DOM
      ▲                                                                            │
      └────────────────────── user clicks something ◄──────────────────────────────┘
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | The trap it removes |
|---|---|---|
| **Component** | A function returning JSX | It is just a function. It re-runs. Often |
| **Props** | Arguments passed in | Read-only. A child never edits its props |
| **State** | Memory that survives re-renders | `let x = 0` inside a component resets every render; `useState` does not |
| **`useState`** | Declares that memory | Setting it is **asynchronous** — reading it on the next line gives the old value |
| **`useEffect`** | Runs code *after* render, for outside systems | Not a "run this when the component loads" box. It is for syncing with things React does not control |
| **Dependency array** | When the effect re-runs | `[]` = once. Missing deps = stale closures. Wrong deps = infinite loops |
| **`useMemo` / `useCallback`** | Cache a value / a function | Optimisations. Adding them everywhere makes things *slower* |
| **Custom hook** | A function calling other hooks | How you reuse logic without copying it |
| **Keys** | Identity in a list | `key={index}` breaks when the list reorders. Use a stable id |
| **Lifting state** | Moving state to a common parent | The fix for "two components need the same value" |

### ⚠️ The three that bite everyone

```jsx
// 1. State updates are asynchronous
const [count, setCount] = useState(0);
function onClick() {
  setCount(count + 1);
  setCount(count + 1);          // ❌ both read the SAME old count → +1, not +2
  setCount((c) => c + 1);       // ✅ the updater form reads the latest → safe
}

// 2. The effect that never stops
useEffect(() => {
  setItems([...items, newItem]);   // ❌ changes `items` → effect re-runs → forever
}, [items]);

// 3. key={index} loses track of identity
{rows.map((row, i) => <Row key={i} />)}      // ❌ delete row 0, everything shifts
{rows.map((row)    => <Row key={row.id} />)} // ✅ identity is stable
```

🧠 **When do you actually need `useEffect`?** Less often than you think. Not for transforming data for display (do it during render), not for responding to a click (do it in the handler). Yes for: subscriptions, timers, event listeners, and syncing with something outside React.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ A React app with a build tool | `npm create vite@latest drill -- --template react-ts` |
| ☐ | 2⃣ Install and run | `cd drill && npm install && npm run dev` |
| ☐ | 3⃣ Build the four pieces below | — |
| ☐ | 4⃣ Prove the re-renders | add `console.log('render: X')` at the top of each component and watch the console as you type |

### Build these four

| # | Build | Teaches |
|---|---|---|
| 1 | A `<TimesheetForm>` with controlled `hours` and `note` inputs | Controlled inputs; state as the single source of truth |
| 2 | A `<TimesheetTable>` rendering a list with stable `key`s | Lists and identity |
| 3 | State lifted to a common parent so the form's submit updates the table | Lifting state — the core skill of this dojo |
| 4 | A custom `useLocalStorage(key, initial)` hook, used for the list | Reuse without copy-paste; `useEffect` for a genuinely external system |

```ts
// Piece 4 — the shape to aim for
function useLocalStorage<T>(key: string, initial: T) {
  const [value, setValue] = useState<T>(() => {
    const stored = localStorage.getItem(key);      // read once, lazily
    return stored ? (JSON.parse(stored) as T) : initial;
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value));   // sync OUT to the browser
  }, [key, value]);

  return [value, setValue] as const;    // `as const` keeps the tuple types
}
```

🧪 **The experiment that teaches the most:** put `console.log` in the form *and* the table. Type one character in the form. Watch the table re-render too, even though its data did not change. Now wrap the table in `React.memo` and watch it stop. **That** is what memoisation is for — and why using it before you have measured is guesswork.

---

## 3. 🚪 The gate

> From an empty Vite project: build a form and a list that share lifted state, write a custom hook that syncs to `localStorage`, use the updater form of `setState` and explain why, and point at any component and say what makes it re-render.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why | ✅ Instead |
|---|---|---|
| Mutating state: `items.push(x)` | React compares by reference; same array = no re-render | `setItems([...items, x])` |
| `useEffect` to derive display data | An extra render and a stale risk | Compute it during render |
| `key={index}` | Identity breaks on reorder/delete | A stable `id` |
| `useCallback`/`useMemo` everywhere | Each has a cost; most add nothing | Measure first, then memoise |
| Reading state right after setting it | You get the old value | The updater form, or wait for the next render |
| One giant component | Nothing is reusable or testable | Split by responsibility |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Learn React (the official course) | <https://react.dev/learn> |
| "You Might Not Need an Effect" — read this twice | <https://react.dev/learn/you-might-not-need-an-effect> |
| Hooks reference | <https://react.dev/reference/react/hooks> |
| Thinking in React | <https://react.dev/learn/thinking-in-react> |

➡️ **Next:** [`../nextjs-app-router/`](../nextjs-app-router/README.md)
