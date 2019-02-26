#!/bin/bash -e

check_host_domain (){
    localhost_domain=$(cat /etc/hosts | grep "$1")
    hostname=$(cat /etc/hostname)
    echo "$localhost_domain" | grep -q "$hostname"
    if [[ $? -ne 0 ]]; then
        hostname_domain=$(echo "$localhost_domain $hostname")
        sudo sed -i "s/$localhost_domain/$hostname_domain/g" /etc/hosts
    fi
}

check_test_result (){
    result_log=$(cat $1)
    echo "$result_log" |grep -q "$2"
    while [ $? -ne 0 ]
    do
        sudo ./test/testepc > $1
        result_log=$(cat $1)
        echo "$result_log" |grep -q "$2"
    done
}

check_ipv6_status (){
    if (( $1 )) ; then
        echo IPv6 is disabled
        sudo sh -c "echo 'net.ipv6.conf.pgwtun.disable_ipv6=0' > /etc/sysctl.d/30-nextepc.conf"
         sudo sysctl -p /etc/sysctl.d/30-nextepc.conf
    fi
}

check_host_domain 127.0.0.1

#Install Install the necessary packages
sudo apt-get update 
sudo apt-get -y install mongodb autoconf libtool gcc pkg-config git flex bison libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev
sudo /etc/init.d/mongodb start

#Set TUN device
sudo chmod 666 /dev/net/tun

#Write the configuration file for the TUN deivce
sudo sh -c "cat << EOF > /etc/systemd/network/99-nextepc.netdev
[NetDev]
Name=pgwtun
Kind=tun
EOF"

#Check IPv6 Kernel Configuration
check_ipv6_status $(sudo sysctl -n net.ipv6.conf.pgwtun.disable_ipv6)

#Set the IP address on TUN device
sudo sh -c "cat << EOF > /etc/systemd/network/99-nextepc.network
[Match]
Name=pgwtun
[Network]
Address=45.45.0.1/16
Address=cafe::1/64
EOF"

sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd

#compile
tar zxvf /NextEPC/deploy/nextepc.tar.gz -C /NextEPC/deploy
cd /NextEPC/deploy/nextepc
autoreconf -iv
./configure --prefix=`pwd`/install
make -j `nproc`
make install

#Verify the installation
log_path='../resultLog.txt'
./test/testepc > $log_path
check_test_result $log_path 'All tests passed'

#Modify the configuration of NextEPC
cat ../nextepc.conf > ./install/etc/nextepc/nextepc.conf

#Run nextepc
./nextepc-epcd &

#WebUI installation
sh ../setup_webui.sh
