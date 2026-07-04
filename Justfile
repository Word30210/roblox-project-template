set shell := ["powershell.exe", "-c"]
set dotenv-load := true

default:
    @just --list

init:
    echo "installing scripts' packages first..."; cd scripts; pesde install; echo "running scripts/init-all.luau"; cd ..; lute run scripts/src/init-all.luau

clean-all:
    echo "cleaning all pesde/dist files..."; lute run scripts/src/clean-all.luau

# asphalt commands
assets:
    asphalt sync studio

assets-debug:
    asphalt sync debug

assets-upload:
    asphalt sync cloud

assets-check:
    asphalt sync cloud --dry-run

# place-related commands
install place:
    cd places/{{place}}; pesde install

sourcemap place:
    cd places/{{place}}; rojo sourcemap default.project.json -o sourcemap.json

build place:
    cd places/{{place}}; rojo sourcemap default.project.json -o sourcemap.json; darklua process src dist; darklua process roblox_packages dist/roblox_packages

dev place:
    cd places/{{place}}; mprocs --names "rojo-sourcemap,darklua-process,rojo-serve" \
    "rojo sourcemap default.project.json -o sourcemap.json --watch" \
    "darklua process src dist --watch" \
    "rojo serve build.project.json"

clean place:
    cd places/{{place}}; Remove-Item -Recurse -Force dist, sourcemap.json -ErrorAction SilentlyContinue

# package-related commands
install-pkg pkg:
    cd packages/{{pkg}}; pesde install

build-pkg pkg:
    cd packages/{{pkg}}; darklua process src dist;

# TODO: automatically run `pesde update` for places that use the changed package.
dev-pkg pkg:
    lute run scripts/pkg-change-watcher.luau
