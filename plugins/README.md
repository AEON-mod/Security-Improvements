Windows Optimization & Cleanup Scripts
A collection of PowerShell scripts to optimize, clean, and customize Windows by removing bloatware, enhancing performance, and creating safety checkpoints.

📁 Scripts Included
Script Name	Purpose
CFEnhancer.M	Enhances Command Prompt/PowerShell functionality with custom aliases and configurations
ChrisTitusApp.ps1	Installs popular applications using the Chris Titus Tech Windows Utility
Create Restore Point.psl	Creates a Windows System Restore point before making changes (safety backup)
Remove Ask Copilot (NX).ps1	Removes Windows Copilot AI assistant from the system
Remove Windows Al.psl	Removes Windows Analytics/telemetry components
Uninstall OneDrive.ps1	Completely uninstall OneDrive cloud storage from Windows
Note: Create Restore Point.psl and Remove Windows Al.psl should be named with .ps1 extension (not .psl) for PowerShell to recognize them.

⚠️ Prerequisites
Windows 10/11 (64-bit)

Administrator privileges required for most scripts

PowerShell 5.1+ (comes pre-installed on Windows)

Internet connection (for ChrisTitusApp.ps1 and script downloads)

🚀 How to Run
Option 1: Run Individual Scripts
Right-click the .ps1 script file

Select "Run with PowerShell"

If prompted by UAC, click Yes to allow admin access

Option 2: Run from Admin PowerShell
Press Win + X → Select Windows PowerShell (Admin) or Terminal (Admin)

Navigate to the script folder:

powershell
cd "C:\Path\To\Your\Scripts"
Run a script:

powershell
.\Create Restore Point.ps1
.\Remove Ask Copilot (NX).ps1
.\Uninstall OneDrive.ps1
If You Get Execution Policy Error
Run this command in the admin PowerShell window first:

powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
📋 Recommended Order of Execution
For safety and best results, run scripts in this order:

Create Restore Point.psl ← Always run this first!

Remove Ask Copilot (NX).ps1

Remove Windows Al.psl

Uninstall OneDrive.ps1

ChrisTitusApp.ps1 (to install apps you actually want)

CFEnhancer.M (final desktop customization)

🔒 Safety Notes
✅ Create a restore point first using Create Restore Point.psl before making any changes

⚠️ OneDrive removal will delete your desktop/taskbar briefly (Explorer restarts)

⚠️ Copilot removal disables Windows AI assistant completely

⚠️ Telemetry removal may affect Windows update diagnostics

🔄 You can restore from the restore point if something goes wrong

🛠️ Troubleshooting
Issue	Solution
"Script is not digitally signed"	Run Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
"Access denied"	Right-click → "Run as administrator"
Script not found	Ensure you're in the correct directory (cd command)
Windows File Explorer freezes	Wait 30 seconds; it restarts automatically after OneDrive removal
📝 Script Details
Create Restore Point
Creates a system restore point so you can roll back changes if needed. Run this before any other script.

Remove Ask Copilot
Removes the Copilot AI button from the taskbar and disables the service completely.

Remove Windows Analytics
Disables Windows telemetry and diagnostic data collection for better privacy.

Uninstall OneDrive
Completely removes OneDrive from your system (requires restarting Explorer).

ChrisTitusApp
Interactive app installer that lets you choose from popular software (Chrome, VS Code, Discord, etc.).

CFEnhancer
Enhances command-line experience with useful aliases and shortcuts.

⚖️ Disclaimer
Use these scripts at your own risk. Always create a restore point before making system changes. The author is not responsible for any data loss or system issues caused by running these scripts.

🤝 Contributing
Feel free to fork this repository, suggest improvements, or submit pull requests!

Made for Windows users who want control over their system 💻
