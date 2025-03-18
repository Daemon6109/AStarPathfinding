#!/bin/bash

set -e

OUTPUT=project.rbxl

echo "Checking for roblox_packages..."
if [ ! -d "roblox_packages" ]; then
    echo "Installing packages..."
    bash scripts/install-packages.sh
fi

echo "Processing src with darklua..."
darklua process --config .darklua.json src/ dist/src &&
echo "Processing run-tests with darklua..."
darklua process --config .darklua.json scripts/run-tests.server.luau dist/run-tests.server.luau &&
echo "Building with rojo..."
rojo build dev.project.json --output "$OUTPUT" &&
echo "Running tests in Roblox..."
run-in-roblox --place "$OUTPUT" --script dist/run-tests.server.luau --port 56000