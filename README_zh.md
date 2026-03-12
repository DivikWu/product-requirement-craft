# Product Requirement Craft

[English](README.md)

一个 Claude skill，通过交互式对话引导你完成结构化的需求梳理，生成 **Problem Framing**、**SRD** 和 **PRD** 文档。

## 功能介绍

三种文档类型，渐进式链路——每一层都建立在前一层的基础上：

```
Problem Framing → SRD → PRD
(为什么要做？)    (做什么方向？)  (具体怎么做？)
```

- **Problem Framing** — 6 字段问题定义，用于早期对齐
- **SRD (Solution Requirements Document)** — 完整方案简报，包含竞品分析、指标、风险和范围
- **PRD (Product Requirements Document)** — 执行级规格书，涵盖前端、后端、数据、A/B 测试和非功能性需求

### 核心特性

- **分层提问** — 三层思考（问题 → 方案 → 成功标准），而非逐字段填写
- **完整度评分** — 红绿灯系统（🟢🟡🔴），确保信息充足后再生成文档
- **项目类型识别** — 自动识别单页面、跨页面流程、分群、全局优化等项目类型，并激活对应的可选章节
- **多角色评审** — 生成后从产品、设计、工程三个角色视角进行评审
- **复盘** — 自我审视文档薄弱点和提问改进空间

## 安装

### Claude Code

```bash
# 通过插件安装（推荐）
# 在 Claude Code 中运行：
/plugin add /path/to/product-requirement-craft

# 或手动安装 — 个人级别（所有项目可用）
git clone https://github.com/DivikWu/product-requirement-craft.git
cp -r product-requirement-craft/.claude/skills/requirement-writer ~/.claude/skills/

# 或手动安装 — 项目级别（仅当前项目）
git clone https://github.com/DivikWu/product-requirement-craft.git
cp -r product-requirement-craft/.claude/skills/requirement-writer .claude/skills/
```

### Cursor

```bash
git clone https://github.com/DivikWu/product-requirement-craft.git
cp -r product-requirement-craft/.claude/skills/requirement-writer skills/
```

或将 SKILL.md 的内容整合到你的 `.cursorrules` 文件中。

### Kiro

```bash
git clone https://github.com/DivikWu/product-requirement-craft.git
cd product-requirement-craft
./install.sh --kiro
```

安装为 `.kiro/steering/requirement-writer.md` steering 文件，使用 `inclusion: auto` 模式，当你提到需求相关话题时 Kiro 会自动激活。

### Claude.ai

从 [Releases](https://github.com/DivikWu/product-requirement-craft/releases) 下载 `requirement-writer.skill` 文件，然后：

**Settings → Customize → Skills → Upload**

> 需要在 Settings → Capabilities 中启用代码执行和文件创建。

## 使用方法

安装后，当你提到需求相关的话题时，skill 会自动触发：

- "帮我写一份 PRD"
- "I have a new feature idea, help me think through it"
- "梳理一下这个项目的需求"
- "Let's define the problem before designing"
- "写一份 Problem Framing"

或在 Claude Code 中直接调用：

```
/requirement-writer
```

## 文件结构

```
.claude/skills/requirement-writer/
├── SKILL.md                          # 入口文件（约 130 行）
│   ├── 工作流（6 个阶段 + 检查清单）
│   ├── 项目类型决策树
│   ├── 文件加载规则
│   └── 评审与复盘规则
│
└── references/
    ├── questioning-guide.md           # 提问策略 + 完整度评分
    ├── problem-framing-template.md    # Problem Framing 模板 + 字段指南
    ├── srd-template.md                # SRD 模板（10 个章节）
    ├── prd-template.md                # PRD 模板（7 个章节 + 可选章节）
    └── example-yami-homepage.md       # 填写示例，供质量参考
```

## 文档框架速览

### Problem Framing（6 个字段）

| 字段 | 填写内容 |
|------|---------|
| WHO | 目标用户 + 分群 |
| WHAT Problem | 痛点 + 现有替代方案 |
| WHEN | 场景 / 触发点 / 触点 |
| WHAT Job | 核心任务（Jobs to be Done） |
| Customer Benefit | 可感知的用户价值 |
| Company Benefit | 可衡量的业务价值 |

### SRD（10 个章节）

Customer → Job to be Done → Benefit（用户 / 业务 / 品牌）→ Problem → Solution（竞品分析 + 前后对比 + 范围）→ Success Metrics → Risks → Feedback Loops → Product Requirements（摘要）→ UI/UX Requirements（摘要）

### PRD（7 个章节 + 可选）

Revision History → Background → Overview → Product Requirements（前端 / 数据逻辑 / CMS / 后端 API / i18n / 内容规格）→ Data Requirements（埋点 + A/B）→ Non-functional（性能 / 降级 / 无障碍 / SEO / 安全）→ Launch Strategy

**可选章节**（根据项目类型激活）：
- §4.0 User Flow Overview — 跨页面项目
- §4.0 User Segment Definition — 分群项目
- §5.4 Phasing — 多阶段项目

## 设计原则

遵循 [Anthropic Skill 编写最佳实践](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)构建：

- **渐进式披露** — SKILL.md 是简洁的入口，模板按需加载
- **默认精简** — 只包含 Claude 尚不知道的信息
- **命令式指令** — 告诉 Claude 该做什么，而不是解释概念
- **反馈闭环** — 完整度评分 → 补充缺口 → 重新评分后再生成
- **生成前重读** — 在生成文档前显式重新加载模板，对抗长对话中的上下文漂移

## 许可证

MIT

## 贡献

欢迎提 Issue 和 PR。如果你为团队定制了模板，欢迎分享你的修改。
