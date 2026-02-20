ln -nfs $(pwd)/.gitignore_global $HOME/.gitignore_global
ln -nfs $(pwd)/.gitconfig        $HOME/.gitconfig
ln -nfs $(pwd)/.zshrc            $HOME/.zshrc
ln -nfs $(pwd)/.editorconfig     $HOME/.editorconfig
ln -nfs $(pwd)/nvim              $HOME/.config/nvim
ln -nfs $(pwd)/exec.sh           $HOME/exec.sh

mkdir -p ~/.codex/skills
ln -sfn "$(pwd)/skills/planner" ~/.codex/skills/planner
ln -sfn "$(pwd)/skills/executor" ~/.codex/skills/executor

source ./osx
