# NVIDIA Container Toolkit Ansible Role

This Ansible role installs and configures the NVIDIA Container Toolkit (formerly known as nvidia-docker), which enables GPU support for Docker containers.

## Requirements

- Docker must be installed and configured
- NVIDIA GPU drivers must be installed on the host

## Supported Platforms

- Ubuntu: 20.04 (Focal), 22.04 (Jammy), 24.04 (Noble)
- RHEL/CentOS/Rocky: 8, 9

## Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `nvidia_docker_repo.base_url` | Base URL for NVIDIA repositories | `https://nvidia.github.io/libnvidia-container` |
| `nvidia_docker_repo.gpg_key` | GPG key URL for repository | `<base_url>/gpgkey` |
| `nvidia_docker_repo.deb_list` | APT repository list URL | `<base_url>/stable/deb/nvidia-container-toolkit.list` |
| `nvidia_docker_repo.rpm_repo` | YUM repository file URL | `<base_url>/stable/rpm/nvidia-container-toolkit.repo` |
| `nvidia_docker_skip_docker_restart` | Skip Docker service restart | `false` |

## Example Playbook

```yaml
- hosts: gpu_servers
  roles:
    - nvidia.nvidia_docker
```

