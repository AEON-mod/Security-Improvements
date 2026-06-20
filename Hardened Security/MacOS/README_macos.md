# 🍎 macOS Hardening Guide

This guide details the custom tools, native configurations, and recovery workflows required to harden Apple macOS (covering both Intel and Apple Silicon Macs) against malware execution, persistence mechanisms, and unauthorized network exfiltration.

---

## 🛠️ The Security Stack

macOS has solid built-in protections, but they lack user visibility and application-level outbound filtering. This stack utilizes free, open-source utilities from industry-renowned developers to patch these visibility gaps.

### 1. [LuLu Outbound Firewall](https://objective-see.org/tools/lulu.html)
*   **Purpose:** The Gatekeeper (Application Network Monitor).
*   **Key Benefits:** macOS's native firewall manages only inbound traffic. LuLu monitors all *outgoing* connection attempts. When a new application or script tries to connect to the internet, LuLu prompts you to allow or block it, stopping trojans or spyware from "phoning home."

### 2. [BlockBlock](https://objective-see.org/tools/blockblock.html)
*   **Purpose:** The Guard (Persistence Prevention).
*   **Key Benefits:** Malware achieves persistence on macOS by installing Launch Agents, Launch Daemons, or login items. BlockBlock monitors these persistence locations in real-time and warns you the instant any program attempts to register a startup launch.

### 3. [OverSight](https://objective-see.org/tools/oversight.html)
*   **Purpose:** Privacy Shield (Hardware Access Monitoring).
*   **Key Benefits:** Alerts you whenever the internal webcam is activated or a program requests microphone access. It also displays which process is accessing the hardware, helping detect spyware or unauthorized recording software.

### 4. [KnockKnock](https://objective-see.org/tools/knockknock.html)
*   **Purpose:** The Specialist (Persistence Auditing).
*   **Key Benefits:** An on-demand companion tool that scans your Mac for existing persistent binaries. It displays all startup code, extensions, and helper applications, highlighting their signatures and VirusTotal status so you can clean up hidden bloatware or dormant malware.

### 5. [SilentKnight](https://eclecticlight.co/)
*   **Purpose:** The Inspector (Security Updates & Firmware Auditor).
*   **Key Benefits:** Apple silently deploys critical firmware updates and security definitions (such as XProtect and MRT databases). SilentKnight scans your Mac at-a-glance to verify that your firmware, SIP configuration, and XProtect versions are completely current.

---

## 🏗️ Deployment Strategy

For the smoothest setup, apply the tools and configurations in the following order:

| Step | Action | Objective |
| :--- | :--- | :--- |
| **01** | Verify Native Settings | Ensure FileVault and System Integrity Protection (SIP) are active. |
| **02** | Install [SilentKnight](https://eclecticlight.co/) | Run a scan to fetch and install pending security data updates. |
| **03** | Install [LuLu Firewall](https://objective-see.org/tools/lulu.html) | Establish control over outgoing network packets. |
| **04** | Install [BlockBlock](https://objective-see.org/tools/blockblock.html) & [OverSight](https://objective-see.org/tools/oversight.html) | Secure persistence vectors and webcam access. |
| **05** | Audit with [KnockKnock](https://objective-see.org/tools/knockknock.html) | Run a scan of pre-existing persistent applications to clean the baseline. |

---

## ⚙️ Native OS Hardening Instructions

### 1. Enforce FileVault (Full Disk Encryption)
Without FileVault, anyone with physical access to your Mac can read all files.
*   **Setup:** Open **System Settings > Privacy & Security > FileVault**. Click **Turn On**.
*   **Key Choice:** Choose to store your recovery key in iCloud (convenient) or write down a local recovery key (highly secure; do not lose it).

### 2. Verify System Integrity Protection (SIP)
SIP prevents even the root user from modifying critical macOS operating system files.
*   **Check:** Open Terminal and execute:
    ```bash
    csrutil status
    ```
*   **Result:** It should return: `System Integrity Protection status: enabled.`
*   *Note: If it is disabled, reboot into Recovery Mode, open Terminal, and run `csrutil enable`.*

### 3. Configure Aggressive Lock Settings
Locking your computer is only effective if the screen lock takes effect immediately.
*   **Setup:** Go to **System Settings > Lock Screen**.
*   **Tweak:** Set **Start Screen Saver when inactive** to a low value (e.g., 5 minutes) and set **Require password after screen saver begins or display is turned off** to **Immediately**.

### 4. Restrict Sharing Services
Disable remote connection interfaces that you do not actively use.
*   **Setup:** Go to **System Settings > General > Sharing**.
*   **Tweak:** Toggle **Off** everything that is not absolutely required, specifically: **Remote Login** (SSH), **Remote Management**, and **File Sharing**.

---

## 🚨 Emergency Workflow (If Infected)

If your Mac is showing indicators of compromise (unauthorized camera activation, browser page redirects, or persistence warning triggers):

> [!IMPORTANT]
> **Step 0: Cut Network Access.**
> Turn off Wi-Fi immediately. You can quickly disable the Wi-Fi card via the command line:
> ```bash
> networksetup -setnetworkserviceenabled Wi-Fi off
> ```

1.  **Run KnoxKnock Audit:** Launch **[KnockKnock](https://objective-see.org/tools/knockknock.html)** and click **Scan**. Check all items flagged as "unauthenticated" or having a low VirusTotal reputation score.
2.  **Audit Launch Daemons and Agents:** Open Finder, press `Cmd + Shift + G` to search, and inspect the files in these directories:
    *   `/Library/LaunchAgents`
    *   `/Library/LaunchDaemons`
    *   `~/Library/LaunchAgents`
    *   *Delete any unknown `.plist` files and the corresponding binaries they reference.*
3.  **Inspect Connections:** Review **LuLu**’s rules dashboard to see if any background process has open outbound connections. Block and locate the path of any suspicious application.
4.  **Second Opinion Scan:** Run a scan using the free version of Malwarebytes for Mac or audit system logs using:
    ```bash
    log show --predicate 'eventMessage contains "malware" or eventMessage contains "exploit"' --last 24h
    ```

---

## 🔗 Related Resources
*   [Main Index](README.md)
*   [Windows Hardening Guide](README_windows.md)
*   [Linux Hardening Guide](README_linux.md)
