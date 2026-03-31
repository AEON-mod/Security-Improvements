🛠️ System Tweaks & Debloating
A collection of PowerShell scripts to streamline Windows, remove AI-integrated bloatware, and optimize system performance.

📄 Script Inventory
| File | Description |
|---|---|
| Create Restore Point.ps1 | Run this first! Creates a system snapshot so you can revert changes if needed. |
| Remove Windows AI.ps1 | Disables and removes deep-integrated AI features from the OS. |
| Remove Ask Copilot (NX).ps1 | Removes the "Ask Copilot" prompts and UI elements. |
| Uninstall OneDrive.ps1 | Completely removes OneDrive and its background sync processes. |
| ChrisTitusApp.ps1 | A shortcut/wrapper to launch the popular Windows Utility for advanced debloating. |
| CFEnhancer.txt | Instructions/Configuration for Cloudflare or Network enhancement. |

🚀 How to Execute
Since Windows restricts script execution by default, follow these steps:
1. Open PowerShell as Administrator
Right-click the Start button and select Terminal (Admin) or PowerShell (Admin).
2. Enable Script Execution
To allow these scripts to run, enter the following command:
Set-ExecutionPolicy RemoteSigned -Scope Process
(This only enables it for the current session for your safety.)
3. Run the Script
Navigate to this folder and run the desired script by typing its name. For example, to create a restore point:
.\'Create Restore Point.ps1'

⚠️ Safety First
 * Always run Create Restore Point.ps1 before applying the AI or OneDrive removal scripts.
 * Some scripts may require a System Restart to fully apply the changes (especially the AI and OneDrive removals).

