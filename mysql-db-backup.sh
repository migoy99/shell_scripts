#!/bin/bash

DB_HOST=""
DB_USER=""
DB_PASS=""
DB_NAME=""
#must be absolute path
BACKUP_DIR="/migoy_backups/db_backup"

DATE_FORMAT=$(date +\%Y-\%m-\%d-\%H\%M\%S)
BACKUP_FILENAME="$BACKUP_DIR/$DATE_FORMAT.sql"
COMPRESSED_FILENAME="$DATE_FORMAT"

mysqldump --no-tablespaces -h$DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILENAME
cd /migoy_backups/db_backup
tar -czvf $COMPRESSED_FILENAME.tgz $BACKUP_FILENAME
if [ $? -eq 0 ]; then
  #tar -czvf "$COMPRESSED_FILENAME.tgz" -C "$BACKUP_DIR" "$BACKUP_FILENAME.sql"
  rm "$BACKUP_FILENAME"
  echo "Weekly MySQL database backup completed successfully."
else
  echo "Error: Weekly MySQL database backup failed."
fi
