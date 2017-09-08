#!/bin/bash

groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle

#passwd oracle
#init oracle password as oracle11g
echo "oracle11g" | passwd --stdin oracle

mkdir -p /u01/oracle
mkdir -p /u01/grid/11g
mkdir -p /u01/oraInventory
chown -R oracle:oinstall /u01/

#backup sysctl.conf
cp /etc/sysctl.conf /etc/sysctl.conf.bk

sed -i \
    -e 's/kernel.shmall/#kernel.shmall/' \
    -e 's/kernel.shmmax/#kernel.shmmax/' \
/etc/sysctl.conf

echo "kernel.shmmni=4096
kernel.shmall=1073741824
kernel.shmmax=4398046511104
kernel.sem=250 32000 100 128
net.core.rmem_default=262144
net.core.rmem_max=4194304
net.core.wmem_default=262144
net.core.wmem_max=1048576
fs.file-max=6815744
fs.aio-max-nr=1048576
net.ipv4.ip_local_port_range=9000 65500" >> /etc/sysctl.conf

sysctl -p

echo "oracle soft nofile 1024
oracle hard nofile 65536
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft stack 10240
oracle hard stack 32768" >> /etc/security/limits.conf

