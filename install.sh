#!/bin/env bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

echo '+--------------------------------------------------+'
echo '| INSTALLER                                        |'
echo '|                                                  |'
echo '| This will install all of the programs enabled in |'
echo '| this script. To skip installing a program, edit  |'
echo '| this script and disable its variable at the      |'
echo '| beginning of the script.                         |'
echo '+--------------------------------------------------+'
echo ''
echo -n 'Continue? (y/n): '

read continue_install

if [[ $continue_install != "y" ]]; then
	exit 0
fi

sudo apt-get update
sudo apt-get c

# Create ~/.local/bin and add to path if it doesn't exist.
if ! [ -d $HOME/.local/bin ]; then
	echo -e "${YELLOW}Creating $HOME/.local/bin...${RESET}"
	mkdir -p $HOME/.local/bin
	echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
	source $HOME/.bashrc
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}$HOME/.local/bin created.${RESET}"
	else
		echo -e "${RED}Failed to create $HOME/.local/bin.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}$HOME/.local/bin exists.${RESET}"

fi

# Make ~/apps if it doesn't exist
if ! [ -d $HOME/apps ]; then
	echo -e "${YELLOW}Creating $HOME/apps...${RESET}"
	mkdir $HOME/apps
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}$HOME/apps created.${RESET}"
	else
		echo -e "${RED}Failed to create $HOME/apps.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}$HOME/apps exists.${RESET}"
fi

cd $HOME/apps

# Install Git
if ! [ -x "$(command -v git)" ]; then
	echo -e "${YELLOW}Installing git...${RESET}"
	sudo apt install git -y
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}Git installed.${RESET}"
	else
		echo -e "${RED}Failed to install git.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}Git already installed.${RESET}"
fi


# Install Neovim
if ! [ -x "$(command -v nvim)" ]; then
	echo -e "${YELLOW}Installing nvim...${RESET}"
	sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	sudo chmod +x nvim.appimage
	sudo cp $HOME/apps/nvim.appimage /usr/local/bin/nvim
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}Nvim installed.${RESET}"
	else
		echo -e "${RED}Failed to install nvim.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}Nvim already installed.${RESET}"
fi

# Install Rust (required to build Alacritty)
if ! [ -x "$(command -v cargo)" ]; then
	echo -e "${YELLOW}Installing rust...${RESET}"
	sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
	source ~/.bashrc
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}Rust installed.${RESET}"
	else
		echo -e "${RED}Failed to install rust.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}Rust already installed.${RESET}"
fi

# Install Alacritty
if ! [ -x "$(command -v alacritty)" ]; then
	echo -e "${YELLOW}Installing alacritty...${RESET}"
	sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
	git clone https://github.com/alacritty/alacritty.git $HOME/apps/alacritty
	cd $HOME/apps/alacritty
	cargo build --release
	sudo cp target/release/alacritty /usr/local/bin/alacritty
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database
	echo "source $(pwd)/extra/completions/alacritty.bash" >> ~/.bashrc
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}Alacritty installed.${RESET}"
	else
		echo -e "${RED}Failed to install alacritty.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}Alacritty already installed.${RESET}"
fi

# Tmux
if ! [ -x "$(command -v tmux)" ]; then
	echo -e "${YELLOW}Installing tmux...${RESET}"
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}Tmux installed.${RESET}"
	else
		echo -e "${RED}Failed to install tmux.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}Tmux already installed.${RESET}"
fi

# Zsh
if ! [ -x "$(command -v tmux)" ]; then
	echo -e "${YELLOW}Installing tmux...${RESET}"
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}Tmux installed.${RESET}"
	else
		echo -e "${RED}Failed to install tmux.${RESET}"
		exit 1
	fi
else
	echo -e "${GREEN}Tmux already installed.${RESET}"
fi

# Rofi

# Lf

# Vifm

# Dotfiles

# Install SSH key for github
