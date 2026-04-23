#!/usr/bin/env bash

set -u

declare -A HOSTS=(
  [lb-haproxy]=192.168.xx.xx
  [app1]=192.168.xx.xx
  [app2]=192.168.xx.xx
  [app3]=192.168.xx.xx
  [db-postgres]=192.168.xx.xx
)

echo "=== HOMELAB HEALTH CHECK ==="
echo

echo "[1] Ping checks"
for name in lb-haproxy app1 app2 app3 db-postgres; do
  ip="${HOSTS[$name]}"
  if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
    echo "OK   $name ($ip)"
  else
    echo "FAIL $name ($ip)"
  fi
done

echo
echo "[2] SSH checks"
for name in lb-haproxy app1 app2 app3 db-postgres; do
  ip="${HOSTS[$name]}"
  if ssh -o BatchMode=yes -o ConnectTimeout=3 root@"$ip" "hostname" >/dev/null 2>&1; then
    echo "OK   SSH $name"
  else
    echo "WARN SSH $name (password/key issue or unreachable)"
  fi
done

echo
echo
echo "[3] App direct checks from laptop"
for name in app1 app2 app3; do
  ip="${HOSTS[$name]}"
  code=$(curl -s --connect-timeout 2 --max-time 3 -o /dev/null -w "%{http_code}" "http://$ip:3000/")
  if [ "$code" = "200" ]; then
    echo "OK   $name ($ip) -> HTTP $code"
  else
    echo "INFO $name ($ip) -> direct access unavailable from laptop (HTTP $code)"
  fi
done
echo
echo "[4] Load balancer rotation"
for i in {1..6}; do
  curl -sI --max-time 3 "http://${HOSTS[lb-haproxy]}/" | grep -i x-backend || echo "LB FAIL"
done

echo
echo "[5] DB port"
nc -zv "${HOSTS[db-postgres]}" 5432
