#!/bin/bash
# Stop development environment

set -e

echo "🛑 Stopping SmartBooking Development Environment..."

cd "$(dirname "$0")/.." || exit 1

docker-compose -f docker-compose.dev.yml down

echo "✅ All services stopped"













