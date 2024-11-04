ln -nfs $(pwd)/.gitignore_global $HOME/.gitignore_global
ln -nfs $(pwd)/.gitconfig        $HOME/.gitconfig
ln -nfs $(pwd)/.zshrc            $HOME/.zshrc
ln -nfs $(pwd)/.editorconfig     $HOME/.editorconfig
ln -nfs $(pwd)/nvim              $HOME/.config/nvim

source ./osx
