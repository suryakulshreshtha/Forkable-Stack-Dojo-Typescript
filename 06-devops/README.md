# 🚢 06 · DevOps

**Four dojos. 14–18 hours. You finish with:** a container you can explain line by line, running in Azure, deployed by a pipeline, on infrastructure created by a script you can re-run safely.

> 🧠 **The one idea:** "it works on my machine" is not a finished feature. Delivery is the part of software that turns code into something other people can use — and it is the part most self-taught developers never practise.

```
 💻 your laptop ──► 📦 image ──► 🏛 registry ──► ☁️ Container App ──► 🌍 a URL anyone can open
                       ▲                              ▲
                  Dockerfile                    created by IaC, deployed by the pipeline
```

| Dojo | Teaches | Time | Needs |
|---|---|---|---|
| [`docker-multistage/`](docker-multistage/README.md) | Images, layers, multi-stage builds, non-root containers | 4–5 h | Docker Desktop |
| [`azure-container-apps/`](azure-container-apps/README.md) | Registry push, deploy, scale to zero, read logs | 4–5 h | Azure subscription |
| [`azure-pipelines/`](azure-pipelines/README.md) | `verify → build → deploy` as YAML (+ GitHub Actions beside it) | 3–4 h | Azure DevOps or GitHub |
| [`powershell-iac/`](powershell-iac/README.md) | Infrastructure as code, and what idempotent really means | 3–4 h | PowerShell 7 + Azure CLI |

💰 **A word on cost.** These dojos create real, billable cloud resources. Every one ends with a teardown command. Run it. A forgotten resource group is the most common unpleasant surprise in learning cloud.

🚪 **Shelf gate:** take an app from your laptop to a public URL, with a pipeline that redeploys on merge, and tear the whole thing down with one command.
