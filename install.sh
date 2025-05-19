#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# List of packages to install
PACKAGES=(
    xfce4-terminal # Terminal on Wayland
)

# Function to install packages using pacman
install_packages() {
    echo "Updating package database..."
    sudo pacman -Syu --noconfirm

    echo "Installing packages..."
    for package in "${PACKAGES[@]}"; do
        if ! pacman -Qi "$package" &>/dev/null; then
            echo "Installing $package..."
            sudo pacman -S "$package" --noconfirm
        else
            echo "$package is already installed."
        fi
    done
}

# Main script execution
echo "Starting installation process..."
install_packages
echo "Installation complete!"