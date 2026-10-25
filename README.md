# infraorgit-docker

Infra locale per InfraOrgIT: Docker Compose con MySQL, Keycloak e Caddy. La configurazione di produzione completa arriva in Fase 8.

## Servizi

| Servizio | Porta host | Scopo |
|---|---|---|
| `mysql` | 127.0.0.1:3306 | database applicativo `infraorgit` |
| `mysql-keycloak` | 127.0.0.1:3307 | database Keycloak |
| `keycloak` | 127.0.0.1:8080 | OIDC, realm `infraorgit` |
| `caddy` | 80/443 | SPA + reverse proxy API (profilo `full`) |

Le porte sono legate a loopback: l'infra non è raggiungibile dalla LAN. MySQL e Keycloak sono configurati per lo sviluppo; la produzione arriva in Fase 8.

## Avvio

```bash
cp .env.example .env
docker compose up -d --wait mysql mysql-keycloak keycloak
```

Keycloak importa `keycloak/realm-infraorgit.json`: client `infraorgit`, utente di test `admin` / `dev-admin`. Credenziali solo di sviluppo, mai in produzione.

Console Keycloak: http://localhost:8080/admin con le credenziali admin in `.env`.

Profilo completo con Caddy:

```bash
# richiede il build del frontend in ../infraorgit-web/dist
docker compose --profile full up -d --wait
```

Caddy serve `dist/` e inoltra `/api/*` e `/auth/*` a `API_UPSTREAM` (default `api:8080`, container API non ancora presente). L'integrazione Keycloak same-host e il container API si completano in Fase 8.

## Regole

- `.env` non si committa; solo `.env.example`.
- Nessuno schema o seed negli init SQL: lo schema nasce dalle migration EF.
- Versioni esplicite delle immagini; digest pinnati alla release.
- Il realm JSON contiene solo credenziali di sviluppo, mai dati rappresentativi.
