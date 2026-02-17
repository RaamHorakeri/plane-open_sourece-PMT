#!/bin/bash

echo "==============================="
echo "      Plane Auto Installer     "
echo "==============================="

read -p "Enter Domain Name (example: plane.example.com): " DOMAIN

if [ -z "$DOMAIN" ]; then
  echo "Domain cannot be empty"
  exit 1
fi

echo "Generating docker-compose.yaml ..."

cat > docker-compose.yaml <<EOF
version: '3.8'

services:

  plane-db:
    image: raamcloudops/postgres:15.7-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: plane
      POSTGRES_PASSWORD: plane
      POSTGRES_DB: plane
    volumes:
      - pgdata:/var/lib/postgresql/data

  plane-redis:
    image: raamcloudops/valkey:7.2.5-alpine
    restart: unless-stopped
    volumes:
      - redisdata:/data

  plane-mq:
    image: raamcloudops/rabbitmq:3.13.6-management-alpine
    restart: unless-stopped
    environment:
      RABBITMQ_DEFAULT_USER: plane
      RABBITMQ_DEFAULT_PASS: plane
      RABBITMQ_DEFAULT_VHOST: plane
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq

  plane-minio:
    image: raamcloudops/minio:latest
    command: server /export --console-address ":9090"
    restart: unless-stopped
    environment:
      MINIO_ROOT_USER: access-key
      MINIO_ROOT_PASSWORD: secret-key
    volumes:
      - uploads:/export
    ports:
      - "9000:9000"
      - "9090:9090"

  api:
    image: raamcloudops/plane-backend:stable
    restart: unless-stopped
    environment:
      WEB_URL: https://$DOMAIN
      CORS_ALLOWED_ORIGINS: https://$DOMAIN
      API_BASE_URL: https://$DOMAIN
      DATABASE_URL: postgresql://plane:plane@plane-db:5432/plane
      REDIS_URL: redis://plane-redis:6379
      AMQP_URL: amqp://plane:plane@plane-mq:5672/plane
      SECRET_KEY: changeme-secret
      USE_MINIO: 1
      AWS_ACCESS_KEY_ID: access-key
      AWS_SECRET_ACCESS_KEY: secret-key
      AWS_S3_ENDPOINT_URL: http://plane-minio:9000
      AWS_S3_BUCKET_NAME: uploads
    depends_on:
      - plane-db
      - plane-redis
      - plane-mq

  worker:
    image: raamcloudops/plane-backend:stable
    command: ./bin/docker-entrypoint-worker.sh
    restart: unless-stopped
    environment:
      DATABASE_URL: postgresql://plane:plane@plane-db:5432/plane
      REDIS_URL: redis://plane-redis:6379
      AMQP_URL: amqp://plane:plane@plane-mq:5672/plane
      SECRET_KEY: changeme-secret
    depends_on:
      - api

  web:
    image: raamcloudops/plane-frontend:stable
    restart: unless-stopped
    depends_on:
      - api

  space:
    image: raamcloudops/plane-space:stable
    restart: unless-stopped
    depends_on:
      - api

  admin:
    image: raamcloudops/plane-admin:stable
    restart: unless-stopped
    depends_on:
      - api

  live:
    image: raamcloudops/plane-live:stable
    restart: unless-stopped
    depends_on:
      - api

  proxy:
    image: raamcloudops/plane-proxy:stable
    restart: unless-stopped
    ports:
      - "80:80"
    environment:
      FILE_SIZE_LIMIT: 5242880
      BUCKET_NAME: uploads
    depends_on:
      - web
      - api
      - space
      - admin
      - live

volumes:
  pgdata:
  redisdata:
  uploads:
  rabbitmq_data:
EOF


echo "Pulling latest images..."
docker compose pull

echo "Starting / Updating Plane stack..."
docker compose up -d

echo "=================================="
echo " Plane Deployment Completed 🚀"
echo " Access: http://$DOMAIN"
echo "=================================="
