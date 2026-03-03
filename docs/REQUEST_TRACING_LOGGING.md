# Request Tracing and Structured Logging

This document describes tenant-aware request tracing and structured logging used across the platform (backend API and frontend).

## Goals

- Every request has a unique **request_id** (UUID).
- Every request has an effective **tenant_id** (tenant, `super_admin`, or `unknown`).
- Every log line includes **request_id** and **tenant_id** so logs are not mixed across tenants.
- **x-request-id** and **x-tenant-id** are propagated: frontend → backend, and echoed in response headers.

## How `tenant_id` is resolved (backend)

The backend resolves **tenant_id** in this order (single function: `src.core.tenant_resolver.resolve_tenant_id`):

1. **`request.state.tenant`** (or `request.state.tenant_id`)  
   If the app has already set tenant on the request (e.g. from auth), that value is used.

2. **Headers `x-tenant-id` or `x-tenant`**  
   If the client or gateway sends either header, that value is used.

3. **Path**  
   If the request path starts with `/api/super-admin`, then `tenant_id` is set to **`super_admin`**.

4. **JWT (Bearer token)**  
   If present, the token is decoded (no DB lookup).  
   - If `role == "super_admin"` → **`super_admin`**.  
   - Otherwise, if `tenant_id` is present in the payload → that **tenant_id** is used.

5. **Query params `tenant_slug` or `domain`**  
   Used for public API (e.g. `/api/public/units?tenant_slug=pine-hill`).

6. **Host subdomain**  
   If the request host is e.g. `pine-hill.myapp.com` and `MAIN_DOMAIN=myapp.com`, then **`pine-hill`** is used as tenant.

7. **Fallback**  
   If none of the above apply, **`tenant_id`** is **`unknown`** (shown as `-` in text logs).

So: **request.state** → **headers** → **path** (super_admin) → **JWT** → **query** → **host subdomain** → **unknown**.

## Log format (cloud-style, single-line)

Logs are single-line and compact. Each line includes: **timestamp** (ISO with timezone), **level**, **req=** (short request id), **tenant=** (slug, `super_admin`, or `-`), **logger=** (short name), **message**.

**Text format** (default, `LOG_FORMAT=text`):

```
2026-02-24T16:16:17.003+02:00 INFO   req=699da83450f...  tenant=pine-hill  logger=src.middleware.tracing  GET /api/events 200 18ms 192.168.1.1
```

- **request_id** is shown shortened (first 12 chars) for readability.
- **tenant** appears on every line (slug, `super_admin`, or `-` when unknown).
- The middleware logs **one request-summary line** at the end of each request: method, path, status_code, duration_ms, client_ip.
- SQL is **not** printed by default. Set **`SQL_LOG_LEVEL=INFO`** in `.env` to show SQL for debugging (see backend `README_LOGGING.md`).

For log aggregators, set **`LOG_FORMAT=json`** for one JSON object per line.

## Log fields (JSON)

Când LOG_FORMAT=json, fiecare linie este JSON cu cel puțin:

| Field          | Description |
|----------------|-------------|
| `timestamp`    | Log time. |
| `level`        | Log level (INFO, WARNING, etc.). |
| `logger`       | Logger name. |
| `message`      | Log message. |
| `request_id`   | UUID for the request (from header or generated). |
| `tenant_id`    | Resolved tenant: tenant id, `super_admin`, or `unknown`. |

For the request-summary log (middleware), `extra` includes:

- `method`, `path`, `status_code`, `duration_ms`, `client_ip`

Logging is configured in `src.core.logging_config` via **`setup_logging()`**, called **before** creating the FastAPI app so uvicorn and app logs use the same format. A filter injects `request_id` and `tenant_id` from contextvars into every log record, including **SQLAlchemy** logs when `SQL_LOG_LEVEL=INFO`. No need to change existing `logger.info(...)` calls.

## Response headers

The API adds (does not remove) these response headers:

- **`x-request-id`** — Same as the one used for the request (from header or generated).
- **`x-tenant-id`** — Resolved tenant_id for this request.

So the client can correlate responses and client-side logs with backend logs using the same ids.

## How to search logs

- **By tenant:**  
  Filter JSON logs where `tenant_id == "<TENANT_ID>"` or `tenant_id == "super_admin"`.

- **By request:**  
  Filter where `request_id == "<UUID>"` to see all log lines for one request.

Example (if logs are JSON lines on stdout):

```bash
# All logs for tenant "abc-123"
docker compose logs backend 2>&1 | grep '"tenant_id":"abc-123"'

# All logs for one request
docker compose logs backend 2>&1 | grep '"request_id":"550e8400-e29b-41d4-a716-446655440000"'
```

With a log aggregator (e.g. ELK, Datadog), index `request_id` and `tenant_id` and filter in the UI.

## Frontend behaviour

- The API client (e.g. Axios in `migration-frontend`) sends:
  - **`x-request-id`** — New UUID per request (or reuse if you set it).
  - **`x-tenant-id`** — From current tenant context (e.g. stored in `localStorage` after login: `tenant_id` or `super_admin` for super-admin users).

- After login/refresh, the app persists `tenant_id` (or `super_admin`) so all subsequent API calls can send **`x-tenant-id`** and backend logs stay tenant-aware.

## Backend implementation summary

- **Context:** `src.core.request_context` — contextvars for `request_id`, `tenant_id`, `path`, `method`.
- **Resolver:** `src.core.tenant_resolver` — `resolve_tenant_id(...)` (request.state, headers, path, JWT, query, host subdomain).
- **Logging:** `src.core.logging_config` — `setup_logging()` (call before creating FastAPI app); cloud-style formatter and filter that add `request_id` / `tenant_id`; `LOG_LEVEL`, `LOG_FORMAT=text|json`, `SQL_LOG_LEVEL=WARNING` (set to INFO to show SQL).
- **Middleware:** `src.middleware.tracing.RequestTracingMiddleware` — sets context, logs one request-summary line at end of request, adds response headers.

No breaking changes: only new headers and log fields; API request/response bodies are unchanged.
