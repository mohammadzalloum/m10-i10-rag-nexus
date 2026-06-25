#!/usr/bin/env bash
# Seed the running Neo4j container with the recipe fixture.
#
# Idempotent — `MERGE` and `CREATE CONSTRAINT IF NOT EXISTS` in seed.cypher
# mean repeat runs do not duplicate nodes.
#
# TODO (Infra-Integration lead): implement this script.
# Required:
# - Read NEO4J_USER and NEO4J_PASSWORD from the environment (loaded
#   from .env by docker compose).
# - Pipe seed.cypher into the neo4j container via
#   `docker compose exec -T neo4j cypher-shell -u $NEO4J_USER -p $NEO4J_PASSWORD`.
# - Print a one-line confirmation.
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