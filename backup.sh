#!/bin/bash

source .env

# Define the log function
log() {
  echo "[$(date)] $*"
}


# --- CONFIGURATION ---
NAS_PATH="//127.0.0.1/shared"
MOUNT_POINT="/mnt/shared"
BACKUP_DEST="/mnt/shared/backup"
TEMP_BACKUP_DIR="docker-backup-$(date '+%Y-%m-%d')"
LOG_FILE="docker-backup.log"
FINAL_ARCHIVE="docker-config-backup-$(date '+%Y-%m-%d').tar.gz"
touch $LOG_FILE

# 1. Ensure NAS is mounted
if ! mountpoint -q "$MOUNT_POINT"; then
  sudo mount -t cifs -o username="$USERNAME",uid=1000,gid=1000,vers=3.0 "$NAS_PATH" "$MOUNT_POINT"
fi

if [ ! -d "$BACKUP_DEST" ]; then
  log "NAS backup directory not found" | tee -a "$LOG_FILE"
  TEMP_BACKUP_DIR="$TEMP_BACKUP_DIR-FAILED"
  exit 1
fi

# 2. Create local temp folder
mkdir $TEMP_BACKUP_DIR

# Push current timestamp
log "--- Backup started at $(date) ---" >> "$LOG_FILE"

# 3. Stop services
docker compose stop >> "$LOG_FILE" 2>&1

# 4. Sync data into the temp folder
# We use -R to maintain the directory structure in the archive
while read -r stack_dir; do
    log "Syncing: $stack_dir" >> "$LOG_FILE"
    rsync -avz --exclude-from="exclude-backup-list" "$stack_dir" "$TEMP_BACKUP_DIR/" >> "$LOG_FILE" 2>&1
done < <(find . -name "docker-compose.yaml" -not -path "./$TEMP_BACKUP_DIR/*" -exec dirname {} \;)

# 5. Restart services immediately to minimize downtime
docker compose start >> "$LOG_FILE" 2>&1

# 6. Compress the local temp folder
log "Compressing backup..." >> "$LOG_FILE"
tar -czvf "$FINAL_ARCHIVE" "$TEMP_BACKUP_DIR" "$LOG_FILE"

# 7. Move to NAS and cleanup
mv "$FINAL_ARCHIVE" "$BACKUP_DEST"
rm -rf "$TEMP_BACKUP_DIR"
rm "$LOG_FILE"

log "--- Backup finished and moved to NAS at $(date) ---"
