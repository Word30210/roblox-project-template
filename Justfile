set shell := ["powershell.exe", "-c"]
set dotenv-load := true

default:
    @just --list

assets:
    asphalt sync studio

assets-debug:
    asphalt sync debug

assets-upload:
    asphalt sync cloud

assets-check:
    asphalt sync cloud --dry-run

install place:
    cd places/{{place}}; pesde install

sourcemap place:
    cd places/{{place}}; rojo sourcemap default.project.json -o sourcemap.json

build place:
    cd places/{{place}}; rojo sourcemap default.project.json -o sourcemap.json; darklua process src dist; darklua process roblox_packages dist/roblox_packages

dev place:
    cd places/{{place}}; mprocs --names "rojo-sourcemap,darklua-src,darklua-pkg,rojo-serve" \
    "rojo sourcemap default.project.json -o sourcemap.json --watch" \
    "darklua process src dist --watch" \
    "darklua process roblox_packages dist/roblox_packages --watch" \
    "rojo serve build.project.json"

clean place:
    cd places/{{place}}; Remove-Item -Recurse -Force dist, sourcemap.json -ErrorAction SilentlyContinue
