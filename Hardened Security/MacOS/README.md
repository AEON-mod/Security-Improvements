# 🍎 macOS Hardening Guide

A curated, high-efficiency security configuration guide designed to secure Apple macOS (Intel and Apple Silicon).

---

## 🚀 One-Line Installation

Install the entire recommended security suite in a single command using Homebrew in the Terminal:

```bash
brew install --cask lulu blockblock oversight knockknock silentknight
```
*Note: Due to system security policies, you must open **System Settings > Privacy & Security** to manually approve system extensions after installation.*

---

## 🛠️ The Security Stack

*   **[LuLu Outbound Firewall](https://objective-see.org/tools/lulu.html)** — Open-source firewall that intercepts and prompts to block outgoing network traffic on a per-app basis.
*   **[BlockBlock](https://objective-see.org/tools/blockblock.html)** — Real-time persistence monitor alerting you whenever code attempts to install as startup Launch Agents/Daemons.
*   **[OverSight](https://objective-see.org/tools/oversight.html)** — Security utility monitoring internal webcam and microphone access, logging which active process triggered them.
*   **[KnockKnock](https://objective-see.org/tools/knockknock.html)** — On-demand scanner listing existing persistent components to identify hidden malware.
*   **[SilentKnight](https://eclecticlight.co/)** — Update auditor inspecting macOS background databases (XProtect/MRT), SIP, and firmware to ensure your system updates are complete.

---

## 🏗️ Deployment Checklist

1.  **Run SilentKnight** to verify all Apple system updates and security files are installed.
2.  **Enable LuLu Firewall** to control outbound background network requests.
3.  **Install BlockBlock & OverSight** to shield startup agents and peripheral hardware.
4.  **Audit pre-existing apps with KnockKnock** to ensure a clean baseline.
5.  **Verify native macOS configurations** (FileVault, SIP status).

---

## ⚙️ Native System Hardening

### 1. FileVault Full Disk Encryption
Protects system files and user data from offline physical decryption.
*   **Action:** Go to **System Settings > Privacy & Security > FileVault** and click **Turn On**.

### 2. Verify System Integrity Protection (SIP)
SIP stops root user accounts from modifying core read-only macOS paths.
*   **Action:** Open Terminal and execute `csrutil status`. Verify that it reports `enabled`.

### 3. Immediate Lock Screen
*   **Action:** Go to **System Settings > Lock Screen**. Set **Start Screen Saver when inactive** to **5 minutes** or less, and set **Require password after screen saver begins** to **Immediately**.

### 4. Restrict Remote Sharing Ports
*   **Action:** Go to **System Settings > General > Sharing** and disable all unused protocols, particularly **Remote Login (SSH)** and **Remote Management**.

---

## 🚨 Emergency Recovery Workflow

If you suspect active compromise on your machine:

1.  **Isolate:** Sever the network connection immediately via Terminal:
    ```bash
    networksetup -setnetworkserviceenabled Wi-Fi off
    ```
2.  **Check Persistence:** Run **[KnockKnock](https://objective-see.org/tools/knockknock.html)** to audit unauthorized persistent startup apps.
3.  **Check Directories:** Inspect these directories for suspicious configurations:
    *   `/Library/LaunchAgents`
    *   `/Library/LaunchDaemons`
    *   `~/Library/LaunchAgents`
4.  **Trace Traffic:** Look at the **LuLu** rules list to identify and block the calling path of suspicious background processes.

---

## 🔗 Navigation
*   [Main Repository Index](../README.md)
*   [Windows Hardening Guide](../Windows/README_windows.md)
*   [Linux Hardening Guide](../Linux/README_linux.md)
