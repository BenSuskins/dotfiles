input=$(cat)

model=$(jq -r '.model.display_name // "unknown"' <<<"$input")
current_directory=$(jq -r '.workspace.current_dir // ""' <<<"$input")
session_cost=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")
context_percentage=$(jq -r '.context_window.used_percentage // 0' <<<"$input")

reset=$'\033[0m'
dim=$'\033[2m'
blue=$'\033[34m'
magenta=$'\033[35m'
green=$'\033[32m'
yellow=$'\033[33m'
red=$'\033[31m'

context_used=$(printf '%.0f' "$context_percentage")
if [ "$context_used" -ge 80 ]; then
  context_colour=$red
elif [ "$context_used" -ge 50 ]; then
  context_colour=$yellow
else
  context_colour=$green
fi

segments=("${magenta}${model}${reset}")

if repository_root=$(git -C "$current_directory" rev-parse --show-toplevel 2>/dev/null); then
  branch=$(git -C "$current_directory" rev-parse --abbrev-ref HEAD 2>/dev/null || echo detached)
  uncommitted_marker=""
  git -C "$current_directory" diff --quiet HEAD 2>/dev/null || uncommitted_marker="*"
  repository=$(basename "$repository_root")
  segments+=("${blue}${repository}${reset}${dim}/${reset}${blue}${branch}${uncommitted_marker}${reset}")
fi

segments+=("${context_colour}${context_used}% ctx${reset}")
segments+=("${dim}\$$(printf '%.2f' "$session_cost")${reset}")

separator="${dim} · ${reset}"
statusline=""
for segment in "${segments[@]}"; do
  [ -n "$statusline" ] && statusline="${statusline}${separator}"
  statusline="${statusline}${segment}"
done

printf '%s\n' "$statusline"
