ssh-keygen -t ed25519 -C "EdgarAether@outlook.jp"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub