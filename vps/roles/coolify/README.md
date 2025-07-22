# Coolify Role

This Ansible role automates the installation and configuration of [Coolify](https://coolify.io/), a self-hosted Heroku/Netlify alternative.

## Features

- **Automated Installation**: Complete setup of Coolify with proper directory structure and permissions
- **Secure Configuration**: Automatic generation and local backup of secure random values for all credentials
- **Docker Integration**: Proper Docker network and container configuration
- **Existing User Integration**: Uses the deploy user's SSH key for Coolify management
- **Idempotent Execution**: Safe to run multiple times without duplicating configuration
- **Credential Management**: Securely stores all generated credentials locally for backup

## Requirements

- Docker and Docker Compose must be installed (handled by the `docker_setup` role)
- UFW firewall configured to allow Coolify ports (handled by the `firewall_setup` role)
- Minimum system requirements: 2 CPU cores, 4GB RAM

## Role Variables

Variables are defined in `defaults/main.yml`:

```yaml
# Coolify installation directory
coolify_base_dir: /data/coolify

# Coolify configuration
coolify_user_id: 9999
coolify_group: root

# Coolify ports
coolify_dashboard_port: 8000
coolify_websocket_port: 6001
coolify_terminal_port: 6002
```

## Directory Structure

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

## Usage

Include this role in your playbook:

```yaml
- hosts: servers
  roles:
    - role: coolify
      tags: [coolify]
      when: server_role == 'coolify'
```

## Post-Installation

After installation, you can access your Coolify dashboard at:
```
http://your-server-ip:8000
```

## User Integration

The role integrates with your existing `deploy` user:

- Uses the deploy user's SSH key for Coolify management
- Adds the Coolify SSH key to the deploy user's authorized_keys
- Ensures the deploy user has Docker access for managing Coolify
- Requires the user_management role to be run first (will fail if user doesn't exist)

## Management Commands

As the deploy user:

```bash
# Restart Coolify services
docker compose --project-directory /data/coolify/source restart

# View Coolify logs
docker compose --project-directory /data/coolify/source logs -f

# Upgrade Coolify
sudo /data/coolify/source/upgrade.sh
```

## Credential Management

All credentials are securely stored in a single file:

```
.credentials/
└── your-server/
    └── coolify/
        ├── passwords       # Single file containing all passwords
        └── .env            # Complete environment file (backup)
```

The `passwords` file contains all generated credentials with labels (e.g., `APP_ID=abc123`), and the `.env` file contains the complete Coolify configuration. This approach keeps all sensitive data in one secure location.

## License

MIT