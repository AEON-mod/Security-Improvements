# 🛡️ Linux Post-Hardening User Guide

> ⚠️ **CRITICAL DISCLAIMER**
> **Please fully research how each component works before installing it or running the script.** Hardening your system introduces strict access controls and limits permissions. Blindly applying these settings without understanding them will break apps, lock you out of devices, or generate overwhelming alerts. **Proceed with knowledge and caution!**

Congratulations, you have deployed enterprise-grade security on your Linux machine. However, tools are useless if you don't know how to wield them. Here is your survival guide to operating your hardened environment.

---

## 🧭 Day-to-Day Operation: Living with Security

### 1. OpenSnitch (The Network Watchdog)
**What it does:** OpenSnitch intercepts every outbound internet connection and asks for your permission before letting it through.
**How to use it:**
- **The Pop-ups:** You will get *a lot* of pop-ups initially. When Firefox asks to connect to port 443, allow it. If a weird background process you don't recognize tries to phone home, block it.
- **Rule of Thumb:** Allow connections temporarily (e.g., "for 5 minutes") if you aren't sure. If nothing breaks, great. If your app stops working, you know you need to allow it permanently.

### 2. AIDE (Advanced Intrusion Detection Environment)
**What it does:** AIDE takes a snapshot of all system files. If malware modifies a system binary (like replacing `ls` with a malicious version), AIDE catches it.
**How to use it (CRITICAL):**
- **The Catch:** Every time *you* update your system (`apt upgrade`, `pacman -Syu`), your system files change legitimately! AIDE will scream that files were modified.
- **Routine Maintenance:** After performing a system update, you must review AIDE's report. If the changes were just your updates, you need to promote the new database to tell AIDE "these changes are safe":
  ```bash
  sudo aide --update
  sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
  ```
- *If you don't do this, AIDE is completely useless because it will constantly cry wolf.*

### 3. USBGuard (The Hardware Bouncer)
**What it does:** It blocks new USB devices from being recognized. This prevents "BadUSB" attacks where a malicious flash drive acts like a keyboard and types destructive commands.
**How to use it:**
- **Plugging in a new drive:** If you plug in a new mouse or USB stick and it doesn't work, USBGuard blocked it!
- **Authorizing:** Open your terminal and run `usbguard list-devices`. Find your blocked device (it will say `block`), note its ID, and run `sudo usbguard allow-device <ID>`.

### 4. Firejail & Flatseal (The Sandboxes)
**What they do:** They put your apps in isolated boxes. If your browser gets hacked, the hacker can only see inside the box, not your personal documents.
**How to use them:**
- **The Symptom:** If an app suddenly can't save a file to your secondary hard drive or can't open a link in your browser, it's the sandbox doing its job too well.
- **The Fix (Flatpak):** Open the **Flatseal** app, find the struggling app, and toggle the permission it needs (e.g., "Filesystem: All system files").
- **The Fix (Firejail):** Run the app from terminal without Firejail (`firejail --noprofile <appname>`) to see if it fixes the issue, or tweak its profile in `/etc/firejail/`.

**Remember:** A secure system asks questions. Be patient, read the prompts, and audit your logs!
