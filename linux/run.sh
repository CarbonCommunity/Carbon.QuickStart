#!/usr/bin/env bash
###
### Copyright (c) 2022 Carbon Community
### All rights reserved
###
set -e

### USER SETTINGS ##############################################################
SERVER_NAME="My Carbon Test Server"

SERVER_MAP_SIZE=1250
SERVER_MAP_SEED=1337

SERVER_PORT=28505
SERVER_RCON_PORT=28506
SERVER_RCON_PASS=mypasslol

### DON'T CHANGE ANYTHING BELOW ################################################
BASE="$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)"
RUST_HOME="${BASE}/server"

CARBON_DL="https://github.com/CarbonCommunity/Carbon.Core/releases/download/develop_build/Carbon.DebugUnix.tar.gz"

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
unzip -o -q /tmp/$(basename ${CARBON_DL}) -d "${RUST_HOME}"
rm /tmp/$(basename ${CARBON_DL})

/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "${RUST_HOME}" \
	+login anonymous +app_info_update 1 +app_update 258550 validate +quit

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${RUST_HOME}/RustDedicated_Data/Plugins/x86_64"
export TERM=xterm

set +e; LOOP=0
while [ ${LOOP} -lt 3 ]; do
	cd ${RUST_HOME} && "${RUST_HOME}/RustDedicated" -batchmode \
		-server.port ${SERVER_PORT} -server.hostname "${SERVER_NAME}" \
		-rcon.port ${SERVER_RCON_PORT} -rcon.password "${SERVER_RCON_PASS}" -rcon.web true \
		+server.seed ${SERVER_MAP_SEED} +server.worldsize ${SERVER_MAP_SIZE}
	LOOP=$(( ${LOOP} + 1 ))
done
