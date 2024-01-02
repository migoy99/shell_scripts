#!/bin/bash

echo ""
echo "Note: This script requires both GitHub CLI (gh) to be installed and a GitHub token for authentication."
echo ""

# Step 1: Check GitHub CLI installation
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install GitHub CLI before running this script."
    exit 1
fi

# Step 2: Input GitHub token
read -p "Enter your GitHub token: " GITHUB_TOKEN

# Step 3: Store token in a text file
echo "$GITHUB_TOKEN" > token.txt

# Step 4: GitHub CLI auth login with token
gh auth login --with-token < token.txt

read -p "Enter the absolute path to your SSH public key (e.g., /root/.ssh/new.pub or /home/.ssh/new.pub): " SSH_KEY_PATH
read -p "Enter a title for the SSH key: " SSH_KEY_TITLE

# Step 5: Refresh authentication
gh auth refresh -h github.com -s admin:public_key

# Step 6: Add SSH key to GitHub account using GitHub CLI
if gh ssh-key add "$SSH_KEY_PATH" --title "$SSH_KEY_TITLE"; then
    echo "SSH key added to GitHub account successfully."
else
    echo "Failed to add SSH key. Exiting..."
    exit 1
fi

# Clean up: Remove the token file
rm token.txt



