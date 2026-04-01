# AEON-mod: Total Copilot Removal
# 1. Disables the Windows Copilot AI engine entirely via Policy.
# 2. Removes the Copilot icon from the Taskbar.
# 3. Prevents AI background processes from starting with Windows.

$Path = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
if (!(Test-Path $Path)) { New-Item -Path $Path -Force }
Set-ItemProperty -Path $Path -Name "TurnOffWindowsCopilot" -Type DWord -Value 1
Stop-Process -Name explorer -Force
Write-Host "Copilot has been removed." -ForegroundColor Green