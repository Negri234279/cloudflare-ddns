# 🌐 Cloudflare DDNS Docker

Dynamic DNS (DDNS) updater for **Cloudflare**, packaged as a **multi-architecture Docker image**, optimized for **Raspberry Pi 3, 4, and 5** as well as Linux x86_64 systems.

This project is designed to automatically keep a Cloudflare DNS (A) record updated with your public IP address, making it ideal for game servers, homelabs, and connections without a static IP.

---

## ✨ Features

* ✅ Uses the **official Cloudflare API** (PATCH `/dns_records`)
* ✅ **Multi-arch Docker**:

  * `linux/amd64` (PC / VPS)
  * `linux/arm/v7` (Raspberry Pi 3)
  * `linux/arm64` (Raspberry Pi 4 and 5)
* ✅ **Automatic semantic versioning** (Semantic Release)
* ✅ Automatic publishing to:

  * Docker Hub
  * GitHub Container Registry (GHCR)
* ✅ Logs with **date and time (Europe/Madrid)**
* ✅ **Non-root user** (improved security)
* ✅ No calls to Cloudflare if the IP has not changed
* ✅ Very lightweight (Alpine Linux)

---

## 📦 Available Images

### Docker Hub

```bash
docker pull negrii/cloudflare-ddns:latest
```

### GitHub Container Registry

```bash
docker pull ghcr.io/negri234279/cloudflare-ddns:latest
```

Also available by version:

```text
v1.0.0
v1.0.1
v1.1.0
```

---

## 🚀 Quick start with Docker Compose

### 1️⃣ Create `.env`

```env
CF_API_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
CF_ZONE_ID=yyyyyyyyyyyyyyyyyyyyyyyy
CF_DOMAIN=foo.bar.es
CF_RECORD_TYPE=A
CF_TTL=1
CF_PROXIED=false
CF_INTERVAL=300
TZ=Europe/Madrid
```

> 💡 `CF_TTL=1` **TTL automático** en Cloudflare.

---

### 2️⃣ `docker-compose.yml`

```yaml
services:
  cloudflare-ddns:
    image: negrii/cloudflare-ddns:latest
    container_name: cloudflare-ddns
    env_file:
      - .env
    restart: unless-stopped
```

---

### 3️⃣ Start service

```bash
docker compose up -d
```

View logs:

```bash
docker logs -f cloudflare-ddns
```

---

## 📝 Example of logs

```text
2025-03-12 02:20:43 🚀 Cloudflare DDNS running on armv7l (TZ=Europe/Madrid)
2025-03-12 02:20:43 ⏱️ Interval: 300s
2025-03-12 02:25:43 ℹ️ IP unchanged (203.0.113.45)
2025-03-12 02:30:44 🔄 IP changed: 203.0.113.45 → 203.0.113.99
2025-03-12 02:30:45 ✅ DNS updated to 203.0.113.99
```

---

## 🔑 How to obtain Cloudflare data

### 🔸 API Token

Create an **API Token** with permissions:

* Zone → DNS → Edit

---

### 🔸 Zone ID

Cloudflare Dashboard → your domain `bar.es` → **Overview** → Zone ID

---

### 🔸 DNS Record ID
It is not necessary to manually obtain the DNS Record ID.

The container will automatically retrieve the **DNS Record ID** from Cloudflare using the domain and zone information provided on first run, and store it internally for future updates.

---

## 🧠 Environment variables

| Variable           | Description                                |
| ------------------ | ------------------------------------------ |
| `CF_API_TOKEN`     | Cloudflare token                           |
| `CF_ZONE_ID`       | Zone ID                                    |
| `CF_DOMAIN`        | Domain or subdomain                        |
| `CF_RECORD_TYPE`   | DNS record type (default A)                |
| `CF_TTL`           | TTL (default `1` = automatic)              |
| `CF_PROXIED`       | `true` / `false` (default false)           |
| `CF_INTERVAL`      | Interval in seconds (default 300)          |
| `TZ`               | Time zone (default `Europe/Madrid`)        |

---

## 🏗️ Development

```bash
docker compose -f 'docker-compose.dev.yml' up -d --build
```

---

## 🔄 CI/CD

This project uses GitHub Actions for:

* Automatic versioning with semantic-release
* Creation of GitHub Releases
* Multi-arch builds with Docker Buildx
* Automatic push to Docker Hub and GHCR

Each push to main generates a new version if the commits require it.

---

## 🔐 Security

* Container run as **non-root user**
* Cloudflare token never stored in the image
* Exclusive use of HTTPS and official API

---

## 👤 Author

**Negrii**
🔗 [https://github.com/Negri234279](https://github.com/Negri234279)

---

## 📄 License

MIT License

---

## ⭐ Contributions

Pull requests and suggestions are welcome 🙌

If you find this project useful, leave a ⭐ on GitHub