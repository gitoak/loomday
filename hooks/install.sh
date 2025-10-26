#!/bin/bash

HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
GIT_HOOKS_DIR="$(git rev-parse --git-dir)/hooks"

echo "📦 Installing git hooks..."

cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
cp "$HOOKS_DIR/pre-commit.ps1" "$GIT_HOOKS_DIR/pre-commit.ps1"

chmod +x "$GIT_HOOKS_DIR/pre-commit"

echo "✅ Git hooks installed successfully!"
echo ""
echo "The pre-commit hook will now:"
echo "  🎨 Format Dart files automatically"
echo "  🔬 Run dart analyze"
echo "  🔧 Check for available fixes"
echo ""
echo "To bypass the hook when needed, use: git commit --no-verify"
