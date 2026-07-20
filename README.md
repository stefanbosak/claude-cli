<div align="center">

# 🤖 Anthropic Claude Code CLI

**Containerized Claude Code CLI (Hardened)**

[![build_status_badge](../../actions/workflows/docker-image-native-multiplatform-pipeline.yaml/badge.svg?branch=main)](.github/workflows/docker-image-native-multiplatform-pipeline.yaml)
[![ClaudeCode](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/anthropics/claude-code)
[![Documentation](https://img.shields.io/badge/Docs-Anthropic-green?logo=github)](https://code.claude.com/docs/en/overview)

</div>

---

## 📦 Latest Build

<!-- VERSION_INFO_START -->
| Component | Version |
|-----------|---------|
| **Anthropic Claude Code CLI** | [`2.1.212`](https://github.com/anthropics/claude-code/releases/tag/v2.1.216) |

> 🔄 Last updated: 2026-07-20T22:40:34Z · [Build #82](https://github.com/stefanbosak/claude-cli/actions/runs/29784593599)
<!-- VERSION_INFO_END -->

---

## 📋 Overview

This repository provides a fully automated preparation of <span style="color: #0969da;">**containerized**</span> [Claude Code CLI](https://github.com/anthropics/claude-code) environment with integrated <span style="color: #8250df;">**MCP server**</span> support using <span style="color: #1a7f37;">**Docker-in-Docker**</span> architecture.

### About solution
- Sandboxing environment for AI scope (reduced possible negative impact via isolation)
- Automated packaging of current tool versions (optimized maintenance effort via automation)
- Strong focus on security (mitigated security issues and vulnerabilities through hardening)
- Simplification of the initial run-up (see: [Container runner script](./claude.sh), [Environment configuration](./.claude/.env))

- **Container image is:**
  - keyless-signed via cosign using GitHub OIDC certificate issuer (trusted verifiable source)
  - automatically built when a new release of Anthropic Claude is detected (scheduled monitoring - every hour)

### 📚 Resources

- 📖 [Official Documentation](https://platform.claude.com/docs/en/about-claude/models/overview)
- 📖 [AI models database](https://models.dev)
- 🤖 **Supported AI Models**: Haiku/Sonet, Opus
  - **Recommended models**:
    - <span style="color: #8250df;">**Claude Sonet**</span> - [Documentation](https://www.anthropic.com/claude/sonnet)
    - <span style="color: #a371f7;">**Claude Opus**</span> - [Documentation](https://www.anthropic.com/claude/opus)
  - **Effective Prompting**:
    - Save output to prevent data loss (reduce costs)
    - Iteratively processing excessively long messages (drop error rate ~<10%)
    - XML tags ensure structural clarity (compliance increase to ~>98 %)
    - Validate continuously (maintain ~>95% accuracy)
    - Instruct what to avoid, not what to do (significantly reduce hallucination by ~>60 %)
    - Contextualize personas (~<15 % improvement using personas)

## 🧱 AI Layering

![AI Layering Architecture](./images/ai_layers.png)

## Anthropic IP prefixes, subdomains for whitelisting, status
- [Anthropic IP prefixes]( https://docs.anthropic.com/en/api/ip-addresses)
- curl -s https://status.claude.com/api/v2/summary.json | jq '.status'

### ⚠️ Important Notices

> [!NOTE]
> All files in this repository are well-commented with relevant implementation details.

> [!IMPORTANT]
> Always review and understand the code before executing any commands.

> [!CAUTION]
> Users are solely responsible for any modifications or execution of code from this repository.

## 🛠 Utilities
- [uv](https://github.com/astral-sh/uv) - An extremely fast Python package installer and resolver
- [bun](https://github.com/oven-sh/bun) - All-in-one JavaScript runtime and toolkit for faster development
- [fabric](https://github.com/danielmiessler/fabric) - Framework for augmenting humans using AI
- [mdflow](https://github.com/johnlindquist/mdflow) - Markdown-based workflow automation tool for streamlined task execution

## 🔌 MCP Servers

> [!NOTE]
> Use custom agents with agent isolation to configure on-demand MCP servers.

### <span style="color: #8250df;">🧠 Reasoning & Documentation</span>

#### **sequentialthinking** - <span style="color: #8250df;">Step-by-Step Reasoning</span>
- [skill](.claude/skills/sequential-thinking/SKILL.md)
- **Benefits:** <span style="color: #1a7f37;">Reduces token consumption by 5-55%</span>
- **Documentation:** [Sequential Thinking MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)

#### **ref** - <span style="color: #8250df;">Documentation Search</span>
- [skill](.claude/skills/doc-search/SKILL.md)
- **Benefits:** <span style="color: #1a7f37;">Essential for efficient context retrieval</span>
- **Documentation:** [Ref.tools](https://ref.tools/)

---

### <span style="color: #1a7f37;">🌐 Utilities</span>

#### **fetch** - <span style="color: #1a7f37;">Web Search</span>
- [skill](.claude/skills/web-search/SKILL.md)
- **Documentation:** [Fetch MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch)

#### **time** - <span style="color: #1a7f37;">Time & Timezone</span>
- [skill](.claude/skills/sequential-thinking/SKILL.md)
- **Documentation:** [Time MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/time)

---

### <span style="color: #0969da;">🗄️ Database & Storage</span>

#### **postgres** - <span style="color: #0969da;">PostgreSQL</span>
- [agent](.claude/agents/postgres.agent.md)
- [skill](.claude/skills/postgres/SKILL.md)
- **Documentation:** [MCP Toolbox for Databases](https://github.com/googleapis/genai-toolbox)
- ⚠ **Note:** <span style="color: #d73a49;">Linux ARM64 architecture currently not supported ([issue](https://github.com/googleapis/genai-toolbox/issues/2754))</span>

---

### <span style="color: #d73a49;">📊 Monitoring & Logging</span>

#### **grafana** - <span style="color: #d73a49;">Grafana</span>
| test | production |
|------|------------|
| [agent](.claude/agents/grafana-tst.agent.md) | [agent](.claude/agents/grafana-prd.agent.md) |
| [skill](.claude/skills/grafana-tst/SKILL.md) | [skill](.claude/skills/grafana-prd/SKILL.md) |
- **Documentation:** [Grafana MCP Server](https://github.com/grafana/mcp-grafana)

#### **graylog** - <span style="color: #d73a49;">Graylog</span>
| test | production |
|------|------------|
| [agent](.claude/agents/graylog-tst.agent.md) | [agent](.claude/agents/graylog-prd.agent.md) |
| [skill](.claude/skills/graylog-tst/SKILL.md) | [skill](.claude/skills/graylog-prd/SKILL.md) |
- **Authentication:** <span style="color: #d73a49;">Authorization header required</span>
- **Documentation:** [Graylog MCP Documentation](https://go2docs.graylog.org/current/setting_up_graylog/model_context_protocol__mcp__tools.htm)


## 📁 Repository Structure

### <span style="color: #8250df;">Configuration Files</span>
| File | Description |
|------|-------------|
| [`.env`](./.claude/.env) | <span style="color: #1a7f37;">Environment variables</span> |

### <span style="color: #0969da;">Docker & Build</span>
| File | Description |
|------|-------------|
| [`Dockerfile`](./Dockerfile) | <span style="color: #0969da;">Container image configuration</span> |
| [`claude-build.sh`](./claude-build.sh) | <span style="color: #1a7f37;">Build automation script</span> |
| [`claude.sh`](./claude.sh) | <span style="color: #1a7f37;">Execution wrapper script</span> |
| [`act.sh`](./act.sh) | <span style="color: #1a7f37;">Act tool script</span> |


## 🐳 Container Images

### <span style="color: #0969da;">Available Registries</span>

| Registry | Network Support | Pull Command |
|----------|----------------|--------------|
| [**GitHub CR**](https://github.com/stefanbosak/claude-cli/pkgs/container/claude-cli) | <span style="color: #8250df;">IPv4 only</span> | `docker pull ghcr.io/stefanbosak/claude-cli:initial` |
| [**Docker Hub**](https://hub.docker.com/r/developmententity/claude-cli) | <span style="color: #1a7f37;">IPv4 & IPv6</span> | `docker pull developmententity/claude-cli:initial` |

## Other resources

- [Claude best practice](https://github.com/shanraisshan/claude-code-best-practice)
- [Claude prompt templates](https://github.com/repowise-dev/claude-code-prompts)
- [BMAD](https://github.com/bmad-code-org/BMAD-METHOD)
- [claudectx](https://github.com/foxj77/claudectx)

---

<div align="center">

<span style="color: #8250df;">**Made with ❤ for ⚡ efficiency and 🔒 security**</span>

</div>
