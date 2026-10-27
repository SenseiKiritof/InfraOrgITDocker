# InfraOrgITDocker — agent guide

`AGENTS.md` is a symlink to this file, read by opencode and the other agents: edit only `CLAUDE.md`.

Read `../AllInfraOrgIT/README.md` and `../AllInfraOrgIT/docs/backlog.md`.

- Secrets only in a local `.env` or a secret manager; version only `.env.example` with fake values.
- No dumps, representative data, Keycloak keys or `data/` in the repo.
- The database schema is not written here: EF migrations in the backend.
- Keycloak in dev uses `start-dev` with the `infraorgit` realm import; the production configuration is added in Phase 8.
- The realm JSON and `.env.example` contain development credentials only; never production data.
- Every change to Compose or the Caddyfile must pass `docker compose config -q` and `caddy validate`.
