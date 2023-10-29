#!/bin/bash
 
rsync -avziO -e "ssh -i /Users/fst.user/.ssh/id_ed25519" mtrinidad@san.ronins.site:~/migoy_backups/db_backup/ ~/Desktop/migoy_backups/db_backup

if [ $? -eq 0 ]; then
    echo "Weekly database backup rsync completed successfully."
else
    echo "Error: Weekly database backup rsync failed."
fi

rsync -avzO -e 'ssh -i /Users/fst.user/.ssh/id_ed25519' mtrinidad@san.ronins.site:~/migoy_backups/app_backup/ ~/Desktop/migoy_backups/app_backup

if [ $? -eq 0 ]; then
    echo "Weekly application backup rsync completed successfully."
else
    echo "Error: Weekly application backup rsync failed."
fi 
