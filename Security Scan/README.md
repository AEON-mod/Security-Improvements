🔍 Security Scan: Deep Cleaning & Removal
This directory contains high-tier removal tools for malware, adware, and stubborn infections. These should be used after running RKill to ensure the most effective cleanup.

🛡️ Tool Overview
| Tool | Focus |
|---|---|
| HitmanPro_x64.exe | The Ultimate Option: A cloud-based "second opinion" scanner that uses multiple antivirus engines (Bitdefender/Kaspersky) to find and remove deeply embedded threats. |
| Malwarebytes | The industry standard for finding and removing modern malware, spyware, and potentially unwanted programs (PUPs). |
| RogueKiller | An advanced anti-malware scanner capable of finding rootkits and malicious processes that hide from the Windows API. |

🚀 Execution Instructions
1. Malwarebytes Setup
 * Run the installer (malwarebytes-5-5-3-140.exe).
 * Once installed, click Scan. It is recommended to let it quarantine everything it finds.
2. HitmanPro (The Ultimate Option)
 * Run the executable.
 * You can choose "Just a one-time scan" if you don't want to install it.
 * It will provide a detailed report of trackers, cookies, and malware.
3. RogueKiller
 * Follow the instructions in RougueKiller Download instruction.txt to get the latest portable version.
 * Run a Standard Scan. It is particularly good at finding registry-level infections.

💡 Recommended Cleaning Workflow
For a 100% clean system, follow this order:
 * Stop: Run RKill (from the Background Killer folder).
 * Analyze: Run RogueKiller to catch rootkits.
 * Clean: Run Malwarebytes for general malware.
 * Confirm: Run HitmanPro last to ensure nothing was missed.

⚠️ Important Note
Most of these tools will require an Internet Connection during the scan to check their cloud databases for the latest virus signatures.
