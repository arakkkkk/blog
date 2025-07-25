---
title: 踏み台サーバー経由でのAnsible実行
date: 2025-07-25
description: 踏み台の先にあるサーバーを対象にAnsibleを実行する備忘録
tags: 
    - Ansible
categories:
    - Ansible
---

踏み台サーバー経由でAnsibleを実行する方法について、少し詰まったので備忘録

## 結論
踏み台サーバーを使った多段SSHの設定として以下のパラメータを設定することで可能となります
```
ansible_ssh_common_args: '-o ProxyCommand="ssh -i {{ bastion_ssh_private_key_file }} -p {{ bastion_port }} {{ bastion_user }}@{{ bastion_host }} -W %h:%p"'
```

サンプル: [arakkkkk/example-ansible-proxyjump](https://github.com/arakkkkk/example-ansible-proxyjump)

## 構成

以下の構成で、対象サーバーへ踏み台サーバー経由でAnsibleを実行します。

```mermaid
graph LR
    A[ローカルマシン<br/>Ansible実行サーバー] -->|SSH:2222<br>公開鍵認証| B[踏み台サーバー<br/>192.168.11.10]
    B -->|SSH:2222<br>公開鍵認証/パスワード認証| C[対象サーバー<br/>192.168.122.70]
```

## 前提条件

* 踏み台サーバーと対象サーバーの両方でSSH公開鍵認証が設定済み
* 両サーバーともSSHポート2222で接続

## hosts設定 (踏み台サーバー/対象サーバー共に公開鍵認証)

`hosts`ファイルに以下の設定を記述

```ini
ansible-client ansible_host=192.168.122.70 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/keys/id_ed25519 ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/keys/id_ed25519 -p 2222 ubuntu@192.168.11.10 -W %h:%p"' ansible_port=2222
```

[ansible-client.yml](https://github.com/arakkkkk/example-ansible-proxyjump/blob/main/host_vars/ansible-client.yml)のようにhost_varsのymlに記載すると管理しやすいかと思います

- `ansible_host`: 対象サーバーのIPアドレス
- `ansible_user`: 対象サーバーのSSH接続ユーザー
- `ansible_ssh_private_key_file`: 秘密鍵ファイルのパス
- `ansible_port`: 対象サーバーのSSHポート
- `ansible_ssh_common_args`: SSH接続時の追加オプション (踏み台へのSSH接続情報)
  - `ProxyCommand`: 踏み台サーバー経由での接続コマンド
  - `-W %h:%p`: ポートフォワーディング設定

## hosts設定 (踏み台サーバーは公開鍵認証、対象サーバーはパスワード認証)

踏み台サーバーには証明書認証、対象サーバーにはパスワード認証という場合でもAnsibleによる実行は可能です。

`ansible_ssh_private_key_file`パラメータを削除し、実行時に`--ask-pass`をつけて実行時にパスワードを入力して実行が可能です。
```ini
ansible-client ansible_host=192.168.122.70 ansible_user=ubuntu ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/keys/id_ed25519 -p 2222 ubuntu@192.168.11.10 -W %h:%p"' ansible_port=2222
```

Ansible Vault等でパスワードを保存している場合、`ansible_ssh_pass`パラメータとして用意しておくことも可能です
```ini
ansible-client ansible_host=192.168.122.70 ansible_user=ubuntu ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/keys/id_ed25519 -p 2222 ubuntu@192.168.11.10 -W %h:%p"' ansible_ssh_pass={{ vault_bastion_pass }} ansible_port=2222
```

※ただし、上記方式での実行には`sshpass`のインストールが必要です
