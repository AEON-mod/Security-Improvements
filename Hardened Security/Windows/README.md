# 🏁 Windows Hardening Guide

A curated, high-efficiency security configuration guide designed to secure a standard Windows 10/11 system.

---

## 🚀 One-Line Installation

Install the entire recommended security suite in a single command using the Windows Package Manager (Winget) in an administrator PowerShell prompt:

```powershell
winget install -e --id Safing.Portmaster; winget install -e --id OO-Software.ShutUp10; winget install -e --id Bitdefender.Bitdefender; winget install -e --id Malwarebytes.Malwarebytes
```

---

## 🛠️ The Security Stack

*   **[Bitdefender Antivirus Free](https://www.bitdefender.com/solutions/free.html)** — Lightweight real-time file protection using behavioral heuristics to stop zero-days and ransomware.
*   **[Safing Portmaster](https://safing.io/)** — Kernel-level firewall filtering outbound telemetry, resolving DNS over HTTPS (DoH), and blocking trackers.
*   **[O&O ShutUp10++](https://www.oo-software.com/en/shutup10)** — Portable privacy tool to disable telemetry, diagnostic reports, and location tracking.
*   **[Emsisoft Emergency Kit (EEK)](https://www.emsisoft.com/en/home/emergency-kit/)** — Portable scanner with dual scanning engines for on-demand "second opinion" malware removal.
*   **[Windows Exploit Protection](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exploit-protection)** — Native system-level exploit mitigations (DEP, ASLR, CFG) combined with **Malwarebytes Free** for manual audits.

---

## 🏗️ Deployment Checklist

1.  **Run O&O ShutUp10++** to disable built-in Windows telemetry and data collection.
2.  **Install Portmaster** to gain network visibility and setup private DNS.
3.  **Install Bitdefender Free** for persistent background file scanning.
4.  **Verify Exploit Protection** settings are active in Windows Security settings.
5.  **Scan with EEK** to establish a clean system baseline.

---

## ⚙️ Native System Hardening

### 1. Standard User Account Buffer
Using an administrator account for daily tasks allows malware to inherit full system access.
*   **Action:** Go to **Settings > Accounts > Other users** and add a local user account without administrative rights. Use this account for daily tasks.

### 2. Aggressive Defender Settings
Enable hidden Windows Defender protections via Administrator PowerShell:

```powershell
# Enable 'Block at First Sight' & auto sample submission
Set-MpPreference -MAPSReporting Advanced -SubmitSamplesConsent SendAllSamples

# Enable PUA (Potentially Unwanted Application) blocking
Set-MpPreference -PUAProtection Enabled

# Increase cloud inspection timeout for security decisions
Set-MpPreference -CloudBlockLevel High -CloudExtendedTimeout 15
```

### 3. Core Isolation & Memory Integrity
Prevents malicious code from injecting into high-privilege system processes.
*   **Action:** Search for **Core isolation** in the Start Menu and turn **Memory integrity** to **On**.

### 4. Controlled Folder Access (Ransomware Block)
*   **Action:** Go to **Windows Security > Virus & threat protection > Manage ransomware protection** and turn **Controlled folder access** to **On**.

---

## 🚨 Emergency Recovery Workflow

If you suspect an infection, isolate and clean the system:

1.  **Isolate:** Disconnect the Ethernet cable and disable Wi-Fi immediately.
2.  **Kill Hijackers:** Run **[RKill](https://www.bleepingcomputer.com/download/rkill/)** to terminate active malware processes.
3.  **Scan & Purge:** Launch **[Emsisoft Emergency Kit](https://www.emsisoft.com/en/home/emergency-kit/)** for a deep file scan.
4.  **Remove Adware:** Run **[Malwarebytes AdwCleaner](https://www.malwarebytes.com/adwcleaner)** to reset browser configurations and purge PUPs.
5.  **Restore:** Reconnect, update security definitions, and rotate sensitive passwords.

---

## 🔗 Navigation
*   [Main Repository Index](../README.md)
*   [Linux Hardening Guide](../Linux/README_linux.md)
*   [macOS Hardening Guide](../MacOS/README_macos.md)
