# 🏰 Advanced System Hardening — The "Fort Knox" Tier

> Kernel · Bootloader · Encryption · Trust Chain

> [!CAUTION]
> **⚠️ EXTREME PRECAUTION — READ BEFORE PROCEEDING ⚠️**
>
> The steps in this guide make **deep, system-level changes** to your kernel, bootloader, firmware keys, and disk encryption. A single misconfiguration can:
>
> - **Brick your boot process** — your system will not start.
> - **Lock you out permanently** — a forgotten LUKS passphrase means **total, irrecoverable data loss**. No one can help you. Not even the drive manufacturer.
> - **Reject all operating systems** — incorrect Secure Boot key enrollment can prevent any OS from booting until keys are reset in BIOS.
>
> **Before you touch anything:**
> 1. ✅ Create a **full system backup** to an external drive.
> 2. ✅ Prepare a **bootable live USB** (e.g., Arch ISO) for emergency recovery.
> 3. ✅ Keep `linux-lts` installed as a **fallback kernel** at all times.
> 4. ✅ Write down and securely store your **LUKS passphrase** and **bootloader password**.
> 5. ✅ Read each section **completely** before executing any commands.

---

Software firewalls, sandboxing, and MAC (AppArmor) protect against runtime exploits and network attacks — but they do **not** protect your physical data at rest or the structural integrity of your boot process. These four steps address the lowest levels of the operating system.

---

## 1 · Hardened Kernel

The standard Linux kernel prioritizes performance and compatibility. The `linux-hardened` kernel prioritizes **security** — integrating patches that mitigate entire classes of memory corruption and buffer overflow vulnerabilities while enforcing aggressive privilege dropping.

**Step 1 — Install the hardened kernel and a fallback:**
```bash
sudo pacman -S linux-hardened linux-hardened-headers linux-lts linux-lts-headers
```

**Step 2 — Regenerate your bootloader config:**

For **GRUB**:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

For **systemd-boot** — create a new loader entry at `/boot/loader/entries/linux-hardened.conf`:
```ini
title   Arch Linux (Hardened)
linux   /vmlinuz-linux-hardened
initrd  /initramfs-linux-hardened.img
options root=PARTUUID=<your-root-partuuid> rw
```
> Replace `<your-root-partuuid>` with the output of `blkid -s PARTUUID -o value /dev/<your-root-partition>`.

**Step 3 — Reboot and verify:**
```bash
sudo reboot
# After reboot:
uname -r
# Expected output should contain: linux-hardened
```

#### 🚨 Recovery — Hardened Kernel Won't Boot

1. Reboot and select **Arch Linux (LTS)** from your bootloader menu.
2. If no menu appears, boot from a **live USB** and mount your system:
   ```bash
   mount /dev/sda2 /mnt        # or /dev/mapper/cryptroot if LUKS
   mount /dev/sda1 /mnt/boot
   ```
3. Chroot and regenerate the bootloader:
   ```bash
   arch-chroot /mnt
   grub-mkconfig -o /boot/grub/grub.cfg   # GRUB
   # or edit /boot/loader/entries/ for systemd-boot
   ```
4. Reboot and select **Arch Linux (LTS)** from the boot menu.

---

## 2 · Full Disk Encryption (LUKS)

If your device is stolen, no software firewall can help. An attacker removes the SSD, mounts it on another machine, and reads everything. **LUKS** encrypts the entire partition — without the passphrase, the drive is indecipherable noise.

> [!IMPORTANT]
> LUKS is best configured **during initial OS installation**. The steps below are for a fresh install. Converting an existing unencrypted system requires a full backup, reformat, and restore.

**Step 1 — Partition the drive** (example using `gdisk` or `fdisk`):
```bash
# Assuming /dev/sda (replace with your actual drive, e.g., /dev/nvme0n1)
# Create two partitions:
#   /dev/sda1 → 512M EFI System Partition (type EF00)
#   /dev/sda2 → Remaining space for LUKS (type 8300)
```

**Step 2 — Encrypt the root partition:**
```bash
cryptsetup luksFormat /dev/sda2
# You will be prompted to type YES (uppercase) and set your master passphrase.
```

**Step 3 — Open the encrypted volume:**
```bash
cryptsetup open /dev/sda2 cryptroot
```

**Step 4 — Format and mount:**
```bash
mkfs.ext4 /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt

mkfs.fat -F32 /dev/sda1
mount --mkdir /dev/sda1 /mnt/boot
```

**Step 5 — Install Arch and generate fstab:**
```bash
pacstrap /mnt base linux-hardened linux-hardened-headers linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
```

**Step 6 — Configure the initramfs** (`arch-chroot /mnt`):

Edit `/etc/mkinitcpio.conf` and add `encrypt` to the HOOKS array **before** `filesystems`:
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```

Regenerate:
```bash
mkinitcpio -P
```

**Step 7 — Configure bootloader kernel parameters:**

For **GRUB** — edit `/etc/default/grub`:
```bash
GRUB_CMDLINE_LINUX="cryptdevice=UUID=<luks-uuid>:cryptroot root=/dev/mapper/cryptroot"
```
> Get your LUKS UUID with: `blkid -s UUID -o value /dev/sda2`

Then regenerate:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

For **systemd-boot** — edit your loader entry:
```ini
options cryptdevice=UUID=<luks-uuid>:cryptroot root=/dev/mapper/cryptroot rw
```

> [!NOTE]
> On every boot, you will now be prompted for your LUKS passphrase before the OS loads. Without it, the drive reads as random noise.

#### 🚨 Recovery — Forgot LUKS Passphrase

> [!CAUTION]
> **There is no recovery.** LUKS encryption is mathematically irreversible without the passphrase. The data is permanently lost. This is by design.

Your only option is to reinstall the OS from scratch. If you had backups on an external drive, restore from those.

---

## 3 · Secure Boot with Custom Keys (`sbctl`)

By default, your motherboard trusts Microsoft's Secure Boot keys. If a vulnerability is found in those signatures (e.g., the **BootHole** flaw), malware can hijack the boot chain before Linux even starts.

**Step 1 — Install sbctl:**
```bash
sudo pacman -S sbctl
```

**Step 2 — Enter UEFI Setup Mode:**

Reboot into your BIOS/UEFI settings and find the Secure Boot section. Set it to **Setup Mode** (this clears the existing Microsoft keys). Save and reboot back into Linux.

**Step 3 — Verify Setup Mode:**
```bash
sbctl status
# Should show: Setup Mode: Enabled
```

**Step 4 — Generate your own keys:**
```bash
sudo sbctl create-keys
```

**Step 5 — Enroll keys into firmware:**
```bash
sudo sbctl enroll-keys -m
# The -m flag includes Microsoft's UEFI CA for compatibility with firmware updates.
# Omit -m for absolute maximum lockdown (may break firmware updates on some boards).
```

**Step 6 — Sign your kernel and bootloader:**
```bash
# Sign the hardened kernel
sudo sbctl sign -s /boot/vmlinuz-linux-hardened

# Sign the fallback kernel
sudo sbctl sign -s /boot/vmlinuz-linux-lts

# Sign the bootloader
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI

# For GRUB users, also sign:
sudo sbctl sign -s /boot/grub/x86_64-efi/grub.efi
```

**Step 7 — Verify all files are signed:**
```bash
sudo sbctl verify
# All listed files should show ✓ Signed
```

**Step 8 — Enable Secure Boot:**

Reboot into BIOS/UEFI and re-enable **Secure Boot**. Save and boot.

> [!NOTE]
> Result — your motherboard will **only** boot operating systems signed by you. After kernel updates, run `sudo sbctl sign-all` to re-sign.

#### 🚨 Recovery — Secure Boot Rejecting Kernel

1. Enter BIOS/UEFI and **disable Secure Boot** temporarily.
2. Boot into Linux normally.
3. Re-sign the updated kernel:
   ```bash
   sudo sbctl sign-all
   sudo sbctl verify       # confirm all files show ✓
   ```
4. Re-enable Secure Boot in BIOS.

#### 🚨 Recovery — Secure Boot Keys Corrupted

1. Enter BIOS/UEFI → Secure Boot → **Reset to Setup Mode** (or "Restore Factory Keys").
2. Boot from live USB, chroot, and re-enroll:
   ```bash
   arch-chroot /mnt
   sudo sbctl create-keys
   sudo sbctl enroll-keys -m
   sudo sbctl sign-all
   ```
3. Re-enable Secure Boot in BIOS.

---

## 4 · Bootloader Password Protection

With temporary physical access (e.g., an unattended laptop), an attacker can press `e` on the GRUB screen, append `init=/bin/bash` to the kernel parameters, and drop into an instant root shell — **no password required**.

### GRUB

**Step 1 — Generate a password hash:**
```bash
grub-mkpasswd-pbkdf2
# Enter your chosen password twice. Copy the output hash (grub.pbkdf2.sha512.10000.XXXX...).
```

**Step 2 — Add to GRUB config:**

Edit `/etc/grub.d/40_custom` and append:
```bash
set superusers="admin"
password_pbkdf2 admin grub.pbkdf2.sha512.10000.<your-full-hash-here>
```

**Step 3 — Regenerate GRUB:**
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

> [!WARNING]
> After this, editing boot entries requires the password. Normal booting (selecting an entry) remains password-free unless you add `--unrestricted` removal from menu entries.

#### 🚨 Recovery — Forgot GRUB Password

1. Boot from live USB.
2. Mount and chroot:
   ```bash
   mount /dev/sda2 /mnt        # or /dev/mapper/cryptroot if LUKS
   mount /dev/sda1 /mnt/boot
   arch-chroot /mnt
   ```
3. Remove the password lines from `/etc/grub.d/40_custom` (delete the `set superusers` and `password_pbkdf2` lines).
4. Regenerate:
   ```bash
   grub-mkconfig -o /boot/grub/grub.cfg
   ```
5. Reboot normally, then re-set a new password if desired.

### systemd-boot

Edit `/boot/loader/loader.conf` and add:
```ini
editor no
```

This disables the kernel parameter editor entirely — no password needed because the functionality is simply removed.

---

> *Security is a spectrum between convenience and paranoia. These four steps move you to the far end — absolute maximum protection for a personal workstation.*
