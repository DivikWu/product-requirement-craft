# Product Requirement Craft

A Claude Code skill (requirement-writer) that generates Problem Framing, SRD, and PRD documents through interactive dialogue.

## Project structure

```
.claude/skills/requirement-writer/   # Claude Code skill (canonical source)
├── SKILL.md                         # Skill entry point
└── references/                      # Templates & guides loaded on demand
    ├── questioning-guide.md
    ├── problem-framing-template.md
    ├── srd-template.md
    └── prd-template.md

skills/requirement-writer/           # Mirror for Cursor compatibility
install.sh                           # Installer script (--personal / --project / --cursor)
```

## Global rules

- When the user says "复盘" (or retrospective/review), invoke the `self-improving` skill to run the retrospective workflow and append the result to `docs/review-log.md`.

## Key conventions

- The `.claude/skills/` copy is the canonical source; `skills/` is a Cursor-compatible mirror. Keep both in sync when editing.
- Skill content is bilingual (Chinese/English). Document language should match the user's conversation language.
- Templates use Markdown with structured section numbering (§1, §2, etc.) and traffic-light completeness scoring (🟢🟡🔴).
- The skill follows a 6-phase workflow: confirm type → layered questioning → project type ID → completeness scoring → generate → review + retrospective.

## Development guidelines

- SKILL.md should stay concise (~130 lines). Put detailed content in `references/` files.
- Follow Anthropic's skill authoring best practices: progressive disclosure, imperative instructions, concise by default.
- When modifying templates, preserve section numbering — downstream logic references sections by number (e.g., PRD §4.0).
- The `install.sh` script copies from `.claude/skills/`; test all three modes (--personal, --project, --cursor) after structural changes.

## Bilingual docs

- `README.md` — English
- `README_zh.md` — Chinese
- Keep both READMEs in sync when updating documentation.
