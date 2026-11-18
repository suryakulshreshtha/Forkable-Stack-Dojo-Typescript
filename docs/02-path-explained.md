# 🧭 02 · PATH, explained properly

**Read this when:** you installed something, the installer said "success", and your terminal says **"command not found"**.

> 🧒 **Starting from zero.** You do not need to know what an environment variable is. By the end of this page you will be able to look at your PATH, add to it, check your work, and undo it.

---

## 1. 🍪 The idea, with a biscuit tin

Imagine you ask a child: **"go and get the biscuits."**

The child does not search the entire house. They have a list of places, in order:

```
 1. kitchen counter
 2. cupboard above the kettle
 3. the pantry
```

They check the counter. Not there. The cupboard. Not there. The pantry. **Found them — stop looking.**

**PATH is that list, for your computer.** When you type `node`, the shell does not search your whole disk. It walks a list of folders, in order, and runs the **first** `node` it finds.

| 🍪 Biscuit tin | 💻 Your computer |
|---|---|
| "Go and get the biscuits" | You type `node` |
| The list of places to look | **PATH** |
| Checking each place in order | The shell checking each folder in order |
| Found it, stop looking | The first match wins — later copies are ignored |
| "I couldn't find any biscuits" | `command not found` |

🔑 **Two consequences, and they explain almost every problem:**

1. **If a program's folder is not on the list, the program may as well not exist.** The installer worked. The shell just never looks there.
2. **Order decides which copy runs.** Two versions of Node installed? The one in the earlier folder wins, no matter which you installed last.

---

## 2. 👀 Look at your own PATH

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `echo $PATH` | `$env:Path` |
| One long line, folders separated by **`:`** | One long line, folders separated by **`;`** |

That wall of text is hard to read. Put one folder per line:

| 🍎 macOS (Terminal) | 🪟 Windows (PowerShell) |
|---|---|
| `echo $PATH \| tr ':' '\n'` | `$env:Path -split ';'` |

You will see something like `/opt/homebrew/bin`, `/usr/local/bin`, `/usr/bin`. **Top of the list = checked first.**

### Which copy am I actually running?

| 🎯 Question | 🍎 macOS | 🪟 Windows |
|---|---|---|
| Which `node` wins? | `which node` | `where.exe node` |
| Are there several? | `which -a node` | `where.exe node` (lists all) |
| What version is it? | `node --version` | `node --version` |

> 🕵️ **The classic mystery solved.** `node --version` says `v18`, you definitely installed 26. Run `which -a node` / `where.exe node`. Two lines come back. The top one is an old install sitting earlier on PATH. You do not need to uninstall anything — you need the right folder to come *first* (§4).

---

## 3. ⏳ Two kinds of change — this is the part everyone gets wrong

| | 🫧 Session change | 🧱 Permanent change |
|---|---|---|
| **Lives for** | This terminal window only | Every window, forever |
| **Gone when** | You close the window | You remove it |
| **How** | Type an `export` / `$env:` line | Write it into a **config file** |
| **Use it for** | Testing whether a folder fixes your problem | The actual fix |

🚨 **The single most common beginner moment:** you run an `export` line, it works, you close the terminal, and tomorrow it is broken again. Nothing is wrong with your computer. A session change *is supposed to* disappear. You skipped the permanent step.

```
  export PATH=...        ──► works now  ──► close window ──► gone 💨
  write it in .zshrc     ──► works now  ──► close window ──► still there ✅
```

---

## 4. 🍎 macOS — add a folder permanently

Your config file depends on your shell. Find out with `echo $SHELL`:

| 🏷 Shell | 📄 Config file |
|---|---|
| zsh (macOS default) | `~/.zshrc` |
| bash | `~/.bash_profile` |

### Step by step

| ✅ | Step | Command (Terminal) | What it does |
|---|---|---|---|
| ☐ | 1⃣ Test it first, temporarily | `export PATH="/opt/homebrew/bin:$PATH"` | Adds the folder **for this window only** |
| ☐ | 2⃣ Did it fix it? | `which brew` | If yes, the folder was the problem. If no, **stop** — the folder is wrong, do not make it permanent |
| ☐ | 3⃣ Make it permanent | `echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc` | Appends that exact line to your config |
| ☐ | 4⃣ Apply without restarting | `source ~/.zshrc` | Re-reads the file now |
| ☐ | 5⃣ Prove it survives | Close the window, open a new one, `which brew` | The real test |

### 🔬 Read that line like a sentence

```
export PATH="/opt/homebrew/bin:$PATH"
│      │     │                  │ │
│      │     │                  │ └─ $PATH = "everything that was already on the list"
│      │     │                  └─── : = the separator between folders (macOS/Linux)
│      │     └────────────────────── the folder you are adding
│      └──────────────────────────── the variable you are changing
└─────────────────────────────────── "make this available to programs I run"
```

| 🧩 You write | 🧠 It means | ⚖️ Effect on order |
|---|---|---|
| `PATH="/new/folder:$PATH"` | new folder **first**, then everything else | Your version **wins** |
| `PATH="$PATH:/new/folder"` | everything else first, new folder **last** | Your version only runs if nothing earlier has it |

💡 Installing a tool and want it to take priority over an old copy? Put it **first**. That is the whole fix for the "wrong version" mystery in §2.

### ☠️ Four ways to break your PATH (and the repair)

| 💥 Mistake | 😖 What happens | 🧯 Repair |
|---|---|---|
| `export PATH="/opt/homebrew/bin"` (forgot `:$PATH`) | You **replaced** the whole list. Even `ls` stops working | The window is wrecked, not your machine. Close it, open a new one. If you wrote it to `~/.zshrc`, see below |
| No quotes, and a folder name has a space | Shell reads it as two things | Always wrap in `"double quotes"` |
| Edited `~/.bash_profile` while using zsh | Nothing changes, ever | Check `echo $SHELL` and edit the right file |
| Pasted the line ten times | Ten duplicates; harmless but messy | Open `~/.zshrc` and delete the extra lines |

🛟 **If you wrote a broken line into `~/.zshrc`** and new terminals are broken, repair it with a full-path editor that does not need PATH:

```
/usr/bin/nano ~/.zshrc
```

Delete the bad line, press `Ctrl+O` then `Return` to save, `Ctrl+X` to exit, open a new terminal.

---

## 5. 🪟 Windows — add a folder permanently

Windows keeps **two** PATHs and joins them: a **User** one (just you) and a **System** one (everyone). Always edit the **User** one — it needs no admin rights and cannot break other accounts.

### Step by step (PowerShell)

| ✅ | Step | Command (PowerShell) | What it does |
|---|---|---|---|
| ☐ | 1⃣ Test it first, temporarily | `$env:Path = "C:\my\folder;" + $env:Path` | This window only |
| ☐ | 2⃣ Did it fix it? | `where.exe node` | If no, **stop** — wrong folder |
| ☐ | 3⃣ See your current User PATH | `[Environment]::GetEnvironmentVariable("Path","User")` | Read it before you change it |
| ☐ | 4⃣ Save a copy first | `[Environment]::GetEnvironmentVariable("Path","User") > $HOME\path-backup.txt` | Your undo file. Do this. |
| ☐ | 5⃣ Append permanently | see the block below | Writes it for every future window |
| ☐ | 6⃣ Prove it | **Close PowerShell, open a new one**, `where.exe node` | Changes do not reach windows that are already open |

```powershell
$old = [Environment]::GetEnvironmentVariable("Path","User")
[Environment]::SetEnvironmentVariable("Path", "C:\my\folder;$old", "User")
```

| 🧩 Piece | 🧠 Meaning |
|---|---|
| `$old` | Everything already on your User PATH — kept, not thrown away |
| `"C:\my\folder;$old"` | Your folder **first**, then the old list. Swap the order to put it last |
| `"User"` | Just your account. `"Machine"` would be system-wide and needs Administrator |
| `;` | The Windows separator (macOS uses `:`) |

### 🖱 The clicking route, if you prefer

| ✅ | Step |
|---|---|
| ☐ | Press `Windows`, type **"environment variables"**, open **Edit the system environment variables** |
| ☐ | Click **Environment Variables…** |
| ☐ | In the **top** box (User variables), select **Path**, click **Edit…** |
| ☐ | **New** → paste the folder → use **Move Up** to change priority → **OK**, **OK**, **OK** |
| ☐ | Close every terminal and open a new one |

🧯 **Undo:** paste the contents of `path-backup.txt` (step 4) back in, the same way.

---

## 6. 🔄 Why "just open a new terminal" keeps working

A terminal reads PATH **once**, when it opens. It never looks again.

```
 open terminal ──► reads config file ──► PATH fixed for this window's whole life
                                          │
 you change the config file ──────────────┘ (this window never finds out)
```

| 🤔 Situation | ✅ Do this |
|---|---|
| Just edited `~/.zshrc` | `source ~/.zshrc`, or open a new window |
| Just changed Windows User PATH | Open a new PowerShell window (`source` does not exist there) |
| Just ran an installer | Open a new window **before** believing it failed |
| VS Code's built-in terminal is stale | Quit VS Code completely and reopen it |

🧠 **Debug in this order, every time:** *new terminal → `which`/`where.exe` → `echo $PATH` → config file.* Four steps, in that order, solve almost all of it.

---

## 7. 🧾 Cheat sheet

| 🎯 I want to... | 🍎 macOS | 🪟 Windows |
|---|---|---|
| See my PATH | `echo $PATH \| tr ':' '\n'` | `$env:Path -split ';'` |
| See which copy runs | `which -a node` | `where.exe node` |
| Add for this window | `export PATH="/f:$PATH"` | `$env:Path = "C:\f;" + $env:Path` |
| Add permanently | add that `export` line to `~/.zshrc` | `[Environment]::SetEnvironmentVariable("Path","C:\f;$old","User")` |
| Reload config now | `source ~/.zshrc` | open a new window |
| Edit config safely | `/usr/bin/nano ~/.zshrc` | `notepad $PROFILE` |
| Find my shell | `echo $SHELL` | `$PSVersionTable.PSVersion` |

---

## 8. 📚 Official sources

| Topic | Where |
|---|---|
| zsh startup files, `export` | <https://zsh.sourceforge.io/Doc/Release/Files.html> |
| PowerShell environment variables | <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables> |
| PowerShell profiles (`$PROFILE`) | <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles> |
| Homebrew's own PATH instructions | <https://docs.brew.sh/FAQ> |
| Node.js downloads and version managers | <https://nodejs.org/en/download> |
