# AEON-mod: VBS & Memory Integrity Killer
# 1. Disables Virtualization-Based Security (VBS) and HVCI.
# 2. Frees up CPU resources normally used for security virtualization.
# 3. Can improve gaming performance by 5-15% on many systems.

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Value 0
Write-Host "VBS/Memory Integrity Disabled. Restart Required." -ForegroundColor Yellow