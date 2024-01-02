#!/bin/bash
echo ""
echo "-------------------------------------------------------------"
echo "               Git Commit Signing Configuration"
echo "                        by: migoy99"
echo "-------------------------------------------------------------"
echo ""
echo "Note: This script assumes that you already have GPG installed"
echo "in your system and have generated a GPG key and associated it"
echo "to your GitHub Account."
echo ""
echo "Note: Ensure that the email associated with your GPG key"
echo "matches your GitHub private email for signing Git commits."
echo "This script requires your private GitHub email and username."
echo ""
echo "-------------------------------------------------------------"
echo ""

echo "Open a separate terminal and execute the following command to list your GPG keys along with their long key IDs:"
echo ""
echo "gpg --list-keys --keyid-format LONG"
echo ""
echo "Look for the key ID usually found after 'pub rsa3072/', 'pub rsa4096/', 'pub ed25519/', etc."
echo "Example: pub   rsa3072/E6C010C36F3C9CF0 where 'E6C010C36F3C9CF0' is the long key ID"
echo ""

# Prompt for GPG key long key ID
read -p "Enter your GPG key's long key ID: " GPG_LONG_KEY_ID

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
