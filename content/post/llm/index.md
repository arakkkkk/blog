---
title: Dockerでサクッと始めるローカルLLM(Ollama + Open WebUI)
date: 2025-11-07
description: Docker ComposeでOllamaとOpen WebUIを使ってローカルLLM環境を用意し、ブラウザとAPIから試すまでの手順をまとめました。
tags:
    - LLM
    - Docker
    - Ollama
    - Open WebUI
categories:
    - LLM
---

# DockerでローカルLLMを始める（Ollama + Open WebUI）

ローカルでLLMを試すための最小構成をDocker Composeで用意しました。ブラウザ（Open WebUI）からの利用と、OllamaのAPIの基本的な呼び出し方を簡単にまとめています。

対象リポジトリ: practice-llm-mcp（Composeと初期化スクリプトを同梱）

## クイックスタート

前提条件
- Docker と Docker Compose が導入済み
- 初回のみモデルのダウンロードが発生（ネットワーク接続が必要）

1) リポジトリ取得

```bash
git clone https://github.com/arakkkkk/practice-llm-mcp.git
cd practice-llm-mcp
```

2) コンテナ起動

```bash
# 環境によっては sudo が必要です
sudo docker compose up -d
# Makefile を使う場合
make run
```

3) 動作確認（ブラウザ / API）

- ブラウザ: http://localhost:8080 へアクセス
- API: `curl` で確認

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "qwen:7b-chat",
  "prompt": "明日のやることを3つ箇条書きで",
  "stream": false
}'
```

停止する場合:

```bash
sudo docker compose down
# または
make down
```

---

## コンポーネント概要（Ollama / Open WebUI）

### Ollama
- 役割: ローカルでLLMモデルを実行するエンジン（HTTP 11434 でAPI提供）
- 取得: `ollama pull <model>` でモデルをダウンロード
- 保存: 本構成では `./ollama/data` に永続化

### Open WebUI
- 役割: ブラウザからOllamaを利用するためのUI
- 接続: `OLLAMA_BASE_URL` で Ollama に接続（Composeでは `http://ollama:11434`）
- アクセス: http://localhost:8080
- 保存: 会話履歴等は `./webui/data` に保存

---

## 構成のポイント

### 1) docker compose

`compose.yml` では以下の2サービスを定義しています。

- `ollama`
  - ポート `11434` を公開（API）
  - モデルを `./ollama/data` に永続化
  - 起動後の初期化でモデルを準備（`init.sh`）

- `open-webui`
  - ポート `8080` でWeb UIを提供
  - `OLLAMA_BASE_URL=http://ollama:11434`
  - `depends_on: [ollama]`

### 2) Ollamaの初期化

`ollama/init.sh` で、Ollamaの待ち受け開始を確認した後にモデルをまとめて取得します（初回のみ時間がかかります）。取得対象の例：

- `phi3:mini`
- `llama3:8b`
- `qwen:7b-chat`
- `mistral`
- 埋め込み用途: `gte-small`, `e5-small-v2`, `nomic-embed-text`

不要なモデルがある場合は、`init.sh` の `ollama pull` 行を調整してください。
利用可能なモデルは[library](https://ollama.com/library?)を参考にしてください。

### 3) Makefile

基本操作のショートカットです。

- `make run` … 起動（`docker compose up -d`）
- `make down` … 停止
- `make logs` … ログ確認
- `make restart` … 再ビルド＋再起動

## 補足メモ

- ポート
  - `11434`: Ollama HTTP API（`/api/chat` と `/api/generate`）
  - `8080`: Open WebUI

- 永続化
  - モデルは容量が大きいため、`./ollama/data` に保存して再ダウンロードを避けます
  - WebUI のデータは `./webui/data` に保存します

- 起動順制御
  - `depends_on` に加えて `init.sh` で疎通確認を行います

- モデル選定
  - まずは軽量な `phi3:mini` で確認 → `qwen:7b-chat` や `llama3:8b` へ拡張

---

## よくあるハマりどころ

- 初回起動が長い
  - モデルのダウンロード時間がかかります。`make logs` で進捗を確認してください

- ポート競合
  - `compose.yml` のポートマッピング（例: `11434:11434`）の左側を空いている番号に変更します

- WebUIは開けるが応答がない
  - `open-webui` の `OLLAMA_BASE_URL` が `http://ollama:11434` か、`ollama` コンテナが起動しているかを確認します

- 権限エラー
  - `sudo` を付けるか、ユーザーを `docker` グループへ追加します

---

## まとめ

以下の手順でローカルLLM環境を用意できます。

1. `docker compose up -d`（または `make run`）
2. ブラウザは http://localhost:8080、API は http://localhost:11434

必要に応じて取得するモデルやポート番号を調整しながら、用途に合わせて拡張してください。
