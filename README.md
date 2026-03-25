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

## 🧠 Notes

* Static IP configured via Proxmox (not inside container)
* SSH access uses `root`
* Backend app ports (3000) are intended for internal access via LB
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

---

## 🚀 Next Steps

* Improve automation via Ansible
* Add monitoring (Prometheus / Grafana or Netdata)
* Simulate deployment workflows
* Add failure testing (kill node, observe behaviour)

---

## 💭 Reflection

This homelab started as a simple setup,
but quickly turned into a full learning playground.

> “Just one more check…” → 4 hours later.

---

## 🧠 Author

Built by someone who:

* opens the lab “just for a while”
* and somehow ends up debugging infrastructure at 3AM
