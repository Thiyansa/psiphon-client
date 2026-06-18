#  Psiphon Client Manager

A simple and lightweight Psiphon Client Manager for Linux servers.

##  Installation / Update

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Thiyansa/psiphon-client/main/psiphon-client.sh)
```

##  Run

```bash
psiphon-client
```

##  Outbound Proxies

After connecting, the following local proxies will be available:

| Protocol | Address          |
| -------- | ---------------- |
| SOCKS5   | `127.0.0.1:1081` |
| HTTP     | `127.0.0.1:8081` |

## ⚠️ Important Notes

* Psiphon proxy supports **HTTP** and **TLS** traffic only.
* UDP traffic is **not supported**.
* Make sure your applications are configured to use the appropriate proxy port.

## ✨ Features

* Easy installation and updates
* Automatic Psiphon client management
* SOCKS5 and HTTP proxy support
* Lightweight and fast
* Suitable for VPS and dedicated servers

---

💻 Developed by **Thiyansa**
