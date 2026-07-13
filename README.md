# Psiphon Client Manager

A lightweight and easy-to-use **Psiphon Client Manager** for Linux servers.

It automatically installs, manages, and runs multiple Psiphon client instances, exposing local **SOCKS5** and **HTTP** proxy ports for use with **Xray**, **V2Ray**, **Sing-box**, web browsers, and other SOCKS5-compatible applications.

---

## Features

- One-command installation
- Simple update process
- Single and Multi Country modes
- Local SOCKS5 and HTTP proxy support
- Lightweight and optimized
- Supports Ubuntu and Debian VPS
- Compatible with Xray, V2Ray, and Sing-box outbound routing
- Automatic client management

---

# Installation

## Single Mode

Installs a single Psiphon client.

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Thiyansa/psiphon-client/main/psiphon-client.sh)
```

---

## Multi Mode

Installs multiple Psiphon clients using different country exit nodes.

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Thiyansa/psiphon-client/main/all.sh)
```

---

# Usage

After installation, start the manager with:

```bash
psiphon-client
```

---

# Local Proxy Ports

## Single Mode

| Protocol | Address |
|----------|---------|
| SOCKS5 | `127.0.0.1:1081` |
| HTTP | `127.0.0.1:8081` |

---

## Multi Mode

Each country is assigned its own local SOCKS5 proxy port.

| Country | Tag | SOCKS5 Port |
|---------|:---:|------------:|
| Austria | AT | 1081 |
| Belgium | BE | 1082 |
| Canada | CA | 1083 |
| Switzerland | CH | 1084 |
| Czech Republic | CZ | 1085 |
| Germany | DE | 1086 |
| Denmark | DK | 1087 |
| Spain | ES | 1088 |
| Finland | FI | 1089 |
| France | FR | 1090 |
| United Kingdom | GB | 1091 |
| Ireland | IE | 1092 |
| India | IN | 1093 |
| Italy | IT | 1094 |
| Japan | JP | 1095 |
| Netherlands | NL | 1096 |
| Norway | NO | 1097 |
| Poland | PL | 1098 |
| Romania | RO | 1099 |
| Serbia | RS | 1100 |
| Sweden | SE | 1101 |
| Singapore | SG | 1102 |
| United States | US | 1103 |

---

# Xray / V2Ray Configuration

Example outbound configuration:

```json
{
  "protocol": "socks",
  "settings": {
    "servers": [
      {
        "address": "127.0.0.1",
        "port": 1081
      }
    ]
  },
  "tag": "AT"
}
```

Replace the port with the appropriate local proxy port for the desired country.

Complete outbound configurations for all supported countries are available here.

👉 **[View Full Outbound Configuration](OUTBOUNDS.md)**

# Notes

- Supports HTTP and TLS traffic.
- UDP traffic is **not** supported.
- All proxy services listen on `127.0.0.1` only.
- Suitable for use as an outbound proxy with Xray, V2Ray, Sing-box, and similar software.

---

# Requirements

- Ubuntu 20.04 or later
- Debian 11 or later
- curl
- systemd
- Root privileges

---

# Contributing

Contributions are welcome.

If you discover a bug or have a feature request, please open an issue or submit a pull request.

---

# Support

If you find this project useful, please consider giving it a **GitHub Star**.

Your support helps improve and maintain the project.

---

# License

Released under the **MIT License**.

---

<div align="center">

## Developed by

### **Thiyansa**

Built for the open-source community.

</div>
