# ============================================================
# uninstall-auto-3000.ps1 — 卸载开机自动切换 token-3000
# 用法: powershell ./uninstall-auto-3000.ps1
# ============================================================

$ErrorActionPreference = "Stop"
$TaskName = "Token3000-AutoSwitch"

Write-Host "============================================"
Write-Host "  卸载开机自动切换 token-3000"
Write-Host "============================================"

# ---- 删计划任务 ----
try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction Stop 2>$null
    Write-Host "[成功] 已移除计划任务 '$TaskName'"
} catch {
    Write-Host "[跳过] 未找到计划任务 '$TaskName'"
}

# ---- 删注册表 Run 键 ----
$RunKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
try {
    $existing = Get-ItemProperty -Path $RunKey -Name $TaskName -ErrorAction Stop
    if ($existing) {
        Remove-ItemProperty -Path $RunKey -Name $TaskName -Force
        Write-Host "[成功] 已移除注册表 Run 键 '$TaskName'"
    }
} catch {
    Write-Host "[跳过] 未找到注册表 Run 键 '$TaskName'"
}

Write-Host ""
Write-Host "============================================"
Write-Host "  卸载完成，不再自动切换"
Write-Host "============================================"
