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

前回はKVMの仮想化基盤を用意するところまでをやってみました。今回は`virsh`を用いてCLIから仮想マシンを構築するところまでをやってみます

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
  - 指定したネットワークの設定を表示します。
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

### isoの準備
今回は、ubuntuのVMを作成しようと思うので、wgetでubuntuのisoをダウンロードしておきます
```bash
mkdir /iso
sudo wget -P /iso https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso                 
```
### ディスクイメージの準備
仮想マシン用のディスクイメージを作成します。
```bash
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/ubuntu001.qcow2 20G
```

### 仮想マシンのXMLファイルを作成
libvirtでは、XMLを用いてVMの構成管理が行われます  
そのため、以下の仮想マシンの構成を定義するXMLファイルを用意します
```bash
vi ubuntu001.xml
```
ファイルには以下内容を記載します
```xml
<domain type='kvm'>
  <name>ubuntu001</name>
  <memory unit='MiB'>4096</memory>
  <vcpu placement='static'>2</vcpu>
  <os>
    <type arch='x86_64' machine='pc-i440fx-6.2'>hvm</type>
    <boot dev='cdrom'/>
  </os>
  <devices>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/ubuntu001.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/iso/ubuntu-24.04.1-live-server-amd64.iso'/>
      <target dev='sda' bus='sata'/>
    </disk>
    <interface type='network'>
      <source network='default'/>
    </interface>
    <graphics type='vnc' port='-1' autoport='yes'/>
  </devices>
</domain>
```

XMLに記載している内容について、細かい内容は省略しますが下記設定を盛り込んでいます
- 基本情報
  - `<name>ubuntu001</name>`: vm名をubuntu001とする
  - `<memory unit='MiB'>4096</memory>`: 仮想マシンに割り当てるメモリ量を4096MB=2GBとする
  - `<vcpu placement='static'>2</vcpu>`: 割り当てるvCPUの数を2にする
- OSの設定 (`<os>`)
  - `<boot dev='cdrom'/>`: 仮想マシン起動時にCD-ROMを最初のブートデバイスとして使用するように設定
- ストレージの設定 (`<disk>`)
  - 仮想ディスク
    - `<source file='/var/lib/libvirt/images/ubuntu001.qcow2'/>`: 作成した仮想ディスクのパスを指定
  - ISOイメージ（`<disk>`）
    - `<disk type='file' device='cdrom'>`: ISOイメージを光学ドライブに割り当てる設定
    - `<source file='/iso/ubuntu-24.04.1-live-server-amd64.iso'/>`: ダウンロードしたISOイメージをソースに設定
- ネットワーク設定 (`<interface>`)
  - `<interface type='network'>`: 仮想マシンのネットワークインターフェイスを設定 (NATを用いた接続)
  - `<source network='default'/>`: 事前定義された`default`ネットワークを使用

詳細は下記サイトにまとまっています
 * [7.3. 仮想マシンの XML 設定例 | Red Hat Product Documentation](https://docs.redhat.com/ja/documentation/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/sample-virtual-machine-xml-configuration_viewing-information-about-virtual-machines#sample-virtual-machine-xml-configuration_viewing-information-about-virtual-machines)

### 仮想マシンの定義を読み込む
用意したXMLファイルを読み込み、仮想マシンを定義します。
```bash
virsh define ubuntu001.xml
```
ちなみに、この時点で仮想マシンが作成された状態となり、`virsh list --all`でその状態が確認できます。
```
ubuntu@kvm001:~$ virsh list --all
 Id   Name        State
----------------------------
 -    ubuntu001   shut off
```

### 仮想マシンを起動
定義した仮想マシンを起動します。
```bash
virsh start ubuntu001
```
起動後、以下のコマンドで仮想マシンの状態を確認します。

 ```bash
 ubuntu@kvm001:~$ virsh list --all
 Id   Name   State
----------------------
 3    myvm   running
```

以上で仮想マシンを構築するところまでが完了しました。  
次回はcockpitを使ってwebのGUIからVMを操作するところまでを実施します
