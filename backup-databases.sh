#!/bin/bash

# Database Backup Script for MCP-XGeneOps
# This script creates backups of PostgreSQL and MongoDB databases

# Configuration
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
POSTGRES_CONTAINER="mcp-xgeneops-postgres-1"
MONGO_CONTAINER="mcp-xgeneops-mongo-1"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Starting database backups at $(date)"

# PostgreSQL Backup
echo "Backing up PostgreSQL database..."
docker exec $POSTGRES_CONTAINER pg_dump -U postgres -d userdb > "$BACKUP_DIR/postgres_backup_$DATE.sql"

if [ $? -eq 0 ]; then
    echo "✅ PostgreSQL backup completed: postgres_backup_$DATE.sql"
else
    echo "❌ PostgreSQL backup failed"
fi

# MongoDB Backup
echo "Backing up MongoDB database..."
docker exec $MONGO_CONTAINER mongodump --db contentdb --out /tmp/mongo_backup
docker cp $MONGO_CONTAINER:/tmp/mongo_backup "$BACKUP_DIR/mongo_backup_$DATE"

if [ $? -eq 0 ]; then
    echo "✅ MongoDB backup completed: mongo_backup_$DATE"
else
    echo "❌ MongoDB backup failed"
fi

# Compress backups
echo "Compressing backups..."
tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" -C "$BACKUP_DIR" "postgres_backup_$DATE.sql" "mongo_backup_$DATE"

# Clean up individual files
rm "$BACKUP_DIR/postgres_backup_$DATE.sql"
rm -rf "$BACKUP_DIR/mongo_backup_$DATE"

echo "✅ Backup completed: backup_$DATE.tar.gz"
echo "Backup location: $BACKUP_DIR/backup_$DATE.tar.gz"

# Keep only last 7 days of backups
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +7 -delete
echo "Cleaned up backups older than 7 days" 