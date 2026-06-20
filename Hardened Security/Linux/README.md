# 🐧 Linux Hardening Guide

A curated, high-efficiency security configuration guide designed to secure desktop Linux distributions.

---

## 🚀 One-Line Installation

Install the security stack in a single command matching your package manager:

### Debian / Ubuntu
```bash
sudo apt update && sudo apt install -y opensnitch lynis usbguard clamav rkhunter flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```

### Fedora
```bash
sudo dnf install -y opensnitch lynis usbguard clamav rkhunter flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```

### Arch Linux
```bash
sudo pacman -S --noconfirm opensnitch lynis usbguard clamav rkhunter flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```

---

## 🛠️ The Security Stack

*   **[OpenSnitch](https://github.com/evilsocket/opensnitch)** — Outbound application firewall that prompts you to allow/block connection attempts per process.
*   **[Flatseal](https://github.com/tchx84/Flatseal)** — Permissions manager that revokes unneeded network or filesystem access for sandboxed Flatpak apps.
*   **[Lynis](https://cisofy.com/lynis/)** — Audit tool scanning kernel configuration, file permissions, and user access to generate security metrics.
*   **[USBGuard](https://usbguard.github.io/)** — Whitelisting daemon safeguarding USB ports against keystroke injection and rogue storage drives.
*   **[ClamAV & rkhunter](https://www.clamav.net/)** — Open-source antivirus engine and local rootkit scanner for regular on-demand audits.

---

## 🏗️ Deployment Checklist

1.  **Audit with Lynis** to establish a system baseline.
2.  **Enable OpenSnitch** to monitor and block telemetry or suspicious background processes.
3.  **Audit Flatpak Permissions** in Flatseal to revoke unnecessary socket/directory access.
4.  **Establish USBGuard Policies** to restrict physical ports to your trusted devices.
5.  **Harden Kernel Parameters** via local sysctl configuration files.

---

## ⚙️ Native System Hardening

### 1. Active Default Firewall
**Debian/Ubuntu (UFW):**
```bash
sudo apt install ufw && sudo ufw default deny incoming && sudo ufw default allow outgoing && sudo ufw enable
```
**Fedora (Firewalld):**
```bash
sudo dnf install firewalld && sudo systemctl enable --now firewalld && sudo firewall-cmd --set-default-zone=drop
```

### 2. Kernel Hardening (sysctl)
Create `/etc/sysctl.d/99-security.conf` and populate it with security parameters:

```ini
# Disable ping responses to hide from scanning sweeps
net.ipv4.icmp_echo_ignore_all = 1

# Disable IP routing/forwarding
net.ipv4.ip_forward = 0

# Mitigate SYN flood denial of service attacks
net.ipv4.tcp_syncookies = 1

# Prevent IP address spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Block credential leaks via core dumps
fs.suid_dumpable = 0

# Harden the internal BPF JIT compiler
net.core.bpf_jit_harden = 2
```
*Apply immediately using `sudo sysctl --system`.*

### 3. Restrict Sudo Cache Timeout
*   **Action:** Run `sudo visudo`.
*   **Tweak:** Add this line to reset the cached administrator session after 5 minutes:
    ```text
    Defaults env_reset, timestamp_timeout=5
    ```

---

## 🚨 Emergency Recovery Workflow

If you detect malicious background activity:

1.  **Isolate:** Sever the network connection immediately via command line:
    ```bash
    sudo ip link set dev <interface_name> down
    ```
2.  **Audit Connections:** Check for listening sockets and active PIDs:
    ```bash
    sudo ss -tupn
    ```
3.  **Rootkit Check:** Scan for file modifications and local rootkits:
    ```bash
    sudo rkhunter --update && sudo rkhunter --check --sk
    ```
4.  **Malware Sweep:** Execute a recursive scan on volatile folders:
    ```bash
    sudo freshclam && sudo clamscan -r -i --bell /tmp /usr/bin /home
    ```

---

## 🔗 Navigation
*   [Main Repository Index](../README.md)
*   [Windows Hardening Guide](../Windows/README_windows.md)
*   [macOS Hardening Guide](../MacOS/README_macos.md)
