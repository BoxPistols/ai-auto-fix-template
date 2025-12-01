#!/bin/bash

# AI Auto-Fix セットアップスクリプト
# 使用方法: curl -fsSL https://raw.githubusercontent.com/BoxPistols/ai-auto-fix-template/main/setup.sh | bash

set -e

echo "=========================================="
echo "🤖 AI Auto-Fix セットアップ"
echo "=========================================="
echo ""

# 現在のディレクトリがgitリポジトリか確認
if [ ! -d ".git" ]; then
  echo "❌ エラー: このディレクトリはGitリポジトリではありません"
  echo "   git init を実行するか、既存のリポジトリで実行してください"
  exit 1
fi

# .github/workflows ディレクトリを作成
mkdir -p .github/workflows

echo "📝 プロジェクト設定を収集中..."
echo ""

# パッケージマネージャーを検出
if [ -f "pnpm-lock.yaml" ]; then
  PKG_MANAGER="pnpm"
  echo "✓ 検出: pnpm"
elif [ -f "yarn.lock" ]; then
  PKG_MANAGER="yarn"
  echo "✓ 検出: yarn"
else
  PKG_MANAGER="npm"
  echo "✓ 検出: npm"
fi

# Node.jsバージョンを検出
if [ -f ".nvmrc" ]; then
  NODE_VERSION=$(cat .nvmrc | tr -d 'v')
  echo "✓ 検出: Node.js $NODE_VERSION (.nvmrc)"
elif [ -f ".node-version" ]; then
  NODE_VERSION=$(cat .node-version | tr -d 'v')
  echo "✓ 検出: Node.js $NODE_VERSION (.node-version)"
else
  NODE_VERSION="20"
  echo "✓ デフォルト: Node.js $NODE_VERSION"
fi

# 技術スタックを検出
TECH_STACK=""
if grep -q '"react"' package.json 2>/dev/null; then
  TECH_STACK+="React, "
fi
if grep -q '"next"' package.json 2>/dev/null; then
  TECH_STACK+="Next.js, "
fi
if grep -q '"vue"' package.json 2>/dev/null; then
  TECH_STACK+="Vue.js, "
fi
if grep -q '"typescript"' package.json 2>/dev/null; then
  TECH_STACK+="TypeScript, "
fi
if grep -q '"vite"' package.json 2>/dev/null; then
  TECH_STACK+="Vite, "
fi
if grep -q '"tailwindcss"' package.json 2>/dev/null; then
  TECH_STACK+="Tailwind CSS, "
fi

# 末尾のカンマを削除
TECH_STACK=${TECH_STACK%, }

if [ -z "$TECH_STACK" ]; then
  TECH_STACK="JavaScript"
fi

echo "✓ 検出: $TECH_STACK"
echo ""

# ワークフローファイルを作成
cat > .github/workflows/ai-auto-fix.yml << EOF
# AI Auto-Fix ワークフロー
# Gemini Code Assist のレビューに自動対応します

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
      node_version: '$NODE_VERSION'
      package_manager: '$PKG_MANAGER'
      tech_stack: '$TECH_STACK'
      language: 'ja'
    secrets:
      ANTHROPIC_API_KEY: \${{ secrets.ANTHROPIC_API_KEY }}
EOF

echo "✅ ワークフローファイルを作成しました"
echo "   .github/workflows/ai-auto-fix.yml"
echo ""

echo "=========================================="
echo "📋 残りの設定手順"
echo "=========================================="
echo ""
echo "1. GitHub Secrets に ANTHROPIC_API_KEY を設定"
echo "   https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/settings/secrets/actions"
echo ""
echo "2. GitHub Actions の権限を設定"
echo "   Settings → Actions → General"
echo "   - Read and write permissions ✓"
echo "   - Allow GitHub Actions to create and approve pull requests ✓"
echo ""
echo "3. (オプション) Gemini Code Assist をインストール"
echo "   Settings → Integrations → GitHub Apps"
echo ""
echo "4. コミット＆プッシュ"
echo "   git add .github/workflows/ai-auto-fix.yml"
echo "   git commit -m 'Add AI Auto-Fix workflow'"
echo "   git push"
echo ""
echo "=========================================="
echo "🎉 セットアップ完了！"
echo "=========================================="
