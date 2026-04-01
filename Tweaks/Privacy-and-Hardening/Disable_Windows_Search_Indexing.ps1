# AEON-mod: Search Indexer Optimizer
# 1. Stops the 'WSearch' service which constantly writes to your disk.
# 2. Prevents the 'Indexer' from eating CPU cycles in the background.
# 3. Highly recommended for users with slower CPUs or full SSDs.

Write-Host "Disabling Windows Search Indexing..." -ForegroundColor Cyan
Stop-Service -Name "WSearch" -ErrorAction SilentlyContinue
Set-Service -Name "WSearch" -StartupType Disabled
Write-Host "Indexing disabled. Background disk activity reduced." -ForegroundColor Green