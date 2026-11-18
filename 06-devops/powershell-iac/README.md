# 📜 Infrastructure as Code with PowerShell

**Time:** 3–4 h · **Needs:** PowerShell 7, Azure CLI · **You finish with:** one script that creates your whole environment, is safe to run twice, and tears it all down again.

> 🧠 **The one idea: idempotent.** Running the script once and running it five times must leave the world in the **same state**. That single property is what separates infrastructure *code* from a list of commands you once typed into a terminal and will never remember again.

```
 ❌ clicking in a portal          ✅ a script in Git
    nobody knows what exists        the repo IS the inventory
    "who changed this?"             git log tells you
    rebuilding = archaeology        rebuilding = run it again
```

---

## 1. 📖 The lesson

### Why PowerShell for this

| 🤔 Reason | Detail |
|---|---|
| **Cross-platform** | PowerShell 7 runs on macOS, Windows and Linux |
| **Objects, not text** | `az ... -o json \| ConvertFrom-Json` gives you real properties, no `grep`/`awk` |
| **Native to the Azure world** | Microsoft's own tooling and docs lean on it |
| **Honest error handling** | `$ErrorActionPreference = 'Stop'` makes a script stop at the first failure |

### Idempotent, concretely

```powershell
# ❌ Not idempotent — fails or duplicates on the second run
az group create --name $rg --location $loc

# ✅ Idempotent — check, then act
if (-not (az group exists --name $rg | ConvertFrom-Json)) {
    az group create --name $rg --location $loc | Out-Null
    Write-Host "✅ Created resource group $rg"
} else {
    Write-Host "⏭  Resource group $rg already exists"
}
```

🎯 **Many `az ... create` commands are already idempotent** (they update rather than fail). Many are not. The discipline is to **check first, and say what you did** — so the output of a second run reads as a list of "already there" lines rather than a wall of errors you learn to ignore.

### Three habits that make a script trustworthy

| 🧩 Habit | What it looks like | Why |
|---|---|---|
| **`-WhatIf` / dry run** | `./deploy.ps1 -WhatIf` prints, changes nothing | You see the plan before it happens |
| **Parameters, not hard-coded values** | `param([string]$Location = 'centralindia')` | One script, many environments |
| **Fail fast and loud** | `$ErrorActionPreference = 'Stop'` | Half-built infrastructure is worse than none |

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install PowerShell 7 | `brew install --cask powershell` (macOS) · `winget install Microsoft.PowerShell` (Windows) |
| ☐ | 2⃣ Start it | `pwsh` |
| ☐ | 3⃣ Sign in to Azure | `az login` |
| ☐ | 4⃣ Write `provision.ps1` | below |
| ☐ | 5⃣ Dry run first | `./provision.ps1 -WhatIf` |
| ☐ | 6⃣ Run it | `./provision.ps1` |
| ☐ | 7⃣ 🎯 **Run it again** | every line should say "already exists" |
| ☐ | 8⃣ Tear down | `./provision.ps1 -Destroy` |

```powershell
#!/usr/bin/env pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
  Provisions the Stack Dojo environment in Azure. Safe to run repeatedly.
.EXAMPLE
  ./provision.ps1 -WhatIf      # show the plan, change nothing
  ./provision.ps1              # create or update
  ./provision.ps1 -Destroy     # remove everything
#>
param(
    [string]$ResourceGroup = $env:AZURE_RESOURCE_GROUP,
    [string]$Location      = $env:AZURE_LOCATION,
    [string]$AcrName       = $env:ACR_NAME,
    [switch]$WhatIf,
    [switch]$Destroy
)

$ErrorActionPreference = 'Stop'          # 🛑 stop at the first real failure

function Invoke-Step {
    param([string]$Description, [scriptblock]$Action, [scriptblock]$Test)

    if ($Test -and (& $Test)) {
        Write-Host "⏭  $Description — already exists" -ForegroundColor DarkGray
        return
    }
    if ($WhatIf) {
        Write-Host "🔍 WOULD DO: $Description" -ForegroundColor Yellow
        return
    }
    Write-Host "⚙️  $Description" -ForegroundColor Cyan
    & $Action | Out-Null
    Write-Host "✅ $Description" -ForegroundColor Green
}

# --- guard: refuse to run half-configured ---
foreach ($name in 'ResourceGroup', 'Location', 'AcrName') {
    if (-not (Get-Variable $name -ValueOnly)) { throw "Missing required value: $name" }
}

if ($Destroy) {
    if ($WhatIf) { Write-Host "🔍 WOULD DELETE resource group $ResourceGroup"; exit 0 }
    Write-Host "🧹 Deleting resource group $ResourceGroup" -ForegroundColor Red
    az group delete --name $ResourceGroup --yes --no-wait
    exit 0
}

Invoke-Step -Description "Resource group $ResourceGroup" `
    -Test   { (az group exists --name $ResourceGroup | ConvertFrom-Json) -eq $true } `
    -Action { az group create --name $ResourceGroup --location $Location }

Invoke-Step -Description "Container registry $AcrName" `
    -Test   { $null -ne (az acr show --name $AcrName --resource-group $ResourceGroup 2>$null) } `
    -Action { az acr create --name $AcrName --resource-group $ResourceGroup --sku Basic }

Write-Host "`n🎉 Environment ready: $ResourceGroup in $Location" -ForegroundColor Green
```

🧪 **Step 7 is the whole lesson.** The second run should print nothing but grey "already exists" lines. If it errors, your script is a transcript, not infrastructure as code. Fix it until a second run is boring.

🧠 **Where this goes next:** `provision.ps1` is imperative — you describe the *steps*. Declarative tools (Bicep, ARM, Terraform) let you describe the *desired state* and work out the steps themselves. Learn idempotency here, in a language you can read, then the declarative tools make immediate sense rather than feeling like magic.

---

## 3. 🚪 The gate

> Write a parameterised PowerShell script that provisions at least two Azure resources, prints a clear plan under `-WhatIf`, is genuinely safe to run three times in a row, refuses to start if required values are missing, and tears the whole environment down with a single flag.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Why it hurts | ✅ Instead |
|---|---|---|
| No existence check | Second run is a wall of errors | Check, then act |
| Hard-coded names and regions | One script, one environment, forever | `param()` with env defaults |
| No `$ErrorActionPreference = 'Stop'` | Carries on after a failure, half-building | Set it at the top |
| Secrets in the script | Committed to Git | Read from env or Key Vault |
| No dry run | You find out by doing | `-WhatIf` |
| Clicking in the portal, then scripting later | The script and reality diverge silently | Script first; portal for reading only |
| No teardown path | Surprise bills | A `-Destroy` switch |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| PowerShell documentation | <https://learn.microsoft.com/en-us/powershell/> |
| `Az` PowerShell module | <https://learn.microsoft.com/en-us/powershell/azure/> |
| Azure CLI reference | <https://learn.microsoft.com/en-us/cli/azure/> |
| Advanced function parameters (`-WhatIf`) | <https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess> |
| Bicep (the declarative next step) | <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/> |

🎓 **That is every dojo.** Back to the [root README](../../README.md), or straight to [PROGRESS.md](../../PROGRESS.md) to see what you have cleared.
