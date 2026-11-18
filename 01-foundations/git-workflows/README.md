# 🌿 Git workflows

**Time:** 2–3 h · **Needs:** Git, a GitHub account · **You finish with:** a conflict you caused and resolved on purpose, and a merged pull request.

> 🧠 **The one idea:** Git stores **snapshots**, not differences. A commit is a complete photograph of the project plus a pointer to its parent. Once that clicks, branches stop being frightening — a branch is a sticky note on one photograph.

```
  A ──► B ──► C         main
              └──► D    feature/x   (D's parent is C. That's the whole model.)
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | The misunderstanding it fixes |
|---|---|---|
| **Commit** | A snapshot + parent + message | Not "a diff". Not "a save" |
| **Branch** | A movable label on a commit | Creating one copies nothing and costs nothing |
| **HEAD** | "Where I am right now" | A detached HEAD means you are on a commit, not a branch |
| **Staging area** | The tray between editing and committing | It exists so you can commit *part* of your work |
| **`merge`** | Joins histories, adds a merge commit | Honest, but noisy on a busy repo |
| **`rebase`** | Replays your commits on a new base | Linear history — but it **rewrites** commits |
| **`fetch` vs `pull`** | `fetch` downloads; `pull` = fetch + merge/rebase | `pull` changes your files, `fetch` never does |
| **Remote-tracking branch** | `origin/main`, your last known view of GitHub | Stale until you `fetch` |

🚦 **The rebase rule:** rebase your **own unpushed** work freely. Never rebase a branch someone else has pulled — their history and yours stop agreeing, and the fix is social, not technical.

---

## 2. 🛠 The drill — break it on purpose

A conflict you created yourself is worth ten you read about.

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Make a sandbox repo | `mkdir git-drill && cd git-drill && git init -b main` |
| ☐ | 2⃣ A first commit | `printf 'port = 3000\n' > config.txt && git add -A && git commit -m "Add config"` |
| ☐ | 3⃣ Branch off | `git switch -c feature/port` |
| ☐ | 4⃣ Change it there | `printf 'port = 8080\n' > config.txt && git commit -am "Use 8080"` |
| ☐ | 5⃣ Change it differently on main | `git switch main` then `printf 'port = 3001\n' > config.txt && git commit -am "Use 3001"` |
| ☐ | 6⃣ 💥 Cause the conflict | `git rebase main` *(from the feature branch)* — switch first with `git switch feature/port` |
| ☐ | 7⃣ Look at the damage | `git status` and open `config.txt` |
| ☐ | 8⃣ Resolve it | edit the file, delete the `<<<`/`===`/`>>>` lines, `git add config.txt`, `git rebase --continue` |
| ☐ | 9⃣ Confirm linear history | `git log --oneline --graph --all` |
| ☐ | 🔟 Practise the panic button | redo steps 3–6, then `git rebase --abort` |

### Then the pull-request half

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Create a repo on GitHub | see [`../../docs/04-create-a-repo-from-scratch.md`](../../docs/04-create-a-repo-from-scratch.md) |
| ☐ | 2⃣ Push a feature branch | `git push -u origin feature/port` |
| ☐ | 3⃣ Open the PR | `gh pr create --fill` or the link GitHub prints |
| ☐ | 4⃣ Review your own diff | on the **Files changed** tab — read it as a stranger |
| ☐ | 5⃣ Merge it | `gh pr merge --squash --delete-branch` |
| ☐ | 6⃣ Sync your local main | `git switch main && git pull` |

🧐 **Step 4 is the actual skill.** Reading your own diff before anyone else does catches debug logs, commented-out code, secrets and half-finished thoughts. It is the cheapest code review in existence.

---

## 3. 🚪 The gate

> You can create a conflict deliberately, resolve it, and explain in one sentence what `rebase --abort` undid. You can open, review and squash-merge a pull request from the command line. And when something goes wrong, your first instinct is `git status`, not a web search.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🛠 Instead |
|---|---|
| `git add .` then committing blind | `git add -A`, then **`git status`**, then `git diff --staged` |
| `git commit -m "fix"` | Say what and why: `Fix token expiry check in auth middleware` |
| `git push --force` on a shared branch | `--force-with-lease`, and only on your own branch |
| Working directly on `main` | Branch per change, even alone. It keeps `main` deployable |
| Committing a `.env` | `git check-ignore -v .env` before your first commit ever |
| Panicking and deleting the folder | `git reflog` — it is almost certainly recoverable |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Command reference | <https://git-scm.com/docs> |
| Pro Git, free and complete | <https://git-scm.com/book/en/v2> |
| GitHub flow | <https://docs.github.com/en/get-started/using-github/github-flow> |
| `gh` CLI manual | <https://cli.github.com/manual/> |

🧯 Recovery commands live in [`../../docs/05-git-daily-driver.md`](../../docs/05-git-daily-driver.md).

➡️ **Next:** [`../http-fundamentals/`](../http-fundamentals/README.md)
