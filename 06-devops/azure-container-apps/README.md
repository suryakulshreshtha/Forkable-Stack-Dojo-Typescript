# ☁️ Azure Container Apps

**Time:** 4–5 h · **Needs:** an Azure subscription, Azure CLI, your image from the Docker dojo · **You finish with:** your container on a public HTTPS URL, scaling to zero when idle — and torn down again.

> 🧠 **The one idea:** you hand Azure a **container image** and a few rules (which port, how many replicas, when to scale). You do not manage a VM, patch an OS, or configure a load balancer. Scale to zero means an idle app can cost nothing while still having a URL.

```
 📦 local image ──az acr build──► 🏛 Azure Container Registry ──► ☁️ Container App ──► 🌍 https://…azurecontainerapps.io
                                                                        │
                                                            ⬍ replicas: 0 … n (zero when idle)
```

---

## 1. 📖 The lesson

| 🧩 Concept | What it is | Why it matters |
|---|---|---|
| **Resource group** | A folder for resources | Deleting it deletes everything inside — your teardown button |
| **Container Registry (ACR)** | Your private image store | Container Apps pulls from here |
| **Container Apps Environment** | The shared boundary apps run in | Networking and logging live at this level |
| **Container App** | One deployed service | Has revisions |
| **Revision** | An immutable snapshot of a deployment | Rollback = send traffic to the previous one |
| **Ingress** | Public or internal + target port | 🎯 The port here **must** match what your app listens on |
| **Scale rules** | min/max replicas, triggers | `min-replicas 0` = scale to zero |
| **Secrets** | Values stored by the platform | Env vars reference them; never baked into the image |

### 🚨 The two things that break every first deployment

| Problem | Symptom | Fix |
|---|---|---|
| App listens on `127.0.0.1` | Deploy succeeds, requests time out | Listen on `0.0.0.0` — inside a container, localhost means "only me" |
| Ingress port ≠ app port | 503s | `--target-port` must equal the app's actual port |

### 🧊 Scale to zero, and the cold start it buys

| | `min-replicas 0` | `min-replicas 1` |
|---|---|---|
| Idle cost | ~nothing | You pay to keep one alive |
| First request after idle | Cold start (seconds) | Instant |
| Good for | Demos, internal tools, learning | Anything user-facing |

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Install the CLI | `brew install azure-cli` (macOS) · `winget install Microsoft.AzureCLI` (Windows) |
| ☐ | 2⃣ Sign in | `az login` |
| ☐ | 3⃣ Add the extension | `az extension add --name containerapp --upgrade` |
| ☐ | 4⃣ Env | `cp .env.example .env` and fill in the Azure values |
| ☐ | 5⃣ Work through the six steps | below |
| ☐ | 6⃣ Open your URL | the FQDN the CLI prints |
| ☐ | 7⃣ 🧹 **Tear it down** | the last command. Do not skip it |

```bash
# Load your own values — nothing below is hard-coded
set -a; source .env; set +a

# 1 · a resource group (your teardown handle)
az group create --name "$AZURE_RESOURCE_GROUP" --location "$AZURE_LOCATION"

# 2 · a registry
az acr create --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$ACR_NAME" --sku Basic --admin-enabled true

# 3 · build the image IN Azure (no local Docker, no arm64/amd64 problem 🎯)
az acr build --registry "$ACR_NAME" --image "stack-dojo:$IMAGE_TAG" .

# 4 · an environment for the app to live in
az containerapp env create --name "env-stack-dojo" \
  --resource-group "$AZURE_RESOURCE_GROUP" --location "$AZURE_LOCATION"

# 5 · deploy. Note target-port, scale-to-zero, and secrets passed properly
az containerapp create \
  --name "$CONTAINER_APP_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --environment "env-stack-dojo" \
  --image "$ACR_NAME.azurecr.io/stack-dojo:$IMAGE_TAG" \
  --registry-server "$ACR_NAME.azurecr.io" \
  --target-port 3001 \
  --ingress external \
  --min-replicas 0 --max-replicas 3 \
  --secrets "jwt-secret=$JWT_SECRET" \
  --env-vars "NODE_ENV=production" "JWT_SECRET=secretref:jwt-secret"

# 6 · what is my URL?
az containerapp show --name "$CONTAINER_APP_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" --query "properties.configuration.ingress.fqdn" -o tsv

# logs, when it inevitably does not work first time
az containerapp logs show --name "$CONTAINER_APP_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" --follow

# 🧹 TEARDOWN — deletes the group and everything in it
az group delete --name "$AZURE_RESOURCE_GROUP" --yes --no-wait
```

🎯 **`az acr build` is the trick worth remembering.** It builds the image **in Azure** from your source, so you need no local Docker and the architecture always matches. It removes the single most common deployment failure for Apple-silicon developers.

🔐 **Note how the secret is passed:** stored as a platform secret, then referenced with `secretref:`. The value is never in the image, never in the YAML, never in your Git history.

🧪 **Prove scale-to-zero:** deploy, wait a few minutes without traffic, then `az containerapp replica list`. Empty. Hit the URL — slow (cold start), then fast. You have just watched the trade-off you chose.

---

## 3. 🚪 The gate

> From nothing: create a resource group and registry, build an image in Azure, deploy it with external ingress on the correct target port and scale-to-zero, pass a secret via a platform secret reference, read the live logs, retrieve the public URL — then delete the whole resource group and verify it is gone.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | 🔍 Symptom | ✅ Fix |
|---|---|---|
| App binds `127.0.0.1` | Timeouts | Bind `0.0.0.0` |
| `--target-port` wrong | 503 | Match the app's port |
| Secrets as plain `--env-vars` | Visible in config | Platform secrets + `secretref:` |
| `IMAGE_TAG=latest` | Cannot tell what is running; rollback is guesswork | Tag with a version or commit SHA |
| Forgetting teardown | A bill next month | `az group delete` |
| ACR name with capitals or hyphens | Creation fails | Lowercase alphanumeric, globally unique |
| Reading no logs | Debugging blind | `az containerapp logs show --follow` |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| Azure Container Apps | <https://learn.microsoft.com/en-us/azure/container-apps/> |
| Manage secrets | <https://learn.microsoft.com/en-us/azure/container-apps/manage-secrets> |
| Scaling rules | <https://learn.microsoft.com/en-us/azure/container-apps/scale-app> |
| Azure Container Registry | <https://learn.microsoft.com/en-us/azure/container-registry/> |
| `az containerapp` reference | <https://learn.microsoft.com/en-us/cli/azure/containerapp> |

➡️ **Next:** [`../azure-pipelines/`](../azure-pipelines/README.md)
