# Value format: [g:]<expansion>[|n]
# 'g:' prefix for global abbreviations (anywhere on line)
# '|n' suffix for no-space abbreviations (don't add trailing space)
typeset -A abbr

# Regular abbreviations (command position only)
abbr[gc]="git commit"
abbr[gcm]="git commit -m \"%\""
abbr[gst]="git status"
abbr[gd]="git diff"
abbr[ga]="git add -p"
abbr[gaa]="git add ."
abbr[gp]="git pull"
abbr[gps]="git push"
abbr[gl]="git log --oneline"
abbr[ll]="ls -lhF"
abbr[lla]="ls -lahF"
abbr[d]="cd ~/.local/dotfiles"
abbr[v]="nvim"
abbr[vv]="nvim ."
abbr[e]="nvim ~/.local/dotfiles/flake.nix"
abbr[reload]="exec \$SHELL -l"

# Examples with multiple % markers
abbr[func]="function %() { % }"
abbr[for]="for % in %; do % done"

# Global abbreviations (anywhere on line)
abbr[G]="g:| grep \"%\""
abbr[L]="g:| less"
abbr[H]="g:| head"
abbr[T]="g:| tail"
abbr[S]="g:| sort"
abbr[replace]="g:sed 's/%/%/g'"

# No-space abbreviations (don't add trailing space)
abbr[rehome]="home-manager switch --flake ~/.local/dotfiles/#|n"

# この関数を削除して、get-expansion内で直接処理
get-expansion() {
    local word="${LBUFFER##* }"
    
    if [[ -n "${abbr[$word]}" ]]; then
        local value="${abbr[$word]}"
        local expansion="" is_global=false no_space=false
        
        [[ "$value" == g:* ]] && { is_global=true; value="${value#g:}"; }
        [[ "$value" == *\|n ]] && { no_space=true; expansion="${value%|n}"; } || expansion="$value"
        
        if [[ "$is_global" == "true" || "$LBUFFER" =~ ^[[:space:]]*${word}$ ]]; then
            echo "$expansion,$no_space"
        else
            echo ","
        fi
    else
        echo ","
    fi
}

apply-expansion() {
    local expansion="$1"
    local word="${LBUFFER##* }"

    if [[ "$expansion" == *"%"* ]]; then
        # Split at first % marker and position cursor there
        LBUFFER="${LBUFFER%$word}${expansion%%\%*}"
        RBUFFER="${expansion#*\%}${RBUFFER}"
        return 0  # Has placeholder
    else
        LBUFFER="${LBUFFER%$word}${expansion}"
        return 1  # No placeholder
    fi
}

# Expand abbreviation (for space key)
expand-abbreviation() {
    local result=$(get-expansion)
    local expansion="${result%,*}"
    local no_space="${result#*,}"

    if [[ -n "$expansion" ]]; then
        apply-expansion "$expansion"
        # Add space only if no placeholder and not a no-space abbreviation
        [[ $? -eq 1 && "$no_space" != "true" ]] && LBUFFER+=" "
    else
        LBUFFER+=" "
    fi
}

# Expand and execute (for Enter key)
expand-and-execute() {
    local result=$(get-expansion)
    local expansion="${result%,*}"

    if [[ -n "$expansion" ]]; then
        apply-expansion "$expansion"
        [[ $? -eq 0 ]] && return  # Don't execute if has placeholder
    fi

    zle accept-line
}

# Jump to next placeholder
next-placeholder() {
    if [[ "$RBUFFER" == *"%"* ]]; then
        LBUFFER+="${RBUFFER%%\%*}"
        RBUFFER="${RBUFFER#*\%}"
    else
        LBUFFER+="$RBUFFER"
        RBUFFER=""
    fi
}

zle -N expand-abbreviation
zle -N expand-and-execute
zle -N next-placeholder

# Key bindings
bindkey " " expand-abbreviation
bindkey "^M" expand-and-execute
bindkey "^J" next-placeholder
