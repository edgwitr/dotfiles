$data="$HOME/.cache/dpp/repos/github.com"
mkdir -p $data

mkdir $data/Shougo
& {
    Set-Location $data/Shougo
    git clone https://github.com/Shougo/dpp.vim
    git clone https://github.com/Shougo/dpp-ext-installer
    git clone https://github.com/Shougo/dpp-protocol-git
    git clone https://github.com/Shougo/dpp-ext-lazy
    git clone https://github.com/Shougo/dpp-ext-toml
}

mkdir $data/vim-denops
& {
    Set-Location $data/vim-denops
    git clone https://github.com/vim-denops/denops.vim
}
