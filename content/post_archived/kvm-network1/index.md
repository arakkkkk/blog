---
title: 【KVMの仮想化入門⑤】仮想ネットワークの種類と接続方法
date: 2024-12-18
description: KVMで作成される仮想ネットワークについて、その種類と、アタッチされる仮想マシンの接続方法を紹介します
tags: 
    - KVM
    - Introduction
categories:
    - KVM
---

前回はcockpitで仮想マシンを作成する方法を紹介しました。  

## 設定概要
### VMのネットワークの種類
* 

## 仮想ネットワーク
```
ubuntu@kvm001:~$ virsh net-dumpxml default
<network>
  <name>default</name>
  <uuid>61c20183-757b-402f-a92e-677072b910d0</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:a3:31:ff'/>
  <ip address='192.168.123.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.123.2' end='192.168.123.254'/>
    </dhcp>
  </ip>
</network>
```

## 仮想NIC
```
    <interface type='network'>
      <mac address='52:54:00:77:59:98'/>
      <source network='default'/>
      <model type='rtl8139'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
```
