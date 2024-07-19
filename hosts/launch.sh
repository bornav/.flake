#!/usr/bin/env bash


hosts=("k3s-oraclearm2" "k3s-oraclearm1" "k3s-local-01")
prepare(){
    cd custom
    ansible-playbook prepare-cloud.yaml -i ../wireguard-mesh/automation-wireguard/inventories/inventory.yml
    cd ..
}
update(){
    nixos-rebuild switch --flake ~/.flake#k3s-oraclearm2 --target-host oraclearm2
    nixos-rebuild switch --flake ~/.flake#k3s-oraclearm1 --target-host oraclearm1
    nixos-rebuild switch --flake ~/.flake#k3s-local-01 --target-host k3s-local-01
}
try_update(){
    nixos-rebuild test --flake ~/.flake#k3s-oraclearm2 --target-host oraclearm2
    nixos-rebuild test --flake ~/.flake#k3s-oraclearm1 --target-host oraclearm1
    nixos-rebuild test --flake ~/.flake#k3s-local-01 --target-host k3s-local-01
}
build(){
    for host in "${hosts[@]}"; do
    nixos-rebuild build --flake ~/.flake#$host --target-host $host
    done
}
wg-mesh(){
    cd automation-wireguard
	ansible-playbook wireguard.yml -i "inventories/inventory.yml"
	ansible-playbook ping.yml -i "inventories/inventory.yml"
    cd ../
}
if [[ $1 == test ]]; then
    build
    try_update
elif [[ $1 == wg-mesh ]]; then
    print
    wg-mesh
    exit
elif [[ $1 == build ]]; then
    build
elif [[ $1 == deploy ]]; then
    build
    try_update
    update
elif [[ $1 == switch ]]; then
    build
    try_update
    update
fi



