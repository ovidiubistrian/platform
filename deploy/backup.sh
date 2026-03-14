#!/usr/bin/env bash
set -euo pipefail
# Full backup: PostgreSQL + uploads + config data → Hetzner S3-compatible storage
# Run daily via cron. Credentials from /opt/360booking/.credentials-s3

BACKUP_DIR="/opt/360booking/backups"
CREDENTIALS="/opt/360booking/.credentials-s3"
RETENTION_DAYS=30
S3_BUCKET="360booking-backups"
S3_ENDPOINT="https://nbg1.your-objectstorage.com"
S3_REGION="nbg1"

# Load postgres credentials from .env (do this FIRST, before S3 creds)
set -a
source /opt/360booking/.env
set +a

# Read S3 credentials (AFTER .env so they aren't overridden by empty .env values)
S3_KEY=$(grep '^key:' "$CREDENTIALS" | awk '{print $2}')
S3_SECRET=$(grep '^secret:' "$CREDENTIALS" | awk '{print $2}')

export AWS_ACCESS_KEY_ID="$S3_KEY"
export AWS_SECRET_ACCESS_KEY="$S3_SECRET"

s3cmd() {
    aws "$@" --endpoint-url "$S3_ENDPOINT" --region "$S3_REGION"
}
DB_USER="${POSTGRES_USER:-booking360}"
DB_NAME="${POSTGRES_DB:-booking360}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

# ── 1. PostgreSQL dump ──
echo "[$(date)] Backing up PostgreSQL..."
PG_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"
docker compose -f /opt/360booking/docker-compose.yml exec -T postgres \
    pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$PG_FILE"

FILESIZE=$(stat -c%s "$PG_FILE" 2>/dev/null || echo 0)
echo "[$(date)] DB dump: ${PG_FILE} (${FILESIZE} bytes)"

s3cmd s3 cp "$PG_FILE" "s3://${S3_BUCKET}/postgres/${DB_NAME}_${TIMESTAMP}.sql.gz" --no-progress
echo "[$(date)] DB dump uploaded."

# ── 2. Uploads (images, PDFs, tenant media) ──
# The uploads Docker volume is mounted from the backend container.
# Extract the volume mount path and sync to S3.
echo "[$(date)] Syncing uploads to S3..."
UPLOADS_VOLUME=$(docker volume inspect 360booking_uploads --format '{{.Mountpoint}}' 2>/dev/null || echo "")

if [[ -n "$UPLOADS_VOLUME" && -d "$UPLOADS_VOLUME" ]]; then
    s3cmd s3 sync "$UPLOADS_VOLUME/" "s3://${S3_BUCKET}/uploads/" --no-progress --delete
    echo "[$(date)] Uploads synced."
else
    echo "[$(date)] WARNING: uploads volume not found, skipping."
fi

# ── 3. AI config and data files ──
echo "[$(date)] Backing up data/config files..."
if [[ -d /opt/360booking/backend/data ]]; then
    s3cmd s3 sync /opt/360booking/backend/data/ "s3://${S3_BUCKET}/data/" --no-progress
    echo "[$(date)] Data files synced."
fi

# ── 4. Clean up old local DB dumps ──
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +${RETENTION_DAYS} -delete
echo "[$(date)] Cleaned local backups older than ${RETENTION_DAYS} days."

# ── 5. Clean up old S3 DB dumps ──
s3cmd s3 ls "s3://${S3_BUCKET}/postgres/" 2>/dev/null | while read -r line; do
    FILE_DATE=$(echo "$line" | awk '{print $1}')
    FILE_NAME=$(echo "$line" | awk '{print $4}')
    if [[ -n "$FILE_DATE" && -n "$FILE_NAME" ]]; then
        FILE_AGE=$(( ($(date +%s) - $(date -d "$FILE_DATE" +%s)) / 86400 ))
        if [[ $FILE_AGE -gt $RETENTION_DAYS ]]; then
            s3cmd s3 rm "s3://${S3_BUCKET}/postgres/${FILE_NAME}"
            echo "[$(date)] Deleted old S3 backup: ${FILE_NAME}"
        fi
    fi
done

echo "[$(date)] Full backup complete."
