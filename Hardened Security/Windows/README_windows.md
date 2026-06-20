# 🏁 Windows Hardening Guide

This guide details the specialized tools, native system configurations, and emergency workflows required to transform a standard Windows 10/11 installation into a highly secure, privacy-respecting digital environment.

---

## 🛠️ The Security Stack

Our stack leverages a modular **Defense in Depth** approach. Instead of a bloated "all-in-one" antivirus suite, we combine specialized, lightweight tools that execute their roles at the highest level.

### 1. [Bitdefender Antivirus Free](https://www.bitdefender.com/solutions/free.html)
*   **Purpose:** The Foundation (Real-Time File Shield).
*   **Key Benefits:** Implements a top-tier, lightweight scanning engine that monitors file activity in real time. It uses behavioral heuristic analysis to detect and block zero-day threats, ransomware, and trojans with minimal CPU/RAM footprint.

### 2. [Safing Portmaster](https://safing.io/)
*   **Purpose:** The Gatekeeper (Application-Level Network Firewall).
*   **Key Benefits:** Operates at the kernel level to monitor every outgoing and incoming connection on your PC. It visualizes traffic per application, blocks ad and tracker domains natively, allows blocking connections by country, and secure DNS queries via DNS-over-HTTPS (DoH).

### 3. [O&O ShutUp10++](https://www.oo-software.com/en/shutup10)
*   **Purpose:** The Silencer (Telemetry & Privacy Hardening).
*   **Key Benefits:** Windows includes extensive telemetry and background network requests. This portable utility lets you disable invasive tracking, Cortana, location services, diagnostic reporting, and auto-updates using a clean, togglable dashboard.

### 4. [Emsisoft Emergency Kit (EEK)](https://www.emsisoft.com/en/home/emergency-kit/)
*   **Purpose:** The Specialist (Portable Remediation).
*   **Key Benefits:** A dual-engine (Emsisoft + Bitdefender) malware scanner that requires no installation. Keep this on your drive or a USB key for second-opinion scans, catching dormant threats that active shields might miss.

### 5. [Windows Exploit Protection & Malwarebytes Free](https://www.malwarebytes.com/mwb-download)
*   **Purpose:** The Shield (Zero-Day & Exploit Prevention).
*   **Key Benefits:** Standalone Malwarebytes Anti-Exploit is deprecated (integrated into Malwarebytes Premium), but Windows 10/11 comes with powerful native **Exploit Protection** (DEP, ASLR, CFG). We supplement this native shield with **Malwarebytes Free** for manual, on-demand scanning.

---

## 🏗️ Deployment Strategy

For the smoothest setup, apply the tools and configurations in the following order:

| Step | Action | Objective |
| :--- | :--- | :--- |
| **01** | Apply [O&O ShutUp10++](https://www.oo-software.com/en/shutup10) | Plug data leaks and disable telemetry before installing other software. |
| **02** | Install [Safing Portmaster](https://safing.io/) | Establish network monitoring and configure secure DNS. |
| **03** | Install [Bitdefender Antivirus Free](https://www.bitdefender.com/solutions/free.html) | Deploy your active, real-time file scanner. |
| **04** | Configure Exploit Protection | Verify native Windows Exploit Protection settings are enabled (DEP, ASLR). |
| **05** | Run [EEK](https://www.emsisoft.com/en/home/emergency-kit/) Baseline Scan | Perform a full scan to guarantee a clean system baseline. |

---

## ⚙️ Native OS Hardening Instructions

### 1. Configure a "Standard User" Account
Running your system under an Administrator account is a critical security vulnerability. If malware executes, it inherits full admin permissions.
*   **Setup:** Navigate to **Settings > Accounts > Other users**. Click **Add account** and create a local account (select *I don't have this person's sign-in information*, then *Add a user without a Microsoft account*).
*   **Usage:** Use this Standard account for your daily work. When an installer or setting requires admin privileges, User Account Control (UAC) will prompt you for your administrator password—creating an intentional buffer.

### 2. Enable Aggressive Defender Mode via PowerShell
Windows Defender operates passively by default. You can elevate its rules to block threats instantly using an elevated PowerShell prompt.

Open **PowerShell (Run as Administrator)** and execute these commands:

```powershell
# Enable Advanced Cloud-Delivered Protection (Block at First Sight)
Set-MpPreference -MAPSReporting Advanced
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# Enable Potentially Unwanted Application (PUA) Blocking
Set-MpPreference -PUAProtection Enabled

# Increase the Cloud Extended Timeout (gives Defender more time to analyze files in the cloud)
Set-MpPreference -CloudBlockLevel High
Set-MpPreference -CloudExtendedTimeout 15
```

### 3. Activate Core Isolation & Memory Integrity
Core Isolation uses virtualization-based security to protect core system processes from injection and tampering.
*   **Setup:** Open the Start Menu, search for **Core isolation**, and toggle **Memory integrity** to **On**.
*   *Note: This may require updating outdated hardware drivers.*

### 4. Enable Controlled Folder Access (Ransomware Shield)
Prevents unauthorized applications from modifying files in critical system directories (Documents, Pictures, Desktop).
*   **Setup:** Open **Windows Security > Virus & threat protection > Manage ransomware protection**. Toggle **Controlled folder access** to **On**. Add custom folders if needed.

---

## 🚨 Emergency Workflow (If Infected)

If your system displays signs of infection (unexplained CPU spikes, popups, hijacked browser homepages), execute these steps immediately:

> [!IMPORTANT]
> **Step 0: Disconnect the Network.**
> Unplug your Ethernet cable or disable your Wi-Fi interface immediately to stop data exfiltration and prevent remote commands.

1.  **Terminate Malicious Processes:** Download and run **[RKill](https://www.bleepingcomputer.com/download/rkill/)**. It forces active malicious processes to terminate, making it possible for your antivirus to scan and delete files that were previously locked.
2.  **Run Dual-Engine Scan:** Launch **[Emsisoft Emergency Kit](https://www.emsisoft.com/en/home/emergency-kit/)** (preferably from a pre-loaded USB drive) and run a **Malware Scan**.
3.  **Purge Adware/Browser Hijackers:** Download and run **[Malwarebytes AdwCleaner](https://www.malwarebytes.com/adwcleaner)** to clean up malicious search bars, tracking cookies, and modified browser preferences.
4.  **Verification & Recovery:** Reconnect your network, run Windows Update, update your antivirus definitions, run a final full scan, and change all passwords stored on the device.

---

## 🔗 Related Resources
*   [Main Index](README.md)
*   [Linux Hardening Guide](README_linux.md)
*   [macOS Hardening Guide](README_macos.md)
