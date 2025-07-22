# Vault Configuration Guide

## Overview
The vault configuration allows you to securely store host-specific settings that override the defaults.

## Structure
```yaml
vault_hosts:
  host1:
    ansible_host: "192.168.1.10"
    ansible_user: "root"
    # Other settings...
  
  host2:
    ansible_host: "192.168.1.20"
    ansible_user: "admin"
    # Other settings...
```

## Key Variables

### Connection Variables
- `ansible_host`: IP address or hostname
- `ansible_user`: SSH username for initial connection
- `ansible_ssh_private_key_file`: Path to SSH key (for key authentication)
- `ansible_become_pass`: Password for both SSH and sudo (for password authentication)
- `auth_method`: Either "ssh_key" or "password"

### Role Variables
- `server_role`: Role of the server (e.g., "coolify", "database")
- `environment_name`: Environment (e.g., "production", "staging")
- `ansible_user`: Username for SSH connection and user creation

## Variable Precedence
1. Vault configuration (highest priority)
2. Default values (fallback)

## Example
```yaml
vault_hosts:
  vps-server:
    ansible_host: "203.0.113.10"
    ansible_user: "root"
    ansible_become_pass: "SecurePassword123"
    auth_method: "password"
    server_role: "coolify"
    environment_name: "production"
```

## Testing Your Configuration
Run the debug playbook to verify your settings:
```bash
ansible-playbook -i inventory.yml debug_merge.yml --limit vps-server
```