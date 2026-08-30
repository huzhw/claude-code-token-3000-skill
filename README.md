# 切换 Claude Code API Token

本技能专用于 Claude Code：API 一键切换——token-3000（公司内网 192.168.80.248:3000，免费）↔ token-me（个人 DeepSeek，自己花钱）。

## 相关技能

- [git-commit](https://github.com/huzhw/git-commit-skill)：Git 提交规范
- [reread-rules](https://github.com/huzhw/reread-rules-skill)：重载 CLAUDE.md / AGENTS.md 规则
- [daily-record-gitlab-md](https://github.com/huzhw/daily-record-gitlab-md-skill)：日报记录
- [daily-merge-gitlab-excel](https://github.com/huzhw/daily-merge-gitlab-excel-skill)：日报合并
- [code-check](https://github.com/huzhw/code-check-skill)：增量代码隐患检查
- [deepseek-harness-settings-curator](https://github.com/huzhw/deepseek-harness-settings-curator)：DSH 模型配置梳理

---

## 解决了什么问题

**公司内网说挂就挂，AI 直接失联。** 手动改 settings.json 切到自己 key——要记住配置、要备份、要改回来。来回切几次，配置就乱了。

这个技能把切换变成了 AI 能听懂的命令：`/token-3000` 切公司白嫖，`/token-me` 切自己花钱。每次切换自动双向同步备份，permissions/hooks/MCP 等所有配置不丢不乱。

## 核心能力

- **一键切换** — 两个命令，不用记 IP 和密钥
- **双向同步** — 每次切换先反向同步当前配置到备份，确保 permissions/hooks/MCP 等永不丢失
- **智能探测** — 切自己时先探公司通不通，通则二次确认防止误操作
- **配置集中** — 换 IP/端口只改脚本顶部 3 个变量，注释写清，一眼看懂

## 使用

### 基本切换

| 命令 | 效果 |
|------|------|
| `/token-3000` | 切公司 `192.168.80.248:3000`，免费 |
| `/token-me` | 切个人 `api.deepseek.com`，自己花钱 |

### 切自己的安全检测

```
/token-me
  ├─ 探测 192.168.80.248:3000 通不通
  ├─ 通 → "公司还能用，确定切自己花钱？" → Y 才切
  └─ 不通 → 直接切，不废话
```

## 配置

以后换 IP 或端口，只改 `switch-token.ps1` 顶部：

```powershell
$CompanyIp   = "192.168.80.248"               # 公司内网服务器 IP
$CompanyPort = "3000"                         # 公司内网端口
$CompanyUrl  = "http://${CompanyIp}:${CompanyPort}"  # 公司 API 地址
```

## 文件结构

```
claude-code-token-3000/
├── SKILL.md                        ← 技能定义
├── README.md                       ← 本文档
└── scripts/
    └── switch-token.ps1            ← 主切换脚本
```

## 安装

```bash
git clone https://github.com/huzhw/claude-code-token-3000-skill.git ~/.claude/skills/claude-code-token-3000
```

重启 Claude Code 生效。

## 依赖

- PowerShell 5.1+
- `settings - 公司.json` 和 `settings - 自己.json` 须存在于 `~\.claude\`

## 许可

MIT