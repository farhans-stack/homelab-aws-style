# Docker in LXC Notes

This lab runs Docker inside **privileged LXC** containers (Proxmox).

## Challenges encountered
- AppArmor restrictions inside LXC
- overlayfs mount permission errors

## Solutions
- Use a wrapper (`drun`) to run containers with:
  `--security-opt apparmor=unconfined`
- On some nodes, Docker uses `fuse-overlayfs`
- `/dev/fuse` is bind-mounted into the container

## Why
This mirrors real-world constraints when running Docker in containerised or restricted environments.
