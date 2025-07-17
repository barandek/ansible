
#!/bin/bash

# Ansible Vault Setup Script
# This script helps you set up encrypted storage for sensitive information

echo "🔐 Ansible Vault Setup"
echo "====================="

VAULT_FILE="group_vars/vault.yml"

# Check if vault file already exists
if [ -f "$VAULT_FILE" ]; then
    echo "📁 Vault file already exists: $VAULT_FILE"
    echo ""
    echo "Choose an option:"
    echo "1. Edit existing vault file"
    echo "2. View vault file (decrypt and display)"
    echo "3. Change vault password"
    echo "4. Create new vault file (will overwrite existing)"
    echo "5. Exit"
    echo ""
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            echo "📝 Opening vault file for editing..."
            ansible-vault edit "$VAULT_FILE"
            ;;
        2)
            echo "👁️ Displaying vault file contents..."
            ansible-vault view "$VAULT_FILE"
            ;;
        3)
            echo "🔑 Changing vault password..."
            ansible-vault rekey "$VAULT_FILE"
            ;;
        4)
            echo "⚠️ This will overwrite the existing vault file!"
            read -p "Are you sure? (y/N): " confirm
            if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                rm "$VAULT_FILE"
            else
                echo "❌ Cancelled"
                exit 0
            fi
            ;;
        5)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice"
            exit 1
            ;;
    esac
fi

# Create new vault file if it doesn't exist
if [ ! -f "$VAULT_FILE" ]; then
    echo "📝 Creating new vault file..."
    echo ""
    echo "You'll need to provide:"
    echo "1. Your server's IP address"
    echo "2. Root password for the server"
    echo "3. A password to encrypt the vault file"
    echo ""
    
    # Get server details
    read -p "Enter your server IP address: " SERVER_IP
    read -s -p "Enter root password for the server: " ROOT_PASSWORD
    echo ""
    
    # Create vault file content
    cat > "$VAULT_FILE" << EOF
---
# This file contains sensitive information and is encrypted with ansible-vault
# Server connection details
vault_target_host: "$SERVER_IP"
vault_initial_password: "$ROOT_PASSWORD"

# Optional: Additional sensitive configuration
# vault_ssh_private_key_path: "/path/to/sensitive/key"
# vault_database_password: "DATABASE_PASSWORD"
EOF
    
    echo "🔐 Encrypting vault file..."
    ansible-vault encrypt "$VAULT_FILE"
    
    if [ $? -eq 0 ]; then
        echo "✅ Vault file created and encrypted successfully!"
        echo "📁 Location: $VAULT_FILE"
    else
        echo "❌ Failed to encrypt vault file"
        exit 1
    fi
fi

echo ""
echo "💡 Usage instructions:"
echo ""
echo "1. Run playbook with vault:"
echo "   ansible-playbook site.yml --ask-vault-pass"
echo ""
echo "2. Or use a vault password file:"
echo "   echo 'your_vault_password' > .vault_pass"
echo "   chmod 600 .vault_pass"
echo "   ansible-playbook site.yml --vault-password-file .vault_pass"
echo ""
echo "3. Edit vault file:"
echo "   ansible-vault edit $VAULT_FILE"
echo ""
echo "4. View vault file:"
echo "   ansible-vault view $VAULT_FILE"
echo ""
echo "⚠️ Remember to add .vault_pass to .gitignore if you create a password file!"
