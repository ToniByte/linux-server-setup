#!/bin/bash

# ============================================
# Server Health Check & Backup Script
# Author: Your Name
# Description: Checks system status and creates backups
# ============================================

# Configuration
BACKUP_DIR="$HOME/backups"
LOG_FILE="$HOME/logs/server-health.log"
KEEP_BACKUPS=5
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Create directories if they don't exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

log "===== Starting server health check ====="

# 1. Disk usage
log "--- Disk Usage ---"
df -h / | tail -1 | awk '{print "Root partition: "$5" used ("$3" of "$2")"}' | tee -a "$LOG_FILE"

# 2. Memory usage
log "--- Memory Usage ---"
free -h | awk '/Mem:/ {print "Memory: "$3" used of "$2}' | tee -a "$LOG_FILE"

# 3. CPU load
log "--- CPU Load ---"
uptime | awk -F'load average:' '{print "Load average:"$2}' | tee -a "$LOG_FILE"

# 4. Check SSH service
log "--- Service Status ---"
if systemctl is-active --quiet ssh; then
    log "SSH service: running"
else
    log "SSH service: NOT running!"
fi

# 5. Create backup of important directories
log "--- Creating backup ---"
BACKUP_NAME="backup_$DATE.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Backup /etc and home scripts (you can add more paths)
tar -czf "$BACKUP_PATH" /etc/ssh /etc/ufw "$HOME/scripts" 2>/dev/null

if [ -f "$BACKUP_PATH" ]; then
    log "Backup created: $BACKUP_PATH"
else
    log "Backup failed!"
fi

# 6. Remove old backups (keep only last N)
log "--- Cleaning old backups ---"
cd "$BACKUP_DIR" || exit
ls -1t backup_*.tar.gz 2>/dev/null | tail -n +$((KEEP_BACKUPS + 1)) | xargs -r rm -f
log "Kept last $KEEP_BACKUPS backups"

log "===== Health check finished ====="
echo ""