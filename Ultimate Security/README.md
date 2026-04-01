🛡️ Windows Security Hardening Toolkit (2026)
A professional-grade guide to securing Windows environments using free, high-performance tools and native hardening techniques. This toolkit focuses on zero-bloat and defense-in-depth.

🛠️ Recommended Software Stack
These tools provide the highest security-to-performance ratio. Use the links below for the official, direct downloads.
| Tool | Download Link | Purpose |
|---|---|---|
| Bitdefender Free | Download | Lightweight, silent real-time antivirus protection. |
| Safing Portmaster | Download | Kernel-level firewall to monitor and block telemetry. |
| Emsisoft Emergency Kit | Download | Portable dual-engine scanner for deep malware removal. |
| O&O ShutUp10++ | Download | Disables Windows tracking and "spyware" features. |
| MB Anti-Exploit | Download | Shields vulnerable apps (Chrome, PDF) from zero-days. |

⚙️ OS Hardening Instructions (Native)
1. Configure a "Standard User" Account
Running as an Administrator is the #1 way to get infected.
 * Step: Go to Settings > Accounts > Other Users.
 * Action: Click Add account and create a user without a Microsoft account (if preferred).
 * Usage: Use this account for 99% of your daily work. When you need to install something, Windows will ask for your Admin password—this is your "firewall" against unauthorized changes.
2. Enable Aggressive Defender Mode
Windows Defender is powerful but passive. You can force it into high-security mode using PowerShell (Admin). Copy and paste these lines:
# Enable 'Block at First Sight' (Advanced Cloud Protection)
Set-MpPreference -MAPSReporting Advanced
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# Enable PUA Blocking (Stops junkware/bundled installers)
Set-MpPreference -PUAProtection Enabled

🌐 Browser Security
The browser is your primary entry point for threats. Install these essentials:
 * uBlock Origin: Set to "Medium Mode" to block all 3rd-party scripts by default.
 * Bitwarden: A secure, open-source vault for your passwords.
 * FastForward: Automatically bypasses trackers and malicious link shorteners.

🚨 Emergency Workflow (If Infected)
If your system is behaving suspiciously, follow these steps in this exact order:
> [!IMPORTANT]
> Step 0: Disconnect the Internet. Unplug your Ethernet cable or turn off Wi-Fi immediately.
> 
 * Terminate Threats: Run RKill (Direct Download). It stops malicious processes from hiding or blocking security tools.
 * Dual-Engine Scan: Run Emsisoft Emergency Kit (from a USB if possible) for a deep scan.
 * Clean Adware: Run AdwCleaner (Direct Download) to remove browser hijackers and "search bar" malware.
 * Restore: Reconnect, update your AV definitions, and rotate your passwords.

📝 License
This project is licensed under the MIT License - see the LICENSE file for details.

🤝 Contributing
Have a better tool or a specific registry tweak? Open an issue or submit a PR to help keep this guide up to date!
