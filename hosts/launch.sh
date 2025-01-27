#!/usr/bin/env bash


hosts=("k3s-oraclearm2" "contabo-01-4v-8m-800g" "k3s-oraclearm1") # make sure the one with bootstrap is at the last place
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
    sleep 15
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
elif [[ $1 == service_restart ]]; then
    echo "restarting services"
    for host in "${hosts[@]}"; do
        echo restarting $host
        ssh $host "systemctl restart rke2-server.service"
    done
elif [[ $1 == deploy_all ]]; then
    echo "wg-mesh step"
    wg-mesh
    echo "build step"
    build
    echo "token step"
    prepare_token_rke2
    echo "try update step"
    try_update
    echo "atempting update step"
    update
    echo "done step"
    exit
fi



