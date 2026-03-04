ln -nfs $(pwd)/.gitignore_global $HOME/.gitignore_global
ln -nfs $(pwd)/.gitconfig        $HOME/.gitconfig
ln -nfs $(pwd)/.zshrc            $HOME/.zshrc
ln -nfs $(pwd)/.editorconfig     $HOME/.editorconfig
ln -nfs $(pwd)/nvim              $HOME/.config/nvim
ln -nfs $(pwd)/exec.sh           $HOME/exec.sh

mkdir -p ~/.codex/skills
ln -sfn "$(pwd)/skills/prd" ~/.codex/skills/prd
ln -sfn "$(pwd)/skills/plan" ~/.codex/skills/plan
ln -sfn "$(pwd)/skills/exec" ~/.codex/skills/exec

source ./osx
