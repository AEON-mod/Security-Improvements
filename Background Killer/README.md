⚔️ Background Killer: Process Termination
This folder contains the RKill utility. RKill is a critical first-step tool designed to terminate known malicious processes, allowing your main antivirus or security scanner to run effectively.

🛠️ Tool: RKill.exe
RKill was developed by the team at BleepingComputer. It searches for active malware processes that may be protecting themselves from being detected or removed by standard security software.
What RKill does:
 * Stops Malicious Processes: It kills the "shields" that malware uses to stay active.
 * Fixes Registry Hijacks: It repairs basic registry associations (like .exe, .com, and .bat files) that malware might have broken.
 * Doesn't Delete Files: It only stops processes. It is not a removal tool; you must run a scan (like RogueKiller or Malwarebytes) immediately after.

🚀 How to Execute
 * Download/Locate: Ensure rkill.exe is in your current directory.
 * Run as Administrator: Right-click rkill.exe and select Run as Administrator.
 * Wait for Completion: A black console window will appear. Do not interact with your computer until it finishes.
 * Review the Log: Once finished, it will generate a log file (RKill.txt) on your desktop showing what it stopped.
 * Important: Do NOT reboot your computer after running RKill. If you reboot, the malware might start back up. Run your security scans immediately after RKill finishes.

⚠️ Important Note
If your browser or Windows Defender tries to block the download or execution, this is normal "false positive" behavior because RKill interacts with system processes. It is a well-known, safe industry tool.
