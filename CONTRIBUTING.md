# 🤝 Contributing

Fixes, new dojos and corrections are all welcome. There is one rule, and it is not negotiable.

---

## 📏 The one rule

> **Nothing is stated as fact unless it was checked, and the check is recorded.**

| ✅ Acceptable | ❌ Not acceptable |
|---|---|
| "Express 5.3.0 (`npm view express version`, 2026-11-18)" | "Express 5 (the latest version)" |
| "npm reports this package as deprecated" | "I think this is deprecated now" |
| "Unverified: Azure's free-tier terms change; read the linked page" | A quoted price or quota with no source |
| A link to official documentation | A link to a blog post, as a source of fact |

If you cannot check it, write that you could not. A labelled gap is useful; a confident guess is not.

---

## 🧱 Adding a dojo

Every dojo README has the same seven parts, in this order:

| # | Part | Must contain |
|---|---|---|
| 1 | **Header** | Time estimate · what it needs · what the reader finishes with |
| 2 | **The one idea** | The single sentence that makes the rest make sense |
| 3 | **The lesson** | A concept table — what it is, and the trap it removes |
| 4 | **The drill** | Numbered checklist + the code to write. Nothing pre-built |
| 5 | **The gate** | One sentence, phrased as something the reader can **do** from an empty file |
| 6 | **Common mistakes** | A table: mistake → why it hurts → what to do instead |
| 7 | **Official docs** | Links to official documentation only |

### ✅ Checklist before you open the PR

| ✅ | Check |
|---|---|
| ☐ | Every command shown for **macOS and Windows**, side by side, where they differ |
| ☐ | Every `.env` variable added to [`docs/03-env-files-and-secrets.md`](docs/03-env-files-and-secrets.md) §5 — the master list must stay complete |
| ☐ | Every version number added to [VERSIONS.md](VERSIONS.md), with the command used and the date |
| ☐ | Every new doc link added to [SOURCES.md](SOURCES.md) |
| ☐ | A row in [PROGRESS.md](PROGRESS.md) |
| ☐ | A row in the root [README.md](README.md) dojo table |
| ☐ | Code blocks tagged with a language (` ```ts `, ` ```bash `, ` ```powershell `) so they are highlighted |
| ☐ | The gate is a **verb**, not "understand X" |

---

## ✍️ Style

| Rule | Why |
|---|---|
| Assume the reader knows nothing about this tool | They came to this dojo *because* they do not |
| Emoji as signposts, not decoration | They make a long page scannable. One per heading is plenty |
| Tables over paragraphs for anything comparable | A table can be scanned; a paragraph must be read |
| Show the broken version too | People learn the rule from seeing it violated |
| One experiment per dojo that **proves** the lesson | Reading is not learning. Running something and seeing it is |
| Short sentences | This is a teaching document, not an essay |

---

## 🐛 Reporting a problem

Open an issue with: the dojo, the exact command, the exact output, your OS, and your `node --version`. Those five things usually contain the answer.
