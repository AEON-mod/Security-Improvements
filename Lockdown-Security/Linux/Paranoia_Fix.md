# 🏰 Advanced System Hardening — The "Fort Knox" Tier

> Kernel · Bootloader · Encryption · Trust Chain

> [!CAUTION]
> These are **irreversible, system-level modifications**. Misconfiguration can render your system unbootable. Always maintain a backup kernel, a live USB recovery drive, and a full data backup before proceeding.

---

Software firewalls, sandboxing, and MAC (AppArmor) protect against runtime exploits and network attacks — but they do **not** protect your physical data at rest or the structural integrity of your boot process. These four steps address the lowest levels of the operating system.

---

## 1 · Hardened Kernel

The standard Linux kernel prioritizes performance and compatibility. The `linux-hardened` kernel prioritizes **security** — integrating patches that mitigate entire classes of memory corruption and buffer overflow vulnerabilities while enforcing aggressive privilege dropping.

```bash
sudo pacman -S linux-hardened linux-hardened-headers
```

> [!WARNING]
> You must regenerate your bootloader configuration to boot from the new kernel. Always keep `linux-lts` installed as a fallback.

---

## 2 · Full Disk Encryption (LUKS)

If your device is stolen, no software firewall can help. An attacker removes the SSD, mounts it on another machine, and reads everything. **LUKS** encrypts the entire partition — without the passphrase, the drive is indecipherable noise.

**How it works:**
- The boot process halts and prompts for a master passphrase before the OS loads.
- Without it, all data reads as cryptographically random garbage.

> [!IMPORTANT]
> LUKS is best configured during initial OS installation. Converting an existing unencrypted system requires a full backup, reformat, and restore.

---

## 3 · Secure Boot with Custom Keys (`sbctl`)

By default, your motherboard trusts Microsoft's Secure Boot keys. If a vulnerability is found in those signatures (e.g., the **BootHole** flaw), malware can hijack the boot chain before Linux even starts.

**The fix:** Wipe the default keys and replace them with your own.

1. Install `sbctl` (Secure Boot Key Manager).
2. Generate your own **PK** (Platform Key), **KEK** (Key Exchange Key), and **db** (Signature Database).
3. Sign your `linux-hardened` kernel and bootloader with `sbctl`.
4. Enroll the keys into your UEFI BIOS.

> [!NOTE]
> Result — your motherboard will **only** boot operating systems signed by you.

---

## 4 · Bootloader Password Protection

With temporary physical access (e.g., an unattended laptop), an attacker can press `e` on the GRUB screen, append `init=/bin/bash` to the kernel parameters, and drop into an instant root shell — **no password required**.

**The fix:** Require a password before allowing boot parameter modifications.

| Bootloader | Method |
| :--- | :--- |
| **GRUB** | Generate a PBKDF2 hash with `grub-mkpasswd-pbkdf2` and add it to `/etc/grub.d/40_custom` as the `superusers` config. |
| **systemd-boot** | Set `editor no` in your `loader.conf`. |

---

> *Security is a spectrum between convenience and paranoia. These four steps move you to the far end — absolute maximum protection for a personal workstation.*
