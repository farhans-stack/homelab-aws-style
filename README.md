# 🧪 AWS Homestyle Lab (Proxmox LXC)

A lightweight homelab simulating AWS-style infrastructure using Proxmox LXC containers.

Built for learning, testing, breaking, and rebuilding — without burning cloud credits.

---

## 🎯 Objective

To replicate a simplified cloud architecture locally:

* App servers → EC2
* HAProxy → Load Balancer (ELB)
* PostgreSQL → RDS
* Ansible → Configuration management
* Netdata → Infrastructure monitoring

---

## 🏗️ Architecture

Client (Laptop)
↓
HAProxy (lb-haproxy:80)
↓
-

|    |         |        |
app1  app2      app3   (round robin)
↓
PostgreSQL (db-postgres:5432)

Monitoring:

* Netdata agents installed on all nodes
* Centralised monitoring via `lb-haproxy`

---

## 🖥️ Nodes

| Node        | Role                | IP Address  | Port |
| ----------- | ------------------- | ----------- | ---- |
| lb-haproxy  | Load Balancer       | 192.168.x.x | 80   |
| app1        | App Server          | 192.168.x.x | 3000 |
| app2        | App Server          | 192.168.x.x | 3000 |
| app3        | App Server          | 192.168.x.x | 3000 |
| db-postgres | Database (Postgres) | 192.168.x.x | 5432 |

---

## ⚙️ Tech Stack

* Proxmox (LXC containers)
* HAProxy (Load balancing)
* Nginx / App service (port 3000)
* PostgreSQL
* Ansible (automation & roles)
* Netdata (monitoring)

---

## ✅ What Has Been Verified

* Static IPs configured for all containers
* SSH connectivity working across all nodes
* HAProxy round-robin working across app1, app2, and app3
* PostgreSQL reachable on port 5432
* Ansible inventory aligned with current infrastructure
* Health check script created for quick validation
* Centralised Netdata monitoring working across all 5 nodes

---

## 🔁 Load Balancing

Round-robin verified:

```text
app1 → app2 → app3 → app1 → app2 → app3
```

HAProxy routes traffic correctly across all backend nodes.

---

## 🔍 Health Check

Run:

```bash
./scripts/check_lab.sh
```

Checks:

* Host reachability (ping)
* SSH access
* Load balancer rotation
* Database port availability
* Optional direct app access

---

## 📊 Monitoring

Netdata is installed on all nodes.

Current setup:

* `lb-haproxy` acts as the Netdata parent
* `app1`, `app2`, `app3`, and `db-postgres` stream metrics to the parent
* A central dashboard is available from the parent node

Monitoring currently provides:

* Per-node CPU usage
* Memory usage
* Load
* Disk activity
* Network traffic

---

## 🧠 Notes

* Static IP is configured via Proxmox, not inside the containers
* SSH access uses `root`
* Backend app ports (3000) are primarily intended for internal access via the load balancer
* Netdata uses a parent-child streaming model for centralised visibility
* Lab is designed for **deploy → test → destroy → repeat**

---

## 📦 Backups

Configs stored locally under:

```bash
/backups
```

Includes:

* HAProxy config
* SSH configs
* PostgreSQL configs

---

## 📸 Proof

See `/screenshots` for:

* HAProxy round robin test
* Lab validation outputs
* Netdata multi-node monitoring view

---

## 🚀 Next Steps

* Refine Ansible roles and playbooks further
* Add alerting for resource thresholds
* Expand deployment workflows
* Simulate node failure and recovery under monitoring
* Optionally add Grafana later for aggregated visual dashboards

---

## 💭 Reflection

This homelab started as a simple setup,
but quickly turned into a full learning playground.

> “Just one more check…” → 4 hours later.
