# Integration 10 — RAG Nexus Four-Service Stack

A containerized four-service integration project for Module 10. The stack combines a FastAPI backend, a Next.js frontend, Neo4j, and Weaviate into a one-command Docker Compose workflow with seeded demo data, health checks, frontend smoke tests, and an end-to-end RAG answer flow.

> Cohort Integration Guide: https://LevelUp-Applied-AI.github.io/aispire-14005-pages/modules/module-10/a0cae6a2
> Team-facing Spec: https://LevelUp-Applied-AI.github.io/aispire-14005-pages/modules/module-10/4ba363ed

---

## Project Overview

This repository demonstrates how to integrate multiple application services into a single working AI system:

* **FastAPI backend** for extraction, knowledge graph querying, readiness checks, and RAG answers.
* **Next.js frontend** for user-facing Extract, KG, and RAG pages.
* **Neo4j** for graph data storage and graph-style querying.
* **Weaviate** for vector-style chunk retrieval.
* **Docker Compose** for local orchestration.
* **Playwright smoke tests** for frontend page validation.
* **Integration scripts** for health checks and database seeding.

The final user flow is:

1. Start all services with Docker Compose.
2. Seed Neo4j and Weaviate.
3. Ask a RAG question through the API or frontend.
4. Receive a grounded answer with citations and confidence.

---

## Architecture

```text
                ┌────────────────────┐
                │   Next.js Web UI    │
                │  localhost:3000     │
                └─────────┬──────────┘
                          │ HTTP
                          ▼
                ┌────────────────────┐
                │   FastAPI Backend   │
                │  localhost:8000     │
                └───────┬──────┬─────┘
                        │      │
             Cypher/Bolt│      │Vector retrieval
                        ▼      ▼
             ┌────────────┐  ┌────────────┐
             │   Neo4j    │  │  Weaviate  │
             │ 7474/7687  │  │    8080    │
             └────────────┘  └────────────┘
```

---

## Service Ports

| Service       | Purpose                   | Local URL               |
| ------------- | ------------------------- | ----------------------- |
| Web           | Next.js frontend          | http://localhost:3000   |
| API           | FastAPI backend           | http://localhost:8000   |
| Neo4j Browser | Graph database UI         | http://localhost:7474   |
| Neo4j Bolt    | Graph database connection | `bolt://localhost:7687` |
| Weaviate      | Vector database API       | http://localhost:8080   |

---

## Team Roles

See TEAM.md for role assignments, anonymized team member identifiers, branch ownership, per-role file checklist, and contribution summaries.

Role ownership:

| Role                   | Main ownership                                                                    |
| ---------------------- | --------------------------------------------------------------------------------- |
| Backend lead           | FastAPI endpoints, Pydantic contracts, backend RAG behavior, API Dockerfile       |
| Frontend lead          | Next.js pages, TypeScript API types, frontend Dockerfile, Playwright smoke specs  |
| Infra-Integration lead | Docker Compose, health checks, seed scripts, `.env.example`, CI workflow, runbook |

See CONTRIBUTING.md for branch conventions, internal PR review rules, and contract-change protocol.

---

## Repository Layout

```text
api/
  main.py                         FastAPI app, routes, CORS, lifecycle wiring
  models.py                       Pydantic request/response contracts
  rag.py                          RAG composition, citations, confidence, fallback behavior
  deps.py                         Backend dependency providers
  Dockerfile                      Python API container build
  seed_weaviate.py                Weaviate seed loader
  seed_chunks.json                Seed chunks for retrieval

web/
  pages/
    index.tsx                     Home page
    extract.tsx                   Named entity extraction UI
    kg.tsx                        Knowledge graph query UI
    rag.tsx                       RAG answer UI
    _app.tsx                      Next.js app wrapper
  lib/
    types.ts                      TypeScript interfaces mirroring backend contracts
  Dockerfile                      Multi-stage Next.js Docker build
  playwright.config.ts            Playwright smoke-test configuration

scripts/
  healthcheck_stack.sh            Verifies service health across the Compose stack
  seed_neo4j.sh                   Loads graph fixture data into Neo4j
  seed_weaviate.sh                Loads retrieval chunks into Weaviate through the API container
  seed.cypher                     Neo4j seed data

tests/
  frontend/playwright/            Playwright smoke tests for Extract, KG, and RAG pages
  integration/                    Integration/e2e stack tests

docker-compose.yml                Four-service Compose stack
.env.example                      Safe environment template with placeholder credentials
TEAM.md                           Team roster and role ownership
CONTRIBUTING.md                   Internal collaboration protocol
README.md                         Project runbook
LICENSE                           Educational-use license
```

---

## Quick Start

From the repository root:

```bash
cp .env.example .env
# Edit .env before starting the stack.

docker compose up -d --build
bash scripts/healthcheck_stack.sh
bash scripts/seed_neo4j.sh
bash scripts/seed_weaviate.sh
```

Open the frontend:

```text
http://localhost:3000
```

Useful pages:

```text
http://localhost:3000/extract
http://localhost:3000/kg
http://localhost:3000/rag
```

---


## Local Development Notes

When working locally, make sure the `.env` file is created from `.env.example` before starting the stack. After updating backend, frontend, or seed data files, rebuild the containers with `docker compose up -d --build` to ensure the latest changes are used.

---

## Demo RAG Command

```bash
curl -s -X POST http://localhost:8000/rag/answer \
  -H "Content-Type: application/json" \
  -d '{"question":"How do I prep ginger for stir-fry?","k":4}' | jq .
```

Expected response shape:

```json
{
  "answer": "For stir-frying, slice ginger thin against the grain and discard any woody core. [1]",
  "citations": [
    {
      "chunk_id": 4,
      "score": 0.78668898
    }
  ],
  "confidence": 0.78668898
}
```

---

## Tests

Backend and integration tests:

```bash
python -m pytest tests/ -v
```

Playwright frontend smoke tests:

```bash
cd web
npm ci
npx playwright install chromium
NODE_PATH="$PWD/node_modules" npx playwright test
cd ..
```

Expected result:

```text
3 passed
```