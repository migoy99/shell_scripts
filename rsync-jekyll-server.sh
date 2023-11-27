USER="mtrinidad"
DOMAIN="san.ronins.site"

#must be absolute paths
#SSH PRIVATE KEY
SSH_KEY_PATH="/home/migoy99/.ssh/migoy_lnx_pc"

SOURCE_DIR_JK="/home/migoy99/Desktop/miguel_blog/_site/"
DEST_DIR_JK="/home/mtrinidad/mtrinidad.ronins.site/public/miguel_blog"

#sync JEKYLL _site to server
#rsync -avziO -e "ssh -i $SSH_KEY_PATH" $USER@$DOMAIN:$SOURCE_DIR_JK $DEST_DIR_JK

rsync -avziO -e "ssh -i $SSH_KEY_PATH" $SOURCE_DIR_JK $USER@$DOMAIN:$DEST_DIR_JK

if [ $? -eq 0 ]; then
    echo "Jekyll site rsync completed successfully."
else
    echo "Jekyll site rsync failed."
fi
