# ⚛️ State management — atomic state

**Time:** 3–4 h · **Needs:** `../react/` cleared · **You finish with:** shared state across unrelated components with no prop-drilling, built in **Jotai** — plus the ability to read the **Recoil** code you will inherit.

> ⚠️ **Read this before anything else.** **Recoil is archived.** Meta archived `facebookexperimental/Recoil` on **2025-01-01**; the last npm publish was **2024-02-12** (`recoil@0.7.7`). It still installs and still works, and plenty of production code — including stacks whose docs still list it — depends on it. **Do not start new code with it.** This dojo teaches the *model* with Jotai 3.0.2, and teaches Recoil's *syntax* only so you can read and migrate what already exists.
>
> *(Checked against npm metadata and the repository's archive notice on 2026-11-18 — see [VERSIONS.md](../../VERSIONS.md).)*

---

## 1. 📖 The lesson

### The problem being solved

```
 ❌ prop-drilling: the value is needed at the bottom, so every floor carries it

    <App user>  ──►  <Layout user>  ──►  <Sidebar user>  ──►  <Avatar user />
                      (ignores it)       (ignores it)          (actually needs it)

 ✅ atomic state: the bottom reads it directly; nothing between knows it exists

    userAtom ─────────────────────────────────────────────────►  <Avatar />
```

### Your four real options

| 🧰 Option | Good for | Watch out for |
|---|---|---|
| `useState` + lifting | 90% of cases. **Start here** | Deep trees become prop-drilling |
| **Context** | Rarely-changing values: theme, locale, the signed-in user | Every consumer re-renders when the value changes |
| **Atomic (Jotai)** | Many small independent pieces of shared state | One more concept for newcomers |
| **Store (Redux/Zustand)** | One big shared state with strict update rules | Boilerplate; more than most apps need |

🎯 **The honest default:** most "we need a state library" moments are really "we are fetching server data in the wrong place". Ask whether the value is **server state** (it lives in a database, you have a copy) or **client state** (it only exists in this browser). Atoms are for client state.

### The atomic model in three sentences

1. An **atom** is one independent piece of state with no connection to the component tree.
2. A component that reads an atom re-renders when **that** atom changes — and no one else does.
3. A **derived** atom computes from other atoms and recomputes automatically.

### Jotai and Recoil, side by side

| Job | ✅ Jotai 3.0.2 (maintained) | 🪦 Recoil 0.7.7 (archived) |
|---|---|---|
| Create an atom | `const countAtom = atom(0)` | `const countAtom = atom({ key: 'count', default: 0 })` |
| Read + write | `const [c, setC] = useAtom(countAtom)` | `const [c, setC] = useRecoilState(countAtom)` |
| Read only | `useAtomValue(countAtom)` | `useRecoilValue(countAtom)` |
| Write only | `useSetAtom(countAtom)` | `useSetRecoilState(countAtom)` |
| Derived | `atom((get) => get(countAtom) * 2)` | `selector({ key: 'double', get: ({get}) => get(countAtom) * 2 })` |
| Provider | optional | `<RecoilRoot>` required |
| Unique string keys | not needed | **required and globally unique** |

🧠 **The migration is mostly mechanical:** drop the `key`, rename the hooks, turn `selector` into `atom((get) => …)`. What takes real time is `atomFamily` and anything using Recoil snapshots.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Use your React or Next.js app | — |
| ☐ | 2⃣ Install Jotai | `npm install jotai@3.0.2` |
| ☐ | 3⃣ Build the four pieces | below |
| ☐ | 4⃣ Prove the isolation | `console.log` in each component, then change one atom |

| # | Build | Teaches |
|---|---|---|
| 1 | `userAtom` holding the signed-in user, read by three *unrelated* components | No prop-drilling |
| 2 | `entriesAtom` holding a list; a form writes, a table reads | Write-only vs read-only |
| 3 | `totalHoursAtom` **derived** from `entriesAtom` | Derived state — never store what you can compute |
| 4 | A component using `useSetAtom` only | Writing without subscribing to re-renders |

```ts
// atoms.ts
import { atom } from 'jotai';

export const userAtom = atom<{ name: string; role: 'staff' | 'manager' } | null>(null);
export const entriesAtom = atom<{ id: number; hours: number }[]>([]);

// Derived: computed, never stored. Add an entry and this updates itself.
export const totalHoursAtom = atom((get) =>
  get(entriesAtom).reduce((sum, entry) => sum + entry.hours, 0),
);

// Derived + writable: reads one shape, writes another
export const isManagerAtom = atom((get) => get(userAtom)?.role === 'manager');
```

```tsx
// Piece 4 — writing without subscribing. This component NEVER re-renders on change.
import { useSetAtom } from 'jotai';
import { entriesAtom } from './atoms';

export function AddEntryButton() {
  const setEntries = useSetAtom(entriesAtom);
  return (
    <button onClick={() => setEntries((prev) => [...prev, { id: Date.now(), hours: 8 }])}>
      Add 8 hours
    </button>
  );
}
```

🧪 **The experiment:** `console.log` in `<AddEntryButton>` (write-only), `<TotalHours>` (reads the derived atom) and `<UserBadge>` (reads a different atom). Click Add. Only the second logs. `<UserBadge>` is untouched because it reads a different atom, and the button never re-renders because it only writes. **That isolation is the entire selling point** — and it is what Context cannot give you.

---

## 3. 🚪 The gate

> From an empty project: share one piece of state between three unrelated components with no props passed, add a derived atom that recomputes itself, use a write-only hook and prove with logs that it does not re-render — then read a snippet of Recoil code and say what the Jotai equivalent is.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why | ✅ Instead |
|---|---|---|
| Starting a 2026 project on Recoil | Archived since 2025-01-01 | Jotai, or `useState` if the tree is shallow |
| Putting everything in global atoms | Nothing is reusable; everything re-renders | Keep state as local as it can live |
| Storing a value you could compute | Two sources of truth that drift | A derived atom |
| Atoms as a cache for API data | That is server state, with staleness rules | A data-fetching library, or server components |
| `useAtom` when you only write | Subscribes you to pointless re-renders | `useSetAtom` |
| Mutating an atom's array | Same reference, no re-render | Replace it: `[...prev, next]` |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Jotai | <https://jotai.org/docs/introduction> |
| Jotai — derived atoms | <https://jotai.org/docs/guides/composing-atoms> |
| React — when Context is right | <https://react.dev/learn/passing-data-deeply-with-context> |
| React — "You Might Not Need an Effect" | <https://react.dev/learn/you-might-not-need-an-effect> |
| Recoil (archived, read-only, for reference) | <https://recoiljs.org> |

➡️ **Next shelf:** [`../../03-backend/`](../../03-backend/README.md)
