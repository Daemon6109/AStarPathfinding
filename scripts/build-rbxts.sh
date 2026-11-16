#!/bin/bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d "${TMPDIR:-$root}/astar-rbxts.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/src"
cp -R "$root/src/Classes" "$root/src/Utils" "$root/src/Types.luau" "$root/src/init.luau" "$tmp/src/"
cp "$root/rokit.toml" "$tmp/"
# The source entry uses @self, which is not defined in .luaurc. Resolve it in
# the staging copy only; the original Luau source is deliberately untouched.
perl -pi -e 's/\@self\//.\//g' "$tmp/src/init.luau"
printf '%s\n' '{"name":"AStarPathfinding","tree":{"$path":"src"}}' > "$tmp/default.project.json"
printf '%s\n' '{"rules":[{"rule":"convert_require","current":"path","target":{"name":"roblox","rojo_sourcemap":"sourcemap.json","indexing_style":"property"}}]}' > "$tmp/config.json"
(cd "$tmp" && rojo sourcemap default.project.json -o sourcemap.json && darklua process --config config.json src generated 2>&1 | tee conversion.log && ! grep -E '(^|[[:space:]])WARN([[:space:]]|[>])' conversion.log)
rm -rf "$root/rbxts/runtime"
cp -R "$tmp/generated" "$root/rbxts/runtime"
