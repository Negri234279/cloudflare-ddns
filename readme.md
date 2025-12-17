# 🌐 Cloudflare DDNS Docker

Actualizador dinámico de DNS (DDNS) para **Cloudflare**, empaquetado en una **imagen Docker multi‑arquitectura**, optimizada para **Raspberry Pi 3, 4 y 5** y sistemas Linux x86_64.

Este proyecto está pensado para mantener actualizado automáticamente un registro DNS (A) de Cloudflare con tu IP pública, ideal para servidores de juegos, homelabs y conexiones sin IP estática.

---

## ✨ Características

* ✅ Usa **API oficial de Cloudflare** (PATCH `/dns_records`)
* ✅ **Multi‑arch Docker**:

  * `linux/amd64` (PC / VPS)
  * `linux/arm/v7` (Raspberry Pi 3)
  * `linux/arm64` (Raspberry Pi 4 y 5)
* ✅ **Versionado semántico automático** (Semantic Release)
* ✅ Publicación automática en:

  * Docker Hub
  * GitHub Container Registry (GHCR)
* ✅ Logs con **fecha y hora (Europe/Madrid)**
* ✅ Usuario **no root** (mejor seguridad)
* ✅ No hace llamadas a Cloudflare si la IP no ha cambiado
* ✅ Muy ligero (Alpine Linux)

---

## 📦 Imágenes disponibles

### Docker Hub

```bash
docker pull negrii/cloudflare-ddns:latest
```

### GitHub Container Registry

```bash
docker pull ghcr.io/negrii/cloudflare-ddns:latest
```

También disponibles por versión:

```text
v1.0.0
v1.1.0
v1.2.3
```

---

## 🚀 Uso rápido con Docker Compose

### 1️⃣ Crear `.env`

```env
CF_API_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx
CF_ZONE_ID=yyyyyyyyyyyyyyyyyyyyyyyy
CF_DNS_RECORD_ID=zzzzzzzzzzzzzzzzzz
CF_DOMAIN=foo.bar.es
CF_TTL=1
CF_PROXIED=false
CF_INTERVAL=300
```

> 💡 `CF_TTL=1` significa **TTL automático** en Cloudflare.

---

### 2️⃣ `docker-compose.yml`

```yaml
version: "3.8"

services:
  cloudflare-ddns:
    image: negrii/cloudflare-ddns:latest
    container_name: cloudflare-ddns
    env_file:
      - .env
    environment:
      - TZ=Europe/Madrid
    restart: unless-stopped
```

---

### 3️⃣ Levantar el servicio

```bash
docker compose up -d
```

Ver logs:

```bash
docker logs -f cloudflare-ddns
```

---

## 📝 Ejemplo de logs

```text
2025-03-12 02:20:43 🚀 Cloudflare DDNS running on armv7l (TZ=Europe/Madrid)
2025-03-12 02:20:43 ⏱️ Interval: 300s
2025-03-12 02:25:43 ℹ️ IP unchanged (203.0.113.45)
2025-03-12 02:30:44 🔄 IP changed: 203.0.113.45 → 203.0.113.99
2025-03-12 02:30:45 ✅ DNS updated to 203.0.113.99
```

---

## 🔑 Cómo obtener los datos de Cloudflare

### 🔸 API Token

Crea un **API Token** con permisos:

* Zone → DNS → Edit

---

### 🔸 Zone ID

Cloudflare Dashboard → tu dominio → **Overview** → Zone ID

---

### 🔸 DNS Record ID

```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$CF_DOMAIN" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json"
```

Copia el campo:

```json
result[0].id
```

---

## 🧠 Variables de entorno

| Variable           | Descripción                                |
| ------------------ | ------------------------------------------ |
| `CF_API_TOKEN`     | Token de Cloudflare                        |
| `CF_ZONE_ID`       | ID de la zona                              |
| `CF_DNS_RECORD_ID` | ID del registro DNS                        |
| `CF_DOMAIN`        | Dominio o subdominio                       |
| `CF_TTL`           | TTL (por defecto `1` = automático)         |
| `CF_PROXIED`       | `true` / `false` (por defecto false)       |
| `CF_INTERVAL`      | Intervalo en segundos (por defecto 300)    |
| `TZ`               | Zona horaria (por defecto `Europe/Madrid`) |

---

## 🏗️ Desarrollo

```bash
docker compose up --build
```

Rebuild sin cache:

```bash
docker compose build --no-cache
```

---

## 🔄 CI/CD

Este proyecto utiliza **GitHub Actions** para:

* Versionado automático con **semantic-release**
* Creación de **GitHub Releases**
* Build **multi‑arch** con Docker Buildx
* Push automático a Docker Hub y GHCR

Cada `push` a `main` genera una nueva versión si los commits lo requieren.

---

## 🔐 Seguridad

* Contenedor ejecutado como **usuario no root**
* Token de Cloudflare nunca se guarda en la imagen
* Uso exclusivo de HTTPS y API oficial

---

## 👤 Autor

**Negrii**
🔗 [https://github.com/Negri234279](https://github.com/Negri234279)

---

## 📄 Licencia

MIT License

---

## ⭐ Contribuciones

Pull Requests y sugerencias son bienvenidas 🙌

Si este proyecto te resulta útil, deja una ⭐ en GitHub
