# AEON-mod: Anti-Malware Tamper Protection
# 1. Activates 'Tamper Protection' within Windows Security.
# 2. Locks down Defender settings so they cannot be changed by scripts or apps.
# 3. Ensures your security configuration remains permanent.

Write-Host "Enabling Tamper Protection..." -ForegroundColor Cyan
Set-MpPreference -IsTamperProtected $true
Set-MpPreference -DisableRealtimeMonitoring $false
Write-Host "Security settings locked against unauthorized changes." -ForegroundColor Green