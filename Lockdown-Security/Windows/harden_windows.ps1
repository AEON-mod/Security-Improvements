# ============================================================================
#  harden_windows.ps1 — Maximum Windows Desktop Hardening Script (v2.0)
# ============================================================================
#
#  WARNING: This script modifies system-level security configurations.
#  Review each function before running. Some settings may affect:
#    - Remote Desktop connectivity (disabled by default)
#    - Enterprise telemetry/diagnostics reporting
#    - Certain legacy application behaviors
#
#  USAGE: Run in Administrator PowerShell:
#    Set-ExecutionPolicy Bypass -Scope Process -Force; .\harden_windows.ps1
#
# ============================================================================

#Requires -RunAsAdministrator

# ─── Colors ─────────────────────────────────────────────────────────────────
function Write-OK      { param($msg) Write-Host "  [OK]    " -ForegroundColor Green -NoNewline; Write-Host $msg }
function Write-Warn    { param($msg) Write-Host "  [WARN]  " -ForegroundColor Yellow -NoNewline; Write-Host $msg }
function Write-Err     { param($msg) Write-Host "  [ERROR] " -ForegroundColor Red -NoNewline; Write-Host $msg }
function Write-Info    { param($msg) Write-Host "  [INFO]  " -ForegroundColor Cyan -NoNewline; Write-Host $msg }
function Write-Section { param($msg) Write-Host "`n── $msg ──" -ForegroundColor Cyan }

# ─── Tracking ───────────────────────────────────────────────────────────────
$Applied = [System.Collections.ArrayList]::new()
$Skipped = [System.Collections.ArrayList]::new()
$Failed  = [System.Collections.ArrayList]::new()

# ─── Banner ─────────────────────────────────────────────────────────────────
function Show-Banner {
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║        🏁  WINDOWS HARDENING SCRIPT  v2.0  🛡️            ║" -ForegroundColor Cyan
    Write-Host "  ║            Maximum Security Configuration                ║" -ForegroundColor Cyan
    Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════
#  HARDENING FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# 1. Windows Defender Hardening
# Rollback: Set-MpPreference -MAPSReporting Basic; Set-MpPreference -PUAProtection Disabled
function Set-DefenderHardening {
    Write-Section "Windows Defender Hardening"
    try {
        Set-MpPreference -MAPSReporting Advanced -ErrorAction Stop
        Set-MpPreference -SubmitSamplesConsent SendAllSamples -ErrorAction Stop
        Set-MpPreference -PUAProtection Enabled -ErrorAction Stop
        Set-MpPreference -CloudBlockLevel High -ErrorAction Stop
        Set-MpPreference -CloudExtendedTimeout 15 -ErrorAction Stop
        Set-MpPreference -EnableNetworkProtection Enabled -ErrorAction Stop
        Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
        Write-OK "Defender: MAPS Advanced, PUA block, cloud analysis, network protection enabled."
        $null = $Applied.Add("Defender Hardening")
    } catch {
        Write-Err "Defender hardening failed: $_"
        $null = $Failed.Add("Defender Hardening")
    }
}

# 2. Exploit Protection
# Rollback: Set-ProcessMitigation -System -Disable DEP, ASLR
function Set-ExploitProtection {
    Write-Section "Exploit Protection (DEP, ASLR, CFG)"
    try {
        Set-ProcessMitigation -System -Enable DEP, EmulateAtlThunks -ErrorAction Stop
        Set-ProcessMitigation -System -Enable ASLR:BottomUp, ASLR:HighEntropy -ErrorAction Stop
        Set-ProcessMitigation -System -Enable CFG, StrictCFG -ErrorAction Stop
        Write-OK "System-wide DEP, ASLR (BottomUp + HighEntropy), and CFG enforced."
        $null = $Applied.Add("Exploit Protection")
    } catch {
        Write-Warn "Some exploit mitigations may not be available on this system: $_"
        $null = $Skipped.Add("Exploit Protection (partial)")
    }
}

# 3. Disable Telemetry
# Rollback: Set-Service DiagTrack -StartupType Automatic; Start-Service DiagTrack
function Disable-Telemetry {
    Write-Section "Telemetry & Diagnostics Disabling"
    try {
        # Disable Diagnostics Tracking Service
        Set-Service -Name DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service -Name DiagTrack -Force -ErrorAction SilentlyContinue

        # Disable Connected User Experiences and Telemetry
        Set-Service -Name dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service -Name dmwappushservice -Force -ErrorAction SilentlyContinue

        # Registry: Disable telemetry data collection
        $DataCollectionPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        if (-not (Test-Path $DataCollectionPath)) {
            New-Item -Path $DataCollectionPath -Force | Out-Null
        }
        Set-ItemProperty -Path $DataCollectionPath -Name "AllowTelemetry" -Value 0 -Type DWord -Force

        # Registry: Disable CEIP
        $CEIPPath = "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
        if (-not (Test-Path $CEIPPath)) {
            New-Item -Path $CEIPPath -Force | Out-Null
        }
        Set-ItemProperty -Path $CEIPPath -Name "CEIPEnable" -Value 0 -Type DWord -Force

        # Disable feedback notifications
        $SiufPath = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
        if (-not (Test-Path $SiufPath)) {
            New-Item -Path $SiufPath -Force | Out-Null
        }
        Set-ItemProperty -Path $SiufPath -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord -Force

        Write-OK "Telemetry services disabled. Registry keys set to block data collection."
        $null = $Applied.Add("Telemetry Disabled")
    } catch {
        Write-Err "Telemetry disabling partially failed: $_"
        $null = $Failed.Add("Telemetry Disabled")
    }
}

# 4. Disable Unnecessary Services
# Rollback: Set-Service -Name <ServiceName> -StartupType Manual
function Disable-UnnecessaryServices {
    Write-Section "Unnecessary Service Teardown"

    $services = @(
        @{Name="RemoteRegistry";     Desc="Remote Registry"},
        @{Name="WMPNetworkSvc";      Desc="Windows Media Player Network Sharing"},
        @{Name="lfsvc";              Desc="Geolocation Service"},
        @{Name="RetailDemo";         Desc="Retail Demo Service"},
        @{Name="wisvc";              Desc="Windows Insider Service"}
    )

    foreach ($svc in $services) {
        try {
            $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
            if ($service) {
                Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction Stop
                Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
                Write-OK "Disabled: $($svc.Desc)"
            } else {
                Write-Info "Not found (skipping): $($svc.Desc)"
            }
        } catch {
            Write-Warn "Could not disable $($svc.Desc): $_"
        }
    }

    # Disable Remote Desktop
    try {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1 -Force
        Write-OK "Remote Desktop disabled."
    } catch {
        Write-Warn "Could not disable Remote Desktop."
    }

    $null = $Applied.Add("Unnecessary Services Disabled")
}

# 5. Firewall Strict Mode
# Rollback: Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Allow
function Set-FirewallStrict {
    Write-Section "Windows Firewall Strict Mode"
    try {
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -ErrorAction Stop
        Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block -ErrorAction Stop
        Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultOutboundAction Allow -ErrorAction Stop
        Set-NetFirewallProfile -Profile Domain,Public,Private -LogBlocked True -LogMaxSizeKilobytes 4096 -ErrorAction Stop
        Write-OK "Firewall: all profiles enabled, inbound blocked, logging active."
        $null = $Applied.Add("Firewall Strict Mode")
    } catch {
        Write-Err "Firewall configuration failed: $_"
        $null = $Failed.Add("Firewall Strict Mode")
    }
}

# 6. Controlled Folder Access
# Rollback: Set-MpPreference -EnableControlledFolderAccess Disabled
function Enable-ControlledFolderAccess {
    Write-Section "Controlled Folder Access (Ransomware Shield)"
    try {
        Set-MpPreference -EnableControlledFolderAccess Enabled -ErrorAction Stop
        Write-OK "Controlled Folder Access enabled (protects Documents, Pictures, Desktop)."
        $null = $Applied.Add("Controlled Folder Access")
    } catch {
        Write-Err "Could not enable Controlled Folder Access: $_"
        $null = $Failed.Add("Controlled Folder Access")
    }
}

# 7. Account Policies
# Rollback: net accounts /lockoutthreshold:0
function Set-AccountPolicies {
    Write-Section "Account Lockout & UAC Policies"
    try {
        # Account lockout: 5 failed attempts, 30 minute lockout
        net accounts /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 2>&1 | Out-Null

        # UAC to maximum
        $UACPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Set-ItemProperty -Path $UACPath -Name "ConsentPromptBehaviorAdmin" -Value 2 -Type DWord -Force
        Set-ItemProperty -Path $UACPath -Name "PromptOnSecureDesktop" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $UACPath -Name "EnableLUA" -Value 1 -Type DWord -Force

        Write-OK "Account lockout: 5 attempts / 30 min. UAC set to maximum."
        $null = $Applied.Add("Account Policies")
    } catch {
        Write-Err "Account policy configuration failed: $_"
        $null = $Failed.Add("Account Policies")
    }
}

# 8. Disable SMBv1
# Rollback: Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
function Disable-SMBv1 {
    Write-Section "SMBv1 Protocol Disabling"
    try {
        $smb1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue
        if ($smb1 -and $smb1.State -eq "Enabled") {
            Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction Stop | Out-Null
            Write-OK "SMBv1 protocol disabled (WannaCry/EternalBlue mitigation)."
        } else {
            Write-Info "SMBv1 is already disabled."
        }
        $null = $Applied.Add("SMBv1 Disabled")
    } catch {
        Write-Warn "Could not disable SMBv1: $_"
        $null = $Skipped.Add("SMBv1 Disabled")
    }
}

# ═══════════════════════════════════════════════════════════════════════════
#  SUMMARY
# ═══════════════════════════════════════════════════════════════════════════
function Show-Summary {
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "                       HARDENING SUMMARY                    " -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════════════" -ForegroundColor Cyan

    if ($Applied.Count -gt 0) {
        Write-Host "`n  Applied ($($Applied.Count)):" -ForegroundColor Green
        foreach ($item in $Applied) {
            Write-Host "    • $item" -ForegroundColor Green
        }
    }

    if ($Skipped.Count -gt 0) {
        Write-Host "`n  Skipped ($($Skipped.Count)):" -ForegroundColor Yellow
        foreach ($item in $Skipped) {
            Write-Host "    • $item" -ForegroundColor Yellow
        }
    }

    if ($Failed.Count -gt 0) {
        Write-Host "`n  Failed ($($Failed.Count)):" -ForegroundColor Red
        foreach ($item in $Failed) {
            Write-Host "    • $item" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "    Reboot recommended to fully activate all changes." -ForegroundColor White
    Write-Host "  ═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════════════════════
Show-Banner

Write-Host "  This script will apply system-level security hardening." -ForegroundColor Yellow
Write-Host "  Review the source code before proceeding.`n" -ForegroundColor Yellow
$confirm = Read-Host "  Continue? [y/N]"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Info "Aborted by user."
    exit 0
}

Set-DefenderHardening
Set-ExploitProtection
Disable-Telemetry
Disable-UnnecessaryServices
Set-FirewallStrict
Enable-ControlledFolderAccess
Set-AccountPolicies
Disable-SMBv1

Show-Summary
