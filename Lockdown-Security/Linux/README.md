# 🐧 Maximum Linux Hardening Guide

A curated, high-efficiency security configuration guide designed to secure desktop Linux distributions to the absolute maximum level.

---

## 🚀 The Ultimate Installation

Install the complete security stack in a single command matching your package manager.

### Debian / Ubuntu
```bash
sudo apt update && sudo apt install -y opensnitch lynis usbguard clamav clamav-daemon rkhunter flatpak apparmor apparmor-profiles apparmor-utils firejail auditd aide ufw && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```

### Fedora
```bash
sudo dnf install -y opensnitch lynis usbguard clamav clamav-update rkhunter flatpak firejail audit aide && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```
> *Fedora uses SELinux by default instead of AppArmor. Do not install AppArmor on Fedora.*

### Arch Linux
```bash
sudo pacman -S --noconfirm opensnitch lynis usbguard clamav rkhunter flatpak apparmor firejail audit ufw && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.tchx84.Flatseal
```
> *`aide` is not in the official Arch repos. Install it from the AUR: `yay -S aide` or `paru -S aide`.*

---

## 🛠️ The Security Stack

*   **[AppArmor](https://apparmor.net/) / [SELinux](https://selinuxproject.org/)** — Mandatory Access Control (MAC) that confines programs to a minimum set of files and capabilities, containing zero-day exploits.
*   **[Firejail](https://firejail.wordpress.com/)** — SUID sandbox using Linux namespaces and seccomp-bpf to isolate native applications (browsers, media players, PDF readers).
*   **[OpenSnitch](https://github.com/evilsocket/opensnitch)** — Outbound application firewall that prompts you to allow/block connection attempts per process, per domain, or per port.
*   **[Flatseal](https://github.com/tchx84/Flatseal)** — GUI permissions manager that revokes unneeded network, filesystem, or hardware access for Flatpak applications.
*   **[Lynis](https://cisofy.com/lynis/)** — Security audit tool scanning kernel config, file permissions, and system services to generate a hardening index with actionable recommendations.
*   **[USBGuard](https://usbguard.github.io/)** — Whitelisting daemon safeguarding USB ports against keystroke injection (BadUSB) and rogue storage drives.
*   **[ClamAV](https://www.clamav.net/) & [rkhunter](https://rkhunter.sourceforge.net/)** — Open-source antivirus engine and rootkit scanner for periodic on-demand audits.
*   **[Auditd](https://people.redhat.com/sgrubb/audit/)** — Linux Audit Daemon tracking syscalls, binary executions, and file access for forensic logging.
*   **[AIDE](https://aide.github.io/)** — Advanced Intrusion Detection Environment — file integrity checker that detects unauthorized modifications to system binaries.

---

## 🏗️ Deployment Checklist

1.  **Enable AppArmor/SELinux** and enforce all available profiles.
2.  **Enable OpenSnitch** to gain visibility into background outbound traffic.
3.  **Run `sudo firecfg`** to automatically sandbox all compatible native applications via Firejail.
4.  **Audit Flatpak Permissions** in Flatseal to strip unnecessary sockets and filesystem access.
5.  **Establish USBGuard Policies** by generating a baseline from currently connected devices.
6.  **Apply Kernel Parameters** via sysctl configuration files.
7.  **Enable DNS-over-TLS (DoT)** to encrypt all DNS queries via `systemd-resolved`.
8.  **Initialize AIDE Database** to create a baseline for file integrity monitoring.
9.  **Run the automated hardening script** (see below) to apply all configurations in one step.

---

## ⚙️ Hardening Guide

### Manual Configuration

#### 1. Active Default Firewall
**Debian/Ubuntu/Arch (UFW):**
```bash
sudo ufw default deny incoming && sudo ufw default allow outgoing && sudo ufw enable
```
**Fedora (Firewalld):**
```bash
sudo systemctl enable --now firewalld && sudo firewall-cmd --set-default-zone=drop
```

#### 2. DNS-over-TLS (DoT)
Prevent DNS spoofing and ISP snooping. Create `/etc/systemd/resolved.conf.d/dns_over_tls.conf`:
```ini
[Resolve]
DNS=9.9.9.9#dns.quad9.net 1.1.1.2#security.cloudflare-dns.com
FallbackDNS=1.0.0.2#security.cloudflare-dns.com
DNSOverTLS=yes
DNSSEC=yes
```
Then apply:
```bash
sudo systemctl restart systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

#### 3. Kernel Hardening (sysctl)
Create `/etc/sysctl.d/99-security.conf`:
```ini
# Disable ping responses to hide from scanning sweeps
net.ipv4.icmp_echo_ignore_all = 1

# Disable IP routing/forwarding
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

# Mitigate SYN flood denial of service attacks
net.ipv4.tcp_syncookies = 1

# Prevent IP address spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP redirects (prevents MITM route injection)
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Disable source routing (prevents attackers from specifying packet paths)
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# Log martian packets (spoofed, misrouted, redirected)
net.ipv4.conf.all.log_martians = 1

# Block credential leaks via core dumps
fs.suid_dumpable = 0

# Harden the internal BPF JIT compiler
net.core.bpf_jit_harden = 2

# Restrict access to kernel pointers in /proc
kernel.kptr_restrict = 2

# Restrict dmesg access to root
kernel.dmesg_restrict = 1

# Restrict performance events
kernel.perf_event_paranoid = 3

# Disable unprivileged user namespaces (mitigates container escape exploits)
kernel.unprivileged_userns_clone = 0
```
Apply immediately: `sudo sysctl --system`

#### 4. Restrict Sudo Cache Timeout
Create `/etc/sudoers.d/00_security_timeout`:
```bash
echo 'Defaults env_reset, timestamp_timeout=5' | sudo tee /etc/sudoers.d/00_security_timeout
sudo chmod 440 /etc/sudoers.d/00_security_timeout
```

#### 5. Harden SSH Configuration
Edit `/etc/ssh/sshd_config`:
```text
PermitRootLogin no
PasswordAuthentication no
MaxAuthTries 3
X11Forwarding no
AllowAgentForwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
```
Restart: `sudo systemctl restart sshd`

#### 6. Enable AppArmor (Debian/Ubuntu/Arch)
```bash
sudo systemctl enable --now apparmor
sudo aa-enforce /etc/apparmor.d/*
```

#### 7. Initialize AIDE File Integrity Database
```bash
sudo aideinit
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```
Run periodic checks: `sudo aide --check`

---

### Automated Hardening Script

> [!TIP]
> **Don't want to do all the manual steps above?** Just run the script below — it applies every configuration listed in the manual section automatically in a single step.

Run the included `harden_linux.sh` script:

```bash
chmod +x harden_linux.sh
sudo ./harden_linux.sh
```

The script automates:
- Firewall activation (UFW or Firewalld, auto-detected)
- Kernel sysctl parameter deployment
- DNS-over-TLS configuration via systemd-resolved
- Sudo timeout restriction
- SSH hardening
- AppArmor / SELinux profile enforcement
- Firejail auto-sandboxing (`firecfg`)
- USBGuard baseline policy generation
- Auditd service activation
- AIDE file integrity database initialization

> [!WARNING]
> Review the script source before running. Some settings (e.g., disabling unprivileged user namespaces) may break container-based workflows. The script will prompt for confirmation before applying destructive changes.

---

## 🏰 Structural Upgrades (The "Fort Knox" Tier)

For absolute maximum physical and boot-level protection:

1.  **Linux Hardened Kernel:** Switch to `linux-hardened` (Arch) or `linux-image-hardened` to mitigate memory corruption exploits and disable legacy syscalls.
2.  **LUKS Full Disk Encryption:** Encrypt the entire drive with `cryptsetup luksFormat` to protect data at rest against physical theft.
3.  **Custom Secure Boot (`sbctl`):** Sign your own kernels and reject Microsoft's default keys to prevent bootloader hijacking.
4.  **Bootloader Password:** Password-protect GRUB/systemd-boot to block unauthorized kernel parameter modifications from the physical console.

---

## 🚨 Emergency Recovery Workflow

If you detect malicious background activity:

1.  **Isolate:** Sever the network connection immediately:
    ```bash
    sudo ip link set dev <interface_name> down
    ```
2.  **Audit Connections:** Check for listening sockets and active PIDs:
    ```bash
    sudo ss -tupn
    ```
3.  **Check Audit Logs:** Review suspicious executions:
    ```bash
    sudo ausearch -m execve --start today | head -100
    ```
4.  **File Integrity Check:** Compare current state against AIDE baseline:
    ```bash
    sudo aide --check
    ```
5.  **Rootkit Check:** Scan for modifications and local rootkits:
    ```bash
    sudo rkhunter --update && sudo rkhunter --check --sk
    ```
6.  **Malware Sweep:** Execute a recursive scan on volatile folders:
    ```bash
    sudo freshclam && sudo clamscan -r -i --bell /tmp /usr/bin /home
    ```

---

## 🔗 Navigation
*   [Main Repository Index](../README.md)
*   [Windows Hardening Guide](../Windows/README.md)
*   [macOS Hardening Guide](../MacOS/README.md)
