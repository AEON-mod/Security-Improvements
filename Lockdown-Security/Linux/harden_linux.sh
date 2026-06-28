#!/bin/bash
# ============================================================================
#  harden_linux.sh — Maximum Linux Desktop Hardening Script (v2.0)
# ============================================================================
#
#  WARNING: This script modifies system-level security configurations.
#  Review each function before running. Some settings may break:
#    - Container/Docker workflows (unprivileged user namespaces)
#    - Network debugging (ICMP disabled)
#    - Remote access (SSH hardened)
#
#  ROLLBACK: Each function documents how to reverse its changes.
#  USAGE: chmod +x harden_linux.sh && sudo ./harden_linux.sh
#
# ============================================================================

set -euo pipefail

# ─── Color Codes ────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─── Logging ────────────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}[INFO]${NC}    $1"; }
success() { echo -e "${GREEN}[OK]${NC}      $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}    $1"; }
error()   { echo -e "${RED}[ERROR]${NC}   $1"; }
section() { echo -e "\n${CYAN}${BOLD}── $1 ──${NC}"; }

APPLIED=()
SKIPPED=()
FAILED=()

track_result() {
    local name="$1" result="$2"
    case "$result" in
        ok)   APPLIED+=("$name") ;;
        skip) SKIPPED+=("$name") ;;
        fail) FAILED+=("$name") ;;
    esac
}

# ─── Banner ─────────────────────────────────────────────────────────────────
banner() {
    echo -e "${CYAN}${BOLD}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════╗
    ║          🐧  LINUX HARDENING SCRIPT  v2.0  🛡️            ║
    ║             Maximum Security Configuration               ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# ─── Root Check ─────────────────────────────────────────────────────────────
check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        error "This script must be run as root. Use: sudo $0"
        exit 1
    fi
}

# ─── Detect Distribution ────────────────────────────────────────────────────
DISTRO=""
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|linuxmint|pop) DISTRO="debian" ;;
            fedora|rhel|centos|rocky|alma) DISTRO="fedora" ;;
            arch|manjaro|endeavouros) DISTRO="arch" ;;
            *)
                warn "Unsupported distribution: $ID. Proceeding with best-effort detection."
                if command -v apt &>/dev/null; then DISTRO="debian";
                elif command -v dnf &>/dev/null; then DISTRO="fedora";
                elif command -v pacman &>/dev/null; then DISTRO="arch";
                else error "Cannot determine package manager."; exit 1; fi
                ;;
        esac
    else
        error "Cannot detect distribution. /etc/os-release not found."
        exit 1
    fi
    info "Detected distribution family: ${BOLD}$DISTRO${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
#  HARDENING FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# 1. Firewall Configuration
# Rollback: sudo ufw disable / sudo systemctl stop firewalld
configure_firewall() {
    section "Firewall Configuration"

    if [[ "$DISTRO" == "fedora" ]]; then
        if command -v firewall-cmd &>/dev/null; then
            systemctl enable --now firewalld 2>/dev/null || true
            firewall-cmd --set-default-zone=drop 2>/dev/null
            success "Firewalld enabled with default zone set to 'drop'."
            track_result "Firewall (firewalld)" "ok"
        else
            warn "Firewalld not found. Install it with: sudo dnf install firewalld"
            track_result "Firewall (firewalld)" "skip"
        fi
    else
        if command -v ufw &>/dev/null; then
            ufw default deny incoming 2>/dev/null
            ufw default allow outgoing 2>/dev/null
            echo "y" | ufw enable 2>/dev/null
            success "UFW enabled: deny incoming, allow outgoing."
            track_result "Firewall (UFW)" "ok"
        else
            warn "UFW not found. Install it with your package manager."
            track_result "Firewall (UFW)" "skip"
        fi
    fi
}

# 2. Kernel Hardening via sysctl
# Rollback: sudo rm /etc/sysctl.d/99-security.conf && sudo sysctl --system
configure_sysctl() {
    section "Kernel Hardening (sysctl)"

    local SYSCTL_FILE="/etc/sysctl.d/99-security.conf"

    cat > "$SYSCTL_FILE" << 'SYSCTL'
# ── Hardened Security Suite — Kernel Parameters ──

# Network: Disable ping responses
net.ipv4.icmp_echo_ignore_all = 1

# Network: Disable IP forwarding
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

# Network: Enable SYN cookie protection
net.ipv4.tcp_syncookies = 1

# Network: Enable strict reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Network: Ignore ICMP redirects (MITM prevention)
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Network: Disable source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# Network: Log martian packets
net.ipv4.conf.all.log_martians = 1

# Security: Block core dumps from SUID binaries
fs.suid_dumpable = 0

# Security: Harden BPF JIT compiler
net.core.bpf_jit_harden = 2

# Security: Restrict kernel pointer exposure
kernel.kptr_restrict = 2

# Security: Restrict dmesg to root
kernel.dmesg_restrict = 1

# Security: Restrict perf events
kernel.perf_event_paranoid = 3
SYSCTL

    sysctl --system &>/dev/null
    success "Kernel parameters deployed to $SYSCTL_FILE and applied."
    track_result "Kernel sysctl hardening" "ok"
}

# 3. DNS-over-TLS Configuration
# Rollback: sudo rm /etc/systemd/resolved.conf.d/dns_over_tls.conf && sudo systemctl restart systemd-resolved
configure_dns_over_tls() {
    section "DNS-over-TLS (DoT)"

    if ! systemctl is-active --quiet systemd-resolved 2>/dev/null; then
        warn "systemd-resolved is not active. Skipping DNS-over-TLS."
        track_result "DNS-over-TLS" "skip"
        return
    fi

    mkdir -p /etc/systemd/resolved.conf.d

    cat > /etc/systemd/resolved.conf.d/dns_over_tls.conf << 'DNS'
[Resolve]
DNS=9.9.9.9#dns.quad9.net 1.1.1.2#security.cloudflare-dns.com
FallbackDNS=1.0.0.2#security.cloudflare-dns.com
DNSOverTLS=yes
DNSSEC=yes
DNS

    # Symlink resolv.conf to systemd-resolved stub
    ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf 2>/dev/null || true

    systemctl restart systemd-resolved
    success "DNS-over-TLS enabled via Quad9 and Cloudflare Security."
    track_result "DNS-over-TLS" "ok"
}

# 4. Sudo Timeout Restriction
# Rollback: sudo rm /etc/sudoers.d/00_security_timeout
configure_sudo_timeout() {
    section "Sudo Timeout Restriction"

    local SUDOERS_FILE="/etc/sudoers.d/00_security_timeout"

    echo 'Defaults env_reset, timestamp_timeout=5' > "$SUDOERS_FILE"
    chmod 440 "$SUDOERS_FILE"

    # Validate the sudoers file
    if visudo -cf "$SUDOERS_FILE" &>/dev/null; then
        success "Sudo timeout set to 5 minutes ($SUDOERS_FILE)."
        track_result "Sudo timeout" "ok"
    else
        error "Invalid sudoers syntax. Removing file."
        rm -f "$SUDOERS_FILE"
        track_result "Sudo timeout" "fail"
    fi
}

# 5. SSH Hardening
# Rollback: sudo rm /etc/ssh/sshd_config.d/99-hardened.conf && sudo systemctl restart sshd
harden_ssh() {
    section "SSH Hardening"

    if ! command -v sshd &>/dev/null && ! systemctl is-enabled sshd &>/dev/null 2>&1; then
        info "SSH server is not installed. Skipping SSH hardening."
        track_result "SSH hardening" "skip"
        return
    fi

    local SSH_DIR="/etc/ssh/sshd_config.d"
    mkdir -p "$SSH_DIR"

    cat > "$SSH_DIR/99-hardened.conf" << 'SSH'
# ── Hardened Security Suite — SSH Configuration ──
PermitRootLogin no
PasswordAuthentication no
MaxAuthTries 3
X11Forwarding no
AllowAgentForwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
SSH

    # Test config before restarting
    if sshd -t &>/dev/null; then
        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null || true
        success "SSH hardened: root login disabled, password auth off, max 3 tries."
        track_result "SSH hardening" "ok"
    else
        error "SSH config test failed. Removing hardened config."
        rm -f "$SSH_DIR/99-hardened.conf"
        track_result "SSH hardening" "fail"
    fi
}

# 6. AppArmor / SELinux Enforcement
# Rollback (AppArmor): sudo aa-complain /etc/apparmor.d/*
# Rollback (SELinux): sudo setenforce 0
enforce_mac() {
    section "Mandatory Access Control (MAC)"

    if [[ "$DISTRO" == "fedora" ]]; then
        # SELinux
        if command -v getenforce &>/dev/null; then
            local status
            status=$(getenforce)
            if [[ "$status" == "Enforcing" ]]; then
                success "SELinux is already in Enforcing mode."
            else
                setenforce 1 2>/dev/null || true
                sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config 2>/dev/null || true
                success "SELinux set to Enforcing mode."
            fi
            track_result "SELinux enforcement" "ok"
        else
            warn "SELinux tools not found."
            track_result "SELinux enforcement" "skip"
        fi
    else
        # AppArmor
        if command -v aa-enforce &>/dev/null; then
            systemctl enable --now apparmor 2>/dev/null || true
            # Enforce all available profiles
            local count=0
            for profile in /etc/apparmor.d/*; do
                [[ -f "$profile" ]] || continue
                aa-enforce "$profile" &>/dev/null && ((count++)) || true
            done
            success "AppArmor enabled. $count profiles set to enforce mode."
            track_result "AppArmor enforcement" "ok"
        else
            warn "AppArmor not installed. Install: sudo apt install apparmor apparmor-utils"
            track_result "AppArmor enforcement" "skip"
        fi
    fi
}

# 7. Firejail Auto-Sandboxing
# Rollback: sudo firecfg --clean
configure_firejail() {
    section "Firejail Sandboxing"

    if command -v firejail &>/dev/null; then
        firecfg &>/dev/null
        success "Firejail: all compatible applications auto-sandboxed via firecfg."
        track_result "Firejail sandboxing" "ok"
    else
        warn "Firejail not installed. Skipping."
        track_result "Firejail sandboxing" "skip"
    fi
}

# 8. USBGuard Baseline Policy
# Rollback: sudo systemctl stop usbguard && sudo rm /etc/usbguard/rules.conf
configure_usbguard() {
    section "USBGuard Policy"

    if command -v usbguard &>/dev/null; then
        if [[ ! -f /etc/usbguard/rules.conf ]] || [[ ! -s /etc/usbguard/rules.conf ]]; then
            usbguard generate-policy > /etc/usbguard/rules.conf 2>/dev/null
            success "USBGuard: baseline policy generated from current devices."
        else
            info "USBGuard: existing policy found. Not overwriting."
        fi
        systemctl enable --now usbguard 2>/dev/null || true
        track_result "USBGuard policy" "ok"
    else
        warn "USBGuard not installed. Skipping."
        track_result "USBGuard policy" "skip"
    fi
}

# 9. Auditd Service
# Rollback: sudo systemctl stop auditd
enable_auditd() {
    section "Linux Audit Daemon (auditd)"

    if command -v auditd &>/dev/null || command -v auditctl &>/dev/null; then
        systemctl enable --now auditd 2>/dev/null || true
        success "Auditd enabled and running."
        track_result "Auditd" "ok"
    else
        warn "Auditd not installed. Skipping."
        track_result "Auditd" "skip"
    fi
}

# 10. AIDE File Integrity Database
# Rollback: sudo rm /var/lib/aide/aide.db
initialize_aide() {
    section "AIDE File Integrity Monitoring"

    if command -v aide &>/dev/null || command -v aideinit &>/dev/null; then
        if [[ ! -f /var/lib/aide/aide.db ]]; then
            info "Initializing AIDE database (this may take several minutes)..."
            if command -v aideinit &>/dev/null; then
                aideinit 2>/dev/null || true
                cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db 2>/dev/null || true
            else
                aide --init 2>/dev/null || true
                cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz 2>/dev/null || \
                cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db 2>/dev/null || true
            fi
            success "AIDE database initialized."
        else
            info "AIDE database already exists. Not overwriting."
        fi
        track_result "AIDE initialization" "ok"
    else
        warn "AIDE not installed. Skipping."
        track_result "AIDE initialization" "skip"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
#  SUMMARY
# ═══════════════════════════════════════════════════════════════════════════
print_summary() {
    echo ""
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}                    HARDENING SUMMARY                      ${NC}"
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════${NC}"

    if [[ ${#APPLIED[@]} -gt 0 ]]; then
        echo -e "\n${GREEN}${BOLD}✅ Applied (${#APPLIED[@]}):${NC}"
        for item in "${APPLIED[@]}"; do
            echo -e "   ${GREEN}•${NC} $item"
        done
    fi

    if [[ ${#SKIPPED[@]} -gt 0 ]]; then
        echo -e "\n${YELLOW}${BOLD}⏭️  Skipped (${#SKIPPED[@]}):${NC}"
        for item in "${SKIPPED[@]}"; do
            echo -e "   ${YELLOW}•${NC} $item"
        done
    fi

    if [[ ${#FAILED[@]} -gt 0 ]]; then
        echo -e "\n${RED}${BOLD}❌ Failed (${#FAILED[@]}):${NC}"
        for item in "${FAILED[@]}"; do
            echo -e "   ${RED}•${NC} $item"
        done
    fi

    echo -e "\n${CYAN}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}  Reboot recommended to fully activate all changes.${NC}"
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════════════════════
main() {
    banner
    check_root
    detect_distro

    echo -e "\n${YELLOW}${BOLD}This script will apply system-level security hardening.${NC}"
    echo -e "${YELLOW}Review the source code before proceeding.${NC}"
    read -r -p "Continue? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Aborted by user."
        exit 0
    fi

    configure_firewall
    configure_sysctl
    configure_dns_over_tls
    configure_sudo_timeout
    harden_ssh
    enforce_mac
    configure_firejail
    configure_usbguard
    enable_auditd
    initialize_aide

    print_summary
}

main "$@"
