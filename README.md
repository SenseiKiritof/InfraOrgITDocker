# InfraOrgITDocker

Docker Compose stack for InfraOrgIT: MySQL, Keycloak, API and the web front door.

Compose project: `infraorgit`. `make dev` applies migrations on startup, so the database populates itself. MySQL data lives in the bind mounts `data/mysql` and `data/mysql-keycloak` and survives `down`/`down -v`; `make reset` deletes the directory and re-runs the init scripts.

## Services

| Service | Host port | Purpose |
|---|---|---|
| `mysql` | 127.0.0.1:3306 | application database `infraorgit`, initialized by `init/mysql`; data in `data/mysql` |
| `mysql-keycloak` | 127.0.0.1:3307 | Keycloak database, data in `data/mysql-keycloak` |
| `keycloak` | 127.0.0.1:8080 | OIDC, realm `infraorgit` |
| `migrate` | — | one-off EF job, exits when the schema is up to date |
| `api` | internal 8080 | non-root .NET API, read-only filesystem, `infraorgit-api` image |
| `web` | 80/443 | SPA, API and Keycloak on one origin (`infraorgit-web` image) |

MySQL and Keycloak are bound to loopback; the `web` front door listens on 80/443. Development credentials only; in production use a secret manager.

## Start

```bash
cp .env.example .env
docker compose up -d --wait mysql mysql-keycloak keycloak
```

Keycloak imports `keycloak/realm-infraorgit.json`: client `infraorgit`, test user `admin` / `dev-admin`. Development-only credentials, never in production.

If you change the realm, the client or the secret, `--import-realm` does not update an existing realm. Use `make reset` from the meta repo (removes the volumes) and restart.

Keycloak console: http://localhost:8080/admin with the admin credentials in `.env`.

Whole stack in one compose file:

```bash
# from this directory: builds API and web images, applies migrations, starts everything
docker compose up -d --build --wait
# or from the meta repo (stop `make dev` first: API and Vite share the host ports)
make full
```

The `web` image serves the SPA and forwards `/api/*` and `/auth/*` to `API_UPSTREAM` (default `api:8080`), `/realms/*` and `/resources/*` to `KEYCLOAK_UPSTREAM` (default `keycloak:8080`). The API runs as user `app` with a read-only root filesystem, `cap_drop: ALL` and `no-new-privileges`; the `migrate` job applies migrations and exits before the API starts. Sessions live in MySQL (`Sessions` table, encrypted payload) and DataProtection keys in the `api-dp-keys` volume: restarting the API does not lose the login.

The full stack runs Keycloak with `start` (not `start-dev`) and `KC_HOSTNAME=https://localhost`, proxy headers and dynamic backchannel (`KC_MODE=prod`, the default); `make dev` passes `KC_MODE=dev`: the public issuer is `https://localhost/realms/infraorgit`, while the API reaches discovery, tokens and JWKS on `http://keycloak:8080` (`Oidc__InternalIssuer`, `Oidc__AllowInsecureInternalDiscovery=true`). API and Keycloak share the isolated `auth` network (`internal: true`), so the other containers do not see the OIDC traffic; it is still internal HTTP, so compromising either container still exposes the tokens.

For a real host you need `SITE_ADDRESS`, `SITE_URL`, `OIDC_ISSUER`, `OIDC_INTERNAL_ISSUER`, `OIDC_REDIRECT_URI` and `FRONTEND_BASE_URL` consistent with each other, plus updated Keycloak client redirect URIs. The current redirects only cover `http://localhost:3000` and `https://localhost`. `WEB_TAG` selects the published web image instead of a local build, like `API_TAG` for the API.

Warning: changing `keycloak/realm-infraorgit.json` does not update an already imported realm. You need a new Keycloak volume (`make reset`, which also removes the application data) or updating the client from the console.

Observability: the API emits JSON logs with a correlation id. Setting `OTEL_EXPORTER_OTLP_ENDPOINT` in `.env` enables OTLP traces and metrics; without a collector they stay disabled.

## Database init scripts

`init/mysql/` is mounted at `/docker-entrypoint-initdb.d` on `mysql` and runs only on a fresh volume (`make reset`). It builds the application database `infraorgit`:

| File | Content | Git |
|---|---|---|
| `1-InfrastructureApps.sql` | schema of every table and the `__EFMigrationsHistory` rows, so the EF `migrate` job is a no-op | versioned |
| `2-BaseData.sql` | generic data: environments, roles, menus and role bindings | versioned |
| `3-CustomData.sql` | installation data: providers, topology, applications, diagrams, users, groups, logs | ignored, private |

The scripts are generated from the migrated database (`1-`), with data exported as `REPLACE INTO` (`2-`, `3-`). After a schema change: apply migrations, re-export `1-`; `__EFMigrationsHistory` keeps the `migrate` job aligned.

## Rules

- `.env` is not committed; only `.env.example`.
- `init/mysql/1-InfrastructureApps.sql` mirrors the EF-managed schema with its history rows; new migrations are applied on top by the `migrate` job.
- `init/mysql/3-CustomData.sql` holds installation data: ignored by git, never published.
- Explicit image versions; digests pinned at release.
- The realm JSON contains development credentials only, never production data.

## Application images

The local Compose builds the API from the `../InfraOrgITApi` context. For a release, use the images published by the application repos:

- `ghcr.io/senseikiritof/infraorgit-api:<versione>`
- `ghcr.io/senseikiritof/infraorgit-web:<versione>`

The web image is not used by the `full` profile (Caddy serves `../InfraOrgITWeb/dist`), but it can be shipped on its own on port 80.
