# 🏁 Maximum Windows Hardening Guide (v2.0)

A curated, high-efficiency security configuration guide designed to secure Windows 10/11 to the absolute maximum level.

---

## 🚀 One-Line Installation

Install the recommended security suite via Windows Package Manager in an **Administrator PowerShell**:

```powershell
winget install -e --id Safing.Portmaster; winget install -e --id OO-Software.ShutUp10; winget install -e --id Bitdefender.Bitdefender; winget install -e --id Malwarebytes.Malwarebytes
```

> *[Emsisoft Emergency Kit](https://www.emsisoft.com/en/home/emergency-kit/) is portable and does not require installation — download and keep it on a USB drive.*

---

## 🛠️ The Security Stack

*   **[Bitdefender Antivirus Free](https://www.bitdefender.com/solutions/free.html)** — Lightweight real-time file protection using behavioral heuristics to intercept zero-days, ransomware, and trojans.
*   **[Safing Portmaster](https://safing.io/)** — Kernel-level application firewall with DNS-over-HTTPS, per-app traffic control, and system-wide tracker blocking.
*   **[O&O ShutUp10++](https://www.oo-software.com/en/shutup10)** — Portable privacy tool to disable telemetry, diagnostic reports, Cortana, and location tracking via a toggle dashboard.
*   **[Emsisoft Emergency Kit](https://www.emsisoft.com/en/home/emergency-kit/)** — Dual-engine (Emsisoft + Bitdefender) portable scanner for on-demand "second opinion" malware removal.
*   **[Windows Exploit Protection](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exploit-protection)** — Native DEP, ASLR, and CFG exploit mitigations supplemented by **Malwarebytes Free** for manual scanning.

---

## 🏗️ Deployment Checklist

1.  **Run O&O ShutUp10++** to disable built-in telemetry before installing other software.
2.  **Install Portmaster** to establish network monitoring and configure private DNS.
3.  **Install Bitdefender Free** for persistent background file scanning.
4.  **Apply native hardening** — manually (see below) or via the automated script.
5.  **Scan with EEK** to establish a clean system baseline.

---

## ⚙️ Hardening Guide

### Manual Configuration

#### 1. Standard User Account Buffer
Running as Administrator allows malware to inherit full system access.
*   **Action:** Go to **Settings > Accounts > Other users** and create a local account without admin rights. Use it for daily tasks.

#### 2. Aggressive Defender Settings
Open **PowerShell (Run as Administrator)** and execute:

```powershell
# Enable 'Block at First Sight' & auto sample submission
Set-MpPreference -MAPSReporting Advanced
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# Enable PUA (Potentially Unwanted Application) blocking
Set-MpPreference -PUAProtection Enabled

# Increase cloud inspection timeout
Set-MpPreference -CloudBlockLevel High
Set-MpPreference -CloudExtendedTimeout 15

# Enable Network Protection (blocks malicious domains)
Set-MpPreference -EnableNetworkProtection Enabled
```

#### 3. Core Isolation & Memory Integrity
Prevents malicious code from injecting into high-privilege system processes.
*   **Action:** Search **Core isolation** in the Start Menu and turn **Memory integrity** to **On**.

#### 4. Controlled Folder Access (Ransomware Shield)
*   **Action:** Go to **Windows Security > Virus & threat protection > Manage ransomware protection** and turn **Controlled folder access** to **On**.

#### 5. Disable Unnecessary Services
Open **PowerShell (Admin)** and disable services that expand your attack surface:
```powershell
# Disable Remote Registry
Set-Service -Name RemoteRegistry -StartupType Disabled -ErrorAction SilentlyContinue

# Disable Remote Desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1

# Disable Windows Media Player network sharing
Set-Service -Name WMPNetworkSvc -StartupType Disabled -ErrorAction SilentlyContinue
```

#### 6. Windows Firewall Hardening
```powershell
# Enable all firewall profiles with strict inbound blocking
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultOutboundAction Allow

# Enable firewall logging
Set-NetFirewallProfile -Profile Domain,Public,Private -LogBlocked True -LogMaxSizeKilobytes 4096
```

#### 7. Disable Telemetry via Registry
```powershell
# Disable Diagnostics Tracking Service
Set-Service -Name DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
Stop-Service -Name DiagTrack -Force -ErrorAction SilentlyContinue

# Disable telemetry data collection
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -PropertyType DWord -Force

# Disable Customer Experience Improvement Program
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Value 0 -PropertyType DWord -Force
```

---

### Automated Hardening Script

For a single-step configuration of all hardening measures above, run the included `harden_windows.ps1` script in an **Administrator PowerShell**:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\harden_windows.ps1
```

The script automates:
- Defender aggressive mode (MAPS, PUA, cloud analysis, network protection)
- Exploit Protection enforcement (DEP, ASLR, CFG)
- Telemetry and diagnostic service disabling
- Unnecessary service teardown (Remote Registry, Remote Desktop, etc.)
- Firewall strict mode with logging
- Controlled Folder Access (ransomware shield)
- Account lockout policies and maximum UAC enforcement

> [!WARNING]
> Review the script source before running. Some settings may affect Remote Desktop access or enterprise telemetry requirements. The script includes error handling but cannot be reversed automatically — see inline rollback comments.

---

## 🏰 Structural Upgrades (The "Fort Knox" Tier)

For absolute maximum physical and boot-level protection:

1.  **BitLocker Full Disk Encryption:** Encrypt the system drive via **Control Panel > BitLocker** to protect data at rest.
2.  **Secure Boot:** Verify Secure Boot is enabled in your UEFI/BIOS to prevent bootloader tampering.
3.  **Credential Guard:** Enable Virtualization-Based Security to protect credential hashes via `gpedit.msc`.
4.  **Attack Surface Reduction (ASR) Rules:** Enable Microsoft's ASR rules via Group Policy to block Office macro exploits, script-based attacks, and email threats.

---

## 🚨 Emergency Recovery Workflow

If your system displays signs of infection:

1.  **Isolate:** Disconnect Ethernet and disable Wi-Fi immediately.
2.  **Kill Hijackers:** Run **[RKill](https://www.bleepingcomputer.com/download/rkill/)** to terminate active malware processes.
3.  **Scan & Purge:** Launch **[Emsisoft Emergency Kit](https://www.emsisoft.com/en/home/emergency-kit/)** for a deep file scan.
4.  **Remove Adware:** Run **[Malwarebytes AdwCleaner](https://www.malwarebytes.com/adwcleaner)** to reset browser configurations and purge PUPs.
5.  **Restore:** Reconnect, update security definitions, and rotate all sensitive passwords.

---

## 🔗 Navigation
*   [Main Repository Index](../README.md)
*   [Linux Hardening Guide](../Linux/README.md)
*   [macOS Hardening Guide](../MacOS/README.md)
