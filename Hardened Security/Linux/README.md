# 🐧 Linux Hardening Guide

This guide details the configurations, tools, and practices required to harden a Linux desktop environment (Debian/Ubuntu, Fedora, or Arch Linux) against unauthorized local access, network exfiltration, and malicious software.

---

## 🛠️ The Security Stack

Unlike Windows, Linux security centers on kernel configuration, network transparency, and sandboxing. This stack leverages robust, open-source utilities to secure your system.

### 1. [OpenSnitch](https://github.com/evilsocket/opensnitch)
*   **Purpose:** The Gatekeeper (Application-Level Outbound Firewall).
*   **Key Benefits:** Inspired by Little Snitch on macOS, OpenSnitch intercepts and logs every outgoing connection your applications attempt. It presents interactive prompts allowing you to allow or block connections on a per-process, per-domain, or per-port level.

### 2. [Flatseal](https://github.com/tchx84/Flatseal)
*   **Purpose:** The Sandbox Controller (Least Privilege Enforcement).
*   **Key Benefits:** Flatpaks are sandboxed, but defaults can be permissive. Flatseal provides a graphical interface to audit and revoke permissions (such as network access, X11 sockets, bluetooth, or home folder read/write access) from individual flatpak applications.

### 3. [Lynis](https://cisofy.com/lynis/)
*   **Purpose:** The Auditor (System Health & Security Audit).
*   **Key Benefits:** A lightweight, command-line system scanner. It performs a comprehensive audit of your kernel configurations, authentication settings, cryptographic keys, systemd services, and file permissions, returning an actionable hardening index and security tips.

### 4. [USBGuard](https://usbguard.github.io/)
*   **Purpose:** Hardware Shield (BadUSB Protection).
*   **Key Benefits:** Implements an authorization whitelist for USB devices. It intercepts new USB connections and denies authorization to unauthorized keyboard-emulators (BadUSB), mouse devices, or storage drives.

### 5. [ClamAV](https://www.clamav.net/) & [rkhunter](https://rkhunter.sourceforge.net/)
*   **Purpose:** The Specialists (On-Demand Rootkit & Malware Scanning).
*   **Key Benefits:** ClamAV is an open-source antivirus engine for detecting trojans and malware. Rootkit Hunter (`rkhunter`) audits files and directories against a database of known rootkit signatures, checking for local exploits and hidden directories.

---

## 🏗️ Deployment Strategy

For the smoothest setup, apply the tools and configurations in the following order:

| Step | Action | Objective |
| :--- | :--- | :--- |
| **01** | Audit with [Lynis](https://cisofy.com/lynis/) | Scan your default installation to establish a baseline security score. |
| **02** | Install [OpenSnitch](https://github.com/evilsocket/opensnitch) | Immediately inspect and control outgoing application connections. |
| **03** | Install [Flatseal](https://github.com/tchx84/Flatseal) | Restrict permissions on sandboxed flatpaks (e.g., restrict browser directory access). |
| **04** | Configure [USBGuard](https://usbguard.github.io/) | Lock down USB ports against physical device injection. |
| **05** | Harden `/etc/sysctl.d/` | Modify kernel flags to prevent network exploitation and spoofing. |

---

## ⚙️ Native OS Hardening Instructions

### 1. Enable and Configure the Default Firewall
Most Linux distributions install a firewall backend but leave it inactive. Enable UFW (Debian/Ubuntu) or Firewalld (Fedora).

**For UFW (Uncomplicated Firewall):**
```bash
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

**For Firewalld:**
```bash
sudo dnf install firewalld
sudo systemctl enable --now firewalld
sudo firewall-cmd --set-default-zone=drop
```

### 2. Kernel Hardening (sysctl Configuration)
You can lock down network parameters and kernel features by adding security parameters to `/etc/sysctl.d/`.

Create a new file `/etc/sysctl.d/99-security.conf` and paste these lines:

```ini
# Ignore ICMP echo requests (disable ping response to hide from scanner sweeps)
net.ipv4.icmp_echo_ignore_all = 1

# Disable IP forwarding (prevents your system from being used as a router)
net.ipv4.ip_forward = 0

# Enable TCP SYN Cookie protection (mitigates SYN flood denial of service attacks)
net.ipv4.tcp_syncookies = 1

# Enable Source Route Verification (prevents IP spoofing)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Disable core dumps (prevents sensitive credentials in memory from being written to disk)
fs.suid_dumpable = 0

# Harden the BPF JIT compiler against exploit compilation
net.core.bpf_jit_harden = 2
```
*Run `sudo sysctl --system` to apply changes immediately.*

### 3. Restrict `sudo` Configuration
Lock down permissions and restrict session persistence.
*   **Action:** Run `sudo visudo` to safely edit the sudoers file.
*   **Tweak:** Add or modify the default timeout to require password re-entry quickly:
    ```text
    Defaults env_reset, timestamp_timeout=5
    ```
    *This resets the sudo authorization cache after 5 minutes of inactivity.*

---

## 🚨 Emergency Workflow (If Infected)

If you suspect a rootkit, local privilege escalation, or malware:

> [!IMPORTANT]
> **Step 0: Sever Network Connectivity.**
> Bring down your network adapters immediately via CLI:
> ```bash
> # List interfaces
> ip link show
> # Disable active interface (e.g., wlan0 or eth0)
> sudo ip link set dev <interface_name> down
> ```

1.  **Examine Active Connections:**
    ```bash
    sudo ss -tupn
    ```
    *Review active TCP/UDP ports and their matching process IDs (PIDs).*
2.  **Audit System Integrity:** Run Rootkit Hunter to detect local modifications:
    ```bash
    sudo rkhunter --update
    sudo rkhunter --check --sk
    ```
3.  **Perform Malware Scan:** Scan critical paths (`/usr/bin`, `/bin`, `/tmp`, `/dev/shm`) with ClamAV:
    ```bash
    sudo freshclam
    sudo clamscan -r -i --bell /tmp /usr/bin /usr/sbin /home
    ```
4.  **Analyze System Logs:** Inspect authentication failures and systemd daemon alerts:
    ```bash
    sudo journalctl -xe -p err
    ```

---

## 🔗 Related Resources
*   [Main Index](README.md)
*   [Windows Hardening Guide](README_windows.md)
*   [macOS Hardening Guide](README_macos.md)
