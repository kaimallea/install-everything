#!/usr/bin/env bash

ZSHRC=https://gist.githubusercontent.com/kaimallea/243514f7540339aef60c0487f4d7e3a9/raw/d9206e40289ed4bbc566c1441adebac361b0c87b/.zshrc

GITCONFIG=https://gist.githubusercontent.com/kaimallea/5622393/raw/db6654c0521aadd46d67cc43edb44a66b1a0145f/.gitconfig

HOMEBREW_INSTALL=https://raw.githubusercontent.com/Homebrew/install/master/install

OH_MY_ZSH_INSTALL=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

POWERLEVEL9K_GIT_REPO=https://github.com/bhilburn/powerlevel9k.git

DOCKER_INSTALL_DMG=https://download.docker.com/mac/stable/Docker.dmg

DOCKER_GPG_KEY=https://download.docker.com/linux/ubuntu/gpg

DOCKER_APT_REPO=https://download.docker.com/linux/ubuntu

NVM_INSTALL=https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh

# OSX-specific stuff
if [[ "$OSTYPE" == darwin* ]]; then

  # Install Homebrew if missing
  if ! type -p brew &>/dev/null; then
    printf '%s\n' "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL $HOMEBREW_INSTALL)"
  fi

  # Install git if missing
  if ! type -p git &>/dev/null; then
    printf '%s\n' "Installing git..."
    brew install git
  fi

  # Install ZSH if missing
  if ! type -p zsh &>/dev/null; then
    printf '%s\n' "Installing ZSH..."
    brew install \
      zsh \
      zsh-completions \
      zsh-syntax-highlighting
  fi

  # Install Hack font if missing
  if ! brew cask ls --versions font-hack-nerd-font &> /dev/null; then
    printf '%s\n' "Installing Hack font..."
    brew tap caskroom/fonts && brew cask install font-hack-nerd-font
  fi

  # Install curl if missing
  if ! type -p curl &>/dev/null; then
    printf '%s\n' "Installing curl..."
    brew install curl
  fi

  # Install vim if missing
  if ! type -p vim &>/dev/null; then
    printf '%s\n' "Installing vim..."
    brew install vim
  fi

  # Install docker if missing
  if ! type -p docker &>/dev/null; then
    printf '%s\n' "Installing Docker..."
    curl "$DOCKER_DMG" > /tmp/Docker.dmg
    local VOLUME=`hdiutil attach /tmp/Docker.dmg | grep Volumes | awk '{print $3}'`
    cp -rf "$VOLUME/*.app" /Applications
    hdiutil detach "$VOLUME" && rm /tmp/Docker.dmg
  fi
fi

# Linux-specific stuff
if [[ "$OSTYPE" == linux* ]]; then
  apt_cache=""

  # Install git if missing
  if ! type -p git &>/dev/null; then
    [ -z "$apt_cache" ] && sudo apt update && apt_cache=1 
    printf '%s\n' "Installing git..."
    sudo apt install -y git
  fi

  # Install ZSH if missing
  if ! type -p zsh &>/dev/null; then
    [ -z "$apt_cache" ] && sudo apt update && apt_cache=1 
    printf '%s\n' "Installing ZSH..."
    sudo apt install -y \
      zsh \
      zsh-syntax-highlighting
  fi

  # Install Hack Nerd Font if missing
  if ! dpkg -l fonts-hack-ttf &> /dev/null; then
    [ -z "$apt_cache" ] && sudo apt update && apt_cache=1 
    printf '%s\n' "Installing Hack font..."
    sudo apt install -y fonts-hack-ttf
  fi

  # Install curl if missing
  if ! type -p curl &>/dev/null; then
    [ -z "$apt_cache" ] && sudo apt update && apt_cache=1 
    printf '%s\n' "Installing curl..."
    sudo apt install -y curl
  fi

  # Install vim if missing
  if ! type -p vim &>/dev/null; then
    [ -z "$apt_cache" ] && sudo apt update && apt_cache=1 
    printf '%s\n' "Installing vim..."
    sudo apt install -y vim
  fi

  # Install docker if missing
  if ! type -p docker &>/dev/null; then
    [ -z "$apt_cache" ] && sudo apt update && apt_cache=1 
    printf '%s\n' "Installing Docker..."
    sudo apt install -y \
      apt-transport-https \
      ca-certificates \
      software-properties-common

    curl -fsSL "$DOCKER_GPG_KEY" | sudo apt-key add -

    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository \
      "deb [arch=amd64] $DOCKER_APT_REPO \
      $(lsb_release -cs) \
      stable"

    sudo apt install docker-ce
  fi
fi

# Install .gitconfig
if [[ ! -s "$HOME/.gitconfig" ]]; then
  printf '%s\n' "Installing .gitconfig..."
  curl "$GITCONFIG" > "$HOME/.gitconfig"
fi


# Install .zshrc
if [[ ! -s "$HOME/.zshrc" ]]; then
  printf '%s\n' "Installing .zshrc..."
  curl "$ZSHRC" > "$HOME/.zshrc"
fi

# Install oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  printf '%s\n' "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL $OH_MY_ZSH_INSTALL)"
fi

# Install Powerlevel9k theme
if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]]; then
  printf '%s\n' "Installing powerlevel9k..."
  git clone "$POWERLEVEL9K_GIT_REPO" "$HOME/.oh-my-zsh/custom/themes/powerlevel9k"
fi

# Install NVM if missing
if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
  printf '%s\n' "Installing NVM..."
  curl -o- "$NVM_INSTALL" | "$BASH"
fi

# Install Node if missing
if ! type -p node &>/dev/null; then
  printf '%s\n' "Installing Node.js..."
  nvm install 10 --latest-npm
  nvm use 10
fi

# Install Yarn if missing
if ! type -p yarn &>/dev/null; then
  printf '%s\n' "Installing Yarn..."
  npm install -g yarn
fi
