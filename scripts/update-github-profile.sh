#!/usr/bin/env bash
#
# update-github-profile.sh
# ────────────────────────────────────────────────────────────────────────────
# Sets, in one run:
#   1. your GitHub profile BIO (with hashtags)
#   2. this repository's ABOUT (description), TOPICS and WEBSITE
#
# Safe by default: it prints exactly what WOULD change and exits.
# Nothing is written until you pass --apply.
#
#   ./scripts/update-github-profile.sh              # dry run (default)
#   ./scripts/update-github-profile.sh --apply      # actually write
#   ./scripts/update-github-profile.sh --apply --yes  # write, skip the prompt
#
# Requires: gh (GitHub CLI), authenticated.   brew install gh && gh auth login
# ────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# ─── EDIT THESE ─────────────────────────────────────────────────────────────

GH_USER="suryakulshreshtha"
REPO="suryakulshreshtha/Forkable-Stack-Dojo-Typescript"

# Profile bio. GitHub truncates long bios (around 160 characters), so the
# script refuses to write one longer than that rather than silently cutting it.
BIO="SDET & Test Automation Architect. I publish Forkable* repos that teach by running, not reading. #SDET #TestAutomation #Playwright #TypeScript #DevOps"

# This repo's About box.
DESCRIPTION="Learn a modern TypeScript stack one tool at a time: 22 self-contained dojos with a lesson, a drill you build, and a gate you must clear. Next.js, React, Express, Prisma, Playwright, Docker, Azure. Commands for macOS and Windows."

# This repo's website link.
HOMEPAGE="https://suryakulshreshtha.github.io"

# Repo topics (GitHub allows up to 20; lowercase, hyphens, no spaces).
TOPICS="typescript,nextjs,react,express,prisma,playwright,jest,eslint,docker,azure,tailwindcss,jotai,learning-by-doing,sdet,test-automation,teaching"

# ─── END OF EDITABLE SECTION ────────────────────────────────────────────────

APPLY=false
ASSUME_YES=false
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=true ;;
    --yes|-y) ASSUME_YES=true ;;
    --help|-h) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg (try --help)" >&2; exit 2 ;;
  esac
done

bold() { printf '\033[1m%s\033[0m\n' "$1"; }
ok()   { printf '\033[32m✅ %s\033[0m\n' "$1"; }
warn() { printf '\033[33m⚠️  %s\033[0m\n' "$1"; }
err()  { printf '\033[31m❌ %s\033[0m\n' "$1" >&2; }

# ─── 1. Preflight ───────────────────────────────────────────────────────────

bold "1 · Preflight"

if ! command -v gh >/dev/null 2>&1; then
  err "GitHub CLI (gh) is not installed."
  echo "   macOS:   brew install gh"
  echo "   Windows: winget install GitHub.cli"
  exit 1
fi
ok "gh found: $(gh --version | head -1)"

if ! gh auth status >/dev/null 2>&1; then
  err "gh is not authenticated. Run: gh auth login"
  exit 1
fi
ok "gh authenticated"

BIO_LEN=${#BIO}
if [ "$BIO_LEN" -gt 160 ]; then
  err "BIO is $BIO_LEN characters. GitHub truncates around 160 — shorten it and re-run."
  exit 1
fi
ok "BIO length $BIO_LEN / 160"

TOPIC_COUNT=$(printf '%s' "$TOPICS" | tr ',' '\n' | grep -c .)
if [ "$TOPIC_COUNT" -gt 20 ]; then
  err "$TOPIC_COUNT topics listed. GitHub allows up to 20."
  exit 1
fi
ok "$TOPIC_COUNT topics"

if ! gh repo view "$REPO" >/dev/null 2>&1; then
  err "Cannot see $REPO. Create and push it first, or fix the REPO value."
  exit 1
fi
ok "repo reachable: $REPO"

# ─── 2. Show the diff ───────────────────────────────────────────────────────

echo
bold "2 · What will change"

CURRENT_BIO=$(gh api "/users/$GH_USER" --jq '.bio // ""')
CURRENT_DESC=$(gh repo view "$REPO" --json description --jq '.description // ""')
CURRENT_HOME=$(gh repo view "$REPO" --json homepageUrl --jq '.homepageUrl // ""')
CURRENT_TOPICS=$(gh repo view "$REPO" --json repositoryTopics \
                   --jq '[.repositoryTopics[]?.name] | sort | join(",")' 2>/dev/null || echo "")

printf '\n\033[1mPROFILE BIO\033[0m (github.com/%s)\n' "$GH_USER"
printf '  before: %s\n' "${CURRENT_BIO:-(empty)}"
printf '  after:  %s\n' "$BIO"

printf '\n\033[1mREPO ABOUT\033[0m (%s)\n' "$REPO"
printf '  before: %s\n' "${CURRENT_DESC:-(empty)}"
printf '  after:  %s\n' "$DESCRIPTION"

printf '\n\033[1mREPO WEBSITE\033[0m\n'
printf '  before: %s\n' "${CURRENT_HOME:-(empty)}"
printf '  after:  %s\n' "$HOMEPAGE"

printf '\n\033[1mREPO TOPICS\033[0m\n'
printf '  before: %s\n' "${CURRENT_TOPICS:-(none)}"
printf '  after:  %s\n' "$TOPICS"

# ─── 3. Apply ───────────────────────────────────────────────────────────────

echo
if [ "$APPLY" != true ]; then
  bold "3 · Dry run — nothing was changed"
  echo "   Re-run with --apply to write these changes."
  exit 0
fi

if [ "$ASSUME_YES" != true ]; then
  bold "3 · Apply"
  printf 'Write these changes to GitHub? [y/N] '
  read -r reply
  case "$reply" in
    [yY]|[yY][eE][sS]) ;;
    *) warn "Aborted. Nothing was changed."; exit 0 ;;
  esac
fi

echo
gh api -X PATCH /user -f bio="$BIO" >/dev/null
ok "profile bio updated"

gh repo edit "$REPO" --description "$DESCRIPTION" >/dev/null
ok "repo About updated"

gh repo edit "$REPO" --homepage "$HOMEPAGE" >/dev/null
ok "repo website updated"

# --add-topic replaces nothing, so clear the old set first for an exact match.
if [ -n "$CURRENT_TOPICS" ]; then
  OLD_IFS=$IFS; IFS=','
  for t in $CURRENT_TOPICS; do
    [ -n "$t" ] && gh repo edit "$REPO" --remove-topic "$t" >/dev/null 2>&1 || true
  done
  IFS=$OLD_IFS
fi
gh repo edit "$REPO" --add-topic "$TOPICS" >/dev/null
ok "repo topics set"

echo
bold "Done. Verify:"
echo "  gh api /users/$GH_USER --jq .bio"
echo "  gh repo view $REPO --json description,homepageUrl,repositoryTopics"
