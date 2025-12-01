# AI Auto-Fix Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Gemini Code Assist のレビューに自動対応する再利用可能なGitHub Actionsワークフローテンプレートです。

## 概要

```
PR作成/更新 → Gemini がレビュー → AI Auto-Fix が自動修正 → コミット
```

### 機能

- 🔍 **問題検出**: Lint, TypeScript, Build, Test エラーを自動検出
- 🤖 **Gemini連携**: Gemini Code Assist のレビュー優先度に応じて対応
- 🔧 **自動修正**: Lint/Format エラーを即座に修正
- 🧠 **AI分析**: 複雑な問題を Gemini または Claude AI が分析・修正
- 📝 **レポート**: PR に修正内容を自動コメント

## クイックスタート

### 方法1: セットアップスクリプト（推奨）

```bash
curl -fsSL https://raw.githubusercontent.com/BoxPistols/ai-auto-fix-template/main/setup.sh | bash
```

### 方法2: 手動設定

`.github/workflows/ai-auto-fix.yml` を作成:

```yaml
name: AI Auto Fix

on:
  pull_request:
    types: [opened, synchronize, reopened]
  pull_request_review:
    types: [submitted]
  workflow_dispatch:

jobs:
  ai-auto-fix:
    uses: BoxPistols/ai-auto-fix-template/.github/workflows/reusable-ai-auto-fix.yml@main
    with:
      node_version: '20'
      package_manager: 'pnpm'
      tech_stack: 'React, TypeScript, Vite'
      language: 'ja'
    secrets:
      GOOGLE_API_KEY: ${{ secrets.GOOGLE_API_KEY }}       # 推奨（無料枠あり）
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }} # オプション
```

## 必要な設定

### 1. GitHub Secrets

| Secret | 必須 | 説明 |
|--------|------|------|
| `GOOGLE_API_KEY` | 推奨 | [Google AI Studio API キー](https://aistudio.google.com/apikey)（無料枠あり） |
| `ANTHROPIC_API_KEY` | オプション | [Claude API キー](https://console.anthropic.com/)（フォールバック） |

**優先順位**: `GOOGLE_API_KEY` が設定されている場合は Gemini を使用、なければ Claude にフォールバック。

### 2. リポジトリ権限

**Settings → Actions → General**:
- ✅ Read and write permissions
- ✅ Allow GitHub Actions to create and approve pull requests

### 3. Gemini Code Assist（オプション）

**Settings → Integrations → GitHub Apps**:
- Gemini Code Assist をインストール

## API キー取得方法

### Google API Key（Gemini用・推奨）

1. [Google AI Studio](https://aistudio.google.com/apikey) にアクセス
2. Googleアカウントでログイン
3. 「Create API Key」をクリック
4. キーをコピー（`AIza...` で始まる形式）
5. GitHubの **Settings → Secrets and variables → Actions** で `GOOGLE_API_KEY` として登録

**無料枠**: 1分あたり15リクエスト、1日あたり1,500リクエスト（2024年現在）

### Anthropic API Key（Claude用・オプション）

1. [Anthropic Console](https://console.anthropic.com/) にアクセス
2. アカウントを作成/ログイン
3. **API Keys** からキーを生成
4. キーをコピー（`sk-ant-...` で始まる形式）
5. GitHubの **Settings → Secrets and variables → Actions** で `ANTHROPIC_API_KEY` として登録

## 設定オプション

| パラメータ | デフォルト | 説明 |
|-----------|-----------|------|
| `node_version` | `'20'` | Node.js バージョン |
| `package_manager` | `'pnpm'` | `pnpm` / `npm` / `yarn` |
| `pnpm_version` | `'9'` | pnpm バージョン |
| `lint_command` | `'lint'` | Lint コマンド |
| `lint_fix_command` | `'lint:fix'` | Lint 修正コマンド |
| `format_command` | `'format'` | Format コマンド |
| `type_check_command` | `'type-check'` | 型チェックコマンド |
| `build_command` | `'build'` | Build コマンド |
| `test_command` | `'test'` | Test コマンド |
| `tech_stack` | `'React, TypeScript, Vite'` | AI 用技術スタック説明 |
| `gemini_model` | `'gemini-pro'` | Gemini モデル |
| `claude_model` | `'claude-sonnet-4-20250514'` | Claude モデル（フォールバック） |
| `language` | `'ja'` | コメント言語 (`ja`/`en`) |

## プロジェクト別設定例

### React + TypeScript + Vite

```yaml
with:
  package_manager: 'pnpm'
  tech_stack: 'React 18, TypeScript 5, Vite 5, Tailwind CSS'
secrets:
  GOOGLE_API_KEY: ${{ secrets.GOOGLE_API_KEY }}
```

### Next.js

```yaml
with:
  package_manager: 'npm'
  tech_stack: 'Next.js 14, React 18, TypeScript'
secrets:
  GOOGLE_API_KEY: ${{ secrets.GOOGLE_API_KEY }}
```

### Vue.js

```yaml
with:
  package_manager: 'pnpm'
  tech_stack: 'Vue 3, TypeScript, Vite, Pinia'
secrets:
  GOOGLE_API_KEY: ${{ secrets.GOOGLE_API_KEY }}
```

### Node.js (JavaScript)

```yaml
with:
  package_manager: 'npm'
  type_check_command: ''
  tech_stack: 'Express.js, Node.js'
secrets:
  GOOGLE_API_KEY: ${{ secrets.GOOGLE_API_KEY }}
```

## 動作フロー

```
1. PR作成/更新
   ↓
2. 問題検出
   - Lint エラー
   - TypeScript エラー
   - ビルドエラー
   - テスト失敗
   - Gemini 高優先度レビュー
   ↓
3. 簡単な修正（自動）
   - lint:fix
   - format
   - 自動コミット
   ↓
4. AI分析（Gemini または Claude）
   - 複雑なエラー分析
   - 修正計画作成
   - ファイル修正
   - 自動コミット
   ↓
5. PRにレポート投稿
```

## ファイル構成

```
your-repo/
└── .github/
    └── workflows/
        └── ai-auto-fix.yml  ← このファイルを追加

ai-auto-fix-template/  (このリポジトリ)
├── .github/
│   └── workflows/
│       └── reusable-ai-auto-fix.yml  ← 再利用可能ワークフロー
├── setup.sh           ← セットアップスクリプト
├── caller-example.yml ← 呼び出しテンプレート
└── README.md
```

## トラブルシューティング

### ワークフローが実行されない

1. ワークフローファイルが `.github/workflows/` に配置されているか確認
2. `on:` トリガーが正しく設定されているか確認
3. リポジトリの Actions が有効になっているか確認

### API Key エラー

**Gemini (GOOGLE_API_KEY)**:
1. [Google AI Studio](https://aistudio.google.com/apikey) でキーを確認
2. キーの形式: `AIza...`
3. 無料枠の制限を超えていないか確認

**Claude (ANTHROPIC_API_KEY)**:
1. `ANTHROPIC_API_KEY` が正しく設定されているか確認
2. API キーの形式: `sk-ant-xxxxx...`
3. API クレジットが残っているか確認

### 権限エラー

1. "Read and write permissions" が有効か確認
2. "Allow GitHub Actions to create and approve pull requests" がチェックされているか確認

## 関連リポジトリ

- [Memo25](https://github.com/BoxPistols/Memo25) - このテンプレートの実装例
- [json-scheme-checker](https://github.com/BoxPistols/json-scheme-checker) - 元となったプロジェクト

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照してください。

## 貢献

Issue や Pull Request を歓迎します！

---

Created with ❤️ by [BoxPistols](https://github.com/BoxPistols)
