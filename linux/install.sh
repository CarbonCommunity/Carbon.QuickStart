#!/usr/bin/env bash
###
### Copyright (c) 2022-2023 Carbon Community
### All rights reserved
###
set -e

### DON'T CHANGE ANYTHING BELOW ################################################
CARBON_DL=https://github.com/CarbonCommunity/Carbon.Core/releases/download/preview_build/Carbon.Linux.Debug.tar.gz
BASE="$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)"
RUST_HOME="${BASE}/server"

# Detect package manager
if command -v apt-get &> /dev/null; then
    # Ubuntu/Debian packages
    sudo -- bash <<EOF
	apt-get -qq --yes --no-install-recommends install software-properties-common
	apt-add-repository non-free && dpkg --add-architecture i386
	apt-get -qq update

	echo steam steam/question select "I AGREE" | debconf-set-selections
	DEBIAN_FRONTEND=noninteractive apt-get -qq --yes --no-install-recommends install \
		steamcmd libsdl2-2.0-0 libgdiplus curl unzip
EOF
    elif command -v pacman &> /dev/null; then
    # Arch Linux packages
    bash <<EOF
    sudo pacman -S --noconfirm sdl2 libgdiplus curl unzip

    # Check and install AUR helper if steamcmd is not available
    if ! command -v steamcmd &> /dev/null; then
        if command -v paru &> /dev/null; then
            paru -S --noconfirm steamcmd
        elif command -v yay &> /dev/null; then
            yay -S --noconfirm steamcmd
        else
            # Install paru if no AUR helper exists
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm
            cd ..
            rm -rf paru
            paru -S --noconfirm steamcmd
        fi
    fi
EOF
else
    echo "Unsupported package manager. Please install dependencies manually."
    exit 1
fi

# Download and install Carbon
curl --fail --location --output /tmp/$(basename ${CARBON_DL}) ${CARBON_DL}

[ -d "${RUST_HOME}" ] || mkdir "${RUST_HOME}"
tar xf /tmp/$(basename ${CARBON_DL}) -C "${RUST_HOME}"
rm /tmp/$(basename ${CARBON_DL})

${BASE}/update.sh

# Prompt user about running the server
read -p "Do you want to start the Rust Carbon server now? (y/n): " run_server

if [[ "$run_server" =~ ^[Yy]$ ]]; then
    ${BASE}/run.sh
else
    echo "Server not started. You can run it later using ${BASE}/run.sh"
fi