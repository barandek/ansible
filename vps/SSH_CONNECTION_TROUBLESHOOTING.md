# SSH Connection Troubleshooting

## Common Issues and Solutions

### 1. Password Authentication Issues

If you're seeing errors like:
```
Invalid/incorrect password
Permission denied, please try again
```

**Solutions:**
- Verify the password in vault.yml or inventory defaults
- Ensure SSH password authentication is enabled on the server
- Check that `auth_method: password` is set correctly
- Run with `-vvv` flag to see detailed SSH connection attempts

### 2. SSH Key Authentication Issues

If you're seeing errors like:
```
no such identity: /path/to/key
Permission denied (publickey)
```

**Solutions:**
- Verify the SSH key path exists
- Check key permissions (should be 0600)
- Ensure the public key is in the server's authorized_keys
- Set `auth_method: ssh_key` in your inventory

### 3. Quick Connection Test

Test SSH connection directly:
```bash
# For password auth
sshpass -p "YOUR_PASSWORD" ssh -o StrictHostKeyChecking=no root@YOUR_SERVER_IP

# For key auth
ssh -i /path/to/key -o StrictHostKeyChecking=no root@YOUR_SERVER_IP
```

### 4. Debug Connection Variables

Run the connection debug playbook:
```bash
ansible-playbook -i inventory.yml connection_debug.yml --limit vps-server
```

### 5. Inventory Configuration

Make sure your inventory has the correct authentication variables:

**For password authentication:**
```yaml
auth_method: password
ansible_ssh_pass: your_password
```

**For SSH key authentication:**
```yaml
auth_method: ssh_key
ansible_ssh_private_key_file: /path/to/key
```