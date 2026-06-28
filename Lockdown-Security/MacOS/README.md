# 🍎 Maximum macOS Hardening Guide (v2.0)

A curated, high-efficiency security configuration guide designed to secure Apple macOS (Intel and Apple Silicon) to the absolute maximum level.

---

## 🚀 One-Line Installation

Install the recommended security suite via Homebrew in the Terminal:

```bash
brew install --cask lulu blockblock oversight knockknock silentknight
```

> *After installation, open **System Settings > Privacy & Security** to manually approve system extensions for each tool.*

---

## 🛠️ The Security Stack

*   **[LuLu](https://objective-see.org/tools/lulu.html)** — Open-source outbound firewall intercepting and prompting to block network connections on a per-app basis.
*   **[BlockBlock](https://objective-see.org/tools/blockblock.html)** — Real-time persistence monitor alerting you whenever code attempts to install as Launch Agents, Daemons, or login items.
*   **[OverSight](https://objective-see.org/tools/oversight.html)** — Webcam and microphone access monitor logging which active process triggered hardware peripherals.
*   **[KnockKnock](https://objective-see.org/tools/knockknock.html)** — On-demand scanner listing existing persistent components to surface hidden malware or bloatware.
*   **[SilentKnight](https://eclecticlight.co/)** — Update auditor inspecting macOS background databases (XProtect, MRT), SIP, and firmware currency.

---

## 🏗️ Deployment Checklist

1.  **Run SilentKnight** to verify all Apple security updates and data files are installed.
2.  **Enable LuLu Firewall** to control outbound background network requests.
3.  **Install BlockBlock & OverSight** to shield startup agents and peripheral hardware.
4.  **Audit pre-existing apps with KnockKnock** to ensure a clean baseline.
5.  **Apply native hardening** — manually (see below) or via the automated script.

---

## ⚙️ Hardening Guide

### Manual Configuration

#### 1. FileVault Full Disk Encryption
Protects all data at rest from offline physical extraction.
*   **Action:** Go to **System Settings > Privacy & Security > FileVault** and click **Turn On**.

#### 2. Verify System Integrity Protection (SIP)
SIP prevents even root from modifying core macOS paths.
```bash
csrutil status
# Expected output: "System Integrity Protection status: enabled."
```
> *If disabled, reboot into Recovery Mode, open Terminal, and run `csrutil enable`.*

#### 3. Enable Native Firewall + Stealth Mode
The macOS firewall is disabled by default. Enable it with strict settings:
```bash
# Enable firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Enable stealth mode (ignores unsolicited ICMP/ping/connection attempts)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Block all incoming connections (except essential services)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on
```

#### 4. Immediate Screen Lock
```bash
# Require password immediately after sleep/screensaver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set screensaver timeout to 5 minutes (300 seconds)
defaults -currentHost write com.apple.screensaver idleTime -int 300
```

#### 5. Disable Unused Sharing Services
Go to **System Settings > General > Sharing** and disable all unused protocols, or via CLI:
```bash
# Disable Remote Login (SSH)
sudo systemsetup -setremotelogin off

# Disable Remote Apple Events
sudo systemsetup -setremoteappleevents off
```

#### 6. Disable Bluetooth Discoverability
```bash
sudo defaults write /Library/Preferences/com.apple.Bluetooth DiscoverableState -int 0
```

#### 7. Enable Automatic Security Updates
```bash
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
```

#### 8. Harden Safari Privacy
```bash
# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false

# Enable fraud/phishing warnings
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Block pop-ups
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false

# Prevent cross-site tracking
defaults write com.apple.Safari BlockStoragePolicy -int 2
```

#### 9. Disable Ad Tracking & Analytics
```bash
# Limit ad tracking
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false

# Disable analytics sharing
defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit -bool false
```

---

### Automated Hardening Script

For a single-step configuration of all hardening measures above, run the included `harden_macos.sh` script:

```bash
chmod +x harden_macos.sh && sudo ./harden_macos.sh
```

The script automates:
- Native firewall activation with stealth mode
- FileVault status verification (with prompt to enable)
- SIP verification
- Sharing service teardown (Remote Login, Remote Apple Events)
- Privacy hardening (ad tracking, analytics, Siri data)
- Safari security configuration (AutoFill, fraud warnings, cross-site tracking)
- Immediate screen lock enforcement
- Bluetooth discoverability disabling
- Automatic security update enforcement

> [!WARNING]
> Review the script source before running. Some settings may affect AirDrop, Remote Login, or Bluetooth device pairing workflows. The script prompts for confirmation before applying changes.

---

## 🏰 Structural Upgrades (The "Fort Knox" Tier)

For absolute maximum physical and boot-level protection:

1.  **Firmware Password (Intel)** / **Startup Security Utility (Apple Silicon):** Prevent booting from external media or Recovery Mode without authorization.
2.  **Disable Thunderbolt DMA:** Prevent Direct Memory Access attacks via external Thunderbolt/USB-C devices.
3.  **MDM Enrollment Lock:** On managed devices, bind to an MDM profile to prevent unauthorized OS wipes.
4.  **Disable Automatic Login:** Go to **System Settings > Users & Groups > Login Options** and set **Automatic login** to **Off**.

---

## 🚨 Emergency Recovery Workflow

If your Mac shows indicators of compromise:

1.  **Isolate:** Sever the network immediately:
    ```bash
    networksetup -setnetworkserviceenabled Wi-Fi off
    ```
2.  **Audit Persistence:** Run **[KnockKnock](https://objective-see.org/tools/knockknock.html)** and flag unauthenticated or low-reputation items.
3.  **Inspect Launch Directories:** Check for rogue `.plist` files:
    *   `/Library/LaunchAgents`
    *   `/Library/LaunchDaemons`
    *   `~/Library/LaunchAgents`
4.  **Trace Traffic:** Review **LuLu**'s rules dashboard to identify suspicious outbound connections.
5.  **System Log Audit:**
    ```bash
    log show --predicate 'eventMessage contains "malware" OR eventMessage contains "exploit"' --last 24h
    ```

---

## 🔗 Navigation
*   [Main Repository Index](../README.md)
*   [Windows Hardening Guide](../Windows/README.md)
*   [Linux Hardening Guide](../Linux/README.md)
