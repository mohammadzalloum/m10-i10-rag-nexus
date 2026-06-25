
#!/usr/bin/env bash
set -euo pipefail

echo "Running Weaviate vector seeder inside the API container..."

docker compose exec -T api python api/seed_weaviate.py

echo "Weaviate vector database seeding completed successfully."
