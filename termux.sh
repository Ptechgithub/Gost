#!/bin/bash

check_dependencies() {
    local dependencies=("wget" "curl" "proot-distro")
    
    for dep in "${dependencies[@]}"; do
        if ! command -v "${dep}" &> /dev/null; then
            echo "${dep} is not installed. Installing..."
            pkg install "${dep}" -y
        fi
    done
}

step1() {
    # Update the system and install required packages
    pkg update -y
    pkg upgrade -y
    pkg update
    check_dependencies
    proot-distro install debian
    proot-distro login debian
}

step2() {
    apt update -y
    apt upgrade -y
    apt install sudo -y
    apt install nano -y
    apt install wget -y
    wget https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-armv6-2.11.5.gz
    gunzip gost-linux-armv6-2.11.5.gz
    mv gost-linux-armv6-2.11.5 gost
    chmod +x gost
}

step3() {
    clear
    read -p "Enter your Config (vpn) Port :" config_port
    read -p "Enter your server IP :" ip
    read -p "Please Enter servers connection Port :" connection_port
    read -p "Enter 'udp' for UDP connection (default is: tcp): " connection_type
    connection_type=${connection_type:-tcp}
    read -p "Enter your protocol (example: relay+wss)  [default : relay] : " protocol
    protocol=${protocol:-relay}
    echo "Tunnel is established at :127.0.0.1:$config_port"
    ./gost -L $connection_type://:$config_port/127.0.0.1:$config_port -F $protocol://$ip:$connection_port
}

login() {
    proot-distro login debian
}


clear
echo "By 2--> Peyman * Github.com/Ptechgithub * "
echo ""
echo "-----Gost Tunnel inTermux----"
echo "Select an option:"
echo ""
echo "1) step 1 [install debian]"
echo "2) Step 2 [install Gost]"
echo "3) Step 3 [Run Gost Tunnel]"
echo "4) LOGIN AGAIN"

echo "-----------------------------"
echo "0) Exit"
read -p "Enter your choice: " choice
case "$choice" in
    1)
        step1
        ;;
    2)
        step2
        ;;
    3)
        step3
        ;;
    4)
        login
        ;;
    0)
        exit
        ;;
    *)
        echo "Invalid choice. Please select a valid option."
        ;;
esac