# 🔬 SonarQube

**Time:** 2 h · **Needs:** Docker · **You finish with:** a local analysis of your own code, and the judgement to tell a real finding from noise.

> 🧠 **The one idea:** ESLint reads a file. SonarQube reads the **whole project over time** — duplication across files, untested new code, security hotspots, and complexity trends. Then a **quality gate** turns all of that into one pass/fail on the code you just wrote.

---

## 1. 📖 The lesson

### What the editions are called

| Edition | What it is |
|---|---|
| **SonarQube Server** | You run it (the self-hosted product) |
| **SonarQube Cloud** | They run it (SaaS) |
| **SonarQube Community Build** | The free self-hosted build — what this dojo uses |
| **SonarLint / SonarQube for IDE** | The editor plugin |

*(Names have changed over the years; older tutorials say "SonarQube" or "SonarCloud" for these. Check the current docs link below rather than trusting a blog post.)*

### The four kinds of finding

| 🏷 Finding | Means | Example |
|---|---|---|
| 🐛 **Bug** | Will probably misbehave | A condition that can never be true |
| 🔓 **Vulnerability** | Exploitable | Unvalidated input reaching a query |
| 🔥 **Security hotspot** | *Needs a human decision* | Use of a weak hash — maybe fine for a cache key, not for a password |
| 👃 **Code smell** | Works, costs you later | A 300-line function; duplicated blocks |

🎯 **A hotspot is not a bug.** It is Sonar saying "a human should look at this one." Reviewing and dismissing hotspots with a reason is the correct workflow — not silencing them.

### The idea that makes gates bearable: **new code**

A gate on *all* code means a legacy project is permanently red and everybody stops looking. A gate on **new code** — what this change added — means today's work must be clean while the old mess is paid down deliberately. That is the setting that makes quality gates survive contact with reality.

---

## 2. 🛠 The drill

| ✅ | Step | Command |
|---|---|---|
| ☐ | 1⃣ Start a local server | `docker run -d --name sonarqube -p 9000:9000 sonarqube:community` |
| ☐ | 2⃣ Open it | <http://localhost:9000> — default login `admin` / `admin`, change it immediately |
| ☐ | 3⃣ Create a project, generate a token | copy the token into `.env` as `SONAR_TOKEN` 🔴 |
| ☐ | 4⃣ Produce coverage first | `npm test -- --coverage` (Sonar reads the LCOV file) |
| ☐ | 5⃣ Configure the scanner | `sonar-project.properties` below |
| ☐ | 6⃣ Scan | `npx sonarqube-scanner` (or `npm run sonar`) |
| ☐ | 7⃣ Read the dashboard | work through every finding |
| ☐ | 8⃣ Fix one of each kind | a smell, a hotspot, and one duplication |

```properties
# sonar-project.properties
sonar.projectKey=stack-dojo
sonar.sources=.
sonar.exclusions=**/node_modules/**,**/dist/**,**/.next/**,**/*.test.ts,**/*.spec.ts
sonar.tests=.
sonar.test.inclusions=**/*.test.ts,**/*.spec.ts
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.host.url=${env.SONAR_HOST_URL}
sonar.token=${env.SONAR_TOKEN}
```

🧪 **Make it find something on purpose.** Copy a 15-line function into three files and re-scan. Sonar reports duplication with a percentage and points at each copy — something no linter and no test would ever have told you. Then extract it into one module and watch the number fall.

🔴 **The token is a credential.** It uploads results as you. It belongs in `.env` locally and in a secret store in CI — never in `sonar-project.properties`, which is committed.

---

## 3. 🚪 The gate

> Run a local SonarQube analysis of your own project with coverage imported, then explain each of your findings: which are real bugs, which are smells you will fix, which hotspots you have reviewed and consciously accepted — and why a gate on *new code* is more useful than one on all code.

---

## 4. 🧯 Common mistakes

| ❌ Mistake | ✅ Instead |
|---|---|
| Scanning without coverage | Run tests with `--coverage` first, and point `lcov.reportPaths` at it |
| Treating every smell as urgent | Triage: bugs and vulnerabilities first |
| Silencing hotspots in bulk | Review each, record the reasoning |
| A quality gate on all code | Gate on **new code** |
| Token committed in a properties file | `.env` / CI secret |
| Scanning `node_modules` | Set `sonar.exclusions` |

---

## 5. 📚 Official docs

| Topic | Where |
|---|---|
| SonarQube documentation | <https://docs.sonarsource.com/> |
| Clean as You Code (the "new code" idea) | <https://docs.sonarsource.com/sonarqube-server/latest/core-concepts/clean-as-you-code/> |
| JavaScript/TypeScript analysis | <https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/languages/javascript-typescript/> |
| Security hotspots explained | <https://docs.sonarsource.com/sonarqube-server/latest/user-guide/security-hotspots/> |

➡️ **Next shelf:** [`../../06-devops/`](../../06-devops/README.md)
