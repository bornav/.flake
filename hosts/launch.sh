#!/usr/bin/env bash


hosts=("k3s-oraclearm2" "k3s-oraclearm1" "k3s-local-01")

prepare(){
    cd custom
    ansible-playbook prepare-cloud.yaml -i ../wireguard-mesh/automation-wireguard/inventories/inventory.yml
    cd ..
}
update(){
    echo "running switch"
    for host in "${hosts[@]}"; do
        nixos-rebuild switch --flake ~/.flake#$host --target-host $host
        if [ $? -eq 0 ]; then
            echo "Command executed successfully."
        else
            echo "Command failed."
            exit
        fi
    done
}
try_update(){
    echo "running test"
    for host in "${hosts[@]}"; do
        nixos-rebuild test --flake ~/.flake#$host --target-host $host
        if [ $? -eq 0 ]; then
            echo "Command executed successfully."
        else
            echo "Command failed."
            exit
        fi
    done
}
build(){
    echo "running builds"
    for host in "${hosts[@]}"; do
        nixos-rebuild build --flake ~/.flake#$host --target-host $host
        if [ $? -eq 0 ]; then
            echo "Command executed successfully."
        else
            echo "Command failed."
            exit
        fi
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



