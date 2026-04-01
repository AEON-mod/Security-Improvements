🛡️ AEON-mod: Security & Improvements
A modular collection of PowerShell scripts and industry-standard tools designed to harden Windows security, strip telemetry, and unlock maximum hardware performance.
> [!WARNING]
> USE AT YOUR OWN RISK. These scripts modify system registry keys, disable background services, and alter core Windows behavior. While designed for efficiency, improper use can lead to system instability. Always create a System Restore Point before proceeding.
> 
📂 Repository Structure
The repository is organized into specific categories for granular system control:
1. 🚀 Performance-Boost
Focus: Speed, latency, and hardware efficiency.
 * ChrisTitusApp.ps1: A wrapper for the popular Windows Utility.
 * Disable_Fast_Startup.ps1: Ensures a true cold boot for system stability.
 * Flush_Network_DNS.ps1: Clears network cache to resolve connectivity lag.
 * Gaming_Latancy_HPET.ps1: Disables HPET to reduce micro-stutter.
 * Gaming_Priority_Tweak.ps1: Prioritizes game threads and GPU resources.
 * Optimize_NVMe_SSD.ps1: Enables high-speed native NVMe driver features.
 * Ultimate_Performance.ps1: Unlocks the hidden "Ultimate Performance" power scheme.
2. 🛡️ Privacy-and-Hardening
Focus: Security hardening and blocking tracking.
 * Disable_VBS_Gaming.ps1: Disables Virtualization-Based Security for better FPS.
 * Disable_Windows_Search_Indexing.ps1: Reduces background disk activity.
 * Enable_Tamper_Protection.ps1: Prevents unauthorized changes to security settings.
 * Hard_Disable_telemetry.ps1: Deep-blocks Windows tracking services.
 * Harden_Defender_Max.ps1: Maxes out Cloud protection and PUA blocking.
 * Remove Windows AI.ps1: Disables integrated AI data analysis.
3. 🗑️ System-Debloater
Focus: Removing Windows junk, AI, and bloatware.
 * Deep_Disable_Copilot.ps1: Entirely removes AI Copilot from the OS.
 * Disable_LockScreen_Ads.ps1: Cleans up the lock screen UI.
 * Remove Ask Copilot (NX).ps1: Removes Copilot integration from the taskbar.
 * Remove_Recall_AI.ps1: Disables the AI screen-snapshot feature.
 * Uninstall OneDrive.ps1: Purges OneDrive and its leftover files.
4. 🔍 Security Scan
Contains instructions and binaries for deep system cleaning:
 * Malwarebytes-5-5-3-140.exe: General malware and PUP removal.
 * RougueKiller Download instruction.txt: Instructions for advanced rootkit detection.
 * The Ultimate option (HitmanPro_x64.exe): Cloud-based second opinion scanner.

 [!IMPORTANT] 
🚀 How to Execute 
Prerequisites
 * Windows 10 or 11
 * Administrator Privileges
 * Execution Policy: Open PowerShell as Admin and run this command to allow scripts:
 * 
    [!NOTE]
   Set-ExecutionPolicy Unrestricted -Scope Process

Execution Steps
 * Safety First: Go to the Maintenance folder and run Create Restore Point.ps1.
 * Run: Right-click the desired .ps1 script and select "Run with PowerShell".
 * Restart: A System Restart is required for most Performance and Registry tweaks to take effect.

⚖️ License & Credits
License
This project is licensed under the MIT License. You are free to use, modify, and distribute these scripts, provided credit is given.
Maintenance
If a tweak causes unexpected behavior, use Revert_All_Tweaks.ps1 (found in Maintenance) or use Windows System Restore to return to the snapshot created in Step 1.
