# Security Hardening Role

This role applies comprehensive security hardening measures to Linux servers.

## Features

- SSH hardening and secure configuration
- Fail2ban setup for intrusion prevention
- Automatic security updates
- Kernel security parameter hardening
- User access verification and security checks

## Kernel Security Parameters

This role applies industry-standard kernel security parameters based on:
- CIS (Center for Internet Security) Benchmarks
- NIST (National Institute of Standards and Technology) guidelines
- DISA STIG (Defense Information Systems Agency Security Technical Implementation Guides)

For detailed explanations of each parameter, see [KERNEL_SECURITY.md](../../docs/KERNEL_SECURITY.md).

## Usage

Include this role in your playbook:

```yaml
- name: Apply security hardening
  hosts: servers
  roles:
    - role: security_hardening
      tags: [security]
```

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_port` | `22` | SSH port to use |
| `ssh_max_auth_tries` | `3` | Maximum SSH authentication attempts |
| `ssh_client_alive_interval` | `300` | SSH client alive interval |
| `ssh_client_alive_count_max` | `2` | Maximum SSH client alive count |
| `fail2ban_bantime` | `3600` | Fail2ban ban time in seconds |
| `fail2ban_findtime` | `600` | Fail2ban find time in seconds |
| `fail2ban_maxretry` | `3` | Fail2ban maximum retry attempts |

## Tags

- `security`: All security hardening tasks
- `ssh`: SSH hardening tasks
- `fail2ban`: Fail2ban configuration tasks
- `kernel`: Kernel security parameter configuration
- `updates`: Automatic security updates configuration

## Dependencies

- Requires the user_management role to be run first to set up the non-root user

## Safety Features

This role includes critical safety checks to prevent lockouts:
- Verifies user existence before applying SSH hardening
- Confirms sudo access is properly configured
- Tests SSH key authentication before disabling password authentication
- Maintains backup of original SSH configuration