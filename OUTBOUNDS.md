# Psiphon Client Outbound Configurations

This page contains ready-to-use **Xray / V2Ray SOCKS outbound** configurations for every supported Psiphon country.

---

## Usage

Copy the outbound you need and paste it into your **Xray**, **V2Ray**, or **Sing-box** configuration.

Each outbound listens on **127.0.0.1**.

---

## Available Countries

| Country | Tag | Port |
|---------|-----|------|
| 🇦🇹 Austria | AT | 1081 |
| 🇧🇪 Belgium | BE | 1082 |
| 🇨🇦 Canada | CA | 1083 |
| 🇨🇭 Switzerland | CH | 1084 |
| 🇨🇿 Czech Republic | CZ | 1085 |
| 🇩🇪 Germany | DE | 1086 |
| 🇩🇰 Denmark | DK | 1087 |
| 🇪🇸 Spain | ES | 1088 |
| 🇫🇮 Finland | FI | 1089 |
| 🇫🇷 France | FR | 1090 |
| 🇬🇧 United Kingdom | GB | 1091 |
| 🇮🇪 Ireland | IE | 1092 |
| 🇮🇳 India | IN | 1093 |
| 🇮🇹 Italy | IT | 1094 |
| 🇯🇵 Japan | JP | 1095 |
| 🇳🇱 Netherlands | NL | 1096 |
| 🇳🇴 Norway | NO | 1097 |
| 🇵🇱 Poland | PL | 1098 |
| 🇷🇴 Romania | RO | 1099 |
| 🇷🇸 Serbia | RS | 1100 |
| 🇸🇪 Sweden | SE | 1101 |
| 🇸🇬 Singapore | SG | 1102 |
| 🇺🇸 United States | US | 1103 |

---

## Configuration

```json
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1081,
          "users": []
        }
      ]
    },
    "tag": "AT"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1082,
          "users": []
        }
      ]
    },
    "tag": "BE"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1083,
          "users": []
        }
      ]
    },
    "tag": "CA"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1084,
          "users": []
        }
      ]
    },
    "tag": "CH"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1085,
          "users": []
        }
      ]
    },
    "tag": "CZ"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1086,
          "users": []
        }
      ]
    },
    "tag": "DE"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1087,
          "users": []
        }
      ]
    },
    "tag": "DK"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1088,
          "users": []
        }
      ]
    },
    "tag": "ES"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1089,
          "users": []
        }
      ]
    },
    "tag": "FI"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1090,
          "users": []
        }
      ]
    },
    "tag": "FR"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1091,
          "users": []
        }
      ]
    },
    "tag": "GB"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1092,
          "users": []
        }
      ]
    },
    "tag": "IE"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1093,
          "users": []
        }
      ]
    },
    "tag": "IN"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1094,
          "users": []
        }
      ]
    },
    "tag": "IT"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1095,
          "users": []
        }
      ]
    },
    "tag": "JP"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1096,
          "users": []
        }
      ]
    },
    "tag": "NL"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1097,
          "users": []
        }
      ]
    },
    "tag": "NO"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1098,
          "users": []
        }
      ]
    },
    "tag": "PL"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1099,
          "users": []
        }
      ]
    },
    "tag": "RO"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1100,
          "users": []
        }
      ]
    },
    "tag": "RS"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1101,
          "users": []
        }
      ]
    },
    "tag": "SE"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1102,
          "users": []
        }
      ]
    },
    "tag": "SG"
  },
  {
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1103,
          "users": []
        }
      ]
    },
    "tag": "US"
  }
```

---

## Back

**← [Return to Main README](README.md)**
