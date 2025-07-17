
# Troubleshooting Guide

## SSH Connection Issues

### 1. Host Key Checking Error (Password Authentication)

**Error:**
```
fatal: [vps-server]: FAILED! => {"msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this. Please add this host's fingerprint to your known_hosts file to manage this host."}
```

**Solutions:**

#### Option A: Use the provided script (Recommended)
```bash
chmod +x run-playbook.sh
./run-playbook.sh
```

#### Option B: Install sshpass and run manually
```bash
# Ubuntu/Debian
sudo apt-get install sshpass

# RHEL/CentOS
sudo yum install sshpass

# Fedora
sudo dnf install sshpass

# macOS
brew install sshpass

# Then run with password prompt
ansible-playbook site.yml --ask-pass
```

#### Option C: Add host to known_hosts first
```bash
# Add the server to known_hosts
ssh-keyscan -H YOUR_SERVER_IP >> ~/.ssh/known_hosts

# Then run the playbook
ansible-playbook site.yml
```

#### Option D: Use environment variables
```bash
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
ansible-playbook site.yml --ask-pass
```

## Docker Installation Issues

### 1. Docker Compose pip Installation Error (PEP 668)

**Error:**
```
error: externally-managed-environment
× This environment is externally managed
╰─> To install Python packages system-wide, try apt install python3-xyz
```

**Solution:**
This error occurs on newer Ubuntu/Debian systems. The playbook now handles this automatically by:

1. **First trying Docker Compose plugin** (comes with Docker CE)
2. **Then trying system package** (`apt install docker-compose`)
3. **Then trying pip with break-system-packages** (if needed)
4. **Finally downloading binary** (as last resort)

**Manual fix if needed:**
```bash
# Option 1: Use Docker Compose plugin (recommended)
docker compose version

# Option 2: Install via system package
sudo apt install docker-compose

# Option 3: Use pip with break-system-packages
pip install docker-compose --break-system-packages

# Option 4: Download binary directly
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. Docker Service Not Starting

**Error:**
```
Job for docker.service failed because the control process exited with error code
```

**Solutions:**
```bash
# Check Docker service status
sudo systemctl status docker

# Check Docker logs
sudo journalctl -u docker

# Restart Docker service
sudo systemctl restart docker

# Enable Docker to start on boot
sudo systemctl enable docker
```

### 3. Docker Permission Issues

**Error:**
```
permission denied while trying to connect to the Docker daemon socket
```

**Solution:**
```bash
# Add user to docker group (done automatically by playbook)
sudo usermod -aG docker $USER

# Logout and login again
exit
ssh -i ~/.ssh/deploy_key deploy@YOUR_SERVER_IP

# Verify group membership
groups
```

### 4. Docker Compose Command Not Found

**Error:**
```
docker-compose: command not found
```

**Solutions:**
```bash
# Try Docker Compose plugin instead
docker compose version

# Or install standalone docker-compose
sudo apt install docker-compose

# Or create symlink if binary exists
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

## SSH Connection Issues (Continued)

### 2. SSH Key Permission Issues

**Error:**
```
UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Load key \"/path/to/key\": bad permissions", "unreachable": true}
```

**Solution:**
```bash
chmod 600 ~/.ssh/your_private_key
```

### 3. SSH Connection Timeout

**Error:**
```
UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: ssh: connect to host X.X.X.X port 22: Connection timed out", "unreachable": true}
```

**Solutions:**
- Check if the server is running and accessible
- Verify the IP address in `group_vars/all.yml`
- Check if SSH port is correct (default: 22)
- Ensure firewall allows SSH connections

### 4. Authentication Failed

**Error:**
```
UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Permission denied (publickey,password)", "unreachable": true}
```

**Solutions:**
- Verify the username in `initial_user` (usually 'root' or 'ubuntu')
- Check if the SSH key path is correct
- Ensure the password is correct (if using password auth)
- Try connecting manually first: `ssh root@YOUR_SERVER_IP`

## Configuration Issues

### 1. Missing Configuration Files

**Error:**
```
❌ Configuration file group_vars/all.yml not found!
```

**Solution:**
```bash
cp group_vars/all.yml.example group_vars/all.yml
nano group_vars/all.yml
```

### 2. Invalid Authentication Method

**Error:**
```
❌ Invalid authentication method: 
```

**Solution:**
Edit `group_vars/all.yml` and set:
```yaml
initial_auth_method: "ssh_key"  # or "password"
```

### 3. SSH Key Not Found

**Error:**
```
❌ SSH private key not found at: ~/.ssh/id_rsa
```

**Solutions:**
- Generate a new SSH key: `ssh-keygen -t rsa -b 4096`
- Update the path in `group_vars/all.yml`:
  ```yaml
  ssh_private_key_path: "/path/to/your/key"
  ```

## Firewall Issues

### 1. Cannot Access Services After Setup

**Problem:** Cannot access Coolify dashboard or other services

**Solutions:**
- Check if Coolify ports are enabled:
  ```yaml
  enable_coolify_ports: true
  ```
- Verify firewall status on server:
  ```bash
  sudo ufw status  # Ubuntu/Debian
  sudo firewall-cmd --list-all  # RHEL/CentOS
  ```
- Test port connectivity:
  ```bash
  telnet YOUR_SERVER_IP 8000
  ```

### 2. SSH Access Blocked

**Problem:** Cannot SSH to server after playbook runs

**Solutions:**
- Check `allowed_ssh_ips` configuration:
  ```yaml
  allowed_ssh_ips: []  # Allow all IPs
  # or
  allowed_ssh_ips:
    - "YOUR_IP/32"  # Your specific IP
  ```
- Use console access to fix firewall rules
- Connect using the generated SSH key:
  ```bash
  ssh -i ~/.ssh/deploy_key deploy@YOUR_SERVER_IP
  ```

## User Management Issues

### 1. Sudo Access Denied

**Error:**
```
deploy is not in the sudoers file
```

**Solution:**
```bash
# Check sudoers file
sudo cat /etc/sudoers.d/deploy

# Should contain: deploy ALL=(ALL) NOPASSWD:ALL
```

### 2. SSH Key Authentication Failed for New User

**Problem:** Cannot connect with generated SSH key

**Solutions:**
- Check key permissions:
  ```bash
  ls -la ~/.ssh/deploy_key  # Should be 600
  chmod 600 ~/.ssh/deploy_key
  ```
- Verify public key on server:
  ```bash
  sudo cat /home/deploy/.ssh/authorized_keys
  ```
- Test key manually:
  ```bash
  ssh-keygen -l -f ~/.ssh/deploy_key
  ```

## Package Manager Issues

### 1. Package Not Found

**Error:**
```
No package matching 'docker-compose' found available, installed or updated
```

**Solutions:**
```bash
# Update package cache first
sudo apt update  # Debian/Ubuntu
sudo yum update  # RHEL/CentOS

# Try alternative package names
sudo apt install docker.io docker-compose  # Ubuntu
sudo yum install docker docker-compose     # CentOS
```

### 2. Repository Issues

**Error:**
```
Failed to fetch https://download.docker.com/linux/ubuntu/dists/jammy/InRelease
```

**Solutions:**
```bash
# Update certificates
sudo apt update && sudo apt install ca-certificates

# Clear apt cache
sudo apt clean && sudo apt update

# Manually add Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

## Ansible-Specific Issues

### 1. Module Not Found

**Error:**
```
ERROR! couldn't resolve module/action 'openssh_keypair'
```

**Solution:**
```bash
# Install required Ansible collections
ansible-galaxy collection install community.crypto
ansible-galaxy collection install ansible.posix
```

### 2. Python Module Missing

**Error:**
```
Failed to import the required Python library (cryptography)
```

**Solution:**
```bash
# Install required Python packages
pip install cryptography
pip install paramiko
```

### 3. Inventory Issues

**Error:**
```
[WARNING]: Unable to parse inventory.yml as an inventory source
```

**Solution:**
```bash
# Check YAML syntax
ansible-inventory --list

# Validate inventory file
ansible-playbook site.yml --syntax-check
```

## Quick Fixes

### Reset and Start Over
```bash
# If everything goes wrong, reset and try again
rm -rf ~/.ssh/deploy_key*
cp group_vars/all.yml.example group_vars/all.yml
# Edit configuration
nano group_vars/all.yml
# Run again
./run-playbook.sh
```

### Manual SSH Test
```bash
# Test initial connection manually
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@YOUR_SERVER_IP

# Test with generated key
ssh -i ~/.ssh/deploy_key -o StrictHostKeyChecking=no deploy@YOUR_SERVER_IP
```

### Check Ansible Configuration
```bash
# Verify Ansible can reach the host
ansible all -m ping

# Check Ansible configuration
ansible-config dump | grep -i ssh

# Test with verbose output
ansible-playbook site.yml -vvv
```

### Docker Compose Verification
```bash
# Check which Docker Compose is available
which docker-compose
docker compose version
docker-compose version

# Test Docker functionality
docker run hello-world
sudo systemctl status docker
```

## Getting Help

If you're still having issues:

1. **Check the logs:** Look at the full Ansible output for specific error messages
2. **Test manually:** Try SSH connections and Docker commands manually before running the playbook
3. **Verify configuration:** Double-check all settings in `group_vars/all.yml`
4. **Use verbose mode:** Run with `-vvv` for detailed output:
   ```bash
   ansible-playbook site.yml -vvv
   ```
5. **Check system logs:** Look at system logs for more details:
   ```bash
   sudo journalctl -u docker
   sudo journalctl -u ssh
   sudo tail -f /var/log/auth.log
   ```

## Common Command Reference

```bash
# Test SSH connection
ssh -o StrictHostKeyChecking=no root@YOUR_SERVER_IP

# Run playbook with verbose output
ansible-playbook site.yml -vvv

# Run specific tags only
ansible-playbook site.yml --tags users

# Check syntax
ansible-playbook site.yml --syntax-check

# Dry run
ansible-playbook site.yml --check

# Test Docker after installation
docker --version
docker compose version
docker run hello-world

# Check firewall status
sudo ufw status verbose
sudo firewall-cmd --list-all
sudo iptables -L -n

# Check services
sudo systemctl status docker
sudo systemctl status fail2ban
sudo systemctl status ssh
```

## Emergency Recovery

### If Locked Out of Server
1. **Use cloud provider console** to access the server
2. **Reset SSH configuration:**
   ```bash
   sudo cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
   sudo systemctl restart ssh
   ```
3. **Disable firewall temporarily:**
   ```bash
   sudo ufw disable  # Ubuntu/Debian
   sudo systemctl stop firewalld  # RHEL/CentOS
   ```
4. **Re-enable root password login temporarily:**
   ```bash
   sudo passwd root  # Set new root password
   # Edit /etc/ssh/sshd_config to allow root login
   sudo systemctl restart ssh
   ```

### If Docker Not Working
1. **Reinstall Docker:**
   ```bash
   sudo apt remove docker-ce docker-ce-cli containerd.io
   sudo apt autoremove
   # Re-run the playbook
   ```
2. **Check Docker daemon:**
   ```bash
   sudo dockerd --debug
   ```
3. **Reset Docker:**
   ```bash
   sudo systemctl stop docker
   sudo rm -rf /var/lib/docker
   sudo systemctl start docker
   ```
