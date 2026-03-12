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

install_kiro() {
    TARGET=".kiro/steering"
    mkdir -p "$TARGET/references"
    # Prepend Kiro steering frontmatter to SKILL.md
    cat > "$TARGET/requirement-writer.md" <<'FRONTMATTER'
---
inclusion: auto
name: requirement-writer
description: >
  Guides users through structured requirements gathering via interactive
  dialogue to generate Problem Framing, SRD, and PRD documents.
---

FRONTMATTER
    # Strip original YAML frontmatter from SKILL.md before appending
    awk 'BEGIN{skip=0} /^---$/{skip++; if(skip<=2) next} skip>=2{print}' "$SOURCE_DIR/SKILL.md" >> "$TARGET/requirement-writer.md"
    cp "$SOURCE_DIR/references/"*.md "$TARGET/references/"
    echo "✅ Installed to $TARGET (Kiro — current project)"
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
    --kiro)
        install_kiro
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
        echo "  --kiro       Install to .kiro/steering/ (Kiro project)"
        echo ""
        echo "Examples:"
        echo "  ./install.sh --personal"
        echo "  ./install.sh --project"
        ;;
esac
