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

# Install steamcmd and some generic dependencies
sudo -- bash <<EOF
	set -e

	apt-get -qq --yes --no-install-recommends install software-properties-common
	apt-add-repository non-free && dpkg --add-architecture i386
	apt-get -qq update

	echo steam steam/question select "I AGREE" | debconf-set-selections
	DEBIAN_FRONTEND=noninteractive apt-get -qq --yes --no-install-recommends install \
		steamcmd libsdl2-2.0-0 libgdiplus curl unzip
EOF

# Download and install Carbon
curl --fail --location --output /tmp/$(basename ${CARBON_DL}) ${CARBON_DL}

[ -d "${RUST_HOME}" ] || mkdir "${RUST_HOME}"
tar xf /tmp/$(basename ${CARBON_DL}) -C "${RUST_HOME}"
rm /tmp/$(basename ${CARBON_DL})

${BASE}/update.sh
${BASE}/run.sh