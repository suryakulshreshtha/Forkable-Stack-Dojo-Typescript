# 🔗 References

Outside material used while building these dojos, or worth reading alongside them.

> ⚖️ **These are not sources of fact.** Every factual claim in this repo comes from official documentation, listed in [SOURCES.md](SOURCES.md), and every version number from the methods in [VERSIONS.md](VERSIONS.md). What follows is context, comparison and opinion — labelled as such.

---

## 🥋 Sibling repos in this series

| Repo | Why it is relevant |
|---|---|
| [ForkableTypescriptPostgreReactNodejsLearning](https://github.com/suryakulshreshtha/ForkableTypescriptPostgreReactNodejsLearning) | A full-stack app with a real test pyramid — the "now build something with it" companion to this repo |
| [ForkableFullStackQASuite](https://github.com/suryakulshreshtha/ForkableFullStackQASuite) | Two Playwright suites (TypeScript + Python) against one shared test plan |
| [Forkable-DevOps-Complete-StarterPack-To-FullSend](https://github.com/suryakulshreshtha/Forkable-DevOps-Complete-StarterPack-To-FullSend) | Where `06-devops/` goes next: Kubernetes, Terraform, SLOs, supply-chain security |
| [ForkableInterviewToolkit](https://github.com/suryakulshreshtha/ForkableInterviewToolkit) | How to talk about all of this in an interview |
| [Forkable-Playwright-Python-ECommerce-Automation-Testing](https://github.com/suryakulshreshtha/Forkable-Playwright-Python-ECommerce-Automation-Testing) | The same teaching approach applied to QA, in Python |

## 📖 Worth reading, by topic

| Topic | Where | What it is |
|---|---|---|
| Example apps | <https://github.com/vercel/next.js/tree/canary/examples> | Official Next.js examples — read the structure, not the styling |
| Testing philosophy | <https://testing-library.com/docs/guiding-principles/> | Why queries are ranked the way they are |
| Playwright practice | <https://playwright.dev/docs/best-practices> | The maintainers' own advice on flakiness |
| Secure coding | <https://cheatsheetseries.owasp.org/> | OWASP cheat sheets — short, specific, practical |
| Git recovery | <https://git-scm.com/book/en/v2> | Pro Git, free and complete |
| `.gitignore` templates | <https://github.com/github/gitignore> | Start here rather than writing one from memory |
| Licence chooser | <https://choosealicense.com> | Plain-English licence comparison |

## 🗣 Opinions held in this repo

Stated so you can argue with them. None of these is a fact.

| 💬 Opinion | 🤔 Reasoning |
|---|---|
| E2E suites should stay small | Slow, flaky suites get ignored, and an ignored suite is worth less than no suite |
| Warnings should be errors, or deleted | A warning nobody must fix trains everyone to scroll past output |
| Prefer `unknown` to `any`, always | `any` removes checking from everything downstream, silently |
| Own your component source (shadcn/ui) | For a learning repo, reading the component is half the value |
| Teach current stable, not what a stack happens to pin | Pins are a snapshot of one team's constraints; the skill is the transferable part |
| Learn imperative IaC before declarative | Idempotency is the concept; Terraform/Bicep make sense once you have hand-written it |
| Gate quality on new code, not all code | A permanently red dashboard is a dashboard nobody opens |

## 🧾 How to add to this file

Found something that genuinely helped? Add a row with **what it is** and **why it helped** — not just a link. A bare URL ages into a mystery.
