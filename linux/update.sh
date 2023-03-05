#!/usr/bin/env bash
###
### Copyright (c) 2022 Carbon Community
### All rights reserved
###
set -e

### DON'T CHANGE ANYTHING BELOW ################################################
BASE="$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)"
RUST_HOME="${BASE}/server"

/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "${RUST_HOME}" \
	+login anonymous +app_info_update 1 +app_update 258550 validate +quit
	