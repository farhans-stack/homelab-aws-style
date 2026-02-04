# Homelab AWS-Style Architecture (Proxmox)

A small homelab project that mimics a simple AWS setup:
- **EC2**: 3 application nodes (Dockerised)
- **ALB/ELB**: HAProxy (round-robin + health checks + stats)
- **RDS**: PostgreSQL server

## Architecture
![diagram](architecture/diagram.png)

## Nodes
| Role | Hostname | IP | Notes |
|---|---|---|---|
| Load Balancer | lb-haproxy | <LB_IP> | HAProxy on port 80, stats on 8404 |
| App 1 | app-1 | <APP1_IP> | Docker + `drun` wrapper |
| App 2 | app-2 | <APP2_IP> | Docker + fuse-overlayfs + /dev/fuse |
| App 3 | app-3 | <APP3_IP> | Docker + fuse-overlayfs + /dev/fuse |
| Database | db-postgres | <DB_IP> | PostgreSQL on 5432 |

## What this demonstrates
- Round-robin load balancing across 3 app nodes
- HTTP health checks and automatic failover (traffic is diverted away from unhealthy nodes)
- Basic monitoring via HAProxy stats dashboard

## HAProxy config highlights
- Backend health check: `GET /`
- Response header injection for testing:
  - `X-Backend: app1/app2/app3`

## How to test
### 1) Confirm round-robin
```bash
for i in {1..12}; do curl -sI http://<LB_IP>/ | grep -i "^x-backend:"; done


## Design Decisions & Constraints
### Why LXC (instead of full virtual machines)
This project uses **Linux Containers (LXC)** on Proxmox instead of full virtual machines.

The decision was made to:
- Reduce CPU and memory overhead on limited homelab hardware
- Allow faster provisioning and recovery of nodes
- Leverage Proxmox’s native container support
- Focus on **system behaviour and architecture**, rather than virtualisation performance

LXC provides a lightweight and practical way to simulate **EC2-style application nodes** while preserving realistic operational constraints.

---

### Running Docker inside LXC
Docker is intentionally run **inside privileged LXC containers**.

This reflects real-world environments where containers are deployed under constraints such as:
- Security frameworks (e.g. AppArmor)
- Filesystem limitations
- Kernel feature availability differences between nodes

Running Docker in this setup exposes operational challenges that engineers are often required to diagnose and resolve in production systems.

---

### Why application nodes are not identical
Although all application nodes serve the **same workload** behind HAProxy, their internal Docker configurations are **not identical**.

- `app1` runs Docker using the default overlay filesystem
- `app2` and `app3` require `fuse-overlayfs` with `/dev/fuse` exposed due to environment constraints

This difference is **intentional**.

In real production environments, infrastructure is rarely perfectly uniform.
Nodes may differ due to kernel versions, security policies, or platform limitations.

This project demonstrates that:
- Load balancers operate based on **health and availability**, not internal implementation
- Services remain resilient as long as each node satisfies the required service contract
- Operational tooling must adapt to infrastructure realities rather than assume uniformity

HAProxy treats all application nodes equally, relying solely on health checks and response behaviour.

