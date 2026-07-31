# 切换 API Token

Claude Code API 一键切换：token-3000（公司免费）↔ token-me（自己花钱）。公司内网挂了自动切自己，开机自动切回公司。

## 相关技能

- [git-commit](https://github.com/huzhw/git-commit-skill)：Git 提交规范
- [coding-rules](https://github.com/huzhw/coding-rules)：AI 编码协作规范
- [reread-claude-md](https://github.com/huzhw/reread-claude-md-skill)：重新加载 CLAUDE.md 规则
- [daily-record](https://github.com/huzhw/daily-record-skill)：日报记录
- [daily-merge](https://github.com/huzhw/daily-merge-skill)：日报合并
- [service-manager](https://github.com/huzhw/service-manager)：桌面服务管理工具

---

## 解决了什么问题

**公司内网说挂就挂，AI 直接失联。** 手动改 settings.json 切到自己 key——要记住配置、要备份、要改回来。来回切几次，配置就乱了。

这个技能把切换变成了 AI 能听懂的命令：`/token-3000` 切公司白嫖，`/token-me` 切自己花钱。每次切换自动双向同步备份，permissions/hooks/MCP 等所有配置不丢不乱。

## 核心能力

- **一键切换** — 两个命令，不用记 IP 和密钥
- **双向同步** — 每次切换先反向同步当前配置到备份，确保 permissions/hooks/MCP 等永不丢失
- **智能探测** — 切自己时先探公司通不通，通则二次确认防止误操作
- **开机自启** — 安装后每次登录自动切回公司，不用惦记
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

### 开机自启

一次安装，每次登录 30 秒后自动切换到 token-3000：

```bash
powershell -File "$env:USERPROFILE\.claude\skills\token-3000\scripts\install-auto-3000.ps1"
```

卸载：

```bash
powershell -File "$env:USERPROFILE\.claude\skills\token-3000\scripts\uninstall-auto-3000.ps1"
```

> 优先用计划任务（需管理员），没有管理员权限自动降级到注册表 Run 键，效果一致。

## 配置

以后换 IP 或端口，只改 `switch-token.ps1` 顶部：

```powershell
$CompanyIp   = "192.168.80.248"               # 公司内网服务器 IP
$CompanyPort = "3000"                         # 公司内网端口
$CompanyUrl  = "http://${CompanyIp}:${CompanyPort}"  # 公司 API 地址
```

## 文件结构

```
token-3000/
├── SKILL.md                        ← 技能定义
├── README.md                       ← 本文档
└── scripts/
    ├── switch-token.ps1            ← 主切换脚本
    ├── install-auto-3000.ps1       ← 安装开机自启
    └── uninstall-auto-3000.ps1     ← 卸载开机自启
```

## 安装

```bash
git clone https://github.com/huzhw/token-3000-skill.git ~/.claude/skills/token-3000
```

重启 Claude Code 生效。

## 依赖

- PowerShell 5.1+
- `settings - 公司.json` 和 `settings - 自己.json` 须存在于 `~\.claude\`

## 许可

MIT
