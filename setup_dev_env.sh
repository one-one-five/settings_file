#!/bin/bash

echo "🔧 Установка окружения..."

sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget unzip htop nano bash-completion build-essential \
python3 python3-pip python3-venv zsh fonts-powerline

if ! command -v docker &> /dev/null; then
    echo "🐳 Установка Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
fi

# Установка Oh My Zsh и плагинов
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💡 Устанавливаем Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "🔌 Установка плагинов Oh My Zsh..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

if ! command -v starship &> /dev/null; then
    echo "🌟 Устанавливаем Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

mkdir -p ~/.config
cat << 'EOF' > ~/.config/starship.toml
add_newline = false

format = "$username@$hostname $directory $git_branch$git_status $docker_context$python $line_break$character"

[directory]
truncation_length = 3

[git_branch]
symbol = " "
style = "bold white"

[git_status]
style = "yellow"

[docker_context]
symbol = "🐳 "
style = "blue"

[python]
symbol = "🐍 "
style = "green"

[character]
success_symbol = "[❯](green)"
error_symbol = "[❯](red)"
EOF

cat << 'EOF' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

alias ll='ls -lah --color=auto'
alias gs='git status'
alias gp='git push'
alias gc='git commit'
alias cls='clear'
EOF

chsh -s $(which zsh)

echo -e "\n✅ Установка завершена! Перезайди по SSH, чтобы активировались Zsh и Docker.\n"
