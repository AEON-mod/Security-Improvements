# 🛡️ Lockdown-Security (v2.0)

> **Proactive Defense · Network Transparency · Privacy Sovereignty**

A modular, multi-platform collection of hardening guides and **automated scripts** designed to transform stock operating systems into fortified environments. Each platform guide includes curated tool recommendations, manual configuration steps, and a one-click hardening script.

---

## 🗺️ Choose Your Platform

| Platform | Guide | Script | Focus |
| :--- | :--- | :--- | :--- |
| **🏁 Windows** | [Hardening Guide](Windows/README.md) | [`harden_windows.ps1`](Windows/harden_windows.ps1) | Telemetry removal, exploit protection, Defender hardening |
| **🐧 Linux** | [Hardening Guide](Linux/README.md) | [`harden_linux.sh`](Linux/harden_linux.sh) | Kernel sysctl, MAC enforcement, DNS-over-TLS, sandboxing |
| **🍎 macOS** | [Hardening Guide](MacOS/README.md) | [`harden_macos.sh`](MacOS/harden_macos.sh) | Outbound firewalls, persistence auditing, privacy lockdown |

---

## 🧠 Security Philosophy

| Principle | Description |
| :--- | :--- |
| **Defense in Depth** | Layer independent controls so that bypassing one does not compromise the system. |
| **Zero Trust** | Every application must explicitly justify its network and filesystem access. |
| **Telemetry Elimination** | Disable all non-essential diagnostic reporting and background analytics. |
| **Minimal Attack Surface** | Remove unused services, close unnecessary ports, and restrict hardware access. |

---

## 🌐 Browser Security Stack (All Platforms)

These browser extensions are essential regardless of your operating system:

*   **[uBlock Origin](https://ublockorigin.com/)** — Content filter blocking malicious scripts, malvertising, and tracking domains at the browser level.
*   **[Bitwarden](https://bitwarden.com/)** — End-to-end encrypted password manager generating and storing unique, high-entropy credentials per service.
*   **[FastForward](https://fastforward.team/)** — Bypasses intermediary tracking links, ad-redirect pages, and countdown screens to reduce drive-by download exposure.

---

## 📁 Repository Structure

```
Hardened-Security/
├── README.md                  ← You are here
├── Windows/
│   ├── README.md              ← Windows hardening guide
│   └── harden_windows.ps1    ← Automated PowerShell hardening script
├── Linux/
│   ├── README.md              ← Linux hardening guide
│   └── harden_linux.sh       ← Automated Bash hardening script
└── MacOS/
    ├── README.md              ← macOS hardening guide
    └── harden_macos.sh       ← Automated Bash hardening script
```

---

## 🤝 Contributing

1. Open an **Issue** to discuss your recommendation.
2. Submit a **Pull Request** with updated configurations, scripts, or documentation.

> [!WARNING]
> **Disclaimer:** Hardening can break compatibility with legacy software, games, or peripherals. Always back up your data and understand what each change does before applying. Download tools from official sources only.
