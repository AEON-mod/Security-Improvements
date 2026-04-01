# AEON-mod: Safety Snapshot
# 1. Creates a system-wide restore point before applying tweaks.
# 2. Ensures you can revert changes if something goes wrong.

Checkpoint-Computer -Description "Before AEON-mod Tweaks" -RestorePointType "MODIFY_SETTINGS"
Write-Host "Safety Restore Point Created." -ForegroundColor Green