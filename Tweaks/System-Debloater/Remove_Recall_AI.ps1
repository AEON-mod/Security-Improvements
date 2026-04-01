# AEON-mod: Recall & AI Data Analysis Kill
# 1. Disables 'Windows Recall' (snapshots of your screen activity).
# 2. Blocks the OS from analyzing your local data for 'AI features'.
# 3. Preserves privacy by stopping background AI indexing.

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
if (!(Test-Path $Path)) { New-Item -Path $Path -Force }
Set-ItemProperty -Path $Path -Name "DisableAIDataAnalysis" -Type DWord -Value 1
Write-Host "AI Recall and Analysis disabled." -ForegroundColor Green

