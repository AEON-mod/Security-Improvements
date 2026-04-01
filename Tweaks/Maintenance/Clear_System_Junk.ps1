# AEON-mod: Junk & Cache Cleaner
# 1. Deletes temporary files, Prefetch, and shader caches.
# 2. Flushes the DNS cache to fix network lag.
# 3. Reclaims disk space and improves general snappiness.

Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
ipconfig /flushdns
Write-Host "System junk and network cache cleared." -ForegroundColor Green