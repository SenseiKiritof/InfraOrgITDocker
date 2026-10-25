# infraorgit-docker

Infra locale e di produzione per InfraOrgIT: Docker Compose con MySQL, Keycloak e Caddy.

## Servizi

| Servizio | Porta host | Scopo |
|---|---|---|
| `mysql` | 3306 | database applicativo `infraorgit` |
| `mysql-keycloak` | 3307 | database Keycloak |
| `keycloak` | 8080 | OIDC, realm `infraorgit` (Fase 2) |
| `caddy` | 80/443 | SPA + reverse proxy API (profilo `full`) |

MySQL e Keycloak usano `start-dev`: solo sviluppo. La configurazione di produzione (Keycloak `start`, hostname, TLS) arriva in Fase 8.

## Avvio

```bash
cp .env.example .env
docker compose up -d --wait mysql mysql-keycloak keycloak
```

Console Keycloak: http://localhost:8080 con le credenziali in `.env`.

Profilo completo con Caddy:

```bash
# richiede il build del frontend in ../infraorgit-web/dist
docker compose --profile full up -d --wait
```

Caddy serve `dist/` e inoltra `/api/*` e `/auth/*` a `API_UPSTREAM` (default `api:8080`, container API non ancora presente). L'integrazione Keycloak same-host si completa con il BFF in Fase 2.

## Regole

- `.env` non si committa; solo `.env.example`.
- Nessuno schema o seed negli init SQL: lo schema nasce dalle migration EF (Fase 2).
- Versioni esplicite delle immagini; digest pinnati alla release.
