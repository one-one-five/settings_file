#!/bin/bash

echo "🔧 Установка базового окружения и терминала..."

# Обновление и установка полезных пакетов
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    git curl wget unzip htop nano \
    bash-completion build-essential \
    python3 python3-pip python3-venv \
    zsh fonts-powerline \
    zsh-syntax-highlighting zsh-autosuggestions

# Установка Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Установка Docker..."
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
fi

# Установка Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💡 Устанавливаем Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Установка Starship
if ! command -v starship &> /dev/null; then
    echo "🌟 Устанавливаем Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Конфигурация Starship
mkdir -p ~/.config
cat << 'EOF' > ~/.config/starship.toml
add_newline = false

format = """\
[](#2e3440)\
[](bold white bg:#2e3440)\
[$user@](bold white bg:#2e3440)\
[$hostname](bold white bg:#2e3440)\
[](bg:#4c566a fg:#2e3440)\
[$directory](bold white bg:#4c566a)\
[](fg:#4c566a bg:#5e81ac)\
$git_branch$git_status\
[](fg:#5e81ac bg:#a3be8c)\
$docker_context$python\
[](fg:#a3be8c)\
$line_break$character"""

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

# Настройка .zshrc
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

# Сделать Zsh по умолчанию
chsh -s $(which zsh)

echo -e "\n✅ Установка завершена! Перезайди по SSH, чтобы активировать Zsh и Docker (группа docker может потребовать relogin).\n"

