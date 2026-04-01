# AEON-mod: Input Lag & Stutter Reducer
# 1. Disables the High Precision Event Timer (HPET) in the boot config.
# 2. Reduces the 'polling' overhead on the CPU during high-intensity gaming.
# 3. Can improve 1% low FPS and mouse responsiveness.

Write-Host "Disabling HPET for smoother gameplay..." -ForegroundColor Cyan
bcdedit /deletevalue useplatformclock
Write-Host "HPET disabled. Note: You should also disable 'High precision event timer' in Device Manager." -ForegroundColor Yellow