# AEON-mod: NVMe SSD Speed Unlocker
# 1. Enables high-performance native NVMe driver features (Feature ID 156965516).
# 2. Reduces overhead between the OS and high-speed storage.
# 3. Can improve IOPS and sequential speeds on supported Gen4/Gen5 drives.

$Path = "HKLM:\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides"
if (!(Test-Path $Path)) { New-Item -Path $Path -Force }
Set-ItemProperty -Path $Path -Name "156965516" -Type DWord -Value 1
Write-Host "NVMe optimizations applied. Restart to see speed gains." -ForegroundColor Green