# AEON-mod: Defender High-Security Mode
# 1. Enables 'Block at First Sight' (Advanced Cloud Protection).
# 2. Turns on Potentially Unwanted Application (PUA) blocking.
# 3. Forces Defender to scan more aggressively for zero-day threats.

Set-MpPreference -PUAProtection Enabled
Set-MpPreference -MAPSReporting Advanced
Set-MpPreference -SubmitSamplesConsent SendAllSamples
Write-Host "Windows Defender Hardened to Maximum." -ForegroundColor Green