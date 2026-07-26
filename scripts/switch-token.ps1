# ============================================================
# switch-token.ps1 — Claude Code API Token 切换脚本
# 用法: powershell ./switch-token.ps1          → 切公司 (3000)
#       powershell ./switch-token.ps1 me       → 切个人 (自己花钱)
#       powershell ./switch-token.ps1 3000     → 切公司 (3000)
# ============================================================
param([string]$Target = "3000")

# ============================================================
# 配置区 — 以后换 IP/端口只改这里
# ============================================================
$CompanyIp   = "192.168.80.248"               # 公司内网服务器 IP
$CompanyPort = "3000"                         # 公司内网端口
$CompanyUrl  = "http://${CompanyIp}:${CompanyPort}"  # 公司 API 地址
$CompanyRegex = [regex]::Escape($CompanyIp)   # 转义正则中的点号
# ============================================================

$ErrorActionPreference = "Stop"
$ClaudeDir = "$env:USERPROFILE\.claude"
$SettingsFile = "$ClaudeDir\settings.json"
$BackupCompany = "$ClaudeDir\settings - 公司.json"
$BackupPersonal = "$ClaudeDir\settings - 自己.json"

# ---- 输入校验 ----
if ($Target -ne "3000" -and $Target -ne "me") {
    Write-Host "用法: .\switch-token.ps1 [3000|me]"
    Write-Host "  不带参数 → token-3000（公司免费）"
    Write-Host "  me       → token-me（自己花钱）"
    exit 1
}

$TargetLabel = if ($Target -eq "3000") { "公司($CompanyPort)" } else { "自己" }

# ---- ① 读取当前 settings.json ----
if (-not (Test-Path $SettingsFile)) {
    Write-Host "[错误] 找不到 $SettingsFile"
    exit 1
}
$Current = Get-Content $SettingsFile -Raw -Encoding UTF8 | ConvertFrom-Json

# 判断当前是公司还是个人
$CurrentBaseUrl = $Current.env.ANTHROPIC_BASE_URL
$CurrentType = if ($CurrentBaseUrl -match $CompanyRegex) { "公司($CompanyPort)" } else { "自己" }

Write-Host "============================================"
Write-Host "  当前: token-$($CurrentType -replace "\($CompanyPort\)",'')  ($CurrentType)"
Write-Host "  目标: token-$Target"
Write-Host "============================================"

# ---- ② 反向同步：当前配置先写回对应备份 ----
if ($CurrentType -match "公司") {
    Write-Host "[同步] 当前配置 -> settings - 公司.json"
    $Current | ConvertTo-Json -Depth 20 | Set-Content $BackupCompany -Encoding UTF8
} else {
    Write-Host "[同步] 当前配置 -> settings - 自己.json"
    $Current | ConvertTo-Json -Depth 20 | Set-Content $BackupPersonal -Encoding UTF8
}

# ---- ③ 读目标备份 ----
$TargetBackup = if ($Target -eq "3000") { $BackupCompany } else { $BackupPersonal }
if (-not (Test-Path $TargetBackup)) {
    Write-Host "[错误] 找不到备份文件 $TargetBackup"
    exit 1
}
$TargetConfig = Get-Content $TargetBackup -Raw -Encoding UTF8 | ConvertFrom-Json

# ---- ④ 合并：目标备份的 env + 当前 settings.json 的其余全部 ----
$Current.env = $TargetConfig.env
$Current | ConvertTo-Json -Depth 20 | Set-Content $TargetBackup -Encoding UTF8
Write-Host "[同步] 合并后配置 -> $TargetBackup"

# ---- ⑤ 如果是切 me（自己），检测公司通不通 ----
if ($Target -eq "me") {
    Write-Host ""
    Write-Host "[检测] 探测公司服务器 ${CompanyUrl} ..."
    try {
        $response = Invoke-WebRequest -Uri $CompanyUrl -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
        Write-Host "[结果] 公司服务器可达 (HTTP $($response.StatusCode))"
        Write-Host ""
        Write-Host "  token-3000 还能用（免费），你确定要切 token-me（自己花钱）？"
        $choice = Read-Host "  [Y] 切自己花钱 / [N] 取消 "
        if ($choice -ne "Y" -and $choice -ne "y") {
            Write-Host "[取消] 继续用 token-3000"
            exit 0
        }
    } catch {
        Write-Host "[结果] 公司服务器不可达，切换到 token-me"
    }
}

# ---- ⑥ 覆盖 settings.json ----
$Current | ConvertTo-Json -Depth 20 | Set-Content $SettingsFile -Encoding UTF8

# ---- ⑦ 输出结果 ----
$NewToken = $Current.env.ANTHROPIC_AUTH_TOKEN
$NewBaseUrl = $Current.env.ANTHROPIC_BASE_URL
$NewModel = $Current.env.ANTHROPIC_MODEL

Write-Host ""
Write-Host "============================================"
Write-Host "  切换完成！token-$Target"
Write-Host "============================================"
Write-Host "  Key      : $($NewToken.Substring(0, [Math]::Min(12, $NewToken.Length)))..."
Write-Host "  Base URL : $NewBaseUrl"
Write-Host "  Model    : $NewModel"
if ($Target -eq "3000") {
    Write-Host "  计费     : 公司免费"
} else {
    Write-Host "  计费     : 自己花钱"
}
Write-Host "============================================"
Write-Host ""
Write-Host "  [!!] 请执行 /new 或重启 Claude Code 使新 Token 生效"
