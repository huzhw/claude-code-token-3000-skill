# 切换 API Token

Claude Code API 一键切换：token-3000（公司免费）↔ token-me（自己花钱）。

## 功能

| 命令 | 效果 |
|------|------|
| `/token-3000` | 切公司 192.168.80.248:3000，免费 |
| `/token-me` | 切个人 api.deepseek.com，自己花钱 |

## 参数 me 切换逻辑

```
/token-me
  ├─ 探测 192.168.80.248:3000 通不通
  ├─ 通 → "公司还能用，确定切自己花钱？"
  └─ 不通 → 直接切，不废话
```

## 安装

```bash
git clone https://github.com/huzhw/token-3000-skill.git ~/.claude/skills/token-3000
```

## 相关技能

- [git-commit](https://github.com/huzhw/git-commit-skill)：Git 提交规范
- [coding-rules](https://github.com/huzhw/coding-rules)：AI 编码协作规范
- [reread-claude-md](https://github.com/huzhw/reread-claude-md-skill)：重新加载 CLAUDE.md 规则
- [daily-record](https://github.com/huzhw/daily-record-skill)：日报记录
- [daily-merge](https://github.com/huzhw/daily-merge-skill)：日报合并

## 依赖

- PowerShell 5.1+
- `settings - 公司.json` 和 `settings - 自己.json` 须存在于 `~/.claude/`
