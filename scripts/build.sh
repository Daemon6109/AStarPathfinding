#!/bin/bash

set -e

# Install packages if needed
if [ ! -d "roblox_packages" ]; then
    bash scripts/install-packages.sh
fi

# Run rojo and darklua commands
rojo sourcemap default.project.json -o sourcemap.json
darklua process --config .darklua.json src/ dist/src
rojo build build.project.json -o project.rbxm