# Request Tracing and Structured Logging

This document describes tenant-aware request tracing and structured logging used across the platform.

## Overview

- Every request gets a unique **request_id** (UUID).
- Every request has an **effective tenant_id** for logging: a real tenant ID, `super_admin`, or `unknown`.
- All log lines written during that request include **request_id** and **tenant_id**.
- Response headers **x-request-id** and **x-tenant-id** are set so clients and gateways can correlate logs.

## How tenant_id is resolved

The backend resolves `tenant_id` in this order (single function: `src.core.tenant_resolver.resolve_tenant_id`):

1. **Header `x-tenant-id`**  
   If the client sends `x-tenant-id`, that value is used. The frontend sends this when the user is logged in (from `user.tenant_id` or `super_admin` for super-admin users).

2. **Path**  
   If the request path starts with `/api/super-admin`, the effective tenant is set to **super_admin** (even without auth, for consistent logging).

3. **JWT (Bearer token)**  
   If no header and not a super-admin path, the backend optionally decodes the Bearer token (without DB lookup) and reads:
   - `role == "super_admin"` → tenant_id = **super_admin**
   - otherwise `tenant_id` from the token payload, if present.

4. **Fallback**  
   If none of the above apply, tenant_id is **unknown**. Logs still include it so you can filter.

## Log fields

Every log line (when structured logging is enabled) includes at least:

| Field         | Description                                      |
|---------------|--------------------------------------------------|
| `timestamp`   | ISO or configured time format                    |
| `level`       | Log level (INFO, WARNING, ERROR, etc.)           |
| `logger`      | Logger name                                      |
| `message`     | Log message                                      |
| `request_id`  | UUID for the current request                     |
| `tenant_id`   | Resolved tenant or `super_admin` or `unknown`    |

For **request_start** and **request_end** events, the middleware also logs:

- `method`, `path`
- **request_end** only: `status_code`, `duration_ms`

Logs are written as **one JSON object per line** to stdout so Docker (or any log driver) can collect them without parsing multi-line messages.

## Searching logs

- **By tenant:**  
  `grep '"tenant_id":"<TENANT_ID>"'`  
  or in a log aggregator: filter `tenant_id = "<TENANT_ID>"`.

- **By request:**  
  `grep '"request_id":"<UUID>"'`  
  to see all log lines for one request (start, application logs, end).

- **By super-admin traffic:**  
  `grep '"tenant_id":"super_admin"'`

- **By path:**  
  `grep '"path":"/api/bookings"'`  
  (combine with `tenant_id` to restrict to one tenant).

## Headers

| Header          | Direction   | Description |
|-----------------|------------|-------------|
| `x-request-id`  | Request    | Optional. If present, the backend uses it and echoes it in the response. If absent, the backend generates a UUID. |
| `x-tenant-id`   | Request    | Optional. Resolved tenant ID or `super_admin`. If sent, the backend uses it for logging (and may still override from path/JWT). |
| `x-request-id`  | Response   | Always set to the request_id used for that request. |
| `x-tenant-id`   | Response   | Always set to the effective tenant_id for that request. |

These headers are **additive**; no existing API behavior or response body is changed.

## Frontend

The React app (Vite) does the following:

- **API client** (`src/lib/api/client.ts`):  
  Every request adds:
  - `x-request-id`: generated UUID (per request).
  - `x-tenant-id`: from `localStorage.tenant_id` if set (see below).

- **Auth context**:  
  On login and on refresh user, the app sets `localStorage.tenant_id` to:
  - `super_admin` when `user.role === 'super_admin'`,
  - `user.tenant_id` when the user has a tenant,
  - or removes it otherwise.  
  On logout, `tenant_id` is removed from localStorage.

So once a user is logged in, all API calls from that client send a consistent `x-tenant-id` for backend logging. The backend can still override from path or JWT if needed.

## Backend implementation details

- **Context storage:** `src.core.request_context` uses Python `contextvars` (`request_id_var`, `tenant_id_var`, etc.) so that any code running during the request (including async) sees the same request_id/tenant_id without passing them explicitly.
- **Middleware:** `src.middleware.tracing.RequestTracingMiddleware` runs for every request: sets context, logs request_start, calls the handler, then logs request_end with status_code and duration_ms, and adds the response headers.
- **Logging:** `src.core.logging_config` provides:
  - `RequestContextFilter`: adds `request_id` and `tenant_id` to every log record from contextvars.
  - `JsonFormatter`: outputs one JSON object per line; does not print secrets (passwords, tokens, etc.).
- **Background tasks:** FastAPI background tasks run in the same process; they do not inherit contextvars by default. If you spawn work that must log with the same request_id/tenant_id, pass them explicitly or copy context in the task (e.g. set the contextvars at the start of the background task from the request-scoped values).

## Running the tests

From the backend root (`migration-backend`). No `PYTHONPATH` needed (conftest adds the backend root).

```bash
poetry run pytest tests/test_tracing_middleware.py -v
```

Tests verify:

1. Response headers `x-request-id` and `x-tenant-id` when provided in the request.
2. Request id is generated when not provided; tenant_id is `unknown` when not provided and path is not super-admin.
3. Path `/api/super-admin/*` results in response `x-tenant-id: super_admin`.
