USER=""
DOMAIN=""

#MUST BE ABSOLUTE PATHS

#SSH PRIVATE KEY
SSH_KEY_PATH=""

#Source and destination directories
#Source is with `/`, destination is without `/`
SOURCE_DIR_JK="/miguel_blog/_site/"
DEST_DIR_JK="/public/miguel_blog"

#Sync JEKYLL _site to server
rsync -avziO -e "ssh -i $SSH_KEY_PATH" $SOURCE_DIR_JK $USER@$DOMAIN:$DEST_DIR_JK

if [ $? -eq 0 ]; then
    echo "Jekyll site rsync completed successfully."
else
    echo "Jekyll site rsync failed."
fi
