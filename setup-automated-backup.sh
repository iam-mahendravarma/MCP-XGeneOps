#!/bin/bash

# Setup Automated Backup Script
# This script sets up automated daily backups using cron

# Make backup scripts executable
chmod +x backup-databases.sh
chmod +x backup-containers.sh
chmod +x restore-backup.sh

# Get the current directory
CURRENT_DIR=$(pwd)

# Create cron job for daily database backup (2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * cd $CURRENT_DIR && ./backup-databases.sh >> ./backups/backup.log 2>&1") | crontab -

# Create cron job for weekly full backup (Sunday 3 AM)
(crontab -l 2>/dev/null; echo "0 3 * * 0 cd $CURRENT_DIR && ./backup-containers.sh >> ./container-backups/full_backup.log 2>&1") | crontab -

echo "✅ Automated backup setup completed!"
echo ""
echo "Backup Schedule:"
echo "- Daily database backup: 2:00 AM"
echo "- Weekly full backup: Sunday 3:00 AM"
echo ""
echo "Backup locations:"
echo "- Database backups: ./backups/"
echo "- Full backups: ./container-backups/"
echo "- Log files: backup.log and full_backup.log"
echo ""
echo "To view current cron jobs: crontab -l"
echo "To edit cron jobs: crontab -e" 