# InfraOrgITDocker

Local infra for InfraOrgIT: Docker Compose with MySQL, Keycloak and Caddy. The complete production configuration arrives in Phase 8.

Compose project: `infraorgit`. `make dev` applies migrations on startup, so the database populates itself; local volumes can be removed with `make reset`.

## Services

| Service | Host port | Purpose |
|---|---|---|
| `mysql` | 127.0.0.1:3306 | application database `infraorgit` |
| `mysql-keycloak` | 127.0.0.1:3307 | Keycloak database |
| `keycloak` | 127.0.0.1:8080 | OIDC, realm `infraorgit` |
| `mysql-legacy` | 127.0.0.1:3308 | fake legacy dump for the Phase 7 rehearsal (`legacy` profile) |
| `migrate` | — | one-off EF job, exits when the schema is up to date (`full` profile) |
| `api` | internal 8080 | non-root .NET API, read-only filesystem (`full` profile), `infraorgit-api` image |
| `caddy` | 80/443 | SPA + API reverse proxy (`full` profile) |

Ports are bound to loopback: the infra is not reachable from the LAN. MySQL and Keycloak are configured for development; production arrives in Phase 8.

## Start

```bash
cp .env.example .env
docker compose up -d --wait mysql mysql-keycloak keycloak
```

Keycloak imports `keycloak/realm-infraorgit.json`: client `infraorgit`, test user `admin` / `dev-admin`. Development-only credentials, never in production.

If you change the realm, the client or the secret, `--import-realm` does not update an existing realm. Use `make reset` from the meta repo (removes the volumes) and restart.

Keycloak console: http://localhost:8080/admin with the admin credentials in `.env`.

Full profile with API, migration job and Caddy:

```bash
# from the meta repo: frontend build, credential key from env.sh, then compose
make full
```

Caddy serves `dist/` and forwards `/api/*` and `/auth/*` to `API_UPSTREAM` (default `api:8080`), `/realms/*` and `/resources/*` to Keycloak. The API runs as user `app` with a read-only root filesystem, `cap_drop: ALL` and `no-new-privileges`; the `migrate` job applies migrations and exits before the API starts. Sessions live in MySQL (`Sessions` table, encrypted payload) and DataProtection keys in the `api-dp-keys` volume: restarting the API does not lose the login.

Keycloak in the `full` profile uses `start` (not `start-dev`) with `KC_HOSTNAME=https://localhost`, proxy headers and dynamic backchannel: the public issuer is `https://localhost/realms/infraorgit`, while the API reaches discovery, tokens and JWKS on `http://keycloak:8080` (`Oidc__InternalIssuer`, `Oidc__AllowInsecureInternalDiscovery=true`). API and Keycloak share the isolated `auth` network (`internal: true`), so the other containers do not see the OIDC traffic; it is still internal HTTP, so compromising either container still exposes the tokens.

For a real host you need `SITE_ADDRESS`, `SITE_URL`, `OIDC_ISSUER`, `OIDC_INTERNAL_ISSUER`, `OIDC_REDIRECT_URI` and `FRONTEND_BASE_URL` consistent with each other, plus updated Keycloak client redirect URIs. The current redirects only cover `http://localhost:3000` and `https://localhost`.

Warning: changing `keycloak/realm-infraorgit.json` does not update an already imported realm. You need a new Keycloak volume (`make reset`, which also removes the application data) or updating the client from the console.

Observability: the API emits JSON logs with a correlation id. Setting `OTEL_EXPORTER_OTLP_ENDPOINT` in `.env` enables OTLP traces and metrics; without a collector they stay disabled.

## Fake legacy dump

`legacy/01-schema.sql` and `legacy/02-data.sql` create a reduced legacy schema with fake data: one environment, one provider, one machine, one proxy, one service, one diagram and one execution. It only exists to test the Phase 7 importer and contains no production data.

The structure matches the legacy export (`InfraOrgITDocker/legacy/01-schema.sql`): same types, defaults, indexes and foreign keys. Only `AdminAuditEntries` and `__EFMigrationsHistory` are left out, which the importer does not read.

```bash
docker compose --profile legacy up -d --wait mysql-legacy
cd ../AllInfraOrgIT && make legacy-rehearsal
```

The container has no volume: every recreation re-runs the init scripts and starts from scratch.

## Rules

- `.env` is not committed; only `.env.example`.
- No target schema or seed in the init SQL: the schema comes from EF migrations. `legacy/` only contains the reduced legacy schema for the rehearsal.
- Explicit image versions; digests pinned at release.
- The realm JSON contains development credentials only, never production data.

## Application images

The local Compose builds the API from the `../InfraOrgITApi` context. For a release, use the images published by the application repos:

- `ghcr.io/senseikiritof/infraorgit-api:<versione>`
- `ghcr.io/senseikiritof/infraorgit-web:<versione>`

The web image is not used by the `full` profile (Caddy serves `../InfraOrgITWeb/dist`), but it can be shipped on its own on port 80.
