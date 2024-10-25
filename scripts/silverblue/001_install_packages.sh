#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  ffmpegthumbnailer
  gnome-tweaks
  adw-gtk3-theme
)

# Function to install packages
install_packages() {
  rpm-ostree install "${packages[@]}"
}

# Call the function to install the packages
install_packages
