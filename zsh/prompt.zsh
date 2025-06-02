git_prompt_info() {
  # if change PWD then clear cache
  if [[ "$_git_prompt_pwd" != "$PWD" ]]; then
    _git_prompt_pwd="$PWD"
    _git_prompt_cache=""
    _git_prompt_time=0
  fi

  # take cache whtn < 1s
  local current_time=$(date +%s)
  if (( current_time - _git_prompt_time < 1 )) && [[ -n "$_git_prompt_cache" ]]; then
    echo "$_git_prompt_cache"
    return
  fi

  # fetch git info
  local git_dir
  git_dir=$(git rev-parse --git-dir 2>/dev/null) || return

  local branch git_status_info=""
  local git_status
  git_status=$(git status --porcelain --branch 2>/dev/null)

  branch=$(echo "$git_status" | head -n1 | sed -E 's/^## ([^.]+).*$/\1/' | sed 's/No commits yet on //')

  # status
  # [[ "$git_status" == *$'\n'[MA][ MTD]* ]] && git_status_info+="+"
  # [[ "$git_status" == *$'\n'[ MTARC]M* ]] && git_status_info+="!"
  # [[ "$git_status" == *$'\n'[ MTARC]D* ]] && git_status_info+="d"
  # [[ "$git_status" == *$'\n'\?\?* ]] && git_status_info+="?"
  # [[ "$git_status" == *$'\n'D.* ]] && git_status_info+="D"
  # [[ "$git_status" == *$'\n'R.* ]] && git_status_info+="R"
  # [[ "$git_status" == *$'\n'C.* ]] && git_status_info+="C"
  # [[ "$git_status" == *$'\n'UU* ]] && git_status_info+="="

  [[ "$git_status" == *$'\n'.[MD]* ]] && git_status_info+="%F{red}*%f"
  [[ "$git_status" == *$'\n'[MADRC]* ]] && git_status_info+="%F{green}+%f"
  [[ "$git_status" == *$'\n'\?\?* ]] && git_status_info+="%F{yellow}?%f"

  # stash
  if [[ -f "$git_dir/refs/stash" ]]; then
    local stash_count=$(wc -l < "$git_dir/refs/stash")
    git_status_info+="%F{blue}\$${stash_count}%f"
  fi

  local remote_status
  remote_status=$(echo "$git_status" | head -n1)
  if [[ "$remote_status" =~ \[ahead\ ([0-9]+)\] ]]; then
    git_status_info+=">${match[1]}"
  fi
  if [[ "$remote_status" =~ \[behind\ ([0-9]+)\] ]]; then
    git_status_info+="<${match[1]}"
  fi

  _git_prompt_cache=" (%F{blue}${branch}%f${git_status_info})"
  _git_prompt_time=$current_time
  echo "$_git_prompt_cache"
}

setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{cyan}%~%f$(git_prompt_info) %# '
