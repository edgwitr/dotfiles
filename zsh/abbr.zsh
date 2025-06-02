# Simple abbreviations for zsh with cursor positioning
# Add this to your .zshrc

# Single dictionary for all abbreviations
# Prefix 'g:' for global abbreviations
typeset -A abbr

# Regular abbreviations (command position only)
abbr[gc]="git commit"
abbr[gcm]="git commit -m \"%\""
abbr[gst]="git status"
abbr[gd]="git diff"
abbr[ga]="git add"
abbr[gp]="git push"
abbr[gl]="git log --oneline"
abbr[ll]="ls -la"

# Examples with multiple % markers
abbr[func]="function %() { % }"
abbr[for]="for % in %; do % done"

# Global abbreviations (anywhere on line)
abbr[g:G]="| grep \"%\""
abbr[g:L]="| less"
abbr[g:H]="| head"
abbr[g:T]="| tail"
abbr[g:S]="| sort"
abbr[g:replace]="sed 's/%/%/g'"

# Expansion function with multiple cursor support
expand-abbreviation() {
    local word="${LBUFFER##* }"
    
    # First: Check for global abbreviation
    local expansion="${abbr[g:$word]}"
    
    # Fallback: Check for regular abbreviation only at command position
    if [[ -z "$expansion" && "$LBUFFER" =~ ^[[:space:]]*${word}$ ]]; then
        expansion="${abbr[$word]}"
    fi
    
    if [[ -n "$expansion" ]]; then
        # Handle cursor positioning if % marker exists
        if [[ "$expansion" == *"%"* ]]; then
            # Split at first % marker and position cursor there
            LBUFFER="${LBUFFER%$word}${expansion%%\%*}"
            RBUFFER="${expansion#*\%}${RBUFFER}"
        else
            LBUFFER="${LBUFFER%$word}${expansion} "
        fi
    else
        LBUFFER+=" "
    fi
}

# Function to jump to next placeholder
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
zle -N next-placeholder

# Bind space to expand abbreviations
bindkey " " expand-abbreviation

# Bind Ctrl+J to jump to next placeholder (or use any key you prefer)
# Alternative bindings you can use:
# bindkey "^J" next-placeholder     # Ctrl+J
# bindkey "^N" next-placeholder     # Ctrl+N
# bindkey "^]" next-placeholder     # Ctrl+]
bindkey "^J" next-placeholder

