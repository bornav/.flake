#!/usr/bin/env sh
set -e
pushd ~/.flake/
# git diff -U0 *.nix
git diff -U0
echo "NixOS Rebuilding ... "
nh os switch ~/.flake -H $flake_name
if [ $? -eq 0 ]; then
    echo "success"
else 
    echo "fail" # seems to never get to it with nh
fi
# sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)
gen=$(nixos-rebuild list-generations --flake ~/.flake#$flake_name | grep current)
git commit -am "$gen"
popd