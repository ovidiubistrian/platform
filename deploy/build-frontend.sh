#!/usr/bin/env bash
set -euo pipefail
# Build frontend static files into /opt/360booking/frontend-dist
cd /opt/360booking/frontend

# Install deps and build
npm ci --prefer-offline
VITE_API_BASE_URL= npm run build

# Deploy built files
rm -rf /opt/360booking/frontend-dist
cp -r dist /opt/360booking/frontend-dist

echo "Frontend built -> /opt/360booking/frontend-dist"
