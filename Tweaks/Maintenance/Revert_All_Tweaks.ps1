# AEON-mod: The "Emergency Undo" Script
# 1. Resets most applied tweaks back to Windows defaults.
# 2. Re-enables services and deletes registry overrides.

Write-Host "Reverting all tweaks to default..." -ForegroundColor Yellow
# Example Reverts
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name HiberbootEnabled -Value 1
Set-Service -Name "WSearch" -StartupType Delayed-Auto
# Add other reverts here...
Write-Host "Defaults restored. Please RESTART immediately." -ForegroundColor Green