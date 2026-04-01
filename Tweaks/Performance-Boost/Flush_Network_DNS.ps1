# AEON-mod: Network & DNS Optimizer
# 1. Clears the DNS Resolver cache to fix website loading issues.
# 2. Releases and Renews your IP address for a fresh connection.
# 3. Flushes and Resets the Windows Socket (Winsock) to repair network errors.

Write-Host "Optimizing network and flushing DNS..." -ForegroundColor Cyan
ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /renew
netsh winsock reset
Write-Host "Network refreshed. You may need to reconnect to Wi-Fi." -ForegroundColor Green