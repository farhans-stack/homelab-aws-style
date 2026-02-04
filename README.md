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
