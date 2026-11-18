# 🔧 05 · Git, the daily driver

**Read this when:** you are mid-mess and need the way out, or you want the ten commands that cover 95% of real work.

> 🧒 Every command here is identical on macOS and Windows. Git is the one tool that does not need a two-column table.

---

## 1. 🔁 The loop you will run a thousand times

```
 edit files  →  git add -A  →  git status  →  git commit -m "why"  →  git push
                                   ▲
                      ⚠️ never skip this one
```

| ✅ | Command | Why |
|---|---|---|
| ☐ | `git status` | What changed. Run it before *and* after staging |
| ☐ | `git diff` | The actual lines, unstaged |
| ☐ | `git diff --staged` | The actual lines you are about to commit |
| ☐ | `git add -A` | Stage everything |
| ☐ | `git commit -m "Add X"` | Snapshot, with a reason |
| ☐ | `git push` | Send it up |
| ☐ | `git log --oneline -10` | The last ten commits |

🧐 **The habit that saves you:** `git diff --staged` immediately before every commit. It is the last moment a secret, a stray `console.log` or a 400 MB file can be caught for free.

---

## 2. 🌿 Branches

| 🎯 I want to... | Command |
|---|---|
| See branches | `git branch` |
| Make one and switch to it | `git switch -c feature/jwt-refresh` |
| Switch back | `git switch main` |
| Push a new branch the first time | `git push -u origin feature/jwt-refresh` |
| Bring `main`'s latest into my branch | `git switch main && git pull && git switch - && git rebase main` |
| Delete it locally once merged | `git branch -d feature/jwt-refresh` |
| Rename the branch I am on | `git branch -M main` |

🏷 **Naming that reads well in a PR list:** `feature/…`, `fix/…`, `docs/…`, `chore/…`.

---

## 3. 🧯 Undo — matched to what you actually did

🛑 **Before any of these, run `git status`.** The right undo depends entirely on whether the change is unstaged, staged, committed or pushed.

| 😖 What happened | ✅ Fix | ⚠️ Destroys work? |
|---|---|---|
| Edited a file, want the last committed version back | `git restore path/to/file` | **Yes** — those edits are gone |
| Staged something by mistake | `git restore --staged path/to/file` | No — edits stay, just unstaged |
| Committed too early, nothing pushed | `git reset --soft HEAD~1` | No — changes return to staging |
| Committed with a bad message, nothing pushed | `git commit --amend -m "Better message"` | No |
| Committed to `main`, meant a branch, nothing pushed | `git branch feature/x && git reset --hard HEAD~1 && git switch feature/x` | No — the commit is saved on the branch first |
| Pushed a commit you must reverse | `git revert <sha>` then push | No — adds an opposite commit. **The safe choice on a shared branch** |
| Want to stash work to switch tasks | `git stash -u` … `git stash pop` | No — `-u` includes new files |
| "I have no idea what I just did" | `git reflog` | No — it lists every position HEAD has had |

### 🪄 `git reflog` is the undo nobody knows

Deleted a branch? Botched a rebase? `reset --hard` over something you needed? Git remembers where you were:

```bash
git reflog                  # find the line from before the mistake
git switch -c rescue <sha>  # re-create it as a new branch
```

🧠 Commits are not deleted immediately when they stop being reachable. If it was ever committed, `reflog` can usually bring it back. **If it was never committed, nothing can.**

---

## 4. ⚔️ Resolving a conflict without panic

A conflict means Git cannot decide; it is not an error and nothing is lost.

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ See which files | `git status` |
| ☐ | 2⃣ Open each one | look for `<<<<<<<`, `=======`, `>>>>>>>` |
| ☐ | 3⃣ Edit to the version you want | delete all three marker lines too |
| ☐ | 4⃣ Mark it resolved | `git add path/to/file` |
| ☐ | 5⃣ Finish | `git rebase --continue` (or `git commit` in a merge) |
| ☐ | 🆘 Back out entirely | `git rebase --abort` / `git merge --abort` |

```
<<<<<<< HEAD              ← what is on your branch
const port = 3001;
=======                   ← the dividing line
const port = 8080;
>>>>>>> main              ← what is coming in
```

Keep one, keep both, or write something new. Just make sure no `<`, `=` or `>` marker lines survive — committing them is how conflict markers reach production.

---

## 5. 🚨 Commands to treat as live wires

| ☠️ Command | What it really does | Only when |
|---|---|---|
| `git reset --hard` | Throws away uncommitted work permanently | You are certain you want nothing back |
| `git push --force` | Overwrites remote history, including other people's | Never on a shared branch. Prefer `--force-with-lease` |
| `git clean -fd` | Deletes untracked files and folders | After `git clean -nd` has shown you the list |
| `git checkout .` | Discards every unstaged change | Same caution as `reset --hard` |

🪢 **The safety net:** before any of these, run `git stash -u`. If it turns out you needed that work, `git stash pop` brings it back. If not, stashes cost nothing.

---

## 6. 📚 Official sources

| Topic | Where |
|---|---|
| Full command reference | <https://git-scm.com/docs> |
| Pro Git (free book) | <https://git-scm.com/book/en/v2> |
| GitHub's Git guides | <https://docs.github.com/en/get-started/using-git> |
