# 🧹 05 · Quality

**Two dojos. 4–5 hours. You finish with:** a repo where broken code cannot be committed, and a static analyser telling you things no test will.

> 🧠 **Tests ask "does it work?". Quality tools ask "will this be maintainable, and is it safe?"** Different questions, both worth automating, because neither survives as a habit on willpower alone.

| Dojo | Teaches | Time | Needs |
|---|---|---|---|
| [`eslint-husky/`](eslint-husky/README.md) | ESLint 10 flat config, Prettier, pre-commit hooks, `--max-warnings=0` | 2–3 h | Node 26 |
| [`sonarqube/`](sonarqube/README.md) | Static analysis, code smells, quality gates | 2 h | Docker |

🚪 **Shelf gate:** a repo that refuses your own bad commit, and the ability to read a Sonar finding and say whether it is a real risk or noise.
