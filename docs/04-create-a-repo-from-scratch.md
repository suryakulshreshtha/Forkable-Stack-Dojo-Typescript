# 🏗 04 · Create a repo from scratch — the whole way

**Time:** 30–45 minutes the first time, 5 minutes once you know it · **You finish with:** your own repository on GitHub, with a README, a licence, a description, topics, a link preview image and a protected default branch.

> 🧒 **Starting from zero.** This page does not assume you have ever made a repository. It explains what each command *does*, not just what to type. Every command is shown for macOS **and** Windows.

---

## 📑 Contents

| # | Stage | Time |
|---|---|---|
| 0 | [🧠 What a repo actually is](#0--what-a-repo-actually-is) | 3 min |
| 1 | [🏷 Choose the name](#1--choose-the-name) | 2 min |
| 2 | [📁 Make the folder and start Git](#2--make-the-folder-and-start-git) | 3 min |
| 3 | [📄 The four files every repo needs](#3--the-four-files-every-repo-needs) | 10 min |
| 4 | [💾 Your first commit](#4--your-first-commit) | 5 min |
| 5 | [🔑 Let your machine talk to GitHub](#5--let-your-machine-talk-to-github) | 5 min |
| 6 | [☁️ Create the repo on GitHub](#%EF%B8%8F-6--create-the-repo-on-github) | 3 min |
| 7 | [🔗 Connect and push](#-7--connect-and-push) | 3 min |
| 8 | [✨ Polish: About, topics, preview image](#-8--polish-about-topics-preview-image) | 5 min |
| 9 | [🛡 Protect the default branch](#-9--protect-the-default-branch) | 3 min |
| 10 | [🃏 Add it to the card kit](#-10--add-it-to-the-card-kit) | 5 min |
| 11 | [🧯 When the push fails](#-11--when-the-push-fails) | — |

---

## 0. 🧠 What a repo actually is

A repository is **a folder with a memory**. That memory is one hidden sub-folder called `.git`.

```
 MyProject/              ← an ordinary folder
 ├── .git/               ← the memory. Delete this and it is just a folder again
 ├── README.md
 └── src/
```

| 🧩 Word | 🧒 Plain meaning |
|---|---|
| **Repository (repo)** | A folder Git is watching |
| **Commit** | A saved snapshot, with a message saying why |
| **Staging area** | The tray you put changes on *before* snapshotting them |
| **Branch** | A line of commits. `main` is the default one |
| **Remote** | A copy of the repo somewhere else. `origin` is the usual nickname for GitHub's copy |
| **Push** | Send your commits to the remote |
| **Clone** | Download a repo, memory and all |

🔑 **Two separate things, and beginners merge them:** `git init` makes a repo **on your machine**. Creating a repo **on GitHub** is a different act. §6 and §7 exist to join them.

---

## 1. 🏷 Choose the name

The name goes in the URL forever, so spend two minutes on it.

| ✅ Good | ❌ Avoid | Why |
|---|---|---|
| `Forkable-Stack-Dojo-Typescript` | `my-project-final-v2` | The name should say what it is |
| Hyphens between words | Spaces, `_`, emoji | Spaces become `%20` in URLs |
| Consistent with your other repos | A new convention each time | A prefix like `Forkable*` makes your profile scannable |
| Searchable words a stranger would type | Private jokes | People find repos by keyword |

💡 **A naming convention is free branding.** Once every learning repo starts with `Forkable`, your profile reads as a deliberate series rather than a pile.

---

## 2. 📁 Make the folder and start Git

| ✅ | Step | 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|---|---|
| ☐ | 1⃣ Go where your repos live | `cd ~/Desktop/GitHubPushes` | `cd $HOME\Desktop\GitHubPushes` |
| ☐ | 2⃣ Make the folder | `mkdir My-New-Repo` | `mkdir My-New-Repo` |
| ☐ | 3⃣ Enter it | `cd My-New-Repo` | `cd My-New-Repo` |
| ☐ | 4⃣ Start the memory | `git init -b main` | `git init -b main` |
| ☐ | 5⃣ Check | `git status` | `git status` |

**Step 5 expected output:**

```
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

| 🧩 Piece of `git init -b main` | 🧒 Meaning |
|---|---|
| `git init` | Create the `.git` memory folder here |
| `-b main` | Name the first branch `main` |

> 🌿 **Why `main` and not `master`?** GitHub creates new repos with `main`. If your local branch is `master` and the remote expects `main`, your first push creates a *second* branch and nothing appears on the front page. Set it once, globally: `git config --global init.defaultBranch main`.

---

## 3. 📄 The four files every repo needs

An empty repo is a dead repo. These four turn it into something a stranger can use.

| 📄 File | Answers | Without it |
|---|---|---|
| `README.md` | "What is this and how do I run it?" | Nobody can use your work, including you in six months |
| `.gitignore` | "What must Git never save?" | You commit `node_modules/` and your `.env` 🚨 |
| `LICENSE` | "What am I allowed to do with this?" | Legally nobody may reuse it, even if it is public |
| `.editorconfig` | "Tabs or spaces? Which line endings?" | Pointless diffs between macOS and Windows |

### 3a · README.md

| ✅ | Step | 🍎 macOS | 🪟 Windows |
|---|---|---|---|
| ☐ | Create it | `printf '# My New Repo\n\nWhat it is, in one sentence.\n' > README.md` | `Set-Content README.md "# My New Repo"` |
| ☐ | Open and write properly | `code README.md` | `code README.md` |

A README that works, in order: **what it is** (one sentence) → **why it exists** → **how to run it** (exact commands) → **what it needs** (Node version, env vars) → **licence**.

### 3b · .gitignore

Do not write one from memory. Start from GitHub's maintained template:

| 🎯 | Where |
|---|---|
| Official templates, per language | <https://github.com/github/gitignore> |
| The Node one | `Node.gitignore` in that repo |

🚨 **Add these three lines yourself**, every time, before the first commit:

```gitignore
.env
.env.local
!.env.example
```

### 3c · LICENSE

| 🪪 Licence | In one line | Pick it when |
|---|---|---|
| **MIT** | "Do what you like, keep my name on it" | Simplest, most common for learning repos |
| **Apache-2.0** | MIT plus an explicit patent grant | You want the patent clause (this repo uses it) |
| **No licence** | "All rights reserved" by default | You genuinely do not want reuse |

Easiest route: let GitHub add it for you in §6, or copy the text from <https://choosealicense.com>.

### 3d · .editorconfig

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
indent_style = space
indent_size = 2
```

---

## 4. 💾 Your first commit

A commit is two moves: **stage** what you want, then **snapshot** it.

```
 working folder  ──git add──►  staging area  ──git commit──►  history
   (you edit)                   (the tray)                    (permanent)
```

| ✅ | Step | Command (identical both OSes) | What it does |
|---|---|---|---|
| ☐ | 1⃣ See what Git noticed | `git status` | Untracked files appear in red |
| ☐ | 2⃣ Stage your files | `git add README.md .gitignore LICENSE .editorconfig` | Puts them on the tray |
| ☐ | 3⃣ **Check the tray** | `git status` | They should now be green. **Read this list** |
| ☐ | 4⃣ Snapshot it | `git commit -m "Initial commit: README, licence, ignore rules"` | Saves it, with a reason |
| ☐ | 5⃣ See the history | `git log --oneline` | One line, your commit |

> 🧐 **Why step 3 is not optional.** `git add .` stages *everything*, including files you never looked at. Running `git status` afterwards is how you catch a `.env`, a 400 MB dataset or an API key **before** it enters history — where removing it is painful and the secret must be rotated anyway. Every time: stage, **look**, commit.

### ✍️ Commit messages

| ✅ Good | ❌ Bad |
|---|---|
| `Add JWT verification middleware` | `fix` |
| `Fix PATH example for Apple Silicon` | `stuff` |
| `Remove committed .env and rotate secret` | `asdf` |

🧠 Write it as the end of the sentence *"If applied, this commit will…"*. Present tense, says **why** where the diff only shows **what**.

---

## 5. 🔑 Let your machine talk to GitHub

Your first push will ask who you are. **Your GitHub account password will not work** — it has not been accepted for Git operations for years. Choose one of these.

| 🔐 Method | How it works | Best for |
|---|---|---|
| **GitHub CLI** (`gh auth login`) | Logs in via the browser, configures Git for you | Easiest, recommended |
| **Personal Access Token (PAT)** | A generated token used *instead of a password* | No CLI, HTTPS remotes |
| **SSH key** | A key pair; GitHub holds the public half | No passwords ever again |

### Option A · GitHub CLI (recommended)

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `brew install gh` | `winget search GitHub.cli` then `winget install GitHub.cli` |
| `gh auth login` | `gh auth login` |
| Choose **GitHub.com** → **HTTPS** → **Yes** (authenticate Git) → **Login with a web browser** | Same four answers |
| Check: `gh auth status` | Check: `gh auth status` |

### Option B · Personal Access Token

| ✅ | Step |
|---|---|
| ☐ | GitHub → your avatar → **Settings** → **Developer settings** → **Personal access tokens** |
| ☐ | Generate a **fine-grained** token, scoped to the repos you need, with **Contents: Read and write** |
| ☐ | Set a short expiry. Copy it — you will never see it again |
| ☐ | When Git asks for a **password**, paste the **token** |

🔴 A PAT is a password. It belongs in your OS keychain or credential manager, never in a file, a commit or a chat message.

### Option C · SSH key

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `ssh-keygen -t ed25519 -C "you@example.com"` | `ssh-keygen -t ed25519 -C "you@example.com"` |
| Press Return three times (default path, optional passphrase) | Same |
| `pbcopy < ~/.ssh/id_ed25519.pub` | `Get-Content $HOME\.ssh\id_ed25519.pub \| Set-Clipboard` |
| Paste into GitHub → **Settings** → **SSH and GPG keys** → **New SSH key** | Same |
| Test: `ssh -T git@github.com` | Test: `ssh -T git@github.com` |

📚 Full official walkthrough: <https://docs.github.com/en/authentication/connecting-to-github-with-ssh>

---

## 6. ☁️ Create the repo on GitHub

### Option A · The command line (one line)

Run this **inside** your repo folder:

```bash
gh repo create My-New-Repo --public --source=. --remote=origin --description "What it is, in one sentence."
```

| 🧩 Flag | What it does |
|---|---|
| `--public` | Anyone can see it. Use `--private` otherwise |
| `--source=.` | Use the repo in this folder |
| `--remote=origin` | Add GitHub's copy as `origin` — so §7 is already done |
| `--description` | Fills the **About** box immediately |

### Option B · The website

| ✅ | Step | Detail |
|---|---|---|
| ☐ | 1⃣ Go to <https://github.com/new> | Or **+** → **New repository** |
| ☐ | 2⃣ **Repository name** | Exactly the name from §1 |
| ☐ | 3⃣ **Description** | One sentence. This is the **About** box |
| ☐ | 4⃣ **Public** or **Private** | GitHub Pages on a free plan needs **Public** |
| ☐ | 5⃣ ⚠️ **Do NOT** tick "Add a README" | You already have one. Ticking it creates a commit your local repo does not have, and your first push is **rejected** |
| ☐ | 6⃣ **Create repository** | Leave the page open — it shows the exact commands for §7 |

---

## 7. 🔗 Connect and push

Skip to the check if you used `gh repo create` with `--remote=origin` — the remote already exists.

| ✅ | Step | Command | What it does |
|---|---|---|---|
| ☐ | 1⃣ Point at GitHub | `git remote add origin https://github.com/<you>/My-New-Repo.git` | Teaches your repo where `origin` is |
| ☐ | 2⃣ Check the address | `git remote -v` | Two lines: fetch and push |
| ☐ | 3⃣ Confirm your branch | `git branch --show-current` | Should say `main` |
| ☐ | 4⃣ Push | `git push -u origin main` | Uploads `main` and remembers the pairing |
| ☐ | 5⃣ Look | `gh repo view --web` or open the URL | Your README is the front page 🎉 |

| 🧩 Piece of `git push -u origin main` | 🧒 Meaning |
|---|---|
| `push` | Send my commits |
| `-u` | Remember this pairing, so next time plain `git push` works |
| `origin` | …to GitHub's copy |
| `main` | …the branch called `main` |

✅ After this, your daily loop is just: `git add -A` → `git status` → `git commit -m "..."` → `git push`.

---

## 8. ✨ Polish: About, topics, preview image

A repo nobody can parse in ten seconds gets closed in ten seconds.

| ✅ | What | Where | Why |
|---|---|---|---|
| ☐ | **Description** | Repo front page → ⚙️ beside **About** | Shows in search results and on your profile |
| ☐ | **Topics** | Same panel → **Topics** | How people browse. Add 5–10: `typescript`, `nextjs`, `express`, `prisma`, `playwright`… |
| ☐ | **Website** | Same panel | Point at your site or docs |
| ☐ | **Social preview image** | **Settings** → **General** → **Social preview** → **Edit** | The image shown when the link is shared. **1280×640**, under 1 MB |
| ☐ | **README banner** | Top of `README.md` | The same image, so the repo page itself leads with it |

### Do it from the command line instead

```bash
gh repo edit --description "What it is, in one sentence."
gh repo edit --add-topic typescript,nextjs,express,prisma,playwright,learning
gh repo edit --homepage "https://suryakulshreshtha.github.io"
```

> 🖼 **Why 1280×640.** That is GitHub's recommended social-preview size. Smaller images get upscaled and look soft in the very place you want them sharp — someone else's timeline.

---

## 9. 🛡 Protect the default branch

Even working alone, this stops the two worst accidents: a force-push that erases history, and a branch deleted by mistake.

| ✅ | Step |
|---|---|
| ☐ | **Settings** → **Rules** → **Rulesets** → **New branch ruleset** |
| ☐ | Target: the **default branch** |
| ☐ | Tick **Restrict deletions** |
| ☐ | Tick **Block force pushes** |
| ☐ | *(Optional, once you have CI)* **Require status checks to pass** |
| ☐ | *(Optional, if you review your own PRs)* **Require a pull request before merging** |
| ☐ | **Create** |

📚 <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets>

> 🧠 **Working solo?** Keep the first two. Requiring pull requests on a one-person repo is friction without a reviewer — turn it on when CI exists and the checks are worth waiting for.

---

## 10. 🃏 Add it to the card kit

This part is specific to how **this** profile works: every `Forkable*` repo has a 1280×640 card, generated from one JSON file, used as both the social preview and the README banner.

| ✅ | Step | Command / where |
|---|---|---|
| ☐ | 1⃣ Add an entry | `~/Desktop/SKgitIO/tools/card-kit/cards.json` — copy an existing block and edit `file`, `branch`, `title`, `tagline`, `vars`, `panel`, `clone` |
| ☐ | 2⃣ Install the renderer once | `pip install playwright pillow` then `python -m playwright install chromium` |
| ☐ | 3⃣ Render just your card | `cd ~/Desktop/SKgitIO/tools/card-kit && python3 render.py <index>` |
| ☐ | 4⃣ Check the output | `out/<your-file>.png` — the script flags overflowing text and oversized files |
| ☐ | 5⃣ Keep it | copy it into `~/Desktop/SKgitIO/cards/` |
| ☐ | 6⃣ Put it in the README | `cd ~/Desktop/SKgitIO && python3 tools/apply_cards.py` to preview, then `--apply` |
| ☐ | 7⃣ Upload as social preview | **Settings** → **General** → **Social preview** → **Edit** |
| ☐ | 8⃣ Refresh the index image | `python3 render_index.py` → `Forkable-index.png` |

🧾 **Honesty rule from the kit's own README:** every number on a card (`tests = 896`, `phases = 9`) must have been counted in the repo, and `cards.json` records where it was counted. If you cannot count it, do not put it on the card.

---

## 11. 🧯 When the push fails

| ❌ Message | 🔍 Cause | 🛠 Fix |
|---|---|---|
| `! [rejected] main -> main (fetch first)` | GitHub has a commit you do not (usually the README you ticked in §6 step 5) | `git pull --rebase origin main` then `git push` |
| `remote: Support for password authentication was removed` | You typed your account password | §5 — use `gh auth login`, a PAT, or SSH |
| `Permission denied (publickey)` | SSH key missing or not added to GitHub | §5 Option C, then `ssh -T git@github.com` |
| `remote: Repository not found` | Typo in the URL, or no access to a private repo | `git remote -v`, then `git remote set-url origin <correct>` |
| `src refspec main does not match any` | No commits yet, or your branch is `master` | `git log --oneline`; if empty, commit first. Rename: `git branch -M main` |
| `GH007: Your push would publish a private email` | Email privacy is on | Use your `users.noreply.github.com` address in `git config --global user.email` |
| `error: failed to push some refs` + `non-fast-forward` | Your branch is behind | `git pull --rebase` then push. **Never** `--force` on a shared branch |
| Nothing on the front page after a push | You pushed `master`, GitHub shows `main` | `git branch -M main` then `git push -u origin main` |
| `fatal: not a git repository` | You are not inside the folder | `pwd` / `cd` into it; check `.git` exists with `ls -a` |

🧯 Deeper recovery — undoing a commit, recovering a deleted branch, fixing a bad rebase — is in [`05-git-daily-driver.md`](05-git-daily-driver.md).

---

## ✅ The whole thing, on one screen

```bash
cd ~/Desktop/GitHubPushes            # 1. where repos live
mkdir My-New-Repo && cd My-New-Repo  # 2. folder
git init -b main                     #    memory
printf '# My New Repo\n' > README.md # 3. the four files
printf '.env\nnode_modules/\n' > .gitignore
git add -A && git status             # 4. stage, then LOOK
git commit -m "Initial commit"       #    snapshot
gh repo create My-New-Repo --public --source=. --remote=origin \
  --description "What it is, in one sentence."   # 5+6. auth already done, repo created
git push -u origin main              # 7. push
gh repo edit --add-topic typescript,learning     # 8. polish
```

🎓 That is the entire lifecycle. Everything above is the explanation of these twelve lines.
