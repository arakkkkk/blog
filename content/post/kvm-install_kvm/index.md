---
title: 【KVMの仮想化入門① 】LinuxにKVMをインストールする
date: 2024-12-10
description: LinuxにKVMをインストールして仮想環境の基盤を構築する
tags: 
    - KVM
    - Introduction
categories:
    - KVM
---

KVM（Kernel-based Virtual Machine）について、少し勉強した上でLinuxのマシンにKVMの仮想化基盤を構築するところまでをやってみます

## 仮想化の概要
KVMについてお話する前に、前提として仮想化と、そのプラットフォームについて書いてみます。  
仮想化とは、1つの物理コンピュータ上で複数の仮想マシン（Virtual Machine, VM）を実行する技術です。仮想化により、物理リソースの効率的な活用、アプリケーションの分離、テスト環境の作成が容易になります。

## KVMについて
仮想化技術に使用されるハイパーバイザには様々なものがありますが、今回利用するKVMについてざっくりと特徴を上げると以下になります
* オープンソースとして無料で提供されている
* Linuxカーネルに統合された仮想化機能
* qemu, libvirtと組み合わせて利用される
* virsh, virt-manager, cockpit, OpenStack, oVirtなど様々な管理ツールが存在する
* AWS, GCP等のメガクラウドでも採用されている技術である

※ qemuについて: [第2回　Linux KVMで知る仮想マシンの概要 | gihyo.jp](https://gihyo.jp/dev/serial/01/vm_work/0002)  
※ KVM管理ツールについて: [KVMとは | OSSのデージーネット](https://www.designet.co.jp/faq/term/?id=S1ZN)

## KVMを用いた仮想化環境の構築

```shell
# 必要なパッケージのインストール
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon libvirt-clients bridge-utils

# 再起動
sudo reboot
```

以上で、KVMとその関連ツールのインストールは完了です。

## インストールの確認
以下のコマンドでインストールが成功しているか確認します。

### KVMの状態確認
```shell
ubuntu@kvm001:~$ sudo kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used
```
### libvirtサービスの状態確認
```shell
ubuntu@kvm001:~$ sudo systemctl status libvirtd
○ libvirtd.service - libvirt legacy monolithic daemon
     Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; enabled; preset: enabled)
     Active: inactive (dead) since Fri 2024-12-13 03:18:37 UTC; 9s ago
     # ~~以下省略~~
```

以上で、KVMとその関連ツールのインストールは完了です。 

次回はこのKVM環境でvirshを使って仮想マシンを構築してみます
