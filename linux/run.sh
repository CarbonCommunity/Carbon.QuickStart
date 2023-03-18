#!/usr/bin/env bash
###
### Copyright (c) 2022 Carbon Community
### All rights reserved
###
set -e

### USER SETTINGS ##############################################################
SERVER_NAME="CARBON | env:linux branch:develop"

SERVER_MAP_SIZE=1000
SERVER_MAP_SEED=12345

SERVER_PORT=28507
SERVER_QUERY=28505
SERVER_RCON_PORT=28506
SERVER_RCON_PASS=mypasslol

### DON'T CHANGE ANYTHING BELOW ################################################
BASE="$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)"
RUST_HOME="${BASE}/server"

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${RUST_HOME}/RustDedicated_Data/Plugins/x86_64"
export TERM=xterm

cd "${RUST_HOME}"
source "${RUST_HOME}/carbon/tools/environment.sh"
"${RUST_HOME}/RustDedicated" -batchmode +server.secure 1 +server.tickrate 30 +server.identity carbon \
	+server.port ${SERVER_PORT} +server.queryport ${SERVER_QUERY} +rcon.port ${SERVER_RCON_PORT} \
	+server.hostname "${SERVER_NAME}" +server.seed ${SERVER_MAP_SEED} +server.worldsize ${SERVER_MAP_SIZE} \
	+rcon.password "${SERVER_RCON_PASS}" +rcon.web true +server.maxplayers 8 +app.port 1-
