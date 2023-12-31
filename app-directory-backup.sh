#!/bin/bash

#MUST BE ABSOLUTE PATHS

#Source and destination directories
APP_DIR="/mtrinidad.ronins.site"
BACKUP_DIR="/migoy_backups/app_backup"

DATE_FORMAT=$(date +\%Y-\%m-\%d-\%H\%M\%S)
BACKUP_FILENAME="$BACKUP_DIR/app_backup-$DATE_FORMAT.tgz"

tar -czvf "$BACKUP_FILENAME" -C "$(dirname $APP_DIR)" "$(basename $APP_DIR)"

# Check the exit status of the tar command
if [ $? -eq 0 ]; then
  echo "App directory backup completed successfully: $BACKUP_FILENAME"
else
  echo "Error: App directory backup failed."
fi
