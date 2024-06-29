#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing..."
    sudo apt update
    sudo apt install -y git
fi

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "wget not found. Installing..."
    sudo apt install -y wget
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "Java not found. Installing..."
    sudo apt install -y default-jre
fi

# Check if inotifytools is installed
if ! command -v inotifywait &> /dev/null; then
    echo "inotifytools not found. Installing..."
    sudo apt install -y inotify-tools
fi

# Check if rustup is installed
if ! command -v rustup &> /dev/null; then
    echo "rustup not found. Installing..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Check if make is installed
if ! command -v make &> /dev/null; then
    echo "make not found. Installing..."
    sudo apt install -y make
fi

# Check if gcc is installed
if ! command -v gcc &> /dev/null; then
    echo "gcc not found. Installing..."
    sudo apt install -y gcc
fi

# Clone the repository if not already cloned
if [ ! -d "anuraOS" ]; then
    git clone --recursive https://github.com/MercuryWorkshop/anuraOS
fi

# Change directory to anuraOS
cd anuraOS

# Build if not already built
if [ ! -f "Makefile" ]; then
    # Configure Rust toolchain for wasm32-unknown-unknown
    rustup target add wasm32-unknown-unknown

    # Run make all
    make all
else
    echo "Already built. Skipping make."
fi

echo "Setup complete."
