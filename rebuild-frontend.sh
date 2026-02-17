#!/bin/bash
# Rebuild frontend fără cache Docker (pentru a vedea ultimele modificări la Packages etc.)
set -e
cd "$(dirname "$0")"

# Folosești docker-compose.dev.yml (Vite dev server) sau docker-compose.yml (build nginx)?
COMPOSE_FILE="${1:-docker-compose.yml}"
echo "Using: $COMPOSE_FILE"

if [[ "$COMPOSE_FILE" == *"dev"* ]]; then
  echo "Dev mode: doar repornim frontend (sursa e montată)."
  docker compose -f "$COMPOSE_FILE" up -d --force-recreate frontend
else
  echo "Rebuilding frontend (no cache)..."
  docker compose -f "$COMPOSE_FILE" build --no-cache frontend
  echo "Restarting frontend..."
  docker compose -f "$COMPOSE_FILE" up -d frontend
fi
echo "Done. Accesează http://localhost:5173 după ce containerul pornește."
