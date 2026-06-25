#!/usr/bin/env bash
set -euo pipefail

echo "Starting stack healthcheck poll (90s budget)"

MAX_ITERATIONS=45
SLEEP_INTERVAL=2

for ((i=1; i<=MAX_ITERATIONS; i++)); do
    PS_JSON="$(docker compose ps --format json)"

    HEALTH_RESULT="$(
        PS_JSON="$PS_JSON" python - <<'PY'
import json
import os

raw = os.environ.get("PS_JSON", "").strip()
needed = {"api", "web", "neo4j", "weaviate"}

if not raw:
    print("0 api web neo4j weaviate")
    raise SystemExit(0)

try:
    parsed = json.loads(raw)
    rows = parsed if isinstance(parsed, list) else [parsed]
except json.JSONDecodeError:
    rows = [json.loads(line) for line in raw.splitlines() if line.strip()]

healthy = set()

for row in rows:
    service = row.get("Service", "")
    health = str(row.get("Health", "")).lower()
    status = str(row.get("Status", "")).lower()

    if service in needed and (health == "healthy" or "(healthy)" in status):
        healthy.add(service)

missing = sorted(needed - healthy)
print(f"{len(healthy)} {' '.join(missing)}")
PY
    )"

    healthy_count="${HEALTH_RESULT%% *}"
    missing_services="${HEALTH_RESULT#* }"

    if [ "$healthy_count" -eq 4 ]; then
        echo "All 4 services are healthy: api, web, neo4j, weaviate"
        exit 0
    fi

    echo "[Attempt $i/$MAX_ITERATIONS] Healthy services: $healthy_count/4. Missing: $missing_services. Retrying in ${SLEEP_INTERVAL}s..."
    sleep "$SLEEP_INTERVAL"
done

echo "Timeout: not all services reached healthy state within 90 seconds."
docker compose ps
exit 1
