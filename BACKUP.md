# Backup and Restore Guide for MCP-XGeneOps

This guide explains how to backup and restore your Docker containers and databases.

## Quick Start

### 1. Setup Automated Backups
```bash
chmod +x setup-automated-backup.sh
./setup-automated-backup.sh
```

### 2. Manual Database Backup
```bash
chmod +x backup-databases.sh
./backup-databases.sh
```

### 3. Manual Full Backup
```bash
chmod +x backup-containers.sh
./backup-containers.sh
```

### 4. Restore from Backup
```bash
chmod +x restore-backup.sh
./restore-backup.sh ./backups/backup_20241229_143022.tar.gz
```

## Backup Types

### 1. Database Backup (`backup-databases.sh`)
- **What it backs up**: PostgreSQL and MongoDB databases
- **Frequency**: Daily (automated) or manual
- **Location**: `./backups/`
- **Retention**: 7 days
- **Size**: Small (only data)

### 2. Full Backup (`backup-containers.sh`)
- **What it backs up**: All containers, volumes, and configuration
- **Frequency**: Weekly (automated) or manual
- **Location**: `./container-backups/`
- **Retention**: 30 days
- **Size**: Large (complete system)

## Backup Contents

### Database Backup Includes:
- PostgreSQL database (`userdb`)
- MongoDB database (`contentdb`)
- Compressed and timestamped

### Full Backup Includes:
- PostgreSQL data volume
- MongoDB data volume
- All configuration files
- Docker Compose files
- Application source code

## Automated Schedule

- **Daily Database Backup**: 2:00 AM
- **Weekly Full Backup**: Sunday 3:00 AM
- **Logs**: `backup.log` and `full_backup.log`

## Manual Backup Commands

### Database Backup Only
```bash
./backup-databases.sh
```

### Full System Backup
```bash
./backup-containers.sh
```

### Restore Database Backup
```bash
./restore-backup.sh ./backups/backup_YYYYMMDD_HHMMSS.tar.gz
```

### Restore Full Backup
```bash
./restore-backup.sh ./container-backups/full_backup_YYYYMMDD_HHMMSS.tar.gz
```

## Backup Locations

```
MCP-XGeneOps/
├── backups/                    # Database backups
│   ├── backup_20241229_143022.tar.gz
│   └── backup.log
├── container-backups/          # Full system backups
│   ├── full_backup_20241229_143022.tar.gz
│   └── full_backup.log
└── [backup scripts]
```

## Monitoring Backups

### Check Backup Status
```bash
# View recent backups
ls -la backups/
ls -la container-backups/

# Check backup logs
tail -f backups/backup.log
tail -f container-backups/full_backup.log
```

### Verify Backup Integrity
```bash
# Test database backup
tar -tzf backups/backup_YYYYMMDD_HHMMSS.tar.gz

# Test full backup
tar -tzf container-backups/full_backup_YYYYMMDD_HHMMSS.tar.gz
```

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x *.sh
   ```

2. **Container Not Found**
   ```bash
   docker-compose ps
   # Ensure containers are running
   ```

3. **Backup Fails**
   ```bash
   # Check container logs
   docker-compose logs postgres
   docker-compose logs mongo
   ```

4. **Restore Fails**
   ```bash
   # Stop all containers first
   docker-compose down
   # Then run restore
   ```

## Best Practices

1. **Test Restores**: Regularly test restore procedures
2. **Offsite Backup**: Copy backups to external storage
3. **Monitor Space**: Ensure sufficient disk space
4. **Verify Backups**: Check backup integrity regularly
5. **Document Changes**: Keep track of configuration changes

## Emergency Recovery

### Complete System Recovery
```bash
# 1. Stop all containers
docker-compose down

# 2. Restore from full backup
./restore-backup.sh ./container-backups/full_backup_YYYYMMDD_HHMMSS.tar.gz

# 3. Start containers
docker-compose up -d
```

### Database-Only Recovery
```bash
# 1. Restore database backup
./restore-backup.sh ./backups/backup_YYYYMMDD_HHMMSS.tar.gz

# 2. Restart application containers
docker-compose restart backend ai-service
```

## Security Considerations

- Backup files contain sensitive data
- Store backups securely
- Use encryption for offsite backups
- Limit access to backup files
- Regularly rotate backup credentials

## Maintenance

### Cleanup Old Backups
```bash
# Manual cleanup (already automated)
find backups/ -name "backup_*.tar.gz" -mtime +7 -delete
find container-backups/ -name "full_backup_*.tar.gz" -mtime +30 -delete
```

### Update Backup Scripts
```bash
# Review and update scripts as needed
nano backup-databases.sh
nano backup-containers.sh
``` 