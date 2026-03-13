#!/bin/bash

# Product Requirement Craft Installer
# Usage: ./install.sh [--project | --personal | --cursor | --kiro]
# Remote: curl -fsSL https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main/install.sh | bash -s -- --kiro

set -e

REPO_URL="https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main"
SKILL_DIR=".claude/skills/requirement-writer"
REMOTE_MODE=false

# Detect if running locally or via pipe (curl | bash)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd 2>/dev/null || echo "")"
SOURCE_DIR="$SCRIPT_DIR/$SKILL_DIR"

if [ -z "$SCRIPT_DIR" ] || [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
    REMOTE_MODE=true
fi

REFERENCE_FILES="questioning-guide.md problem-framing-template.md srd-template.md prd-template.md example-yami-homepage.md"

# Download a file from GitHub raw URL to a local path
download_file() {
    local url="$1"
    local dest="$2"
    if command -v curl &>/dev/null; then
        curl -fsSL "$url" -o "$dest"
    elif command -v wget &>/dev/null; then
        wget -q "$url" -O "$dest"
    else
        echo "❌ Error: curl or wget is required for remote install."
        exit 1
    fi
}

# Copy or download a skill file
fetch_skill() {
    local rel_path="$1"
    local dest="$2"
    if [ "$REMOTE_MODE" = true ]; then
        download_file "$REPO_URL/$SKILL_DIR/$rel_path" "$dest"
    else
        cp "$SOURCE_DIR/$rel_path" "$dest"
    fi
}

install_refs() {
    local dest="$1"
    for f in $REFERENCE_FILES; do
        fetch_skill "references/$f" "$dest/$f"
    done
}

install_personal() {
    TARGET="$HOME/.claude/skills/requirement-writer"
    mkdir -p "$TARGET/references"
    fetch_skill "SKILL.md" "$TARGET/SKILL.md"
    install_refs "$TARGET/references"
    echo "✅ Installed to $TARGET (personal — available in all projects)"
}

install_project() {
    TARGET=".claude/skills/requirement-writer"
    mkdir -p "$TARGET/references"
    fetch_skill "SKILL.md" "$TARGET/SKILL.md"
    install_refs "$TARGET/references"
    echo "✅ Installed to $TARGET (project — current project only)"
}

install_cursor() {
    TARGET="skills/requirement-writer"
    mkdir -p "$TARGET/references"
    fetch_skill "SKILL.md" "$TARGET/SKILL.md"
    install_refs "$TARGET/references"
    echo "✅ Installed to $TARGET (Cursor — current project)"
}

install_kiro() {
    TARGET=".kiro/steering"
    mkdir -p "$TARGET/references"
    # Download SKILL.md to a temp file, then transform
    TMPFILE="$(mktemp)"
    fetch_skill "SKILL.md" "$TMPFILE"
    # Prepend Kiro steering frontmatter
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
    awk 'BEGIN{skip=0} /^---$/{skip++; if(skip<=2) next} skip>=2{print}' "$TMPFILE" >> "$TARGET/requirement-writer.md"
    rm -f "$TMPFILE"
    install_refs "$TARGET/references"
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
        echo ""
        echo "Remote install (no git clone needed):"
        echo "  curl -fsSL https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main/install.sh | bash -s -- --kiro"
        ;;
esac
