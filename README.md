# plane-open_sourece-PMT

# 🚀 Plane Deployment Guide

This document explains how to deploy **Plane** using the `deploy-plane.sh` script.

The installer will:

- ✅ Ask only for your **Domain Name**
- ✅ Automatically generate `docker-compose.yaml`
- ✅ Pull images from `raamcloudops`
- ✅ Start or update the containers

---

# 📋 Prerequisites

Make sure your server has:

- Docker installed
- Docker Compose v2
- Ports **80**, **9000**, and **9090** open (if required)

Check Docker installation:

```bash
docker --version
docker compose version
```

---

# 📦 Step 1 — Prepare Deployment Directory

```bash
mkdir plane
cd plane
```

Copy `deploy-plane.sh` into this directory.

---

# 🔐 Step 2 — Make Script Executable

```bash
chmod +x deploy-plane.sh
```

---

# 🚀 Step 3 — Run Deployment

```bash
./deploy-plane.sh
```

You will be prompted:

```
Enter Domain Name (example: plane.example.com):
```

### Example

```
Enter Domain Name (example: plane.example.com): plane.mycompany.com
```

---

# ⚙️ What Happens Automatically

The script will:

1. Generate `docker-compose.yaml`
2. Pull images from `raamcloudops`
3. Create required Docker volumes
4. Start all Plane services
5. Configure internal:
   - PostgreSQL
   - Redis
   - RabbitMQ
   - MinIO

---

# 🌐 Step 4 — Access Application

Open your browser:

```
http://your-domain
```

### Example

```
http://plane.mycompany.com
```

---

# 🔄 Updating Plane

To update the application later:

```bash
./deploy-plane.sh
```

This will:

- Regenerate `docker-compose.yaml`
- Pull latest images
- Restart services safely

---

# 🛑 Stop Plane

```bash
docker compose down
```

---

# 📂 View Logs

```bash
docker compose logs -f
```

---

# 🧹 Remove Everything (Including Data)

⚠ WARNING: This deletes all data permanently.

```bash
docker compose down -v
```

---

# 📊 Check Running Containers

```bash
docker ps
```

---

# 📦 Images Used

| Component | Image Source |
|-----------|-------------|
| Backend   | raamcloudops/plane-backend |
| Frontend  | raamcloudops/plane-frontend |
| Database  | raamcloudops/postgres |
| Redis     | raamcloudops/valkey |
| RabbitMQ  | raamcloudops/rabbitmq |
| Storage   | raamcloudops/minio |

---

# 🎯 Notes

- Default internal credentials are auto-configured.
- For production use, update secrets properly.
- SSL can be configured using a reverse proxy like Nginx.

---

# ✅ Deployment Summary

You now have a fully working Plane instance deployed using:

- Single script
- Automatic configuration
- Custom Docker images
- Minimal setup steps

---

Happy Deploying 🚀
