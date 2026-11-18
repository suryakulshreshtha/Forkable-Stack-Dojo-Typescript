# 🔁 Azure Pipelines (and GitHub Actions beside it)

**Time:** 3–4 h · **Needs:** Azure DevOps or a GitHub repo · **You finish with:** a `verify → build → deploy` pipeline that runs on every merge, and the ability to read either YAML dialect.

> 🧠 **The one idea:** CI/CD is just **your terminal commands, run by someone else, on a clean machine, every time.** Nothing more. If it does not work from a fresh clone with no local setup, the pipeline will tell you — which is exactly its value.

```
 push / merge
     │
     ▼
 ┌──────────┐    ┌──────────┐    ┌──────────┐
 │ VERIFY   │───►│ BUILD    │───►│ DEPLOY   │
 │ lint     │    │ image    │    │ Container│
 │ typecheck│    │ push to  │    │ App      │
 │ test     │    │ registry │    │ revision │
 └──────────┘    └──────────┘    └──────────┘
   fails fast      only if green    only on main
```

---

## 1. 📖 The lesson

### The vocabulary, in both dialects

| Concept | 🔵 Azure Pipelines | ⚫ GitHub Actions |
|---|---|---|
| The file | `azure-pipelines.yml` | `.github/workflows/ci.yml` |
| What starts it | `trigger:` | `on:` |
| A phase | `stage` | (a `job`, with `needs:`) |
| A unit of work | `job` | `job` |
| One command set | `step` / `task` | `step` / `uses` |
| The machine | `pool: vmImage:` | `runs-on:` |
| A secret | pipeline variable / variable group | repository or environment secret |
| Passing files between phases | `publish` / `download` artifacts | `upload-artifact` / `download-artifact` |

🧠 **The concepts are identical.** Learn the model once and the other file is a translation exercise, which is why this dojo shows both.

### 🔐 Supply-chain hygiene, the part tutorials omit

| ✅ Do | 🤔 Why |
|---|---|
| Pin third-party actions to a **commit SHA**, not a tag | A tag can be moved to point at new code |
| Grant least-privilege tokens (`permissions:` in Actions) | A compromised step can do less |
| Never `echo` a secret | CI logs are often readable by more people than you think |
| Use `npm ci`, not `npm install` | `ci` obeys the lockfile exactly — reproducible |
| Keep deploy on `main` only, behind an environment approval | Stops a feature branch reaching production |

---

## 2. 🛠 The drill

| ✅ | Step | What |
|---|---|---|
| ☐ | 1⃣ Write the verify stage first | lint + typecheck + test. **Make it fail**, then fix it |
| ☐ | 2⃣ Add build | only runs if verify passed |
| ☐ | 3⃣ Add deploy | only on `main` |
| ☐ | 4⃣ Store secrets in the platform | never in the YAML |
| ☐ | 5⃣ Break it on purpose | push a lint error and watch the gate hold |
| ☐ | 6⃣ Translate it | write the same pipeline in the other dialect |

```yaml
# azure-pipelines.yml
trigger:
  branches: { include: [main] }
pr:
  branches: { include: [main] }        # run verify on pull requests too

variables:
  - group: stack-dojo-secrets          # ACR_NAME, AZURE_RESOURCE_GROUP, CONTAINER_APP_NAME

stages:
  - stage: Verify
    jobs:
      - job: Checks
        pool: { vmImage: 'ubuntu-latest' }
        steps:
          - task: NodeTool@0
            inputs: { versionSpec: '26.x' }
          - script: npm ci
            displayName: Install (lockfile-exact)
          - script: npm run lint
            displayName: Lint
          - script: npm run typecheck
            displayName: Typecheck
          - script: npm test -- --coverage
            displayName: Test
          - task: PublishTestResults@2
            condition: succeededOrFailed()      # 🎯 publish results even when tests fail
            inputs: { testResultsFiles: '**/junit.xml' }

  - stage: Build
    dependsOn: Verify
    condition: succeeded()
    jobs:
      - job: Image
        pool: { vmImage: 'ubuntu-latest' }
        steps:
          - task: AzureCLI@2
            inputs:
              azureSubscription: 'stack-dojo-connection'
              scriptType: bash
              scriptLocation: inlineScript
              inlineScript: |
                az acr build --registry $(ACR_NAME) \
                  --image stack-dojo:$(Build.SourceVersion) .   # tagged with the commit SHA

  - stage: Deploy
    dependsOn: Build
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: ToContainerApp
        environment: production          # approvals and gates attach here
        pool: { vmImage: 'ubuntu-latest' }
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureCLI@2
                  inputs:
                    azureSubscription: 'stack-dojo-connection'
                    scriptType: bash
                    scriptLocation: inlineScript
                    inlineScript: |
                      az containerapp update \
                        --name $(CONTAINER_APP_NAME) \
                        --resource-group $(AZURE_RESOURCE_GROUP) \
                        --image $(ACR_NAME).azurecr.io/stack-dojo:$(Build.SourceVersion)
```

```yaml
# .github/workflows/ci.yml — the same pipeline, other dialect
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }

permissions:
  contents: read            # 🔐 least privilege by default

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5          # pin to a SHA in real projects
      - uses: actions/setup-node@v5
        with: { node-version: 26, cache: npm }
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck
      - run: npm test -- --coverage

  build-and-deploy:
    needs: verify
    if: github.ref == 'refs/heads/main'    # deploy only from main
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v5
      - run: echo "build and deploy steps here"
```

🧪 **Step 5 is the dojo.** Push a deliberate lint error on a branch and open a PR. Verify goes red; Build and Deploy never start. *That* is what a pipeline is for — not the green ticks, the **blocked** merge. A pipeline you have never seen fail is a pipeline you cannot trust.

⏱ **Keep verify under five minutes.** Past that, people start merging without waiting, and the gate becomes decoration. Cache dependencies, run jobs in parallel, and push slow browser tests to a separate workflow.

---

## 3. 🚪 The gate

> Write a three-stage pipeline where build only runs after a green verify and deploy only runs on `main`, with secrets stored in the platform, test results published even on failure, images tagged by commit SHA — then prove the gate works by watching a bad commit stopped at verify.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| Secrets in the YAML | Variable groups / repository secrets |
| `npm install` in CI | `npm ci` |
| Deploy on every branch | Condition on `main` |
| No condition on test publishing | `condition: succeededOrFailed()` |
| Image tagged `latest` | Tag with the commit SHA |
| Third-party actions pinned to a tag | Pin to a commit SHA |
| A 25-minute verify stage | Cache, parallelise, split out E2E |
| Never seeing it fail | Break it on purpose, once |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Azure Pipelines | <https://learn.microsoft.com/en-us/azure/devops/pipelines/> |
| YAML schema reference | <https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/> |
| Secrets and variable groups | <https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups> |
| GitHub Actions | <https://docs.github.com/en/actions> |
| Security hardening for Actions | <https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions> |

➡️ **Next:** [`../powershell-iac/`](../powershell-iac/README.md)
