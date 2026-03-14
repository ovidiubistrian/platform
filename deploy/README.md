# 360Booking Production Deployment

Production deployment skeleton for the 360Booking platform.

## Architecture

```
Internet → Caddy (ports 80/443, auto TLS)
             ├─ /api/*     → backend container (:8000)
             ├─ /uploads/* → backend container (:8000)
             └─ /*         → frontend container (:3000 → nginx :80)

Docker Compose:
  - postgres:16-alpine (port 5432, localhost only)
  - 360booking-backend:latest (FastAPI + Uvicorn)
  - 360booking-frontend:latest (Vite React build served by nginx)
```

## Server: `/opt/360booking/`

| File | Purpose |
|---|---|
| `docker-compose.yml` | Postgres + backend + frontend services |
| `.env` | Production secrets (not committed) |
| `nginx-frontend.conf` | Override nginx config for frontend (removes backend proxy, Caddy handles it) |
| `backup.sh` | Daily PostgreSQL + uploads backup to Hetzner S3 |
| `tenant.sh` | Add/remove custom tenant domains in Caddy |
| `deploy.sh` | Manual deployment helper |

## Caddy: `/etc/caddy/Caddyfile`

- `360booking.ro` — main domain, standard ACME TLS
- `*.360booking.ro` — tenant subdomains, on-demand TLS
- `/etc/caddy/tenants/*.caddy` — custom tenant domains (managed by `tenant.sh`)

## GitHub Actions (self-hosted runners)

Runners at `/opt/actions-runner/{backend,frontend}` run as `runner` user.

**Backend workflow** (`360booking/backend/.github/workflows/deploy.yml`):
1. `actions/checkout`
2. `docker build -t 360booking-backend:latest .`
3. `docker compose up -d backend` + `alembic upgrade head`

**Frontend workflow** (`360booking/frontend/.github/workflows/deploy.yml`):
1. `actions/checkout`
2. `docker build -t 360booking-frontend:latest .`
3. `docker compose up -d frontend`

## Backups

Daily at 03:00 UTC via cron → `backup.sh`:
- PostgreSQL dump → `s3://360booking-backups/postgres/`
- Uploads (Docker volume) → `s3://360booking-backups/uploads/`
- Data/config files → `s3://360booking-backups/data/`
- S3 credentials in `/opt/360booking/.credentials-s3`
- 30-day retention (local + S3)

## Tenant Management

```bash
# Subdomains (*.360booking.ro) work automatically.
# For custom external domains:
./tenant.sh add salon-maria.ro
./tenant.sh remove salon-maria.ro
./tenant.sh list
```

## Initial Setup

1. Copy `.env.example` → `.env` and fill in secrets
2. `docker compose up -d`
3. Install Caddy, copy Caddyfile to `/etc/caddy/Caddyfile`
4. Install GitHub Actions runners (see runner setup in main CLAUDE.md)
5. Set up backup cron: `0 3 * * * /opt/360booking/backup.sh >> /var/log/360booking-backup.log 2>&1`
