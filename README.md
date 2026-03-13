# Product Requirement Craft

[中文版](README_zh.md)

A Claude skill that guides you through structured requirements gathering via interactive dialogue, generating **Problem Framing**, **SRD**, and **PRD** documents.

## What it does

Three document types, progressive chain — each builds on the previous:

```
Problem Framing → SRD → PRD
(Why do this?)    (What direction?)  (How exactly?)
```

- **Problem Framing** — 6-field problem definition for early-stage alignment
- **SRD (Solution Requirements Document)** — Full solution brief with benchmarks, metrics, risks, and scope
- **PRD (Product Requirements Document)** — Execution-level spec with frontend, backend, data, A/B testing, and non-functional requirements

### Key features

- **Layered questioning** — Three thinking layers (problem → solution → success), not a field-by-field checklist
- **Completeness scoring** — Traffic-light system (🟢🟡🔴) ensures enough information before generating
- **Project type detection** — Auto-identifies single-page, cross-page flow, segmented, or holistic optimization projects and activates relevant optional sections
- **Multi-role review** — Post-generation review from Product, Design, and Engineering perspectives
- **Retrospective** — Self-review of document weak points and questioning improvements

## Installation

All modes support **one-line remote install** (no git clone needed):

```bash
curl -fsSL https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main/install.sh | bash -s -- <MODE>
```

### Claude Code

```bash
# One-line install — personal (all projects)
curl -fsSL https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main/install.sh | bash -s -- --personal

# One-line install — project (current project only)
curl -fsSL https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main/install.sh | bash -s -- --project
```

### Cursor

```bash
curl -fsSL https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main/install.sh | bash -s -- --cursor
```

Or integrate the SKILL.md content into your `.cursorrules` file.

### Kiro

```bash
curl -fsSL https://raw.githubusercontent.com/DivikWu/product-requirement-craft/main/install.sh | bash -s -- --kiro
```

Installs as a steering file at `.kiro/steering/requirement-writer.md` with `inclusion: auto`, so Kiro activates it automatically when you mention requirements-related topics.

### Claude.ai

Download the `requirement-writer.skill` file from [Releases](https://github.com/DivikWu/product-requirement-craft/releases), then:

**Settings → Customize → Skills → Upload**

> Requires Code execution and file creation enabled in Settings → Capabilities.

## Usage

Once installed, the skill triggers automatically when you mention requirements-related topics:

- "帮我写一份 PRD"
- "I have a new feature idea, help me think through it"
- "梳理一下这个项目的需求"
- "Let's define the problem before designing"
- "写一份 Problem Framing"

Or invoke directly in Claude Code:

```
/requirement-writer
```

## File structure

```
.claude/skills/requirement-writer/
├── SKILL.md                          # Entry point (~130 lines)
│   ├── Workflow (6 phases + checklist)
│   ├── Project type decision tree
│   ├── File loading rules
│   └── Review & retrospective rules
│
└── references/
    ├── questioning-guide.md           # Questioning strategy + completeness scoring
    ├── problem-framing-template.md    # Problem Framing template + field guide
    ├── srd-template.md                # SRD template (10 sections)
    ├── prd-template.md                # PRD template (7 sections + optional sections)
    └── example-yami-homepage.md       # Filled-in example for quality reference
```

## Document frameworks at a glance

### Problem Framing (6 fields)

| Field | What to fill |
|-------|-------------|
| WHO | Target users + segmentation |
| WHAT Problem | Pain points + current workarounds |
| WHEN | Scenario / trigger / touchpoint |
| WHAT Job | Core task (Jobs to be Done) |
| Customer Benefit | Tangible user value |
| Company Benefit | Measurable business value |

### SRD (10 sections)

Customer → Job to be Done → Benefit (customer / business / brand) → Problem → Solution (benchmark + before/after + scope) → Success Metrics → Risks → Feedback Loops → Product Requirements (summary) → UI/UX Requirements (summary)

### PRD (7 sections + optional)

Revision History → Background → Overview → Product Requirements (frontend / data logic / CMS / backend API / i18n / content specs) → Data Requirements (tracking + A/B) → Non-functional (performance / fallback / ADA / SEO / security) → Launch Strategy

**Optional sections** (activated by project type):
- §4.0 User Flow Overview — for cross-page projects
- §4.0 User Segment Definition — for segmented projects
- §5.4 Phasing — for multi-phase projects

## Design principles

Built following [Anthropic's Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices):

- **Progressive disclosure** — SKILL.md is a concise entry point; templates load on demand
- **Concise by default** — Only includes what Claude doesn't already know
- **Imperative instructions** — Tells Claude what to do, not what things are
- **Feedback loops** — Completeness scoring → fix gaps → re-score before generating
- **Re-read before generate** — Explicitly re-loads templates before document generation to counter context drift in long conversations

## License

MIT

## Contributing

Issues and PRs welcome. If you've adapted the templates for your team, consider sharing your modifications.
