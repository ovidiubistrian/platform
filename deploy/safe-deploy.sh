#!/usr/bin/env bash
# Safe deploy: backup -> build -> restart -> health -> smoke -> rollback on failure.
#
# This is the canonical deploy path. It never leaves the site in a broken state:
# the current image is tagged as a rollback point BEFORE building, and if the
# health check or the browser smoke fails, it restores the previous image
# automatically and exits non-zero.
#
# Usage:
#   bash /opt/360booking/safe-deploy.sh frontend   # build+deploy+smoke frontend
#   bash /opt/360booking/safe-deploy.sh backend    # build+deploy+migrate+health backend
#   bash /opt/360booking/safe-deploy.sh all        # backend then frontend
#
# Frontend smoke = e2e/smoke/tenant-hero-mobile.spec.ts (the recurring mobile
# "hero shows but no DISPONIBILITATE button" incident). Backend smoke = health.
set -uo pipefail

cd /opt/360booking
COMPONENT="${1:-all}"
TS="$(date +%Y%m%d_%H%M%S)"

log() { echo "==> $*"; }
fail() { echo "!! $*" >&2; }

# ---------------------------------------------------------------- frontend ----
FE_IMG="360booking-frontend:latest"
FE_ROLLBACK="360booking-frontend:rollback"

# Build context for the frontend image. Defaults to the reference clone's working
# tree (the manual path). CI overrides it with the runner's git checkout so that
# a push deploys exactly what was pushed, never the server's local edits.
FE_SRC="${FE_SRC:-/opt/360booking/frontend}"
# The 73 MB Android APK is deliberately not in git. The image must still serve it
# at /360booking.apk (DownloadAppPage), so restore it into any build context that
# lacks it — i.e. every git checkout.
APK_STORE="/opt/360booking/assets/360booking.apk"
# The smoke always runs from the reference clone: it needs node_modules and only
# talks to live public URLs, so the source it runs from is irrelevant.
FE_SMOKE_DIR="/opt/360booking/frontend"
# World-readable browser cache: the CI runner (uid 1001) has no HOME cache of its
# own and cannot sudo, so without this the smoke would fail and trigger a bogus
# rollback. Root uses the same copy.
export PLAYWRIGHT_BROWSERS_PATH="${PLAYWRIGHT_BROWSERS_PATH:-/opt/360booking/.playwright}"

# Playwright writes test-results/.last-run.json, playwright-report/ and artifacts
# next to the config by default. Those dirs persist between runs, so a set left
# behind by root makes the CI runner's smoke die with EACCES *after every test
# passed* — indistinguishable from a real regression, and it triggered a rollback.
# Send every output to a private temp dir instead; nothing is shared, nothing rots.
fe_smoke() {
    local out; out="$(mktemp -d "${TMPDIR:-/tmp}/360booking-smoke-XXXXXX")" || return 1
    ( cd "$FE_SMOKE_DIR" \
        && PLAYWRIGHT_HTML_REPORT="$out/html" \
           PLAYWRIGHT_JUNIT_OUTPUT_NAME="$out/junit.xml" \
           npm run smoke:hero -- --output="$out/artifacts" )
    local rc=$?
    [ $rc -eq 0 ] && rm -rf "$out" || fail "    smoke artifacts kept at $out"
    return $rc
}

fe_health() {
    for _ in $(seq 1 30); do
        [ "$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3000/ || true)" = "200" ] && return 0
        sleep 2
    done
    return 1
}

fe_rollback() {
    if docker image inspect "$FE_ROLLBACK" >/dev/null 2>&1; then
        fail "Rolling back frontend to previous image ($FE_ROLLBACK)..."
        docker tag "$FE_ROLLBACK" "$FE_IMG"
        docker compose up -d frontend
        fe_health && log "Rollback healthy." || fail "Rollback image is ALSO unhealthy — manual intervention needed."
    else
        fail "No frontend rollback image available — cannot auto-rollback."
    fi
}

deploy_frontend() {
    log "[frontend 1/5] Backup: tag current image as rollback point..."
    if docker image inspect "$FE_IMG" >/dev/null 2>&1; then
        docker tag "$FE_IMG" "$FE_ROLLBACK" && log "    $FE_IMG -> $FE_ROLLBACK"
    else
        log "    no existing $FE_IMG (first deploy) — nothing to back up"
    fi

    log "[frontend 2/5] Build image from $FE_SRC..."
    if [ ! -f "$FE_SRC/public/360booking.apk" ] && [ -f "$APK_STORE" ]; then
        cp "$APK_STORE" "$FE_SRC/public/360booking.apk" \
            && log "    restored 360booking.apk into the build context"
    fi
    if ! docker build -t "$FE_IMG" -f "$FE_SRC/Dockerfile" "$FE_SRC"; then
        fail "Build failed — keeping current running container untouched."
        return 1
    fi

    log "[frontend 3/5] Restart container..."
    docker compose up -d frontend

    log "[frontend 4/5] Health check (http://127.0.0.1:3000)..."
    if ! fe_health; then
        fail "Frontend unhealthy after restart."
        fe_rollback
        return 1
    fi

    # Bust the backend's 60s SPA-shell cache so SSR tenant pages immediately
    # reference the NEW asset hashes (otherwise React can't boot for up to 60s
    # because the old chunks are gone — the exact "hero but no button" failure).
    log "    flushing backend SPA-shell cache..."
    docker compose exec -T backend python -c "import urllib.request as u; u.urlopen(u.Request('http://127.0.0.1:8000/api/internal/spa-cache/flush', method='POST'), timeout=5)" \
        && log "    cache flushed" || fail "    cache flush failed (continuing; smoke will catch it)"

    log "[frontend 5/5] Smoke: tenant hero on mobile..."
    # Warm the just-started container/CDN so the smoke doesn't false-fail on a
    # cold first paint, then retry once before treating it as a real regression.
    curl -s -o /dev/null "http://127.0.0.1:3000/" || true
    sleep 5
    if fe_smoke; then
        log "Frontend smoke PASSED ✅ — deploy complete."
        return 0
    fi
    fail "Smoke failed once — retrying in 8s (guards against cold-start flake)..."
    sleep 8
    if fe_smoke; then
        log "Frontend smoke PASSED on retry ✅ — deploy complete."
        return 0
    fi
    fail "Frontend smoke FAILED ❌ (twice) — public hero broken on mobile."
    fe_rollback
    return 1
}

# ----------------------------------------------------------------- backend ----
BE_IMG="360booking-backend:latest"
BE_ROLLBACK="360booking-backend:rollback"
DB_DUMP="/opt/360booking/backups/pre-deploy_${TS}.sql"

be_health() {
    for _ in $(seq 1 30); do
        [ "$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8000/api/health || true)" = "200" ] && return 0
        sleep 2
    done
    return 1
}

be_rollback() {
    if docker image inspect "$BE_ROLLBACK" >/dev/null 2>&1; then
        fail "Rolling back backend to previous image ($BE_ROLLBACK)..."
        docker tag "$BE_ROLLBACK" "$BE_IMG"
        docker compose up -d backend
        be_health && log "Rollback healthy." || fail "Rollback image ALSO unhealthy — manual intervention needed."
    else
        fail "No backend rollback image available — cannot auto-rollback image."
    fi
    fail "NOTE: DB was NOT auto-restored (avoids losing live data). If a migration"
    fail "      broke things, restore manually from: $DB_DUMP"
}

deploy_backend() {
    log "[backend 1/6] Backup: tag image + quick local DB dump..."
    if docker image inspect "$BE_IMG" >/dev/null 2>&1; then
        docker tag "$BE_IMG" "$BE_ROLLBACK" && log "    $BE_IMG -> $BE_ROLLBACK"
    else
        log "    no existing $BE_IMG (first deploy)"
    fi
    mkdir -p /opt/360booking/backups
    set -a; source /opt/360booking/.env 2>/dev/null || true; set +a
    if docker compose exec -T postgres pg_dump -U "${POSTGRES_USER:-booking360}" "${POSTGRES_DB:-booking360}" > "$DB_DUMP" 2>/dev/null; then
        log "    DB dump -> $DB_DUMP ($(du -h "$DB_DUMP" | cut -f1))"
    else
        fail "    DB dump failed (continuing — image rollback still available)."
    fi

    log "[backend 2/6] Build image..."
    if ! bash build-backend.sh; then
        fail "Build failed — keeping current running container untouched."
        return 1
    fi

    log "[backend 3/6] Restart container..."
    docker compose up -d backend

    log "[backend 4/6] Health check (http://127.0.0.1:8000/api/health)..."
    if ! be_health; then
        fail "Backend unhealthy after restart."
        be_rollback
        return 1
    fi

    log "[backend 5/6] Run migrations (alembic upgrade heads)..."
    if ! docker compose exec -T backend alembic upgrade heads; then
        fail "Migration failed."
        be_rollback
        return 1
    fi

    log "[backend 6/6] Health re-check after migrations..."
    if be_health; then
        log "Backend deploy complete ✅."
        return 0
    else
        fail "Backend unhealthy after migrations."
        be_rollback
        return 1
    fi
}

# -------------------------------------------------------------------- main ----
rc=0
case "$COMPONENT" in
    frontend) deploy_frontend || rc=1 ;;
    backend)  deploy_backend  || rc=1 ;;
    all)      deploy_backend  && deploy_frontend || rc=1 ;;
    *) echo "Usage: $0 [frontend|backend|all]"; exit 2 ;;
esac

if [ "$rc" -eq 0 ]; then
    log "DEPLOY OK ✅ ($COMPONENT)"
else
    fail "DEPLOY FAILED ❌ ($COMPONENT) — rolled back where possible."
fi
exit "$rc"
