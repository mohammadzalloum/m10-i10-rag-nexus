# Team Roster — Module 10 Integration

This file is the team roster artifact for the Module 10 four-service Docker Compose Integration. The instructional team pre-populates the role assignments before handing the template repo to the team; the team fills in the Team Member identifier, branch, and Slack channel fields.

> **No personal names** in this file. Use anonymized initials, role tokens, or team-chosen identifiers. The team grading and TA cross-reference use `git log --author=<email>` for attribution, not names in this file.

---

## Team Identity

* **Team name:** `team-rag-nexus`
* **Team Slack channel:** `#m10-team-rag-nexus`
* **Team-formation date:** 2026-06-24
* **Designated team submitter:** Infra-Integration lead

---

## Team Roster

| Role                   | Team Member identifier | Assigned by        | Branch                  | Internal-PR reviewer | Primary files owned                                                                                                                                                                                                              |
| ---------------------- | ---------------------- | ------------------ | ----------------------- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Backend lead           | `BE-MZ`                | Instructional team | `backend/api-endpoints` | Frontend lead        | `api/main.py`, `api/models.py`, `api/rag.py`, `api/deps.py`, `api/Dockerfile`                                                                                                                                                    |
| Frontend lead          | `FE-RA`                | Instructional team | `frontend/nextjs-pages` | Backend lead         | `web/pages/{extract,kg,rag}.tsx`, `web/lib/types.ts`, `web/Dockerfile`, `web/playwright.config.ts`, `tests/frontend/playwright/*`                                                                                                |
| Infra-Integration lead | `INF-LS`               | Instructional team | `infra/docker-compose`  | Backend lead         | `docker-compose.yml`, `scripts/healthcheck_stack.sh`, `scripts/seed_neo4j.sh`, `scripts/seed_weaviate.sh`, `.env.example`, `.github/workflows/integration-10-dockerize-stack-autograder.yml`, `README.md`, `tests/integration/*` |

**Fallback compositions for non-3-Team-Member teams:**

* **2 Team Members:** Frontend and Infra-Integration roles merge. The merged Team Member owns all `web/`, `docker-compose.yml`, and `seed_*.sh` files.
* **4 Team Members:** Infra-Integration splits into "Compose + healthchecks" (owns `docker-compose.yml`, all healthchecks, readiness ordering) and "Seed + runbook" (owns `scripts/seed_neo4j.sh`, `scripts/seed_weaviate.sh`, `README.md` runbook). The two Team Members internal-review each other.

---

## Per-Role File Checklist (used for TA grading cross-reference)

The TA cross-references this checklist against `git log --author=<email>` on the team fork during per-role grading. Check the box when the Team Member confirms they authored the file.

### Backend lead

* [x] `api/main.py` — FastAPI path operations, application wiring, `lifespan`, and CORS middleware
* [x] `api/models.py` — Pydantic request/response shapes for backend contracts
* [x] `api/rag.py` — RAG composer with grounding contract, citations, confidence, and citation-only fallback behavior
* [x] `api/deps.py` — dependency-provider functions used by FastAPI endpoints
* [x] `api/Dockerfile` — Python API container build definition

### Frontend lead

* [x] `web/pages/extract.tsx` — Extract UI page for named entity extraction
* [x] `web/pages/kg.tsx` — Knowledge graph query UI page
* [x] `web/pages/rag.tsx` — RAG answer UI page with cited answer rendering
* [x] `web/lib/types.ts` — TypeScript interfaces mirroring backend/Pydantic API contracts
* [x] `web/Dockerfile` — multi-stage Node/Next.js frontend container
* [x] `web/playwright.config.ts` — Playwright smoke-test configuration, test discovery path, and reuse of the running web service
* [x] `tests/frontend/playwright/extract.spec.ts` — frontend smoke test for Extract page
* [x] `tests/frontend/playwright/kg.spec.ts` — frontend smoke test for KG page
* [x] `tests/frontend/playwright/rag.spec.ts` — frontend smoke test for RAG page

### Infra-Integration lead

* [x] `docker-compose.yml` — four-service stack, ports, service wiring, healthchecks, dependency ordering, and named volumes
* [x] `scripts/healthcheck_stack.sh` — stack healthcheck helper for API, web, Neo4j, and Weaviate
* [x] `scripts/seed_neo4j.sh` — Neo4j seed script using environment-based credentials
* [x] `scripts/seed_weaviate.sh` — Weaviate seed script executed through the API container
* [x] `.env.example` — placeholder-only environment template with no real credentials
* [x] `.github/workflows/integration-10-dockerize-stack-autograder.yml` — CI workflow for integration smoke checks, RAG response validation, Docker Compose stack checks, and Playwright smoke tests
* [x] `README.md` — runbook and local execution instructions
* [x] `tests/integration/test_stack_e2e.py` — integration/e2e stack test coverage

---

## Per-Role Contribution Summary

### Backend lead — `BE-MZ`

The Backend lead owned the FastAPI service contract and backend behavior. This included the API path operations, Pydantic models, dependency wiring, and the RAG response contract. The backend work ensured `/rag/answer` returns a usable grounded answer with non-empty citations and confidence, and added protection against citation-only responses by falling back to an extractive answer from the retrieved chunk when needed. The Backend lead also maintained the API container build definition and supported integration with the frontend and infrastructure layers.

### Frontend lead — `FE-RA`

The Frontend lead owned the Next.js user-facing pages and frontend validation flow. This included the `/extract`, `/kg`, and `/rag` pages, the shared TypeScript API interfaces, the frontend Dockerfile, and the Playwright smoke tests for all three pages. The frontend work verified that each page renders correctly, can call or mock the matching API route, and displays expected output to the user. The Playwright configuration was also adjusted so frontend smoke tests run against the already-running Docker Compose web service.

### Infra-Integration lead — `INF-LS`

The Infra-Integration lead owned the four-service Docker Compose integration and the operational scripts. This included the Compose stack for API, web, Neo4j, and Weaviate; healthchecks; dependency ordering; named volumes; and environment configuration. The Infra lead also owned the Neo4j and Weaviate seed scripts, the placeholder-only `.env.example`, the CI/autograder workflow, and the runbook-level integration instructions. This work ensured the stack can be built, started, seeded, health-checked, and validated end-to-end in both local and CI environments.

---

## Integration Validation Summary

The final integration branch was merged into `main` after the GitHub pull request checks passed. The final stack included all four services running through Docker Compose, seed scripts for Neo4j and Weaviate, backend RAG validation with citations and confidence, and Playwright frontend smoke tests for Extract, KG, and RAG pages.

The final local Git state confirmed:

* `main` was up to date with `origin/main`
* the integration PR merge commit was present on `main`
* the working tree was clean
* the temporary cleanup branch was deleted locally after merge

---

## Escalation Checklist (apply in order)

When a disagreement about scope, role boundaries, or contract changes arises:

1. **Inline comment on the internal PR.** State the disagreement specifically and link the contract artifact (Pydantic shape, TypeScript interface, Compose service entry).
2. **Team Slack channel with TA tagged.** Tag the TA who covers the team. Allow up to 4 working hours for response.
3. **Support Instructor.** If the TA decision is contested or the TA is unavailable, escalate to the Support Instructor via the cohort Slack channel.
4. **Lead Instructor.** Only if a role-rebalancing decision is needed or the disagreement is not resolved by the Support Instructor.

Document the escalation path taken in the team submission PR description.

---

## Contract-Change Protocol

* **Backend lead** announces any Pydantic shape change on the team Slack channel **before** the change lands.
* **Frontend lead** requests new backend fields via an internal-PR comment on the Backend lead's branch — does not assume.
* **Infra-Integration lead** announces any `.env` or DNS-affecting change before the change lands.

The protocol is enforced by the internal-PR review — the reviewer rejects PRs where the contract change was not announced.

---

## Submission

When all three role branches merge to the team fork's `main` and `docker compose up -d` smoke passes locally for each Team Member:

1. The team submitter pastes the team fork URL into TalentLMS → Module 10 → Integration Task.
2. Each Team Member separately submits the participation-confirmation TalentLMS unit naming their assigned role and the files they authored.

The two-tier grading model (team tier 60 pts + per-role tier 40 pts) is described in the team-facing Integration Spec at https://LevelUp-Applied-AI.github.io/aispire-14005-pages/modules/module-10/4ba363ed.
