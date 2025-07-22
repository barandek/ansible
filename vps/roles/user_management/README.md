# User Management Role

## Purpose
Creates and configures a custom user with SSH key authentication and sudo privileges.

## What This Role Does
- ✅ Generates SSH key pair locally
- ✅ Creates custom user with UID 9999 (Coolify compatibility)
- ✅ Sets up SSH key authentication
- ✅ Configures passwordless sudo access
- ✅ Verifies SSH connectivity

## What This Role Does NOT Do
- ❌ Modify SSH daemon configuration (AllowUsers, etc.)
- ❌ Change SSH ports or security settings
- ❌ Disable root access

## Security Approach
This role focuses on **user creation only**. SSH security hardening is handled by the `security_hardening` role to prevent accidental lockouts.

## Role Execution Order
1. `user_management` - Creates user and SSH access
2. `security_hardening` - Applies SSH restrictions and hardening

## Variables
- `ansible_user` - Username to create (from inventory)
- `ssh_key_dir` - Local SSH key directory (default: ~/.ssh)
- `ssh_allowed_users` - List of users for SSH access (used by security_hardening)

## Connection After Setup
```bash
ssh -i ~/.ssh/HOSTNAME_USERNAME_key USERNAME@SERVER_IP
```

## Safety Features
- SSH connectivity test before completion
- No SSH daemon modifications (prevents lockouts)
- Backup and validation for sudoers file
- Process handling for UID changes