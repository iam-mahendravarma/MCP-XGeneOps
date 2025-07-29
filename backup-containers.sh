#!/bin/bash

# Full Container Backup Script for MCP-XGeneOps
# This script creates backups of containers and their volumes

# Configuration
BACKUP_DIR="./container-backups"
DATE=$(date +%Y%m%d_%H%M%S)
PROJECT_NAME="mcp-xgeneops"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Starting full container backup at $(date)"

# Stop containers gracefully
echo "Stopping containers..."
docker-compose down

# Backup Docker volumes
echo "Backing up Docker volumes..."

# PostgreSQL volume
docker run --rm -v mcp-xgeneops_postgres_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/postgres_volume_$DATE.tar.gz -C /data .

# MongoDB volume
docker run --rm -v mcp-xgeneops_mongo_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/mongo_volume_$DATE.tar.gz -C /data .

# Backup docker-compose.yml and configuration files
echo "Backing up configuration files..."
tar -czf "$BACKUP_DIR/config_$DATE.tar.gz" \
    docker-compose.yml \
    backend/ \
    frontend/ \
    ai-service/ \
    nginx/ \
    *.md \
    *.sh

# Create a comprehensive backup archive
echo "Creating comprehensive backup..."
tar -czf "$BACKUP_DIR/full_backup_$DATE.tar.gz" \
    -C "$BACKUP_DIR" \
    "postgres_volume_$DATE.tar.gz" \
    "mongo_volume_$DATE.tar.gz" \
    "config_$DATE.tar.gz"

# Clean up individual files
rm "$BACKUP_DIR/postgres_volume_$DATE.tar.gz"
rm "$BACKUP_DIR/mongo_volume_$DATE.tar.gz"
rm "$BACKUP_DIR/config_$DATE.tar.gz"

echo "✅ Full backup completed: full_backup_$DATE.tar.gz"
echo "Backup location: $BACKUP_DIR/full_backup_$DATE.tar.gz"

# Restart containers
echo "Restarting containers..."
docker-compose up -d

# Keep only last 30 days of full backups
find "$BACKUP_DIR" -name "full_backup_*.tar.gz" -mtime +30 -delete
echo "Cleaned up full backups older than 30 days" 