#!/bin/bash
# Start services locally (without Docker for backend/frontend)
# Only PostgreSQL runs in Docker

set -e

echo "🚀 Starting SmartBooking Local Development..."
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Navigate to migration-platform directory
cd "$(dirname "$0")/.." || exit 1

# Start only PostgreSQL
echo "📦 Starting PostgreSQL..."
docker-compose -f docker-compose.dev.yml up -d postgres

echo ""
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# Check PostgreSQL
if docker-compose -f docker-compose.dev.yml exec -T postgres pg_isready -U roompilot > /dev/null 2>&1; then
    echo -e "${GREEN}✅ PostgreSQL is ready${NC}"
else
    echo -e "${YELLOW}⚠️  PostgreSQL is starting...${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}✅ PostgreSQL is running!${NC}"
echo "=========================================="
echo ""
echo "📍 PostgreSQL: localhost:5432"
echo ""
echo "📝 Next steps:"
echo "  1. Start Backend:  cd ../migration-backend && poetry run uvicorn src.api.main:app --reload"
echo "  2. Start Frontend: cd ../migration-frontend && npm run dev"
echo ""













