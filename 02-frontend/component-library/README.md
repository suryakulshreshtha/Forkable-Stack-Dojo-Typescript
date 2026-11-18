# 🧱 Component library — shadcn/ui + Radix

**Time:** 3–4 h · **Needs:** `../nextjs-app-router/` cleared · **You finish with:** a form, a data table and a dialog whose source lives **in your repo**, keyboard-accessible, styled to your theme.

> 🧠 **The one idea:** shadcn/ui is **not a dependency**. It is a CLI that *copies component source into your project*. You own the files from that moment — edit them, delete them, read them. Underneath sits **Radix UI**, which supplies behaviour and accessibility and zero styling.

```
 Radix primitive            shadcn/ui                     your repo
 (behaviour + a11y,   ──►   (adds Tailwind styling,  ──►  components/ui/dialog.tsx
  no styles)                 copies the file in)           ← yours now. Edit freely
```

---

## 1. 📖 The lesson

### Why "copy it in" beats "install it"

| | 📦 Classic library (install) | 📋 shadcn/ui (copy in) |
|---|---|---|
| Need a different border radius | Fight the theme API, or `!important` | Open the file, change the class |
| Need one extra prop | Wrap it, or open an upstream issue | Add the prop |
| A breaking major version lands | Migration, across your whole app | Nothing happens. It is your file |
| Bundle size | Whatever the library weighs | Only the components you took |
| Trade-off | Updates arrive for free | ⚠️ **You** apply upstream fixes yourself |

🎯 Pick "copy in" when you intend to own your design system. Pick a classic library when you want someone else to maintain it. Both are defensible — this repo teaches the first because the skill transfers.

### What Radix gives you that hand-rolling will not

A `<div>` with an `onClick` is not a dialog. A real dialog needs: focus moved in on open, focus **trapped** inside, `Escape` to close, focus returned to the trigger on close, the background made inert, `aria-modal` and labelling, and scroll locking.

| 🧩 Primitive | Behaviour you would otherwise write by hand |
|---|---|
| `Dialog` | Focus trap, restore focus, `Escape`, inert background, ARIA |
| `Select` | Keyboard navigation, typeahead, collision-aware positioning |
| `Popover` | Click-outside, portals, flipping when it hits the viewport edge |
| `Tabs` | Arrow-key navigation, correct `role`/`aria-selected` wiring |
| `Tooltip` | Hover **and** focus triggers, delay, touch handling |

♿ **Accessibility is not a feature you add later.** It is behaviour, and behaviour is code. This is the strongest argument for primitives.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Work in your Next.js app | `cd ../nextjs-app-router/drill` |
| ☐ | 2⃣ Initialise shadcn/ui | `npx shadcn@4.23.0 init` |
| ☐ | 3⃣ Read its answers | it writes `components.json` and a `cn()` helper — open both |
| ☐ | 4⃣ Add components | `npx shadcn@4.23.0 add button input label table dialog form` |
| ☐ | 5⃣ 🔍 **Read what landed** | open `components/ui/button.tsx`. This is the dojo's real moment |
| ☐ | 6⃣ Build the three pieces | below |
| ☐ | 7⃣ Test with the keyboard only | Tab, Enter, Escape, arrows — **unplug your mouse** |

| # | Build | Teaches |
|---|---|---|
| 1 | A timesheet form: `Input`, `Label`, `Button`, validation messages | Composition and labelling |
| 2 | A `Table` listing entries, with a status badge | Styling a semantic table |
| 3 | A `Dialog` confirming deletion, opened from a row | Focus management you did not write |

```tsx
// Piece 3 — composition is the pattern. Each part is a real element with real ARIA.
import { Dialog, DialogContent, DialogDescription, DialogFooter,
         DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';

export function ConfirmDelete({ onConfirm }: { onConfirm: () => void }) {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="destructive">Delete</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Delete this entry?</DialogTitle>
          <DialogDescription>This cannot be undone.</DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <Button variant="destructive" onClick={onConfirm}>Yes, delete</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
```

🧠 **`asChild` is the clever bit.** It tells Radix: "do not render your own element — give your behaviour and ARIA attributes to my child instead." That is how a styled `<Button>` becomes a dialog trigger without a wrapper `<div>` in the way.

🧪 **The keyboard test is the gate, really.** Open the dialog with Tab + Enter. Is focus inside? Does Tab cycle within it? Does Escape close it *and* return focus to the Delete button? If yes, you got all of that from a primitive, for free. That is the point.

---

## 3. 🚪 The gate

> From your Next.js app: initialise shadcn/ui, add components, build a form + table + confirmation dialog, operate the whole flow with the keyboard alone, and explain what `asChild` does and why the component source lives in your repo rather than `node_modules`.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| Treating `components/ui/*` as untouchable | Edit it. That is the entire design |
| Re-running `add` and overwriting your edits | Check the diff before accepting; the CLI will prompt |
| A `<div onClick>` instead of a primitive | You lose focus, keyboard and ARIA, and will not notice |
| Dropping `<DialogTitle>` | Screen readers announce an unnamed dialog |
| Styling by wrapping in another `<div>` | Edit the component's own classes |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| shadcn/ui | <https://ui.shadcn.com/docs> |
| Radix Primitives | <https://www.radix-ui.com/primitives/docs/overview/introduction> |
| Radix `asChild` / composition | <https://www.radix-ui.com/primitives/docs/guides/composition> |
| WAI-ARIA Authoring Practices (what "accessible" means) | <https://www.w3.org/WAI/ARIA/apg/> |

➡️ **Next:** [`../tailwind/`](../tailwind/README.md)
