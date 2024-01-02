#!/bin/bash

# by: migoy99
# Remember to add SSH private key to ssh-agent
# eval "$(ssh-agent)" && ssh-add ~/.ssh/my-ssh-key

echo ""
echo "-------------------------------------------------------------"
echo "     Generate SSH Key and Associate to GitHub Account"
echo "                      by: migoy99"
echo "-------------------------------------------------------------"
echo ""
echo "This script helps you create and associate SSH keys with your"
echo "GitHub account."
echo ""
echo "If you want to associate the SSH key with your"
echo "GitHub account, ensure that you have the GitHub CLI (gh)"
echo "installed, and make sure you have a GitHub token ready for"
echo "authentication."
echo ""
echo "-------------------------------------------------------------"
echo ""
echo "Remember to add the SSH private key to the ssh-agent:"
echo "eval \"\$(ssh-agent)\" && ssh-add ~/.ssh/my-ssh-key"
echo "Note: Adding the SSH key to the ssh-agent allows you to use"
echo "the key for authentication without entering the passphrase"
echo "every time. It enhances security and convenience."
echo ""
echo "-------------------------------------------------------------"
echo ""

read -p "Enter SSH Key Name (ex: my-ssh-key): " SSHKEYNAME
read -p "Enter SSH Key Passphrase (optional, leave blank if needed): " SSHKEYPASSPHRASE
read -p "Enter a comment for the SSH key (e.g., email or name): " SSHKEYCOMMENT

# Check if there is a ~/.ssh directory, if not, creates.
SSH_DIR=~/.ssh
if [ ! -d "$SSH_DIR" ]; then
    echo "Creating ~/.ssh directory..."
    mkdir "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

while true; do
  read -p "Enter SSH Key Type (ed25519 or rsa): " SSHKEYTYPE
  if [ "$SSHKEYTYPE" == "rsa" ]; then
    while true; do
      read -p "Enter RSA Key Length (3072 or 4096): " RSASIZE
      if [ "$RSASIZE" == "3072" ] || [ "$RSASIZE" == "4096" ]; then
        ssh-keygen -q -t rsa -b "$RSASIZE" -N "$SSHKEYPASSPHRASE" -C "$SSHKEYCOMMENT" -f "$SSH_DIR/$SSHKEYNAME" <<<y >/dev/null 2>&1
        break 2 # Break out of both loops
      else
        echo "Invalid RSA key length. Please choose either 3072 or 4096."
      fi
    done
  elif [ "$SSHKEYTYPE" == "ed25519" ]; then
    ssh-keygen -q -t ed25519 -N "$SSHKEYPASSPHRASE" -C "$SSHKEYCOMMENT" -f "$SSH_DIR/$SSHKEYNAME" <<<y >/dev/null 2>&1
    break # Break out of the outer loop
  else
    echo "Invalid SSH key type. Please choose either ed25519 or rsa."
  fi
done

if [ $? -eq 0 ]; then
  echo "SSH Key created successfully: $SSHKEYNAME"
  # echo "Add SSH key to ssh-agent: $SSHKEYNAME"

  # Prompt to associate SSH key with GitHub account
  read -p "Do you want to associate this SSH key with your GitHub account? (y/n): " ASSOCIATE_GITHUB

  if [[ "$ASSOCIATE_GITHUB" =~ ^[Yy](es)?$ ]]; then
    echo ""
    echo "Note: This script requires both GitHub CLI (gh) to be installed and a GitHub token for authentication."
    echo ""

    # Step 1: Check GitHub CLI installation
    if ! command -v gh &>/dev/null; then
      echo "GitHub CLI (gh) is not installed. Please install GitHub CLI before running this script."
      exit 1
    fi

    # Step 2: Input GitHub token
    read -p "Enter your GitHub token: " GITHUB_TOKEN

    # Step 3: Store token in a text file
    echo "$GITHUB_TOKEN" >token.txt

    # Step 4: GitHub CLI auth login with token
    gh auth login --with-token <token.txt

    read -p "Enter the absolute path to your SSH public key (e.g., /root/.ssh/new.pub or /home/.ssh/new.pub): " SSH_KEY_PATH
    read -p "Enter a title for the SSH key: " SSH_KEY_TITLE

    # Step 5: Refresh authentication
    gh auth refresh -h github.com -s admin:public_key

    # Step 6: Add SSH key to GitHub account using GitHub CLI
    if gh ssh-key add "$SSH_KEY_PATH" --title "$SSH_KEY_TITLE"; then
      echo "SSH key associated with GitHub account."
    else
      echo "Failed to add SSH key. Exiting..."
      exit 1
    fi

    # Clean up: Remove the token file
    rm token.txt

  else
    echo "SSH key not associated with GitHub account."
  fi

else
  echo "SSH creation failed..."
fi

# eval "$(ssh-agent)" && ssh-add ~/.ssh/$SSHKEYNAME
