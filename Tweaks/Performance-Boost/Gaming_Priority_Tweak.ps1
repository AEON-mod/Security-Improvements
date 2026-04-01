# AEON-mod: Multimedia Class Scheduler (MMCSS) Tweak
# 1. Sets 'Games' task priority to 'High' and GPU priority to '8'.
# 2. Sets 'SystemResponsiveness' to 0 for pure gaming/streaming focus.
# 3. Ensures the CPU prioritizes game threads over background tasks.

$path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty -Path $path -Name "NetworkThrottlingIndex" -Value 0xffffffff
Set-ItemProperty -Path $path -Name "SystemResponsiveness" -Value 0
$taskPath = "$path\Tasks\Games"
Set-ItemProperty -Path $taskPath -Name "GPU Priority" -Value 8
Set-ItemProperty -Path $taskPath -Name "Priority" -Value 6
Set-ItemProperty -Path $taskPath -Name "Scheduling Category" -Value "High"
Write-Host "Gaming Priority Tweaks Applied." -ForegroundColor Green