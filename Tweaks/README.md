🛡️ AEON-mod: Security & Improvements
A modular collection of PowerShell scripts and industry-standard tools designed to harden Windows security, strip telemetry, and unlock maximum hardware performance.
> [!WARNING]
> USE AT YOUR OWN RISK. These scripts modify system registry keys, disable background services, and alter core Windows behavior. While designed for efficiency, improper use can lead to system instability. Always create a System Restore Point before proceeding.
> 

📂 Repository Structure
The repository is organized into specific categories to allow for granular system control:
1. 🚀 Performance Boost
 * Ultimate_Performance.ps1: Unlocks the hidden "Ultimate Performance" power scheme.
 * Gaming_Priority_Tweak.ps1: Prioritizes game threads and GPU resources.
 * Optimize_NVMe_SSD.ps1: Enables high-speed native NVMe driver features.
 * Disable_Fast_Startup.ps1: Ensures a true cold boot for system stability.
2. 🛡️ Privacy & Hardening
 * Hard_Disable_Telemetry.ps1: Deep-blocks Windows tracking services and domains.
 * Harden_Defender_Max.ps1: Maxes out Cloud protection and PUA blocking in Defender.
 * Disable_VBS_Gaming.ps1: Disables Virtualization-Based Security to boost FPS.
 * Disable_Bing_Start.ps1: Removes web search results from the Start Menu.
3. 🗑️ System Debloater
 * Deep_Disable_Copilot.ps1: Entirely removes AI Copilot from the OS.
 * Remove_Recall_AI.ps1: Disables the "Recall" screen-snapshot feature.
 * Uninstall_OneDrive.ps1: Purges OneDrive and cleans up leftover files.
4. 🔍 Security Scan
Contains instructions and binaries for deep cleaning:
 * Malwarebytes: General malware and PUP removal.
 * HitmanPro: A cloud-based second opinion scanner.
 * RogueKiller: Advanced rootkit and hidden process detection.

🚀 How to Execute
Prerequisites
 * Windows 10 or 11
 * Administrator Privileges
 * Execution Policy: You may need to allow script execution. Open PowerShell as Admin and run:
   Set-ExecutionPolicy Unrestricted -Scope Process

Step-by-Step Instructions
 * Safety First: Go to the Maintenance folder and run:
   * Create_Restore_Point.ps1
 * Download: Clone the repo or download the specific .ps1 file you need.
 * Run: Right-click the script and select "Run with PowerShell".
   * Alternatively, run via terminal: .\Script_Name.ps1
 * Restart: Most tweaks (especially Registry and Performance tweaks) require a System Restart to take effect.

⚖️ License & Credits
License
This project is licensed under the MIT License - see the LICENSE file for details. You are free to use, modify, and distribute these scripts, provided credit is given.
Credits
 * Chris Titus Tech: For the baseline debloat utility logic.
 * Safeing / Portmaster: For network hardening inspiration.
 * AEON-mod Community: For testing and ricing contributions.

🛠️ Maintenance
If a tweak causes unexpected behavior, use the Revert_All_Tweaks.ps1 script (found in Maintenance) or use the Windows System Restore tool to return to the snapshot created in Step 1.
