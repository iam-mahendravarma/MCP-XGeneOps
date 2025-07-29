#!/bin/bash

# Restore Script for MCP-XGeneOps
# Usage: ./restore-backup.sh <backup_file>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <backup_file>"
    echo "Example: $0 ./backups/backup_20241229_143022.tar.gz"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Starting restore from: $BACKUP_FILE"

# Stop containers
echo "Stopping containers..."
docker-compose down

# Extract backup
echo "Extracting backup..."
TEMP_DIR=$(mktemp -d)
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"

# Check if it's a database backup or full backup
if [[ "$BACKUP_FILE" == *"full_backup"* ]]; then
    echo "Detected full backup, restoring volumes and config..."
    
    # Restore PostgreSQL volume
    echo "Restoring PostgreSQL volume..."
    docker run --rm -v mcp-xgeneops_postgres_data:/data -v "$TEMP_DIR":/backup alpine sh -c "rm -rf /data/* && tar -xzf /backup/postgres_volume_*.tar.gz -C /data"
    
    # Restore MongoDB volume
    echo "Restoring MongoDB volume..."
    docker run --rm -v mcp-xgeneops_mongo_data:/data -v "$TEMP_DIR":/backup alpine sh -c "rm -rf /data/* && tar -xzf /backup/mongo_volume_*.tar.gz -C /data"
    
    # Restore configuration files
    echo "Restoring configuration files..."
    tar -xzf "$TEMP_DIR/config_*.tar.gz" -C . --strip-components=0
    
else
    echo "Detected database backup, restoring databases..."
    
    # Restore PostgreSQL
    echo "Restoring PostgreSQL database..."
    docker-compose up -d postgres
    sleep 10  # Wait for PostgreSQL to start
    
    # Drop and recreate database
    docker exec mcp-xgeneops-postgres-1 psql -U postgres -c "DROP DATABASE IF EXISTS userdb;"
    docker exec mcp-xgeneops-postgres-1 psql -U postgres -c "CREATE DATABASE userdb;"
    
    # Restore from backup
    docker exec -i mcp-xgeneops-postgres-1 psql -U postgres -d userdb < "$TEMP_DIR/postgres_backup_*.sql"
    
    # Restore MongoDB
    echo "Restoring MongoDB database..."
    docker-compose up -d mongo
    sleep 10  # Wait for MongoDB to start
    
    # Copy backup to container and restore
    docker cp "$TEMP_DIR/mongo_backup_*" mcp-xgeneops-mongo-1:/tmp/
    docker exec mcp-xgeneops-mongo-1 mongorestore --db contentdb /tmp/mongo_backup_*/contentdb/
fi

# Clean up
rm -rf "$TEMP_DIR"

# Start all containers
echo "Starting all containers..."
docker-compose up -d

echo "✅ Restore completed successfully!"
echo "Your application should now be running with the restored data." 