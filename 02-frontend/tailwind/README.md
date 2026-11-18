# 🎨 Tailwind CSS

**Time:** 2–3 h · **Needs:** Node 26 · **You finish with:** a responsive, dark-mode-aware layout built from utilities, and a theme defined in CSS rather than JavaScript.

> 🧠 **The one idea:** you stop naming things. There is no `.card-header-title--large` to invent, maintain and eventually fear deleting. You compose from small, fixed utilities, and the design system lives in the constraints.

```
  ❌ write CSS elsewhere:  .btn { padding: .5rem 1rem; border-radius: .5rem; }
  ✅ compose in place:     <button class="px-4 py-2 rounded-lg">
```

---

## 1. 📖 The lesson

| 🧩 Concept | Example | What it means |
|---|---|---|
| **Utility** | `p-4`, `flex`, `text-sm` | One class, one declaration |
| **Scale** | `p-1 p-2 p-4 p-8` | Spacing comes from a scale, not arbitrary pixels — that is the consistency |
| **Responsive prefix** | `md:flex-row` | Applies **from** that breakpoint **up**. Mobile-first, always |
| **State prefix** | `hover:`, `focus:`, `disabled:` | Variants without writing a pseudo-selector |
| **Dark mode** | `dark:bg-slate-900` | Paired with a `dark` class or the OS preference |
| **Arbitrary value** | `w-[73px]` | The escape hatch. Each use is a small admission the scale did not fit |
| **`@theme`** (v4) | CSS, not `tailwind.config.js` | v4 moved configuration **into CSS** |
| **`cn()` helper** | `cn('p-4', isActive && 'bg-blue-600')` | Merges conditional classes and resolves conflicts |

### 🆕 What changed in v4

| v3 habit | v4 reality |
|---|---|
| `tailwind.config.js` with a JS theme object | A CSS file with `@import "tailwindcss"` and an `@theme { }` block |
| `content: [...]` globs to scan | Automatic content detection |
| `@tailwind base; @tailwind components; @tailwind utilities;` | One `@import "tailwindcss";` |

```css
/* v4: your theme IS css. app/globals.css */
@import "tailwindcss";

@theme {
  --color-brand: oklch(0.55 0.21 265);   /* now usable as bg-brand, text-brand… */
  --font-display: "Inter", sans-serif;
  --spacing-gutter: 1.5rem;
}
```

*(Tailwind 4.3.5 read from the npm registry on 2026-11-18.)*

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Use your Next.js app (Tailwind already set up) | `cd ../nextjs-app-router/drill` |
| ☐ | 2⃣ Or standalone | `npm install -D tailwindcss@4.3.5` and `@import "tailwindcss";` in your CSS |
| ☐ | 3⃣ Build the four pieces | below |
| ☐ | 4⃣ Test by dragging the window narrow→wide | breakpoints should click into place |

| # | Build | Teaches |
|---|---|---|
| 1 | A card: padding, rounded corners, border, shadow — utilities only | The scale |
| 2 | Stacked on mobile, side by side from `md:` up | Mobile-first responsive |
| 3 | `hover:` and `focus-visible:` states on a button | State variants, and why `focus-visible` not `focus` |
| 4 | A `--color-brand` in `@theme`, used as `bg-brand` | v4's CSS-first theming |

```tsx
// Pieces 1–3 together. Read the class list as a sentence, left to right.
<div className="flex flex-col gap-4 md:flex-row md:items-center
                rounded-lg border border-slate-200 p-6 shadow-sm
                dark:border-slate-800 dark:bg-slate-900">
  <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-100">
    This week
  </h2>
  <button className="rounded-md bg-brand px-4 py-2 text-white
                     transition-colors hover:bg-brand/90
                     focus-visible:outline-2 focus-visible:outline-offset-2
                     disabled:cursor-not-allowed disabled:opacity-50">
    Submit
  </button>
</div>
```

♿ **Why `focus-visible:` and not `focus:`** — `focus:` shows the ring to mouse users too, so people delete it, and keyboard users lose the only indicator they have. `focus-visible:` shows it when it is actually needed. Never remove a focus ring without replacing it.

---

## 3. 🚪 The gate

> From an empty component: build a responsive card that stacks on mobile and goes horizontal at `md:`, with a button that has hover, focus-visible and disabled states, using a colour you defined yourself in `@theme` — with no custom CSS file and no arbitrary values.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why | ✅ Instead |
|---|---|---|
| `w-[73px]` everywhere | You have left the design system | Use the scale; reserve arbitrary values for genuine one-offs |
| Desktop-first (`sm:` to shrink things) | Fighting the framework's direction | Style mobile unprefixed, add `md:` upward |
| Class lists 40 utilities long | Unreadable | Extract a component, not a CSS class |
| Reaching for `!important` | A specificity fight you created | Resolve conflicts with `cn()`/`tailwind-merge` |
| Deleting focus rings for looks | Keyboard users lose their place | Restyle `focus-visible:`, never remove it |
| Writing a `.css` file out of habit | Two systems to reason about | Utilities, or `@theme` for real design tokens |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Documentation | <https://tailwindcss.com/docs> |
| Theme variables (`@theme`) | <https://tailwindcss.com/docs/theme> |
| Responsive design | <https://tailwindcss.com/docs/responsive-design> |
| Dark mode | <https://tailwindcss.com/docs/dark-mode> |
| Upgrading to v4 | <https://tailwindcss.com/docs/upgrade-guide> |

➡️ **Next:** [`../state-management/`](../state-management/README.md)
