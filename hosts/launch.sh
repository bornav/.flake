#!/usr/bin/env bash


hosts=("k3s-oraclearm2" "k3s-local-01" "k3s-oraclearm1")
prepare_token_rke2(){
    # while true; do
        echo "running token"
        for host in "${hosts[@]}"; do
            # ssh $host "mkdir -p /etc/rancher/rke2/"
            scp /home/bocmo/.ssh/token $host:/var/token
        done
        # sleep 2
    # done
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
    echo "sleeping before ping"
    sleep 10
	ansible-playbook ping.yml -i "inventories/inventory.yml"
    cd ../
}
if [[ $1 == test ]]; then
    build
    prepare_token_rke2
    try_update
elif [[ $1 == wg-mesh ]]; then
    print
    wg-mesh
    exit
elif [[ $1 == build ]]; then
    build
elif [[ $1 == deploy ]]; then
    build
    prepare_token_rke2
    try_update
    update
elif [[ $1 == switch ]]; then
    build
    prepare_token_rke2
    # prepare_token_rke2 &
    # TOKEN_PID=$!
    # kill $TOKEN_PID
    # wait $TOKEN_PID
    try_update
    update
elif [[ $1 == token ]]; then
    prepare_token_rke2
fi



