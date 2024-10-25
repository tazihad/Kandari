#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  adw-gtk3-theme
  ffmpegthumbnailer
  gnome-tweaks
)

# Function to install packages
install_packages() {
  rpm-ostree install "${packages[@]}"
}

# Call the function to install the packages
install_packages
