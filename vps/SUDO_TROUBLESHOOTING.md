# Sudo Authentication Troubleshooting

## Common Sudo Issues

### 1. "Missing sudo password" Error

This error occurs when:
- You're connecting as a non-root user
- The user doesn't have passwordless sudo configured
- You haven't provided the sudo password to Ansible

### Solutions:

#### Option 1: Add sudo password to vault

```yaml
vault_hosts:
  your-server:
    ansible_user: "deploy"
    ansible_become_pass: "Password123"  # Used for both SSH and sudo
```

#### Option 2: Use --ask-become-pass flag

```bash
ansible-playbook -i inventory.yml site.yml --ask-become-pass
```

#### Option 3: Configure passwordless sudo (after first login)

```yaml
- name: Add user to sudoers
  lineinfile:
    path: /etc/sudoers.d/{{ ansible_user }}
    line: "{{ ansible_user }} ALL=(ALL) NOPASSWD:ALL"
    create: yes
    mode: "0440"
    validate: "visudo -cf %s"
```

### 2. Checking Sudo Configuration

To verify sudo is properly configured:

```bash
# Check if user has sudo access
sudo -l -U username

# Check sudoers files
ls -la /etc/sudoers.d/

# Test sudo access
sudo whoami
```

### 3. First-Time Setup

For first-time setup when you don't have sudo configured yet:

1. Connect as root initially
2. Run the user_management role to set up your user with sudo
3. Then switch to using that user for future runs

```bash
# First run as root
ansible-playbook -i inventory.yml site.yml --tags users --limit your-server

# Then update vault to use the new user
# and run future playbooks with that user
```