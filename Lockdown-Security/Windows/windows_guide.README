# 🛡️ Windows Post-Hardening User Guide

> ⚠️ **CRITICAL DISCLAIMER**
> **Please fully research how each component works before installing it or running the script.** Hardening your system introduces restrictions. You are taking off the "training wheels". If you blindly install these tools without understanding them, you will likely break apps or lose access to things you need. **Proceed with knowledge and caution!**

Welcome to your fortified Windows system! The installation was just step one. Security is a lifestyle, and this guide will teach you how to live in your new, secure environment without pulling your hair out.

---

## 🧭 Day-to-Day Operation: Living with Security

### 1. Safing Portmaster (The Gatekeeper)
**What it does:** Portmaster is your application firewall. It watches every single app trying to connect to the internet and blocks trackers and ads system-wide.
**How to use it:**
- **The Pop-ups:** When a new app tries to connect, you might see a notification. You are in control.
- **Troubleshooting:** If a game or app suddenly can't connect to the internet, open the Portmaster dashboard. Look at the network history. You will see what was blocked and can click "Allow" if you trust the app.

### 2. O&O ShutUp10++ (The Privacy Shield)
**What it does:** It forcefully turns off Windows 10/11 telemetry, Cortana, and background tracking.
**How to use it:**
- **Maintenance:** Microsoft *loves* to silently turn telemetry back on after major Windows Updates. 
- **Routine:** Run O&O ShutUp10++ once a month (or after a big Windows update). It will highlight settings that reverted to "factory defaults." Just click "Apply only recommended settings" to lock it back down.

### 3. Bitdefender Antivirus Free (The Bodyguard)
**What it does:** It replaces Windows Defender with a lighter, more aggressive scanning engine.
**How to use it:**
- **Passive Protection:** It runs silently. 
- **False Positives:** If Bitdefender blocks a safe file you downloaded, open the app, go to "Protection" -> "Quarantine", and restore the file (only if you are 100% sure it is safe!).

### 4. Emsisoft Emergency Kit / Malwarebytes (The SWAT Team)
**What it does:** These are your on-demand scanners. They don't run constantly (which saves battery), but they are incredibly powerful when manually launched.
**How to use it:**
- **Routine Checkup:** Once a month, or if your PC starts acting strange (slow, weird popups), open Emsisoft or Malwarebytes and run a "Full Scan". Think of it as going to the dentist for a deep clean.

---

## 🔧 Managing Windows Features

**Controlled Folder Access (Ransomware Shield)**
Our script turns on Windows' built-in Ransomware protection. 
- **What you'll notice:** If you install a new game and it tries to save a file in your "Documents" folder, it might get blocked!
- **The Fix:** Go to *Windows Security > Virus & threat protection > Ransomware protection > Allow an app through Controlled folder access* and add your game/app to the whitelist.

**Remember:** Security tools are not set-and-forget. You are the admin now!
