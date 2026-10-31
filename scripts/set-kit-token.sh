#!/usr/bin/env bash
# Sets the KIT_TOKEN secret on every repo of yours generated from claude-kit (the ones with a
# .copier-answers.yml pointing at claude-kit). The token is read from stdin, never from argv.
#   scripts/set-kit-token.sh [OWNER]   # default owner: the gh-authenticated user
# Token: fine-grained PAT with Contents, Pull requests and Workflows = write on the project
# repos, and Contents = read on claude-kit.
set -euo pipefail

owner="${1:-$(gh api user -q .login)}"
repos=()
while IFS= read -r repo; do
  answers=$(gh api "repos/$repo/contents/.copier-answers.yml" -H "Accept: application/vnd.github.raw" 2>/dev/null || true)
  if grep -q 'claude-kit' <<<"$answers"; then repos+=("$repo"); fi
done < <(gh repo list "$owner" --limit 200 --no-archived --json nameWithOwner -q '.[].nameWithOwner')

if [ "${#repos[@]}" -eq 0 ]; then
  echo "No claude-kit projects found for $owner" >&2
  exit 1
fi
printf 'claude-kit projects:\n'
printf '  %s\n' "${repos[@]}"

read -r -s -p "Paste the KIT_TOKEN (input hidden): " token
echo
[ -n "$token" ] || { echo "empty token" >&2; exit 1; }
for repo in "${repos[@]}"; do
  gh secret set KIT_TOKEN -R "$repo" <<<"$token" >/dev/null
  echo "set: $repo"
done
