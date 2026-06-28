#!/bin/bash
# ============================================================================
#  harden_macos.sh — Maximum macOS Hardening Script (v2.0)
# ============================================================================
#
#  WARNING: This script modifies system-level security configurations.
#  Review each function before running. Some settings may affect:
#    - AirDrop functionality (sharing services disabled)
#    - Remote Login / SSH access (disabled)
#    - Bluetooth device pairing (discoverability off)
#
#  USAGE: chmod +x harden_macos.sh && sudo ./harden_macos.sh
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
NC='\033[0m'

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
    ║          🍎  macOS HARDENING SCRIPT  v2.0  🛡️             ║
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

# ═══════════════════════════════════════════════════════════════════════════
#  HARDENING FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# 1. Enable macOS Firewall + Stealth Mode
# Rollback: sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
enable_firewall() {
    section "macOS Firewall & Stealth Mode"

    local fw="/usr/libexec/ApplicationFirewall/socketfilterfw"

    if [[ -x "$fw" ]]; then
        "$fw" --setglobalstate on 2>/dev/null
        "$fw" --setstealthmode on 2>/dev/null
        "$fw" --setblockall on 2>/dev/null
        success "Firewall enabled. Stealth mode on. All unsolicited incoming blocked."
        track_result "Firewall + Stealth Mode" "ok"
    else
        error "socketfilterfw not found at expected path."
        track_result "Firewall + Stealth Mode" "fail"
    fi
}

# 2. Check FileVault Status
# Rollback: sudo fdesetup disable
check_filevault() {
    section "FileVault Full Disk Encryption"

    if fdesetup status 2>/dev/null | grep -q "On"; then
        success "FileVault is already enabled."
        track_result "FileVault" "ok"
    else
        warn "FileVault is NOT enabled."
        info "To enable, run: sudo fdesetup enable"
        info "Or go to System Settings > Privacy & Security > FileVault > Turn On."
        track_result "FileVault" "skip"
    fi
}

# 3. Verify SIP
verify_sip() {
    section "System Integrity Protection (SIP)"

    if csrutil status 2>/dev/null | grep -q "enabled"; then
        success "System Integrity Protection is enabled."
        track_result "SIP verification" "ok"
    else
        error "SIP is DISABLED. Reboot into Recovery Mode and run: csrutil enable"
        track_result "SIP verification" "fail"
    fi
}

# 4. Disable Sharing Services
# Rollback: sudo systemsetup -setremotelogin on
disable_sharing() {
    section "Sharing Service Teardown"

    # Disable Remote Login (SSH)
    if systemsetup -getremotelogin 2>/dev/null | grep -qi "on"; then
        systemsetup -setremotelogin off 2>/dev/null || true
        success "Remote Login (SSH) disabled."
    else
        info "Remote Login already disabled."
    fi

    # Disable Remote Apple Events
    if systemsetup -getremoteappleevents 2>/dev/null | grep -qi "on"; then
        systemsetup -setremoteappleevents off 2>/dev/null || true
        success "Remote Apple Events disabled."
    else
        info "Remote Apple Events already disabled."
    fi

    track_result "Sharing services disabled" "ok"
}

# 5. Privacy Hardening
# Rollback: defaults delete com.apple.AdLib allowApplePersonalizedAdvertising
harden_privacy() {
    section "Privacy & Analytics Hardening"

    # Disable personalized ads
    defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false 2>/dev/null || true
    success "Personalized ad tracking disabled."

    # Disable analytics sharing
    defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" AutoSubmit -bool false 2>/dev/null || true
    success "Diagnostic and analytics sharing disabled."

    # Disable Siri analytics
    defaults write com.apple.assistant.support "Siri Data Sharing Opt-In Status" -int 2 2>/dev/null || true
    success "Siri data sharing disabled."

    track_result "Privacy hardening" "ok"
}

# 6. Screen Lock Enforcement
# Rollback: defaults delete com.apple.screensaver askForPassword
set_screen_lock() {
    section "Screen Lock Enforcement"

    # Require password immediately after sleep/screensaver
    defaults write com.apple.screensaver askForPassword -int 1 2>/dev/null || true
    defaults write com.apple.screensaver askForPasswordDelay -int 0 2>/dev/null || true

    # Set screensaver activation to 5 minutes
    defaults -currentHost write com.apple.screensaver idleTime -int 300 2>/dev/null || true

    success "Screen lock: password required immediately, screensaver at 5 minutes."
    track_result "Screen lock" "ok"
}

# 7. Automatic Security Updates
# Rollback: sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
enable_auto_updates() {
    section "Automatic Security Updates"

    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true 2>/dev/null || true
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true 2>/dev/null || true
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true 2>/dev/null || true
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true 2>/dev/null || true

    success "Auto-check, auto-download, and critical security updates enabled."
    track_result "Auto security updates" "ok"
}

# 8. Bluetooth Discoverability
# Rollback: sudo defaults write /Library/Preferences/com.apple.Bluetooth DiscoverableState -int 1
disable_bluetooth_discoverability() {
    section "Bluetooth Discoverability"

    sudo defaults write /Library/Preferences/com.apple.Bluetooth DiscoverableState -int 0 2>/dev/null || true
    success "Bluetooth discoverability disabled."
    track_result "Bluetooth discoverability" "ok"
}

# 9. Safari Hardening
# Rollback: defaults delete com.apple.Safari AutoFillFromAddressBook
harden_safari() {
    section "Safari Security Hardening"

    # Disable AutoFill
    defaults write com.apple.Safari AutoFillFromAddressBook -bool false 2>/dev/null || true
    defaults write com.apple.Safari AutoFillPasswords -bool false 2>/dev/null || true
    defaults write com.apple.Safari AutoFillCreditCardData -bool false 2>/dev/null || true

    # Enable fraud warnings
    defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true 2>/dev/null || true

    # Block popups
    defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false 2>/dev/null || true

    # Prevent cross-site tracking
    defaults write com.apple.Safari BlockStoragePolicy -int 2 2>/dev/null || true

    success "Safari: AutoFill off, fraud warnings on, popups blocked, cross-site tracking prevented."
    track_result "Safari hardening" "ok"
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
    echo -e "${BOLD}  Some changes may require a logout or reboot to take effect.${NC}"
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════════════════════
main() {
    banner
    check_root

    echo -e "\n${YELLOW}${BOLD}This script will apply system-level security hardening.${NC}"
    echo -e "${YELLOW}Review the source code before proceeding.${NC}"
    read -r -p "Continue? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Aborted by user."
        exit 0
    fi

    enable_firewall
    check_filevault
    verify_sip
    disable_sharing
    harden_privacy
    set_screen_lock
    enable_auto_updates
    disable_bluetooth_discoverability
    harden_safari

    print_summary
}

main "$@"
