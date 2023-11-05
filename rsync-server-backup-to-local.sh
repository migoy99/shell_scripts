#!/bin/bash
 
USER=""
DOMAIN=""

#must be absolute paths
#SSH PRIVATE KEY
SSH_KEY_PATH=""

SOURCE_DIR_DB="/home/mtrinidad/migoy_backups/db_backup/"
DEST_DIR_DB="/Users/fst.user/Desktop/migoy_backups/db_backup"

SOURCE_DIR_APP="/home/mtrinidad/migoy_backups/app_backup/"
DEST_DIR_APP="/Users/fst.user/Desktop/migoy_backups/app_backup"


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
