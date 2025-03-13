#!/bin/zsh
source ~/.zshrc

set -e

# If Packages aren't installed, install them.
if [ ! -d "roblox_packages" ]; then
    sh scripts/install-packages.sh
fi

rojo sourcemap default.project.json -o sourcemap.json

darklua process --config .darklua.json src/ dist/src
rojo build build.project.json -o project.rbxl