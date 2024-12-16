---
title: 【KVMの仮想化入門③】仮想マシンのconoleに接続するまで
date: 2024-12-12
description: virshを使って仮想マシンのconsoleに接続するための設定を行います
tags: 
    - KVM
    - Introduction
categories:
    - KVM
---

前回は`virsh`でVMを構築するところまでを実施しました。今回は仮想マシンに追加の設定を行ない、console接続するところまでをやってみようと思います

## 仮想マシンにconsoleに接続する
対象の仮想マシンに十分な設定がなされている場合、下記コマンドでconsoleに入ることができます
```bash
virsh console <仮想マシン名>
```
しかし、今回作成されたVMではエラーとなってしまいconsoleに入ることができません
```
ubuntu@kvm001:~$ virsh console ubuntu001
Connected to domain 'ubuntu001'
Escape character is ^] (Ctrl + ])
error: internal error: cannot find character device <null>
```

## 仮想シリアルコンソールの設定
上記エラーは仮想マシンに仮想シリアルコンソールが設定されていないことに起因するため、その設定を行ないます



## 仮想マシンのOS設定
仮想マシンにconsole接続するためには仮想マシンのOSにも設定が必要になります
