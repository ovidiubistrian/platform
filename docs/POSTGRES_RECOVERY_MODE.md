# PostgreSQL "recovery mode" / Container Error – Login failed

## What the errors mean

### 1. "FATAL: the database system is in recovery mode"
The PostgreSQL container is **recovering** (e.g. after restart or crash). During recovery it does not accept normal connections. This is **not** a wrong username/password issue.

### 2. "No space left on device" / Container smartbooking-db Error
- **Logs show**: `PANIC: could not write to file "pg_logical/replorigin_checkpoint.tmp": No space left on device` or `could not write lock file "postmaster.pid": No space left on device`
- **Cause**: **Docker’s disk** (the Docker Desktop VM on Mac) is full, not necessarily your Mac’s main disk. PostgreSQL then crashes in a loop and never leaves recovery.
- **Fix**: Free space inside Docker (see below), then restart the stack.

---

---

## Fix: "No space left on device" (smartbooking-db Error)

1. **Stop the stack**
   ```bash
   cd migration-platform
   docker compose down
   ```

2. **Free Docker disk space** (images + build cache; does **not** remove your DB volume)
   ```bash
   docker image prune -a -f
   docker builder prune -a -f
   ```

3. **Start again**
   ```bash
   docker compose up -d
   ```
   Wait 30–60 seconds, then check: `docker compose ps`. Postgres should become **healthy**.

4. **If postgres still exits with the same error**: the data volume may be corrupted from repeated crashes. To start with a **fresh database** (you lose all data in this environment):
   ```bash
   docker compose down -v
   docker compose up -d
   ```
   Then run your DB migrations again and recreate users if needed.

---

## Quick fix (recovery mode only, no "no space" in logs)

### 1. Wait and retry

After a restart, recovery often finishes in **30–60 seconds**. Wait a minute and try logging in again.

### 2. Restart PostgreSQL and wait for healthy

From `migration-platform/`:

```bash
docker compose restart postgres
# Wait until healthy (about 20–30 seconds with the healthcheck)
docker compose ps
```

When `postgres` shows **healthy**, try login again.

### 3. Full stack restart

If the backend started before Postgres was ready:

```bash
cd migration-platform
docker compose down
docker compose up -d
# Wait 30–60 seconds for postgres to become healthy and backend to connect
docker compose ps
```

Then try login again.

---

## If it keeps failing

### Check PostgreSQL logs

```bash
docker compose logs postgres
```

Look for:

- **Recovery complete** – then it should accept connections; if the app still fails, restart backend: `docker compose restart backend`.
- **Stuck recovery** – messages like "waiting for WAL" or repeated errors. Possible causes: restored/copied data, disk full, or corruption.
- **Disk full** – free disk space and restart postgres.

### Check Postgres is accepting connections

```bash
docker compose exec postgres pg_isready -U smartbooking -d smartbooking
```

If it prints `accepting connections`, Postgres is ready. Restart the backend and try login again:

```bash
docker compose restart backend
```

### Nuclear option: fresh data volume

Only if you can afford to **lose all data** in this environment (e.g. local dev):

```bash
docker compose down -v    # removes volumes!
docker compose up -d
# Run migrations again, recreate users, etc.
```

Use this only when you don’t need to keep the current database contents.
