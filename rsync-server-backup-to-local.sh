#!/bin/bash
 
USER=""
DOMAIN=""

#MUST BE ABSOLUTE PATHS

#SSH PRIVATE KEY PATH
SSH_KEY_PATH=""

#Source and destination directories
#Source is with `/`, destination is without `/`
SOURCE_DIR_DB="/migoy_backups/db_backup/"
DEST_DIR_DB="/migoy_backups/db_backup"

SOURCE_DIR_APP="/migoy_backups/app_backup/"
DEST_DIR_APP="/migoy_backups/app_backup"


#sync db backup
rsync -avziO -e "ssh -i $SSH_KEY_PATH" $USER@$DOMAIN:$SOURCE_DIR_DB $DEST_DIR_DB

if [ $? -eq 0 ]; then
    echo "Weekly database backup rsync completed successfully."
else
    echo "Error: Weekly database backup rsync failed."
fi

#sync app backup
rsync -avziO -e "ssh -i $SSH_KEY_PATH" $USER@$DOMAIN:$SOURCE_DIR_APP $DEST_DIR_APP

if [ $? -eq 0 ]; then
    echo "Weekly application backup rsync completed successfully."
else
    echo "Error: Weekly application backup rsync failed."
fi 
