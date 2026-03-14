#!/usr/bin/env bash
set -euo pipefail
# Deployment script called by GitHub Actions runner
# Usage: ./deploy.sh [backend|frontend|all]

COMPONENT="${1:-all}"
cd /opt/360booking

deploy_backend() {
    echo "==> Deploying backend..."
    cd /opt/360booking/backend
    git pull --ff-only
    cd /opt/360booking
    docker compose build backend
    docker compose up -d backend
    # Run migrations
    docker compose exec -T backend alembic upgrade head
    echo "==> Backend deployed."
}

deploy_frontend() {
    echo "==> Deploying frontend..."
    cd /opt/360booking/frontend
    git pull --ff-only
    cd /opt/360booking
    bash build-frontend.sh
    echo "==> Frontend deployed."
}

case "$COMPONENT" in
    backend)
        deploy_backend
        ;;
    frontend)
        deploy_frontend
        ;;
    all)
        deploy_backend
        deploy_frontend
        ;;
    *)
        echo "Usage: $0 [backend|frontend|all]"
        exit 1
        ;;
esac
