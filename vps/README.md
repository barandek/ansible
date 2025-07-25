
# VPS Server Setup and Hardening Ansible Playbook

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ansible](https://img.shields.io/badge/Ansible-2.9%2B-red.svg)](https://www.ansible.com/)
[![Platform](https://img.shields.io/badge/Platform-Debian%2FUbuntu-blue.svg)](https://www.debian.org/)

A comprehensive Ansible playbook for setting up and hardening Debian/Ubuntu VPS servers. Designed for Coolify deployments, Docker environments, and secure server management with security best practices built-in.

## 📁 Project Structure

```
vps/
├── ansible.cfg                 # Ansible configuration
├── inventory.yml.example       # Example host inventory
├── site.yml                    # Main playbook
├── group_vars/
│   ├── all.yml                 # Common variables
│   └── vault.yml.example       # Encrypted secrets
├── roles/
│   ├── system_setup/           # System configuration and packages
│   ├── user_management/        # User creation, SSH keys, and group management
│   ├── security_hardening/     # SSH hardening and kernel security (SCP/SFTP enabled)
│   ├── docker_setup/           # Docker installation and configuration
│   ├── firewall_setup/         # UFW configuration with Docker integration
│   └── coolify/                # Coolify installation with intelligent restart logic
└── tasks/
    ├── system_check.yml       # System requirements
    └── post_install_tests.yml # Verification tests
```

## 🚀 Features

This comprehensive Ansible playbook provides automated VPS setup and hardening with the following capabilities:

- **System Language Localization**: Automatically changes host language to English (useful for VPS hosted in other countries)
- **Comprehensive Security Hardening**: SSH hardening, firewall configuration, and intrusion prevention
- **Docker Platform Setup**: Complete Docker CE and Docker Compose installation with security integration
- **Multi-Host Management**: Support for different server roles and environments
- **Automated Testing**: Post-installation verification to ensure all services are properly configured

### 🌐 Platform Support
- **Operating Systems**: Debian 10+, Ubuntu 18.04+
- **Architectures**: AMD64 (x86_64) and ARM64 (aarch64)
- **Package Manager**: APT (Advanced Package Tool)

### 🔐 Flexible Authentication
- **SSH Key Authentication**: Use existing SSH keys for secure access
- **Password Authentication**: Uses `ansible_become_pass` for both SSH and sudo
- **Automatic Key Generation**: Creates new SSH key pairs for deployment users
- **Ansible Vault Integration**: Secure storage of sensitive data
- **Root User Support**: Handles both root and non-root users with proper SSH key placement

### 🛡️ Security Hardening
- **SSH Hardening**: Disabled root login, password authentication, strong encryption, **SCP/SFTP support enabled**
- **UFW Firewall**: Ubuntu/Debian firewall with Docker integration, idempotent configuration, and clear display
- **Intrusion Prevention**: Fail2ban with SSH protection
- **System Security**: Secure kernel parameters, disabled unused protocols
- **Automatic Updates**: Unattended security updates for Debian/Ubuntu
- **Firewall Visualization**: Numbered rules display with clear summaries and rule counts
- **Idempotent Configuration**: Smart UFW management that only makes necessary changes

### 🌍 System Localization
- **Language Configuration**: Automatically changes system language from German to English
- **Locale Management**: Sets en_US.UTF-8 as default system locale
- **Environment Variables**: Configures LANG, LANGUAGE, and LC_ALL for consistent English interface
- **Profile Integration**: Creates system-wide locale settings for all users

### 🐳 Container Platform
- **Docker CE**: Latest Docker Community Edition for Debian/Ubuntu
- **Docker Compose**: Both plugin and standalone versions supported
- **Containerd**: Container runtime included with Docker
- **Coolify**: Automated installation with intelligent restart logic and idempotent credential management
- **Docker-UFW Integration**: Proper firewall configuration for Docker containers

### 🌟 Application Support
- **Coolify**: Pre-configured ports and setup for Coolify self-hosted deployments
- **GitHub Webhooks**: Compatible with GitHub webhooks via standard HTTP/HTTPS ports (80/443)
- **Custom Applications**: Flexible port and service configuration

### 🏗️ Multi-Host Management
- **Role-Based Configuration**: Different settings for vps-servers, webservers, databases, applications
- **Environment Management**: production, staging, development configurations
- **Vault-Based Secrets**: Secure multi-host credential management
- **Dynamic Inventory**: Automatic host grouping and configuration

## 📋 Quick Start

### What This Playbook Does

When you run this playbook, it will automatically:

1. **🌍 System Localization**: Change system language from German to English (perfect for German-hosted VPS)
2. **👤 User Management**: Create a secure deployment user with SSH key authentication
3. **🔐 Security Hardening**: Configure SSH security, disable root login, set up fail2ban
4. **🛡️ Firewall Setup**: Configure UFW firewall with proper Docker integration
5. **🐳 Docker Installation**: Install Docker CE, Docker Compose, and configure container security
6. **🔧 System Optimization**: Apply security patches and configure automatic updates
7. **✅ Verification**: Run comprehensive tests to ensure everything is working correctly

### Prerequisites
- **Control Machine**: Ansible 2.9+ installed
- **Target Server**: Debian/Ubuntu server with SSH access
- **Local Requirements**: Python 3.6+, sshpass (for password auth)

### 1. Setup Configuration

#### Configure Inventory
Edit `inventory.yml` to define your servers:
```yaml
all:
  hosts:
    vps-server: {}  # Your server hostname
```

#### Configure Vault
Create and encrypt your server credentials:
```bash
# Create vault file
ansible-vault create group_vars/vault.yml

# Add your server configuration:
vault_hosts:
  vps-server:
    ansible_host: "your.server.ip"
    ansible_user: "root"
    ansible_become_pass: "your_password"  # Used for both SSH and sudo
    server_role: "coolify"
    environment_name: "production"
    auth_method: "password"  # or "ssh_key"
```

### 2. Run Playbook
```bash
# Deploy to all servers
ansible-playbook -i inventory.yml site.yml --ask-vault-pass

# Deploy to specific server
ansible-playbook -i inventory.yml site.yml --limit vps-server --ask-vault-pass

# Dry run (check what would change)
ansible-playbook -i inventory.yml site.yml --check --ask-vault-pass
```

## 🧪 Testing & Validation

### Coolify Idempotency Testing
```bash
# Test Coolify deployment idempotency
ansible-playbook -i inventory.yml test-custom-compose-idempotency.yml --ask-vault-pass
```

## 🔧 Configuration

### Firewall Configuration

The playbook uses a simplified, flexible firewall configuration system:

**Default Ports (Applied to All Servers):**
- SSH (port 22 or custom)
- HTTP (port 80) 
- HTTPS (port 443)

**Role-Specific Ports:**
- Automatically added based on `server_role` in vault configuration
- Each role has predefined ports for common services

**Custom Ports:**
- Define `vault_custom_firewall_ports` in your vault file
- Supports both allow and deny rules
- Can specify TCP or UDP protocols

**Example Configuration:**
```yaml
# In vault.yml
vault_custom_firewall_ports:
  - { port: 9000, proto: tcp, rule: allow, comment: "Monitoring" }
  - { port: 8443, proto: tcp, rule: allow, comment: "Admin panel" }

custom_firewall_deny_ports:
  - { port: 23, proto: tcp, rule: deny, comment: "Block Telnet" }
```

**UFW Configuration Output:**

When the playbook runs, you'll see a clear, organized display of your firewall configuration:

**Readable Format:**
```
=== UFW FIREWALL CONFIGURATION ===
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  # SSH access
[ 2] 80/tcp                     ALLOW IN    Anywhere                  # HTTP traffic
[ 3] 443/tcp                    ALLOW IN    Anywhere                  # HTTPS traffic
[ 4] 8000/tcp                   ALLOW IN    Anywhere                  # Coolify dashboard HTTP
[ 5] 6001/tcp                   ALLOW IN    Anywhere                  # Real-time communications
[ 6] 6002/tcp                   ALLOW IN    Anywhere                  # Terminal access
[ 7] 9000/tcp                   ALLOW IN    Anywhere                  # Custom monitoring port
[ 8] 8443/tcp                   ALLOW IN    Anywhere                  # Custom HTTPS admin panel
[ 9] 23/tcp                     DENY IN     Anywhere                  # Block Telnet

Configuration Summary:
- Total rules configured: 9
- Allow rules: 8
- Deny rules: 1
```

**Smart UFW Management:**

The playbook uses intelligent UFW configuration that avoids unnecessary disruptions:

- **No Rule Resets**: Checks existing configuration before making changes
- **Idempotent Operations**: Only applies rules that aren't already in place
- **Policy Verification**: Only updates default policies if they're incorrect
- **Status Preservation**: Maintains existing UFW state when possible

**Docker & UFW Integration:**

The playbook configures Docker to work cleanly with UFW:

- **Disabled Docker iptables**: Docker doesn't interfere with UFW rules
- **Clean UFW Management**: All firewall rules managed exclusively by UFW
- **Simple Port Control**: Use standard UFW commands to control access

### Coolify Port Configuration

The playbook provides flexible control over Coolify port exposure for enhanced security:

**Default Behavior:**
- Coolify dashboard accessible on port 8000
- Real-time communications on port 6001  
- Terminal access on port 6002
- All ports are exposed externally by default

**Disable External Port Exposure:**

To enhance security by preventing external access to Coolify ports, set the following variable in `group_vars/all.yml`:

```yaml
# Set to true to disable external port exposure (8000, 6001, 6002)
# This creates a docker-compose.custom.yml file that resets port mappings
coolify_disable_external_ports: true
```

**What This Does:**
- Creates a `docker-compose.custom.yml` file with `ports: !reset []` for coolify and soketi services
- Automatically removes firewall rules for ports 8000, 6001, and 6002
- Coolify services remain accessible internally via Docker networks
- External access is completely blocked at both Docker and firewall levels

**Access Methods When Ports Are Disabled:**
- Use SSH tunneling: `ssh -L 8000:localhost:8000 user@server`
- Access via reverse proxy (nginx, Traefik, etc.)
- VPN connection to the server's internal network

**Re-enabling External Access:**
```yaml
coolify_disable_external_ports: false
```

Then re-run the playbook to restore external port access

**Tag-Specific Deployment:**
```bash
# Deploy only firewall configuration
ansible-playbook -i inventory.yml site.yml --ask-vault-pass --tags firewall

# Deploy firewall to specific server
ansible-playbook -i inventory.yml site.yml --ask-vault-pass --limit vps-server --tags firewall
```

### Authentication Methods

**SSH Key Authentication (Recommended):**
```yaml
vault_hosts:
  vps-server:
    auth_method: "ssh_key"
    ansible_ssh_private_key_file: "/path/to/your/private/key"
```

**Password Authentication:**
```yaml
vault_hosts:
  vps-server:
    auth_method: "password"
    ansible_become_pass: "your_server_password"  # Used for both SSH and sudo
```

### Server Roles

The playbook supports different server roles with automatic port configuration:

- **coolify**: Coolify deployment server with full Coolify installation (ports: 8000, 6001, 6002 + defaults)
- **webserver**: General web applications (ports: 8080, 3000 + defaults)  
- **database**: Database servers (ports: 5432, 6379 + defaults, custom SSH port)
- **minimal**: Basic setup (only default ports: SSH, HTTP, HTTPS)

**Default ports for all roles**: SSH (22), HTTP (80), HTTPS (443)

### Environment Settings

Configure different environments in your vault:
```yaml
vault_hosts:
  vps-server:
    environment_name: "production"  # or "staging", "development"
    server_role: "coolify"
    # Production gets stricter security settings
```

## 🏢 Multi-Host Deployment

### Vault Configuration
```yaml
vault_hosts:
  coolify-server:
    ansible_host: "203.0.113.10"
    ansible_user: "root"
    auth_method: "ssh_key"
    ansible_ssh_private_key_file: "/home/user/.ssh/coolify_key"
    server_role: "coolify"
    environment_name: "production"
    
  web-server:
    ansible_host: "203.0.113.20"
    ansible_user: "root"
    auth_method: "password"
    ansible_become_pass: "secure_password"
    server_role: "webserver"
    environment_name: "staging"
```

### Deployment Commands
```bash
# Deploy to all hosts
ansible-playbook -i inventory.yml site.yml --ask-vault-pass

# Deploy to production servers only
ansible-playbook -i inventory.yml site.yml --limit production --ask-vault-pass

# Deploy to specific host
ansible-playbook -i inventory.yml site.yml --limit coolify-server --ask-vault-pass
```

## 🔐 Security Features

### SSH Hardening
- Root login restricted to key-based authentication only (`PermitRootLogin prohibit-password`)
- Password authentication disabled for enhanced security
- Strong encryption algorithms (ChaCha20, AES-GCM)
- **SCP/SFTP support enabled** with proper TCP forwarding and SFTP subsystem configuration
- Connection rate limiting and session management
- Verbose logging for security monitoring
- Custom SSH banner and user restrictions

### System Security
- Kernel parameter hardening
- Unused network protocols disabled
- Automatic security updates (unattended-upgrades)
- Fail2ban intrusion prevention
- UFW firewall configuration

### Network Security
- Default deny firewall policy
- SSH access control (IP-based)
- GitHub webhook support via HTTP/HTTPS ports
- Port-based access control

## 📊 Post-Installation

After successful deployment:

```bash
# Connect with generated SSH key
ssh -i ~/.ssh/hostname_username_key username@your-server-ip

# Verify services
docker --version
sudo systemctl status fail2ban
sudo ufw status numbered  # Shows numbered firewall rules
```

### Firewall Verification

The playbook provides clear firewall status during deployment and you can verify it anytime:

```bash
# Check UFW status with numbered rules
sudo ufw status numbered

# Expected output:
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere
[ 2] 80/tcp                     ALLOW IN    Anywhere
[ 3] 443/tcp                    ALLOW IN    Anywhere
[ 4] 8000/tcp                   ALLOW IN    Anywhere
```

### Generated Assets
- **SSH Keys**: `~/.ssh/hostname_username_key` (generated during deployment)
- **User Account**: Custom user with sudo access
- **Security**: Hardened SSH, UFW firewall, fail2ban
- **Services**: Docker, Docker Compose, containerd

## 🚀 Coolify Installation

When you select the `coolify` server role, the playbook automatically installs and configures [Coolify](https://coolify.io/) - a self-hosted Heroku/Netlify alternative.

### Coolify Features
- **Automated Setup**: Complete installation with proper directory structure and permissions
- **Intelligent Restart Logic**: Smart deployment with conditional restart strategies (force recreate, restart, or normal start)
- **Idempotent Configuration**: Credentials and SSH keys are preserved across playbook runs, with content-based change detection
- **Secure Configuration**: Automatic generation and local backup of secure random values
- **Docker Integration**: Proper Docker network and container configuration with validation
- **User Integration**: Uses coolify group (GID 9999) for proper file access
- **Firewall Configuration**: Pre-configured firewall rules for Coolify ports (8000, 6001, 6002)
- **Credential Management**: Securely stores all generated credentials locally with backup
- **Enhanced Error Handling**: Early failure detection and comprehensive status reporting

### Accessing Coolify
After installation, you can access your Coolify dashboard at:
```
http://your-server-ip:8000
```

### Coolify Directory Structure
```
/data/coolify/
├── source/           # Configuration files
├── applications/     # Deployed applications
├── databases/        # Database data
├── backups/          # Backup files
├── services/         # Service data
├── ssh/              # SSH keys and configuration
└── proxy/            # Proxy configuration
```

### Coolify Management
```bash
# Restart Coolify services
cd /data/coolify/source && docker compose restart

# View Coolify logs
cd /data/coolify/source && docker compose logs -f

# Upgrade Coolify
cd /data/coolify/source && ./upgrade.sh
```

## 🛠️ Customization

### Custom Firewall Rules
```yaml
# In group_vars/vault.yml - Custom ports (added to defaults)
vault_custom_firewall_ports:
  - { port: 8080, proto: tcp, rule: allow, comment: "Custom API" }
  - { port: 5432, proto: tcp, rule: allow, comment: "PostgreSQL" }
  - { port: 9000, proto: udp, rule: allow, comment: "Custom UDP service" }

# Optional: Explicitly deny specific ports
custom_firewall_deny_ports:
  - { port: 23, proto: tcp, rule: deny, comment: "Block Telnet" }
```

### Environment-Specific Settings
```yaml
# In group_vars/vault.yml
vault_hosts:
  production-server:
    environment_name: "production"
    min_cpu_cores: 4
    min_memory_gb: 8
    ssh_port: 2222
    
  staging-server:
    environment_name: "staging"
    min_cpu_cores: 2
    min_memory_gb: 4
    ssh_port: 22
```

### System Requirements
```yaml
# Default values in group_vars/all.yml
min_cpu_cores: 2
min_memory_gb: 4
ssh_port: 22
ssh_key_dir: "~/.ssh"
ssh_allowed_users: ["{{ ansible_user }}"]
ssh_permit_root: true
```

## 🐛 Troubleshooting

### Common Issues

**SSH Key Authentication Fails:**
- Check SSH key permissions: `chmod 600 ~/.ssh/your_key`
- Verify key path in vault configuration
- Ensure public key is properly added to target server

**Environment Variable Shows Empty:**
- Verify vault.yml has correct host key matching inventory.yml
- Check that `environment_name` field is set in vault configuration
- Ensure vault file is properly encrypted and accessible

**Docker Installation Issues:**
- Clean Docker repository conflicts manually if needed
- Verify system meets minimum requirements (2 CPU, 4GB RAM)
- Check internet connectivity on target server

**Firewall Blocks Access:**
- Verify SSH port is allowed before enabling firewall
- Check UFW status: `sudo ufw status verbose`
- Ensure custom ports are properly configured

**UFW Shows as Inactive After Installation:**
- The playbook now includes additional verification steps to ensure UFW is properly enabled
- If UFW still shows as inactive, manually run: `sudo ufw --force enable && sudo systemctl enable ufw`
- Verify with: `sudo systemctl status ufw && sudo ufw status`

**Docker Containers Network Issues:**
- The playbook disables Docker's iptables management to prevent conflicts with UFW
- All firewall rules are managed exclusively by UFW for consistency
- Use standard UFW commands: `sudo ufw allow port/tcp` to control access
- If containers can't reach the internet, check UFW outgoing policy: `sudo ufw status verbose`

**SSH Root Access Issues:**
- Root login is set to `prohibit-password` (key-based authentication only)
- This is more secure than completely disabling root login
- Use your deployment user account and `sudo` for administrative tasks
- Emergency root access is still possible with SSH keys if needed

**Coolify Deployment Performance:**
- The playbook now uses intelligent restart logic to minimize downtime
- Only restarts services when configuration actually changes
- Eliminates unnecessary waiting periods when services are already running
- Provides clear feedback on restart strategy decisions

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
```bash
# Clone repository
git clone https://github.com/yourusername/vps-ansible-setup.git
cd vps-ansible-setup/vps

# Test configuration
ansible-playbook -i inventory.yml site.yml --syntax-check
ansible-inventory -i inventory.yml --list
```

### Reporting Issues
Please use the [GitHub Issues](https://github.com/yourusername/vps-ansible-setup/issues) page to report bugs or request features.

## 📖 Documentation

- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**: Common issues and solutions
- **Ansible Vault**: Use `ansible-vault create/edit/decrypt` for managing secrets

## 🏷️ Supported Platforms

| OS Family | Distributions | Package Manager | Firewall |
|-----------|---------------|-----------------|----------|
| Debian | Ubuntu, Debian | apt | UFW |

## 🔄 Versioning

This project uses [Semantic Versioning](https://semver.org/). For available versions, see the [tags on this repository](https://github.com/yourusername/vps-ansible-setup/tags).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Ansible](https://www.ansible.com/) for the automation framework
- [Coolify](https://coolify.io/) for self-hosted application deployment
- The open-source community for security best practices

## 📞 Support

- **Documentation**: Check troubleshooting section above
- **Issues**: [GitHub Issues](https://github.com/yourusername/vps-ansible-setup/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/vps-ansible-setup/discussions)

---

**⚡ Quick Commands:**

```bash
# Create vault configuration
ansible-vault create group_vars/vault.yml

# Deploy to all hosts
ansible-playbook -i inventory.yml site.yml --ask-vault-pass

# Test connection after setup
ssh -i ~/.ssh/hostname_username_key username@your-server-ip
```

**🎯 Perfect for:** Debian/Ubuntu VPS setup, Coolify deployment, CI/CD servers, development environments, production infrastructure