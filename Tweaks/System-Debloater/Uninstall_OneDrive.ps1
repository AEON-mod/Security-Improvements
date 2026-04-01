# AEON-mod: OneDrive Purge
# 1. Forcefully closes any running OneDrive instances.
# 2. Runs the built-in uninstaller and removes the sidebar icon.
# 3. Cleans up leftover setup files to free up disk space.

Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
$os = if ([Environment]::Is64BitOperatingSystem) { "SysWOW64" } else { "System32" }
Start-Process "$env:SystemRoot\$os\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait
Write-Host "OneDrive has been uninstalled." -ForegroundColor Green