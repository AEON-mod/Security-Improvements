# AEON-mod: Total Telemetry Kill
# 1. Blocks Microsoft's data collection services (DiagTrack) at the root.
# 2. Points tracking domains to 0.0.0.0 in the hosts file.
# 3. Stops Windows from 'phoning home' with your usage statistics.

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Stop-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled
Write-Host "Telemetry services killed and blocked." -ForegroundColor Green