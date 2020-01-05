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
git clone https://github.com/tw0927041027/OpenStack-Tacker-Exercise -b kubevirt
cd /free5gc
autoreconf -iv
./configure --prefix=`pwd`/install
make -j `nproc`
make install
grep -r "mongodb://localhost" | awk -F : '{print $1}' | xargs -i sed -i 's/localhost/mongodb/g' {}
