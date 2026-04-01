# AEON-mod: Cold Boot Enforcer
# 1. Disables 'Fast Startup' to ensure Windows performs a REAL shutdown.
# 2. Prevents kernel hibernation, which often traps system errors and bugs.
# 3. Essential for a clean-feeling system and accurate 'Uptime' tracking.

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name HiberbootEnabled -Value 0
Write-Host "Fast Startup disabled." -ForegroundColor Green