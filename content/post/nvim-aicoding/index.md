---
title: Neovimで使えるAIコーディング支援プラグイン比較【2025年版】
date: 2025-06-20
description: Neovimを使ったAIコーディング方法を模索します
tags: 
    - NeoVim
    - AI Coding
categories:
    - NeoVim
---


## Neovim AIコーディング用プラグイン（2025/06/20）

他にも様々あるかと思いますが、コーディングのサポートがあり、GitHubのスター数が1k以上ということを基準に探してみました。

## 🔍 比較対象プラグイン

* **avante.nvim**
* **Copilot.vnim (+CopilotChat.nvim)**
* **codecompanion.nvim**

## 📊 機能比較表

| プラグイン名       | GitHub Star | 補完機能 | チャットモード | ファイル作成         | 複数ファイル同時編集                    |
| ------------------ | ----------- | -------- | -------------- | -------------------- | --------------------------------------- |
| avante.nvim        | 14.9k       | ×        | ◯              | ◯                    | ✕                                       |
| CopilotChat.nvim   | 3K(3.5k)    | ◯        | ◯              | ✕                    |                                         |
| codecompanion.nvim | 4.4k        | ×        | ◯              | ✅ Slashで新規作成可 | ✅ 複数チャット同時 ＆ ワークフロー可能 |

---

## 💡 詳細な解説

### avante.nvim

* **スター数**：約1.3K ([github.com][1], [github.com][2], [neovim.discourse.group][3])
* **補完機能**：完全なインライン補完ではなく、チャットで差分を提案 → **diff形式で即適用**
* **チャットモード**：あり。対話形式でdiff提案&#x20;
* **ワークスペース読み込み**：基本的には**現在のファイルのみ**
* **ファイル作成**：未対応
* **複数ファイル対応**：diffは単一ファイル中心

### CopilotChat.nvim

* **スター数**：約3K&#x20;
* **補完機能**：copilot.lua 経由でインライン補完
* **チャットモード**：あり。チャットUI＋diff 組み込み ([github.com][4])
* **ワークスペース読み込み**：Smart embedding によるバッファ/ファイル全体の読み込み ([github.com][4])
* **ファイル作成**：難しいが Quickfix 連携で実質可能
* **複数ファイル対応**：Quickfix／複数バッファ処理で対応

### codecompanion.nvim

* **スター数**：約4.4K ([github.com][4])
* **補完機能**：インライン補完対応（複数LLM）
* **チャットモード**：あり。チャットバッファ、エージェント機能 ([github.com][5])
* **ワークスペース読み込み**：バッファ、LSP、ツール／ワークフローにも対応&#x20;
* **ファイル作成**：Slash Commands 等で**新規ファイル生成に対応**
* **複数ファイル対応**：複数チャット、エージェントで同時操作が可能

---

## 🧭 おすすめ用途ごとに選ぶなら？

* **diffで提案 → すぐ適用したい人**：`avante.nvim`
* **Copilot Chat を Neovim で使いたい人**：`CopilotChat.nvim`
* **フルスタックAI開発支援（補完〜ファイル生成〜複数ファイル編集）を目指す人**：`codecompanion.nvim`

---

必要なら設定例やサンプルプロンプトなど、さらに掘り下げてご紹介できます！

[1]: https://github.com/yetone/avante.nvim?utm_source=chatgpt.com "yetone/avante.nvim: Use your Neovim like using Cursor AI IDE!"
[2]: https://github.com/LazyVim/LazyVim/discussions/4402?utm_source=chatgpt.com "avante.nvim · LazyVim LazyVim · Discussion #4402 - GitHub"
[3]: https://neovim.discourse.group/t/what-is-the-current-and-future-state-of-ai-integration-in-neovim/5303?utm_source=chatgpt.com "What is the current and future state of AI integration in Neovim?"
[4]: https://github.com/CopilotC-Nvim/CopilotChat.nvim?utm_source=chatgpt.com "CopilotC-Nvim/CopilotChat.nvim: Chat with GitHub Copilot in Neovim"
[5]: https://github.com/olimorris/codecompanion.nvim?utm_source=chatgpt.com "olimorris/codecompanion.nvim: AI-powered coding, seamlessly in ..."
