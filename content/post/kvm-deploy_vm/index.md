---
title: 【KVMの仮想化入門②】virshでVMをデプロイしてみる
date: 2024-12-11
description: virshでVMをデプロイしてみる
tags: 
    - KVM
    - Introduction
categories:
    - KVM
---

前回はKVMの仮想化基盤を用意するところまでをやっていみました。今回は`virsh`を用いてCLIから仮想マシンを構築するところまでをやってみます

## virshとは

* KVMやQEMUを利用した仮想化基盤の管理をコマンドラインから行うためのツール
* Libvirtという仮想化管理ツールをバックエンドに利用
* 仮想マシンの作成、削除、起動、停止、リソースの管理などをシンプルなコマンドで実行可能

## virshで利用できる参照コマンド

`virsh`には仮想化リソースを参照するための多くのコマンドが用意されています。  
まずはよく利用しそうなコマンドを使ってみようと思います

### 仮想マシンの参照コマンド
- `virsh list --all`
  - 稼働中、停止中を問わずすべてのVMを表示します(今回はまだVMを作成できていないので表示なし)
```
ubuntu@kvm001:~$ virsh list --all
 Id   Name   State
--------------------

```

仮にVMが存在した場合、以下のような表示になります

```
$ virsh list --all
 Id   Name            State
--------------------------------
 12   ubuntu001       running
 -    ubuntu002       shut off
```

- `virsh dominfo <VM名>`
  - 指定したVMの詳細情報を表示(別途用意した環境で確認)
```
$ virsh dominfo ubuntu001
Id:             12
Name:           ubuntu001
UUID:           bdce429c-1284-463b-8af4-f538374a3b2d
OS Type:        hvm
State:          running
CPU(s):         2
CPU time:       10368.9s
Max memory:     3145728 KiB
Used memory:    3145728 KiB
Persistent:     yes
Autostart:      disable
Managed save:   no
Security model: none
Security DOI:   0
Messages:       tainted: running with undesirable elevated privileges
```

### 仮想ネットワークの参照コマンド
- `virsh net-list`
  - 現在有効な仮想ネットワークの一覧を表示します。
  - `default` という名前の仮想ネットワークがすでに作成されていることがわかります
```
ubuntu@kvm001:~$ virsh net-list --all
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```
- `virsh net-dumpxml <ネットワーク名>`
  - 指定したネットワークのXML設定を表示します。
```
ubuntu@kvm001:~$ virsh net-info default
Name:           default
UUID:           61c20183-757b-402f-a92e-677072b910d0
Active:         yes
Persistent:     yes
Autostart:      yes
Bridge:         virbr0
```

この仮想ネットワークについては、今後もう少し詳細を書きたいと思っています

### 仮想ストレージの参照コマンド
- `virsh pool-list`
  - 現在利用可能なストレージプールの一覧を表示します。(今回はまだ作成できていないので表示なし)
```
ubuntu@kvm001:~$ virsh pool-list --all
 Name   State   Autostart
---------------------------

```

すでに作成されていた場合、以下のような表示になります

```
$ virsh pool-list
 Name           State    Autostart
------------------------------------
 default        active   yes
 ubuntu         active   yes
```

- `virsh pool-info <プール名>`
  - 指定したストレージプールの詳細情報を表示します。
```
$ virsh pool-info default
Name:           default
UUID:           fa63badf-324b-4fa9-992c-81581e9c307f
State:          running
Persistent:     yes
Autostart:      yes
Capacity:       456.35 GiB
Allocation:     72.34 GiB
Available:      384.00 GiB
```

## virsh仮想マシンを構築する

前置きが長くなりましたが、いよいよ仮想マシンの構築に入ります。

1. **ディスクイメージの準備**
   仮想マシン用のディスクイメージを作成します。
   ```bash
   qemu-img create -f qcow2 /var/lib/libvirt/images/myvm.qcow2 20G
   ```
   上記のコマンドで20GBのQCOW2形式のディスクイメージを作成します。

2. **仮想マシンのXMLファイルを作成**
   仮想マシンの構成を定義するXMLファイルを用意します。以下は基本的な構成の例です。
   ```xml
   <domain type='kvm'>
       <name>myvm</name>
       <memory unit='KiB'>2097152</memory>
       <vcpu placement='static'>2</vcpu>
       <os>
           <type arch='x86_64' machine='pc'>hvm</type>
       </os>
       <devices>
           <disk type='file' device='disk'>
               <source file='/var/lib/libvirt/images/myvm.qcow2'/>
               <target dev='vda' bus='virtio'/>
           </disk>
           <interface type='network'>
               <source network='default'/>
           </interface>
       </devices>
   </domain>
   ```

3. **仮想マシンの定義を読み込む**
   用意したXMLファイルを読み込み、仮想マシンを定義します。
   ```bash
   virsh define myvm.xml
   ```

4. **仮想マシンを起動**
   定義した仮想マシンを起動します。
   ```bash
   virsh start myvm
   ```

5. **動作確認**
   起動後、以下のコマンドで仮想マシンの状態を確認します。
   ```bash
   virsh list --all
   ```
