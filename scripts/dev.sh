#!/bin/zsh
source ~/.zshrc

set -e

# If Packages aren't installed, install them.
if [ ! -d "roblox_packages" ]; then
    sh scripts/install-packages.sh
fi

rojo serve build.project.json \
    & rojo sourcemap default.project.json -o sourcemap.json --watch \
    & darklua process --config .darklua.json --watch src/ dist/src \
    & NOCOLOR=1 darklua process --config .darklua.json --watch scripts/run-tests.server.luau dist/run-tests.server.luau