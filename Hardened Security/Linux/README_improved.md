# 🐧 Maximum Linux Hardening Guide (v2.0)

A curated, high-efficiency security configuration guide designed to secure desktop Linux distributions to the absolute maximum level.

---

## 🚀 The Ultimate Installation

Install the complete security stack in a single command matching your package manager. This includes sandboxing, firewalls, MAC, and auditing tools.

### Debian / Ubuntu
```bash
sudo apt update && sudo apt install -y opensnitch lynis usbguard clamav rkhunter flatpak apparmor apparmor-profiles firejail auditd && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```

### Fedora
```bash
sudo dnf install -y opensnitch lynis usbguard clamav rkhunter flatpak firejail audit && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```
*(Note: Fedora uses SELinux by default instead of AppArmor).*

### Arch Linux
```bash
sudo pacman -S --noconfirm opensnitch lynis usbguard clamav rkhunter flatpak apparmor firejail audit && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```

---

## 🛠️ The Security Stack

*   **[AppArmor / SELinux]** — Mandatory Access Control (MAC) that restricts programs to a limited set of files and capabilities, mitigating zero-day exploits.
*   **[Firejail]** — SUID sandbox utilizing Linux namespaces to isolate native applications (browsers, PDF readers).
*   **[OpenSnitch]** — Outbound application firewall that prompts you to allow/block connection attempts per process.
*   **[Flatseal]** — Permissions manager that revokes unneeded network or filesystem access for sandboxed Flatpak apps.
*   **[Lynis]** — Audit tool scanning kernel configuration, file permissions, and user access to generate security metrics.
*   **[USBGuard]** — Whitelisting daemon safeguarding USB ports against keystroke injection and rogue storage drives.
*   **[ClamAV & rkhunter]** — Open-source antivirus engine and local rootkit scanner for regular audits.
*   **[Auditd]** — The Linux Audit Daemon, tracking and logging system calls, executions, and file access.

---

## 🏗️ Deployment Checklist

1.  **Enable AppArmor** and update your kernel boot parameters to include `lsm=landlock,lockdown,yama,integrity,apparmor,bpf`.
2.  **Enable OpenSnitch** to monitor and block telemetry or suspicious background processes.
3.  **Run `sudo firecfg`** to automatically symlink and sandbox all compatible native apps via Firejail.
4.  **Audit Flatpak Permissions** in Flatseal to revoke unnecessary socket/directory access.
5.  **Establish USBGuard Policies** to restrict physical ports to your trusted devices.
6.  **Harden Kernel Parameters** via local sysctl configuration files.
7.  **Enable DNS-over-TLS (DoT)** to encrypt all DNS queries via `systemd-resolved`.

---

## ⚙️ Native System Hardening

### 1. Active Default Firewall
**Debian/Ubuntu/Arch (UFW):**
```bash
sudo ufw default deny incoming && sudo ufw default allow outgoing && sudo ufw enable
```

### 2. DNS-over-TLS (DoT)
Prevent DNS spoofing and ISP snooping by creating `/etc/systemd/resolved.conf.d/dns_over_tls.conf`:
```ini
[Resolve]
DNS=9.9.9.9#dns.quad9.net 1.1.1.2#security.cloudflare-dns.com
DNSOverTLS=yes
```
*Restart `systemd-resolved` and symlink `/etc/resolv.conf` to `/run/systemd/resolve/stub-resolv.conf`.*

### 3. Kernel Hardening (sysctl)
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

### 4. Restrict Sudo Cache Timeout
Add a rule to `/etc/sudoers.d/00_security_timeout` to ensure the administrator session requires a password again after 5 minutes:
```text
Defaults env_reset, timestamp_timeout=5
```

---

## 🏰 Structural Upgrades (The "Fort Knox" Tier)
For absolute maximum security, users must also implement physical and boot-level protections:
1.  **Linux Hardened Kernel:** Switch to `linux-hardened` to mitigate memory corruption exploits.
2.  **LUKS Full Disk Encryption:** Encrypt the entire drive to protect data at rest against physical theft.
3.  **Custom Secure Boot (`sbctl`):** Sign your own kernels and reject Microsoft's default keys to prevent bootloader hijacking.
4.  **Bootloader Password:** Password-protect GRUB/systemd-boot to prevent unauthorized kernel parameter modifications at the terminal.

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
3.  **Check Audit Logs:** Review `ausearch` for suspicious executions.
4.  **Rootkit Check:** Scan for file modifications and local rootkits:
    ```bash
    sudo rkhunter --update && sudo rkhunter --check --sk
    ```
5.  **Malware Sweep:** Execute a recursive scan on volatile folders:
    ```bash
    sudo freshclam && sudo clamscan -r -i --bell /tmp /usr/bin /home
    ```
