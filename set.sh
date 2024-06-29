#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install dependencies if not already installed
install_if_not_present() {
  if ! dpkg -s $1 > /dev/null 2>&1; then
    sudo apt install -y $1
  else
    echo "$1 is already installed"
  fi
}

install_if_not_present nodejs
install_if_not_present npm
install_if_not_present wget
install_if_not_present default-jdk
install_if_not_present inotify-tools
install_if_not_present make
install_if_not_present gcc
install_if_not_present docker.io

# Install Rustup and add the required Rust toolchain if not already installed
if ! command -v rustup > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
else
  echo "rustup is already installed"
  source $HOME/.cargo/env
fi

if ! rustup target list --installed | grep -q wasm32-unknown-unknown; then
  rustup target add wasm32-unknown-unknown
else
  echo "Rust target wasm32-unknown-unknown is already added"
fi

# Clone the repository if not already cloned
if [ ! -d "anuraOS" ]; then
  git clone --recursive https://github.com/MercuryWorkshop/anuraOS
else
  echo "anuraOS repository is already cloned"
fi

cd anuraOS

# Build the project
make all

# Add user to the docker group if not already added
if ! groups $USER | grep -q "\bdocker\b"; then
  sudo usermod -aG docker $USER
  echo "User $USER added to docker group. Please log out and log back in to apply changes."
else
  echo "User $USER is already in the docker group"
fi

# Build the Linux RootFS
make rootfs

# Start the AnuraOS server
make server

# Print completion message
echo "AnuraOS setup is complete and the server is running at http://localhost:8000"
