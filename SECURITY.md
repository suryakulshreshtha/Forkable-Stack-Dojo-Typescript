# 🔐 Security

This is a learning repository: no deployed service, no users, no data. The security that matters here is **yours** — the credentials you create while working through the dojos.

---

## 🚨 The one that actually happens: a committed `.env`

Several dojos ask you to create real secrets. If one reaches a commit, **act in this order**:

| ⏱ | Step | Why this order |
|---|---|---|
| **1st** | **Rotate the secret.** Generate a new value; change it wherever it was issued | The moment it is pushed, treat it as public. This is the only step that actually fixes anything |
| **2nd** | Remove it from the working tree and commit that | Stops it spreading further |
| **3rd** | Confirm it is ignored: `git check-ignore -v .env` | Stops the repeat |
| **4th** | *Optionally* rewrite history | Housekeeping. It does **not** un-leak the value |

🛑 **The mistake to avoid:** an hour spent rewriting Git history and no rotation. Forks, clones, CI caches and cached web views may still hold the old commit.

📚 GitHub's own guidance: <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository>

---

## ✅ Habits this repo asks of you

| ✅ | Habit | Where it is taught |
|---|---|---|
| ☐ | `git check-ignore -v .env` before your first commit in any dojo | [`docs/03-env-files-and-secrets.md`](docs/03-env-files-and-secrets.md) §3 |
| ☐ | `git status` and `git diff --staged` before **every** commit | [`docs/05-git-daily-driver.md`](docs/05-git-daily-driver.md) |
| ☐ | A different secret per environment, 32 bytes minimum | `docs/03` §4 |
| ☐ | Never a secret in a `NEXT_PUBLIC_` variable | `docs/03` §6 |
| ☐ | Never a secret in a Dockerfile `ENV` | [`06-devops/docker-multistage/`](06-devops/docker-multistage/README.md) |
| ☐ | Platform secrets + `secretref:` in Azure, not plain env vars | [`06-devops/azure-container-apps/`](06-devops/azure-container-apps/README.md) |
| ☐ | Pipeline secrets in variable groups, never in YAML | [`06-devops/azure-pipelines/`](06-devops/azure-pipelines/README.md) |
| ☐ | Tear down cloud resources when a dojo ends | `06-devops/*` |

---

## ☁️ Cloud cost is a security concern too

An abandoned resource group is both a bill and an unmonitored, unpatched attack surface. Every `06-devops/` dojo ends with a teardown command. Run it.

```bash
az group delete --name "$AZURE_RESOURCE_GROUP" --yes --no-wait
```

---

## 📣 Reporting something about this repo

Found a genuine security problem in the repository's own content — a sample that teaches an unsafe pattern, a secret accidentally committed, a dependency with a known advisory? Open an issue. If it involves a credential, do **not** put the credential in the issue.
