# AEON-mod: Lock Screen Ad Remover
# 1. Disables 'Windows Spotlight' suggestions on the lock screen.
# 2. Stops Windows from showing "Fun facts, tips, and more" before login.
# 3. Ensures a clean, minimalist lock screen experience.

Write-Host "Removing Lock Screen ads and tips..." -ForegroundColor Cyan
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
Set-ItemProperty -Path $Path -Name "RotatingLockScreenEnabled" -Value 0
Set-ItemProperty -Path $Path -Name "SubscribedContent-338387Enabled" -Value 0
Write-Host "Lock screen is now clean." -ForegroundColor Green