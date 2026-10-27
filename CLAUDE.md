# InfraOrgITDocker — guida per agenti

`AGENTS.md` è un symlink a questo file, letto da opencode e dagli altri agenti: modifica solo `CLAUDE.md`.

Leggi `../AllInfraOrgIT/README.md` e `../AllInfraOrgIT/docs/backlog.md`.

- Segreti solo in `.env` locale o secret manager; versionare solo `.env.example` con valori finti.
- Niente dump, dati rappresentativi, chiavi Keycloak o `data/` nel repo.
- Lo schema del database non si scrive qui: migration EF nel backend.
- Keycloak in dev usa `start-dev` con import del realm `infraorgit`; la configurazione di produzione si aggiunge in Fase 8.
- Il realm JSON e `.env.example` contengono solo credenziali di sviluppo; mai dati rappresentativi.
- Ogni modifica a Compose o Caddyfile deve passare `docker compose config -q` e `caddy validate`.
