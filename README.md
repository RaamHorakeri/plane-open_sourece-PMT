# plane-open_sourece-PMT

🚀 Plane Deployment Guide

This guide explains how to deploy Plane using the deploy-plane.sh script.

The script will:

Ask only for your Domain Name

Automatically generate docker-compose.yaml

Pull images from raamcloudops

Start or update the containers

📋 Prerequisites

Make sure your server has:

Docker installed

Docker Compose (v2 recommended)

Ports 80, 9000, 9090 open (if required)

Check Docker:

docker --version
docker compose version
📦 Step 1 — Upload Script

Place deploy-plane.sh in your server directory:

mkdir plane-app
cd plane-app
nano deploy-plane.sh

Paste the script content and save.

🔐 Step 2 — Make Script Executable
chmod +x deploy-plane.sh
🚀 Step 3 — Run Deployment
./deploy-plane.sh

It will prompt:

Enter Domain Name (example: plane.example.com):
Example:
Enter Domain Name (example: plane.example.com): plane.mycompany.com
⚙️ What Happens Automatically

The script will:

Generate docker-compose.yaml

Pull images from raamcloudops

Create required volumes

Start all Plane services

Configure internal database, Redis, RabbitMQ, and MinIO

🌐 Step 4 — Access Application

Open your browser:

http://your-domain
Example:
http://plane.mycompany.com
🔄 Updating Plane

To update containers later:

./deploy-plane.sh

It will:

Recreate docker-compose.yaml

Pull latest images

Restart services safely

🛑 Stop Plane
docker compose down
📂 View Logs
docker compose logs -f
🧹 Remove Everything (Including Data)

⚠ This will delete all data permanently.

docker compose down -v
📊 Check Running Containers

docker ps
