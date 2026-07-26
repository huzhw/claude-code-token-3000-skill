---
name: token-3000
description: 切换 Claude Code API Token：token-3000（公司内网 192.168.80.248:3000，免费）和 token-me（个人 DeepSeek，自己花钱）。触发词：token-3000、token-me、切3000、切自己、切公司、切免费、切付费、切换token、3000token、我的token。
author: 胡志伟
motto: "token-3000 白嫖，token-me 花自己的钱——切换只需一条命令。"
---

# 切换 API Token

在公司内网 API 和个人 DeepSeek API 之间一键切换。

## 触发

| 命令 | 效果 |
|------|------|
| `/token-3000` | 切到公司内网 API（免费，不检测） |
| `/token-me` | 切到个人 DeepSeek API（自己花钱） |

## 执行

收到触发请求后：

1. 判断触发词：
   - 含 `3000`、`公司`、`免费` → 参数 `3000`
   - 含 `me`、`自己`、`我的`、`付费` → 参数 `me`

2. 执行脚本：
   ```
   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\skills\token-3000\scripts\switch-token.ps1" [3000|me]
   ```

3. 脚本自动：
   - 反向同步当前配置到对应备份文件
   - 合并目标 env + 当前其余配置
   - 参数 `me` 时先探测公司通不通，通则二次确认
   - 覆盖 settings.json

4. 展示脚本输出，提醒 `/new` 重启。
