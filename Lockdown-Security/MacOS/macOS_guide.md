# 🛡️ macOS Post-Hardening User Guide

> ⚠️ **CRITICAL DISCLAIMER**
> **Please fully research how each component works before installing it or running the script.** macOS is already quite secure out of the box. Adding these advanced tools will result in frequent prompts and strict permissions. If you blindly install them without understanding their purpose, you will find your system frustrating to use. **Proceed with knowledge and caution!**

Welcome to your fortified Mac. You’ve installed Objective-See's world-class security suite. These tools don't just protect you—they make the invisible background activity of your Mac visible. Here is how to operate your new setup.

---

## 🧭 Day-to-Day Operation: Living with Security

### 1. LuLu (The Outbound Firewall)
**What it does:** By default, macOS only blocks incoming connections. LuLu blocks *outbound* connections. It stops malware from phoning home to its creator.
**How to use it:**
- **The Pop-ups:** When an app tries to connect to the internet for the first time, LuLu will show an alert. 
- **The Decision:** If you just opened Spotify and it asks to connect, click **Allow**. If you are just reading an offline document and a random updater script asks to connect to a weird IP address, click **Block**. 
- **Mistakes:** If you accidentally block something and an app stops working, click the LuLu icon in your menu bar, open "Rules", and change the block to an allow.

### 2. BlockBlock (The Persistence Monitor)
**What it does:** Malware survives reboots by installing itself as a "Launch Agent" or "Daemon" (things that start automatically when you turn on your Mac). BlockBlock alerts you the exact millisecond something tries to do this.
**How to use it:**
- **Normal use:** When you install a new app (like Google Chrome or a VPN), BlockBlock will pop up saying "An app is trying to install a persistent item." Since you are installing it, click **Allow**.
- **Danger:** If you are just browsing the web and suddenly get a BlockBlock alert out of nowhere, you might be under attack. Click **Block** immediately!

### 3. OverSight (The Hardware Watchdog)
**What it does:** It monitors your webcam and microphone. 
**How to use it:**
- **The Alerts:** When you open Zoom or FaceTime, OverSight will notify you that your mic/camera is active. This is normal.
- **The Catch:** If you are sitting alone reading a PDF and get a notification that a background process activated your microphone, someone is spying on you. You can click **Block** right from the notification!

### 4. KnockKnock & SilentKnight (The Auditors)
**What they do:** They are your manual inspection tools.
**How to use them:**
- **KnockKnock:** Run this app once a month. It lists every single thing that starts with your Mac and checks them against VirusTotal (a database of known malware). If something shows up red, investigate it!
- **SilentKnight:** Run this occasionally to check if Apple's hidden background security updates (XProtect) are up-to-date. If it flags something as outdated, it usually provides a button to force the update.

**Remember:** The goal of these tools is visibility. When they prompt you, take a second to read what is asking for permission. You are the final line of defense!
