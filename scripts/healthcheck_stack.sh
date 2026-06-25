#!/usr/bin/env bash
# Poll `docker compose ps` until all four services report healthy or
# until the 90s budget expires.
#
# TODO (Infra-Integration lead): implement this script.
# - Loop with 2s sleep, up to 45 iterations.
# - Use `docker compose ps --format json` and check Health=="healthy"
#   for api, web, neo4j, weaviate.
# - Exit 0 on all healthy; exit 1 on timeout.


set -euo pipefail

echo "Starting stack healthcheck poll (90s budget)"

MAX_ITERATIONS=45
SLEEP_INTERVAL=2

for ((i=1; i<=MAX_ITERATIONS; i++)); do
    HEALTHY_COUNT=$(docker compose ps --format json | grep -c '"Health":"healthy"' || true)
    
    if [ "$HEALTHY_COUNT" -eq 4 ]; then
        echo "✅ All 4 services (api, web, neo4j, weaviate) are HEALTHY!"
        exit 0
    fi
    
    echo "  [Attempt $i/$MAX_ITERATIONS] Healthy services: $HEALTHY_COUNT/4. Retrying in ${SLEEP_INTERVAL}s..."
    sleep $SLEEP_INTERVAL
done

echo "❌ Timeout: Not all services reached a healthy state within 90 seconds."
exit 1
