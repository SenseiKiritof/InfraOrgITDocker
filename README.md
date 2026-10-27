# infraorgit-docker

Infra locale per InfraOrgIT: Docker Compose con MySQL, Keycloak e Caddy. La configurazione di produzione completa arriva in Fase 8.

## Servizi

| Servizio | Porta host | Scopo |
|---|---|---|
| `mysql` | 127.0.0.1:3306 | database applicativo `infraorgit` |
| `mysql-keycloak` | 127.0.0.1:3307 | database Keycloak |
| `keycloak` | 127.0.0.1:8080 | OIDC, realm `infraorgit` |
| `mysql-legacy` | 127.0.0.1:3308 | dump legacy fittizio per il rehearsal Fase 7 (profilo `legacy`) |
| `migrate` | — | job EF una tantum, esce a schema aggiornato (profilo `full`) |
| `api` | interna 8080 | API .NET non-root, filesystem read-only (profilo `full`) |
| `caddy` | 80/443 | SPA + reverse proxy API (profilo `full`) |

Le porte sono legate a loopback: l'infra non è raggiungibile dalla LAN. MySQL e Keycloak sono configurati per lo sviluppo; la produzione arriva in Fase 8.

## Avvio

```bash
cp .env.example .env
docker compose up -d --wait mysql mysql-keycloak keycloak
```

Keycloak importa `keycloak/realm-infraorgit.json`: client `infraorgit`, utente di test `admin` / `dev-admin`. Credenziali solo di sviluppo, mai in produzione.

Se modifichi il realm, il client o il secret, `--import-realm` non aggiorna un realm già esistente. Usa `make reset` dal meta repo (rimuove i volumi) e riavvia.

Console Keycloak: http://localhost:8080/admin con le credenziali admin in `.env`.

Profilo completo con API, job migrazioni e Caddy:

```bash
# dal meta repo: build del frontend, chiave credenziali da env.sh, poi compose
make full
```

Caddy serve `dist/` e inoltra `/api/*` e `/auth/*` a `API_UPSTREAM` (default `api:8080`), `/realms/*` e `/resources/*` a Keycloak. L'API gira come utente `app` con root filesystem read-only, `cap_drop: ALL` e `no-new-privileges`; il job `migrate` applica le migration e termina prima dell'avvio API. Le sessioni stanno in MySQL (tabella `Sessions`, payload cifrato) e le chiavi DataProtection nel volume `api-dp-keys`: il restart dell'API non fa perdere il login.

Keycloak nel profilo full usa `start` (non `start-dev`) con `KC_HOSTNAME=https://localhost`, proxy headers e backchannel dinamico: l'issuer pubblico è `https://localhost/realms/infraorgit`, mentre l'API raggiunge discovery, token e JWKS su `http://keycloak:8080` (`Oidc__InternalIssuer`, `Oidc__AllowInsecureInternalDiscovery=true`). API e Keycloak condividono la rete `auth` isolata (`internal: true`), così gli altri container non vedono il traffico OIDC; resta HTTP interno, quindi il compromesso di uno dei due container espone comunque i token.

Per un host reale servono `SITE_ADDRESS`, `SITE_URL`, `OIDC_ISSUER`, `OIDC_INTERNAL_ISSUER`, `OIDC_REDIRECT_URI` e `FRONTEND_BASE_URL` coerenti tra loro, e i redirect URI del client Keycloak aggiornati. I redirect attuali coprono solo `http://localhost:3000` e `https://localhost`.

Attenzione: cambiare `keycloak/realm-infraorgit.json` non aggiorna un realm già importato. Serve un volume Keycloak nuovo (`make reset`, che rimuove anche i dati applicativi) oppure l'aggiornamento del client dalla console.

Osservabilità: l'API emette log JSON con correlation id. Impostando `OTEL_EXPORTER_OTLP_ENDPOINT` nel `.env` abilita tracce e metriche OTLP; senza collector restano disabilitate.

## Dump legacy fittizio

`legacy/01-schema.sql` e `legacy/02-data.sql` creano uno schema legacy ridotto con dati finti: un ambiente, un provider, una macchina, un proxy, un servizio, un diagramma e un'esecuzione. Serve solo a provare l'importer della Fase 7, non contiene dati rappresentativi.

```bash
docker compose --profile legacy up -d --wait mysql-legacy
cd ../AllInfraOrgIT && make legacy-rehearsal
```

Il container non ha volume: ogni ricreazione riesegue gli init script e riparte da zero.

## Regole

- `.env` non si committa; solo `.env.example`.
- Nessuno schema o seed del target negli init SQL: lo schema nasce dalle migration EF. `legacy/` contiene solo lo schema legacy ridotto per il rehearsal.
- Versioni esplicite delle immagini; digest pinnati alla release.
- Il realm JSON contiene solo credenziali di sviluppo, mai dati rappresentativi.
