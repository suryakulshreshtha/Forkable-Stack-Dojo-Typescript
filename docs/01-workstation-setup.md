# 🛠 01 · Set up your workstation

**Time:** 45–90 minutes · **You finish with:** Node 26, Git, an editor, and a terminal where every check below prints a version number.

> 🧒 **This page assumes nothing.** Not that you have used a terminal. Not that you know what a shell is. Not that anything is installed. If a line looks obvious, skip it — nothing later depends on you having read it.

---

## 📑 Contents

| # | Section | For |
|---|---|---|
| 1 | [What a terminal actually is](#1-what-a-terminal-actually-is) | Complete beginners |
| 2 | [Which shell am I in?](#2-which-shell-am-i-in) | Everyone, once |
| 3 | [Install the package manager](#3-install-the-package-manager) | Everyone |
| 4 | [Install Node 26](#4-install-node-26) | Everyone |
| 5 | [Install Git](#5-install-git) | Everyone |
| 6 | [Tell Git who you are](#6-tell-git-who-you-are) | Everyone, once per machine |
| 7 | [Install an editor](#7-install-an-editor) | Everyone |
| 8 | [Install Docker (later dojos only)](#8-install-docker-later-dojos-only) | From `06-devops/` |
| 9 | [npm, yarn or pnpm?](#9-npm-yarn-or-pnpm) | Everyone, once |
| 10 | [The final check](#10-the-final-check) | Everyone |
| 11 | [When it goes wrong](#11-when-it-goes-wrong) | When it goes wrong |

---

## 1. What a terminal actually is

A terminal is a window where you **type a command and press Enter**, instead of clicking. That is the whole idea.

| 🧩 Word | 🧒 What it means | 🤔 Why you care |
|---|---|---|
| **Terminal** | The window itself | It is just a box that shows text |
| **Shell** | The program *inside* that window reading what you type | Different shells have slightly different syntax |
| **Command** | A word you type that runs a program | `node --version` runs Node and asks its version |
| **Prompt** | The text sitting there waiting (`➜`, `$`, `PS C:\>`) | If you see it, the shell is ready for you |
| **Flag** | A word starting with `-` or `--` that changes a command | `--version` means "don't run, just tell me the version" |

### Open one

| 🍎 macOS | 🪟 Windows |
|---|---|
| Press `⌘ Space`, type `Terminal`, press `Return` | Press the `Windows` key, type `PowerShell`, press `Enter` |
| You land in your **home folder** (`/Users/yourname`) | You land in your **home folder** (`C:\Users\yourname`) |

### Three commands that cannot break anything

| Command | What it tells you | 🍎 macOS | 🪟 Windows |
|---|---|---|---|
| Where am I? | The folder you are in | `pwd` | `pwd` |
| What is in here? | The files in it | `ls` | `ls` |
| Go somewhere | Move into a folder | `cd ~/Desktop` | `cd $HOME\Desktop` |

💡 `~` (macOS) and `$HOME` (Windows PowerShell) both mean "my home folder". Typing `cd ~` or `cd $HOME` always takes you home.

---

## 2. Which shell am I in?

You need this once, because §3 and [`02-path-explained.md`](02-path-explained.md) ask you to edit **your shell's config file**, and the file's name depends on the answer.

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `echo $SHELL` | `$PSVersionTable.PSVersion` |

| 🧾 What printed | 🏷 Your shell | 📄 Its config file |
|---|---|---|
| `/bin/zsh` | zsh (the macOS default since Catalina) | `~/.zshrc` |
| `/bin/bash` | bash | `~/.bash_profile` |
| A version like `7.x.x` | PowerShell 7 | run `$PROFILE` to see the path |
| A version like `5.1.x` | Windows PowerShell 5.1 (built in) | run `$PROFILE` to see the path |

📝 **Write your answer down.** Every "add this to your config file" instruction below means *that* file.

---

## 3. Install the package manager

A package manager installs software from one command instead of hunting for download pages.

### 🍎 macOS — Homebrew

| ✅ | Step | Command (Terminal) | Notes |
|---|---|---|---|
| ☐ | 1⃣ Install Apple's build tools | `xcode-select --install` | A dialog appears; click **Install**. Takes a few minutes. Homebrew needs these. |
| ☐ | 2⃣ Install Homebrew | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` | Command from <https://brew.sh>. It will ask for your Mac password — typing shows nothing, that is normal. |
| ☐ | 3⃣ Read what it printed | — | On Apple Silicon it ends with **"Next steps"** and two `eval` lines. **Do not skip them.** |
| ☐ | 4⃣ Put `brew` on your PATH | `echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc` | Only if your shell is zsh (§2). This is the step people skip, and then `brew` is "not found" in a new window. |
| ☐ | 5⃣ Reload the config | `source ~/.zshrc` | Or just close the window and open a new one. |
| ☐ | 6⃣ Check | `brew --version` | A version number means done. |

> 🧠 **Why step 4 exists.** On Apple Silicon Macs, Homebrew installs to `/opt/homebrew`, which your shell does not search by default. Step 4 tells the shell to look there. If `brew` works now but not tomorrow, step 4 never happened — see [`02-path-explained.md`](02-path-explained.md).

### 🪟 Windows — winget

`winget` ships with App Installer on Windows 11 and on Windows 10 1809+.

| ✅ | Step | Command (PowerShell) | Notes |
|---|---|---|---|
| ☐ | 1⃣ Check it exists | `winget --version` | A version means you are done — skip to §4. |
| ☐ | 2⃣ If missing | Install **App Installer** from the Microsoft Store | Then close and reopen PowerShell. |
| ☐ | 3⃣ Allow local scripts | `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` | Needed later so npm's `.ps1` shims and venv-style activation scripts can run. Answer `Y`. |

> 🔎 **If a `winget install` below says no package was found,** the package ID changed. Run `winget search <name>` and use the ID it prints. IDs are not guaranteed stable, so this page shows the search command rather than pretending otherwise.

---

## 4. Install Node 26

**Why 26?** It became **Active LTS on 2026-10-28** and is supported until **2029-04-30** (Node.js release schedule). Node 24 and 22 are in Maintenance — fine for old projects, not what you start on today.

### Option A · The version manager (recommended)

A version manager lets a 2019 project use Node 18 while this repo uses Node 26, on the same machine.

| 🍎 macOS — `nvm` | 🪟 Windows — `fnm` |
|---|---|
| Install with the command on <https://github.com/nvm-sh/nvm#installing-and-updating> — copy it from that page, because it contains a version number that changes | `winget search fnm` then `winget install Schniz.fnm` |
| Add the lines nvm prints to `~/.zshrc`, then `source ~/.zshrc` | Add fnm to your profile: `fnm env --use-on-cd \| Out-String \| Invoke-Expression` (put it in the file `$PROFILE` points to) |
| `nvm install 26` | `fnm install 26` |
| `nvm use 26` | `fnm use 26` |
| `nvm alias default 26` | `fnm default 26` |

🎁 **The payoff:** this repo has a `.nvmrc` file containing `26`. In the repo folder, `nvm use` (macOS) or `fnm use` (Windows) reads that file and switches for you. No arguing about versions, ever.

### Option B · Straight install

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `brew install node` | `winget search OpenJS.NodeJS` then `winget install OpenJS.NodeJS.LTS` |
| Or the macOS installer from <https://nodejs.org/en/download> | Or the Windows installer from <https://nodejs.org/en/download> |

⚠️ Homebrew's `node` formula tracks the newest release, not necessarily LTS. Check with `node --version` and use Option A if you need to pin.

### Check it

| 🍎 macOS | 🪟 Windows | ✅ Expected |
|---|---|---|
| `node --version` | `node --version` | `v26.x.x` |
| `npm --version` | `npm --version` | A version (npm ships with Node) |

❌ `command not found` / `not recognized` → **close the terminal and open a new one first.** Still failing? [`02-path-explained.md`](02-path-explained.md).

---

## 5. Install Git

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `brew install git` | `winget install --id Git.Git -e --source winget` |
| Or Apple's bundled Git: `xcode-select --install` | Or the installer from <https://git-scm.com/downloads> |
| Check: `git --version` | Check: `git --version` |

> 🪟 **Windows line endings.** Git for Windows may convert line endings on checkout. This repo ships an `.editorconfig` that asks for `lf`. If a file looks like one long line in your editor, that is the cause, not a broken file.

---

## 6. Tell Git who you are

Every commit records a name and an email. Set them **once per machine**, before your first commit, or your history is signed by nobody.

| ✅ | What | Command (identical on macOS and Windows) |
|---|---|---|
| ☐ | Your name | `git config --global user.name "Your Name"` |
| ☐ | Your email | `git config --global user.email "you@example.com"` |
| ☐ | Default branch name | `git config --global init.defaultBranch main` |
| ☐ | Check all three | `git config --global --list` |

> 🔐 **Keeping your email private.** GitHub can give you a `users.noreply.github.com` address and reject pushes that would expose your real one. Turn it on in **GitHub → Settings → Emails**, then use that address in `user.email`. If a push is ever rejected with error **GH007**, this is why.

---

## 7. Install an editor

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `brew install --cask visual-studio-code` | `winget search Microsoft.VisualStudioCode` then `winget install Microsoft.VisualStudioCode` |
| Or download from <https://code.visualstudio.com> | Or download from <https://code.visualstudio.com> |

### Extensions worth having for this repo

| 🧩 Extension | 🤔 Why |
|---|---|
| ESLint | Shows lint errors as you type, not at commit time |
| Prettier | Formats on save, so `05-quality/` never fails on formatting |
| Prisma | Syntax and autocomplete for `schema.prisma` |
| Playwright Test for VS Code | Run and debug one browser test from the gutter |
| Tailwind CSS IntelliSense | Autocompletes utility classes and shows the CSS behind them |

---

## 8. Install Docker (later dojos only)

You need Docker from [`03-backend/prisma-azuresql/`](../03-backend/prisma-azuresql/README.md) (to run SQL Server locally) and all of [`06-devops/`](../06-devops/). Skip it until then.

| 🍎 macOS | 🪟 Windows |
|---|---|
| Download **Docker Desktop for Mac** from <https://docs.docker.com/desktop/setup/install/mac-install/> | First: `wsl --install` in PowerShell **run as Administrator**, then restart |
| Pick the **Apple silicon** build if `uname -m` prints `arm64` | Then download **Docker Desktop for Windows** from <https://docs.docker.com/desktop/setup/install/windows-install/> |
| Check: `docker --version` | Check: `docker --version` |
| Check it is actually running: `docker ps` | Check it is actually running: `docker ps` |

> ⚖️ **Licence.** Docker Desktop is free for personal use, education, non-commercial open source, and smaller businesses; larger organisations need a paid subscription. The current thresholds are on Docker's own install pages — read them there rather than trusting a number copied into a tutorial.

💡 `docker --version` answers "is it installed". `docker ps` answers "is the engine running". Beginners hit the second one constantly: Docker Desktop must be **open**.

---

## 9. npm, yarn or pnpm?

All three install packages. They are interchangeable in *purpose* and absolutely not in *lockfiles*.

| 📦 Manager | 🔒 Lockfile | 🏃 Install | 🤔 When |
|---|---|---|---|
| **npm** | `package-lock.json` | `npm install` | Ships with Node. This repo's default. |
| **yarn** | `yarn.lock` | `yarn install` | Common on existing backends. Some teams require it. |
| **pnpm** | `pnpm-lock.yaml` | `pnpm install` | Fast, disk-efficient, strict about dependencies |

🚨 **The one rule:** a project has **one** lockfile. Running `npm install` in a yarn project creates a second one, the two disagree, and CI installs something different from your laptop. Look at which lockfile exists, and use that manager.

> 📌 Real example: a stack may use **npm for the frontend** and **mandate yarn for the backend** in the same monorepo. That is normal, and it is why you check the lockfile before typing anything.

---

## 10. The final check

Run every line. You want a version number from each.

| 🎯 Checking | 🍎 macOS | 🪟 Windows | ✅ Want |
|---|---|---|---|
| Node | `node --version` | `node --version` | `v26.x.x` |
| npm | `npm --version` | `npm --version` | any version |
| Git | `git --version` | `git --version` | any version |
| Git identity | `git config --global user.name` | `git config --global user.name` | your name |
| Editor | `code --version` | `code --version` | any version |
| Docker *(only from `06-devops/`)* | `docker ps` | `docker ps` | a table, even an empty one |

🎉 All green? Go to [`00-what-this-repo-is.md`](00-what-this-repo-is.md), then pick a dojo.

---

## 11. When it goes wrong

| ❌ What you see | 🔍 What it means | 🛠 Fix |
|---|---|---|
| `command not found: brew` | Homebrew is installed but not on your PATH | §3 step 4, then open a new terminal |
| `command not found: node` | Node is not installed, or not on PATH | Open a **new** terminal first; then [`02-path-explained.md`](02-path-explained.md) |
| `'node' is not recognized...` (Windows) | Same thing, Windows wording | Reopen PowerShell; then [`02-path-explained.md`](02-path-explained.md) |
| `cannot be loaded because running scripts is disabled` | PowerShell execution policy | §3 step 3 |
| `EACCES: permission denied` on `npm install -g` | You are installing globally into a system folder | Use a version manager (§4 Option A). **Do not** use `sudo npm` |
| `Cannot connect to the Docker daemon` | Docker is installed but not running | Open Docker Desktop and wait for the whale to settle |
| `node --version` shows an old version | Another Node is earlier on your PATH | `nvm use 26` / `fnm use 26`; then [`02-path-explained.md`](02-path-explained.md) |
| Everything works, new window breaks | You changed PATH for one session only | The change must be in your shell config file (§2) |

🧯 Still stuck? [`06-troubleshooting.md`](06-troubleshooting.md) has the longer list, including errors from specific dojos.
