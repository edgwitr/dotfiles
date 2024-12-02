mkdir -p ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "EdgarAether@outlook.jp"
[ -z "$SSH_AGENT_PID" ] && eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
