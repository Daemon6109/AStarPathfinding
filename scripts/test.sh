#!/bin/bash

set -e

OUTPUT=project.rbxl

# Install packages if needed
if [ ! -d "roblox_packages" ]; then
    bash scripts/install-packages.sh
fi

# Build and test sequence
darklua process --config .darklua.json src/ dist/src &&
darklua process --config .darklua.json scripts/run-tests.server.luau dist/run-tests.server.luau &&
rojo build build.project.json --output "$OUTPUT" &&
run-in-roblox --place "$OUTPUT" --script dist/run-tests.server.luau