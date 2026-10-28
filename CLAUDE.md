# InfraOrgITDocker — agent guide

`AGENTS.md` is a symlink to this file, read by opencode and the other agents: edit only `CLAUDE.md`.

Read `../AllInfraOrgIT/README.md` and `../AllInfraOrgIT/docs/backlog.md`.

- Secrets only in a local `.env` or a secret manager; version only `.env.example` with fake values.
- No dumps, representative data, Keycloak keys or `data/` in the repo.
- The database schema is not written here: EF migrations in the backend.
- One Compose file for the whole stack; Keycloak runs `start-dev` for `make dev` (`KC_MODE=dev`) and `start` for the full stack (`KC_MODE=prod`, default).
- The realm JSON and `.env.example` contain development credentials only; never production data.
- Every change to Compose must pass `docker compose config -q`; the web Caddyfile lives in `../InfraOrgITWeb`.
