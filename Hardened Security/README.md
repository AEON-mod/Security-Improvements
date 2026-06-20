# 🛡️ The Ultimate PC Hardening Suite

> **Proactive Defense | Network Transparency | Privacy Sovereignty**

Welcome to the **Ultimate PC Hardening Suite**. This repository is a curated collection of industry-leading configurations, tools, and native settings designed to transform standard operating system installations into fortified digital fortresses.

Rather than relying on a single "all-in-one" solution that often fails to excel in every category, this suite utilizes **Defense in Depth**—layering specialized security controls to safeguard your files, monitor network traffic, seal system vulnerabilities, and eliminate telemetry.

---

## 🗺️ Choose Your Platform

Select your operating system to view the specialized hardening guide, curated tool stack, and deployment strategy:

| Platform | Hardening Focus | Guide Link |
| :--- | :--- | :--- |
| **🏁 Windows** | Telemetry removal, exploit protection, active defense | **[Windows Hardening Guide](README_windows.md)** |
| **🐧 Linux** | Kernel sysctl hardening, app sandboxing, network auditing | **[Linux Hardening Guide](README_linux.md)** |
| **🍎 macOS** | Outbound firewalls, persistence auditing, native protection | **[macOS Hardening Guide](README_macos.md)** |

---

## 🧠 The Security Philosophy

Our methodology relies on four core pillars:

1. **Defense in Depth:** If one security layer is bypassed (e.g., your browser is exploited), another layer (e.g., your application firewall or system sandbox) must intercept the attack.
2. **Zero Trust Architecture:** Do not trust applications or network requests by default. Every app must justify its internet usage and system permissions.
3. **Telemetry & Privacy Sovereignty:** Modern operating systems are rife with diagnostics, tracking, and telemetry. True security requires blocking outbound diagnostic reporting.
4. **Simplification & Minimalism:** Uninstall unnecessary software, disable unused features, and reduce the attack surface of your operating system.

---

## 🌐 The Browser Security Stack (Universal)

Regardless of the operating system you choose, the web browser remains the primary entry point for modern cyber threats. We recommend hardening your browser with this baseline stack:

### 1. [uBlock Origin](https://ublockorigin.com/)
*   **Role:** Content Filtering & Script Blocking.
*   **Why:** While system-level firewalls block connections, uBlock Origin cleans up the web inside your browser. It blocks malicious scripts, prevents "malvertising" attacks, and strips away resource-intensive tracking bloat.

### 2. [Bitwarden](https://bitwarden.com/)
*   **Role:** Identity & Credential Vault.
*   **Why:** Your PC's security is moot if your online accounts are compromised. Bitwarden manages high-entropy, unique passwords for every service, preventing credential stuffing attacks.

### 3. [FastForward](https://fastforward.team/)
*   **Role:** Link Shortener & Tracker Bypass.
*   **Why:** Automatically bypasses intermediate tracking links, redirect sites (e.g., linkvertise, adf.ly), and countdown screens. This reduces exposure to drive-by downloads and IP logs.

---

## 🤝 Contributing

Contributions are welcome! If you have a registry tweak, kernel parameter optimization, or a security utility to suggest:
1. Open an Issue to discuss your recommendation.
2. Submit a Pull Request with updated configurations or markdown documentation.

> [!WARNING]
> **Disclaimer:** Hardening your operating system can occasionally break compatibility with certain software, services, or games. Always backup your important data and understand the changes you are applying. Download all suggested software from official sites only.
