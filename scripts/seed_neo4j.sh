
#!/usr/bin/env bash
set -euo pipefail

if [ -f .env ]; then
    set -a
    . ./.env
    set +a
fi

NEO4J_USER="${NEO4J_USER:-neo4j}"

if [ -z "${NEO4J_PASSWORD:-}" ]; then
    echo "Error: NEO4J_PASSWORD must be set in .env or environment."
    exit 1
fi

SEED_FILE="scripts/seed.cypher"

if [ ! -f "$SEED_FILE" ]; then
    echo "Error: missing $SEED_FILE"
    exit 1
fi

echo "Seeding Neo4j from $SEED_FILE..."

docker compose exec -T neo4j cypher-shell \
    -u "$NEO4J_USER" \
    -p "$NEO4J_PASSWORD" < "$SEED_FILE"

echo "Neo4j database seeding completed successfully."