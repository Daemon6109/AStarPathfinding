#!/bin/bash

set -e

# Install packages if needed
if [ ! -d "roblox_packages" ]; then
    bash scripts/install-packages.sh
fi

# Run commands in background with wait to keep script alive
rojo serve build.project.json &
PID1=$!
rojo sourcemap default.project.json -o sourcemap.json --watch &
PID2=$!
darklua process --config .darklua.json --watch src/ dist/src &
PID3=$!
NOCOLOR=1 darklua process --config .darklua.json --watch scripts/run-tests.server.luau dist/run-tests.server.luau &
PID4=$!

# Wait for all background processes to complete
wait $PID1 $PID2 $PID3 $PID4