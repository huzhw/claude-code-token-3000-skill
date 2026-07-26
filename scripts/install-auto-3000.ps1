# ============================================================
# install-auto-3000.ps1 — 注册开机自动切换 token-3000
# 用法: powershell ./install-auto-3000.ps1
# 效果: 每次开机登录后自动执行 switch-token.ps1（默认→公司）
# ============================================================

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SwitchScript = Join-Path $ScriptDir "switch-token.ps1"

if (-not (Test-Path $SwitchScript)) {
    Write-Host "[错误] 找不到 switch-token.ps1: $SwitchScript"
    exit 1
}

$TaskName = "Token3000-AutoSwitch"

Write-Host "============================================"
Write-Host "  安装开机自动切换 token-3000"
Write-Host "============================================"

# ---- 先删旧任务（如果存在）----
try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue 2>$null
    Write-Host "[清理] 已移除旧的计划任务"
} catch {}

# ---- 注册计划任务 ----
$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$SwitchScript`""

# 触发器：用户登录后延迟 30 秒（等网络就绪）
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 2) `
    -Hidden

# 延迟 30 秒
$Trigger.Delay = "PT30S"

try {
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $Action `
        -Trigger $Trigger `
        -Settings $Settings `
        -Description "开机后自动切换 Claude Code API 到公司 token-3000（免费）" `
        -RunLevel Limited `
        -Force | Out-Null
    Write-Host "[成功] 计划任务 '$TaskName' 已注册"
} catch {
    Write-Host "[失败] 计划任务注册失败: $_"
    Write-Host ""
    Write-Host "[备选] 尝试注册表 Run 键..."
    
    $RunKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $RegValue = "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$SwitchScript`""
    Set-ItemProperty -Path $RunKey -Name $TaskName -Value $RegValue
    Write-Host "[成功] 注册表 Run 键已设置: $TaskName"
}

Write-Host ""
Write-Host "============================================"
Write-Host "  安装完成！"
Write-Host "============================================"
Write-Host "  每次开机登录后 30 秒会自动切换到 token-3000"
Write-Host "  如需卸载，运行: .\uninstall-auto-3000.ps1"
