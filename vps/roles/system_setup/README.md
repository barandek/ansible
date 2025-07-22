# System Setup Role

This role performs basic system setup for Linux servers.

## Features

- Essential package installation
- Timezone configuration
- System language configuration

## Usage

Include this role in your playbook:

```yaml
- name: Apply system setup
  hosts: servers
  roles:
    - role: system_setup
      tags: [system]
```

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `timezone` | `UTC` | System timezone |
| `system_packages` | [list] | Essential packages to install |

## Tags

- `system`: All system setup tasks
- `packages`: Package installation tasks

## Dependencies

None. This role is designed to run independently before other roles.