#!/bin/bash
echo ""
echo "-------------------------------------------------------------"
echo "   GitHub GPG Key Upload and Git Commit Signing Configuration"
echo "                        by: migoy99"
echo "-------------------------------------------------------------"
echo ""
echo "Note: This script assumes that you already have GPG installed"
echo "in your system or have generated a GPG key."
echo "If not, Open a separate terminal and execute the following command" 
echo "'gpg --full-generate-key' or visit:"
echo "https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key"
echo "for instructions."
echo ""
echo "Note: Ensure that the email associated with your GPG key"
echo "matches your GitHub private email for signing Git commits."
echo ""
echo "Note: Strongly suggested GPG key types are RSA or Ed25519."
echo "Choose either of these when generating your GPG key."
echo ""
echo "Note: This script requires GitHub CLI (gh) for uploading your"
echo "GPG key to GitHub. Ensure 'gh' is installed, and have a GitHub"
echo "token ready, for authentication."
echo "-------------------------------------------------------------"
echo ""

echo "Open a separate terminal and execute the following command to list your GPG keys along with their long key IDs:"
echo ""
echo "gpg --list-keys --keyid-format LONG"
echo ""
echo "Look for the key ID usually found after 'pub rsa3072/', 'pub rsa4096/', 'pub ed25519/', etc."
echo "Example: pub   rsa3072/E6C010C36F3C9CF0 where 'E6C010C36F3C9CF0' is the long key ID"
echo ""

# Input GPG key long key ID
read -p "Enter your GPG key's long key ID: " GPG_LONG_KEY_ID

# Store exported data in temporary text file
gpg --export --armor $GPG_LONG_KEY_ID > temp_exported_key.txt


# Prompt for GPG key details
read -p "Enter your GPG key title: " GPG_KEY_TITLE

# Prompt for GitHub token
read -p "Enter your GitHub token: " GITHUB_TOKEN

# Store token in a text file
echo "$GITHUB_TOKEN" > token.txt

# GitHub CLI auth login with token
gh auth login --with-token < token.txt

# Refresh authentication
gh auth refresh -s write:gpg_key

# Add GPG key to GitHub account using gh cli
if gh gpg-key add temp_exported_key.txt; then
    echo "GPG key added to GitHub account successfully."
else
    echo "Failed to add GPG key. Exiting..."
    exit 1
fi

# Clean up: Remove the Exported GPG file
rm temp_exported_key.txt

# Prompt for private GitHub email associated with the GPG key
read -p "Enter your private GitHub email associated with the GPG key: " GITHUB_EMAIL

# Prompt for GitHub username
read -p "Enter your GitHub username: " GITHUB_USERNAME

# Prompt for Git configuration type (local or global)
while true; do
    read -p "Do you want to configure Git locally or globally? (local/global): " GIT_CONFIG_TYPE

    # Check if the input is valid (either "local" or "global")
    if [ "$GIT_CONFIG_TYPE" == "local" ]; then
        break  # Exit the loop if the input is valid
    elif [ "$GIT_CONFIG_TYPE" == "global" ]; then
        break  # Exit the loop if the input is valid
    else
        echo "Invalid input. Please enter either 'local' or 'global'."
    fi
done

# Configure Git settings based on user input
if [ "$GIT_CONFIG_TYPE" == "local" ]; then
    # Configure local Git settings
    git config --local user.name "$GITHUB_USERNAME"
    git config --local user.signingkey "$GPG_LONG_KEY_ID"
    git config --local user.email "$GITHUB_EMAIL"
    git config --local gpg.program "$(which gpg)"
    git config --local commit.gpgSign true
else
    # Configure global Git settings
    git config --global user.name "$GITHUB_USERNAME"
    git config --global user.signingkey "$GPG_LONG_KEY_ID"
    git config --global user.email "$GITHUB_EMAIL"
    git config --global gpg.program "$(which gpg)"
    git config --global commit.gpgSign true
fi

# Tell our Shell about GPG
current_shell="$(ps -p $$ | awk 'FNR == 2 {print}' | awk '{print $4}')"
if [ "$current_shell" == "-bash" ]; then
    echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
    source ~/.bashrc
elif [ "$current_shell" == "/bin/zsh" ]; then
    echo 'export GPG_TTY=$(tty)' >> ~/.zshrc
    source ~/.zshrc
fi

echo ""
echo "Git configuration completed successfully."
echo "Check config by: git config --local --list"
echo "Check config by: git config --global --list"
echo ""

