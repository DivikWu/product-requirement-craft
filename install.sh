#!/bin/bash

# Product Requirement Craft Installer
# Usage: ./install.sh [--project | --personal | --cursor]

set -e

SKILL_DIR=".claude/skills/requirement-writer"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/$SKILL_DIR"

if [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
    echo "❌ Error: SKILL.md not found at $SOURCE_DIR"
    echo "   Make sure you're running this from the repo root."
    exit 1
fi

install_personal() {
    TARGET="$HOME/.claude/skills/requirement-writer"
    mkdir -p "$TARGET/references"
    cp "$SOURCE_DIR/SKILL.md" "$TARGET/"
    cp "$SOURCE_DIR/references/"*.md "$TARGET/references/"
    echo "✅ Installed to $TARGET (personal — available in all projects)"
}

install_project() {
    TARGET=".claude/skills/requirement-writer"
    mkdir -p "$TARGET/references"
    cp "$SOURCE_DIR/SKILL.md" "$TARGET/"
    cp "$SOURCE_DIR/references/"*.md "$TARGET/references/"
    echo "✅ Installed to $TARGET (project — current project only)"
}

install_cursor() {
    TARGET="skills/requirement-writer"
    mkdir -p "$TARGET/references"
    cp "$SOURCE_DIR/SKILL.md" "$TARGET/"
    cp "$SOURCE_DIR/references/"*.md "$TARGET/references/"
    echo "✅ Installed to $TARGET (Cursor — current project)"
}

case "${1:-}" in
    --personal)
        install_personal
        ;;
    --project)
        install_project
        ;;
    --cursor)
        install_cursor
        ;;
    *)
        echo "Product Requirement Craft Installer"
        echo ""
        echo "Usage: ./install.sh <mode>"
        echo ""
        echo "Modes:"
        echo "  --personal   Install to ~/.claude/skills/ (all projects)"
        echo "  --project    Install to .claude/skills/ (current project)"
        echo "  --cursor     Install to skills/ (Cursor project)"
        echo ""
        echo "Examples:"
        echo "  ./install.sh --personal"
        echo "  ./install.sh --project"
        ;;
esac
