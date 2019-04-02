#!/bin/bash -e

#Install the necessary packages
apt-get update
apt-get install -y --no-install-recommends software-properties-common
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install -y \
    autoconf \
    libtool \
    pkg-config \
    git \
    flex \
    bison \
    libsctp-dev \
    libgnutls28-dev \
    libgcrypt-dev \
    libssl-dev \
    libidn11-dev \
    libmongoc-dev \
    libbson-dev \
    libyaml-dev \
    iproute2 \
    wget \
    gcc-7 \
    iptables

apt-get clean 

wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.11.4.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export GOPATH=/root/go
export PATH=$PATH:/usr/local/go/bin
go get -u -v "github.com/gorilla/mux"
go get -u -v "golang.org/x/net/http2"
go get -u -v "golang.org/x/sys/unix"
git clone https://bitbucket.org/nctu_5g/free5gc.git

cd /free5gc
autoreconf -iv
./configure --prefix=`pwd`/install
make -j `nproc`
make install
rm -rf install/etc/free5gc/*.conf && rm -rf install/etc/free5gc/freeDiameter/*.conf
grep -r "mongodb://localhost" | awk -F : '{print $1}' | xargs -i sed -i 's/localhost/mongodb/g' {}
cp /OpenStack-Tacker-CoreNetwork/deploy/free5gc/free5gc.conf /free5gc/install/etc/free5gc/free5gc.conf
echo 192.188.2.100 mongodb >> /etc/hosts 
