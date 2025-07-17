
# Configuration Examples

This directory contains example configuration files for different scenarios. Choose the one that best matches your setup and copy it to `group_vars/all.yml`.

## 🔥 Firewall Configuration Options

The playbook now supports flexible firewall configurations:

### 1. Coolify Setup (Default - Recommended)
- **File**: `coolify-setup.yml`
- **Ports**: 8000, 6001, 6002, 80, 443, SSH
- **Use Case**: Coolify self-hosted deployments

### 2. Custom Coolify Ports
- **File**: `coolify-custom-ports.yml`
- **Ports**: Coolify defaults + custom application ports
- **Use Case**: Coolify with additional services

### 3. GitHub Webhooks Only
- **File**: `github-webhooks-only.yml`
- **Ports**: SSH + HTTP/HTTPS (restricted to GitHub IPs)
- **Use Case**: CI/CD servers, webhook receivers

### 4. No Firewall (Not Recommended)
- **File**: `no-firewall.yml`
- **Ports**: All ports open
- **Use Case**: Development only, external firewall protection

## 📋 Quick Start

1. **Copy the appropriate example:**
   ```bash
   # For Coolify deployments (most common)
   cp examples/coolify-setup.yml group_vars/all.yml
   cp inventory.yml.example inventory.yml
   
   # For GitHub webhook servers
   cp examples/github-webhooks-only.yml group_vars/all.yml
   cp inventory.yml.example inventory.yml
   ```

2. **Edit the configuration:**
   ```bash
   nano group_vars/all.yml
   ```

3. **Update these required values:**
   - `target_host`: Your server's IP address
   - `initial_auth_method`: Choose "ssh_key" or "password"
   - `ssh_private_key_path`: Path to your SSH key (if using ssh_key method)

4. **Run the playbook:**
   ```bash
   ansible-playbook site.yml
   ```

## 🔐 SSH Access Control

By default, SSH access is **open to all IP addresses** for easier initial setup. You can optionally restrict SSH access to specific IPs:

```yaml
# Default: SSH open to all IPs (easier setup)
allowed_ssh_ips: []

# Optional: Restrict SSH to specific IPs (more secure)
allowed_ssh_ips:
  - "203.0.113.100/32"  # Your home IP
  - "198.51.100.50/32"  # Your office IP
  - "192.168.1.0/24"    # Local network
```

## 📁 Available Examples

### Authentication Examples
- **`ssh-key-auth.yml`** - SSH key authentication (recommended)
- **`password-auth.yml`** - Password authentication
- **`digitalocean-password.yml`** - DigitalOcean droplet with password

### Firewall Examples
- **`coolify-setup.yml`** - Standard Coolify configuration
- **`coolify-custom-ports.yml`** - Coolify with additional ports
- **`github-webhooks-only.yml`** - GitHub webhooks only
- **`no-firewall.yml`** - No firewall (development only)

### Environment Examples
- **`development.yml`** - Development environment settings
- **`production.yml`** - Production environment settings
- **`aws-ec2.yml`** - AWS EC2 instance configuration
- **`digitalocean.yml`** - DigitalOcean droplet configuration
- **`multiple-servers.yml`** - Multiple server management

## 🚀 Usage Examples

### Coolify Deployment
```bash
# 1. Configure for Coolify
cp examples/coolify-setup.yml group_vars/all.yml

# 2. Edit configuration
nano group_vars/all.yml
# Update: target_host, initial_auth_method, ssh_private_key_path

# 3. Deploy
ansible-playbook site.yml

# 4. Access Coolify
# Navigate to: http://YOUR_SERVER_IP:8000
```

### GitHub Webhook Server
```bash
# 1. Configure for webhooks
cp examples/github-webhooks-only.yml group_vars/all.yml

# 2. Edit configuration
nano group_vars/all.yml
# Update: target_host, allowed_ssh_ips (recommended for security)

# 3. Deploy
ansible-playbook site.yml

# 4. Configure GitHub webhooks
# Point to: http://YOUR_SERVER_IP/webhook
```

### Development Server
```bash
# 1. Configure for development
cp examples/development.yml group_vars/all.yml

# 2. Edit configuration
nano group_vars/all.yml
# Update: target_host, initial_auth_method

# 3. Deploy
ansible-playbook site.yml
```

## 🔧 Customization

### Adding Custom Ports
Edit the `coolify_ports` section in your configuration:

```yaml
coolify_ports:
  # Standard Coolify ports
  - { port: 8000, proto: tcp, comment: "Coolify dashboard" }
  - { port: 6001, proto: tcp, comment: "Real-time communications" }
  - { port: 6002, proto: tcp, comment: "Terminal access" }
  - { port: 80, proto: tcp, comment: "HTTP traffic" }
  - { port: 443, proto: tcp, comment: "HTTPS traffic" }
  
  # Your custom ports
  - { port: 3000, proto: tcp, comment: "Node.js app" }
  - { port: 5432, proto: tcp, comment: "PostgreSQL" }
  - { port: 6379, proto: tcp, comment: "Redis" }
```

### SSH Key Storage Options
```yaml
# Default location
custom_user_ssh_key_dir: "~/.ssh"
custom_user_ssh_key_name: "deploy_key"

# Project-specific location
custom_user_ssh_key_dir: "./keys"
custom_user_ssh_key_name: "{{ target_host }}_key"

# Server-specific naming
custom_user_ssh_key_name: "coolify_{{ custom_user }}_key"
```

## 🔒 Security Recommendations

### For Production Servers
1. **Restrict SSH access:**
   ```yaml
   allowed_ssh_ips:
     - "YOUR_OFFICE_IP/32"
   ```

2. **Use custom SSH port:**
   ```yaml
   ssh_port: 2222
   ```

3. **Enable stricter fail2ban:**
   ```yaml
   fail2ban_bantime: 7200  # 2 hours
   fail2ban_maxretry: 2    # 2 attempts only
   ```

### For Development Servers
1. **Keep SSH open for flexibility:**
   ```yaml
   allowed_ssh_ips: []  # Open to all IPs
   ```

2. **Use relaxed settings:**
   ```yaml
   fail2ban_bantime: 1800  # 30 minutes
   fail2ban_maxretry: 5    # More attempts
   ```

## 🐛 Troubleshooting

### SSH Connection Issues
```bash
# Test initial connection
ssh -i ~/.ssh/id_rsa root@YOUR_SERVER_IP

# Test with generated key after deployment
ssh -i ~/.ssh/deploy_key deploy@YOUR_SERVER_IP

# Check SSH service
sudo systemctl status ssh
```

### Firewall Issues
```bash
# Check firewall status (Ubuntu/Debian)
sudo ufw status verbose

# Check firewall status (RHEL/CentOS)
sudo firewall-cmd --list-all

# Check open ports
sudo netstat -tlnp
```

### Port Access Issues
```bash
# Test port connectivity
telnet YOUR_SERVER_IP 8000

# Check if service is running
sudo systemctl status docker
sudo docker ps
```

## 📝 Configuration Variables Reference

### Required Variables
- `target_host` - Server IP address
- `initial_auth_method` - "ssh_key" or "password"
- `custom_user` - Username to create

### Optional Variables
- `allowed_ssh_ips` - SSH IP restrictions (empty = all IPs allowed)
- `ssh_port` - SSH port (default: 22)
- `enable_coolify_ports` - Enable Coolify ports (default: true)
- `enable_custom_firewall` - Enable GitHub webhook restrictions (default: false)
- `coolify_ports` - Custom port configuration
- `custom_user_ssh_key_dir` - SSH key storage location
- `fail2ban_bantime` - Ban duration in seconds

## ⚠️ Important Notes

- **SSH Access**: By default, SSH is open to all IPs for easier setup
- **Firewall**: Coolify ports are enabled by default
- **SSH Keys**: New keys are automatically generated for the custom user
- **Root Access**: Root password authentication is disabled after setup
- **GitHub IPs**: Webhook IPs are fetched automatically when needed

---

**Need help?** Check the main README.md for detailed documentation and troubleshooting guides.
