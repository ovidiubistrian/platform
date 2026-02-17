#!/bin/bash
# Start development environment
# This script starts PostgreSQL, FastAPI backend, and React frontend

set -e

echo "🚀 Starting SmartBooking Development Environment..."
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

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ Created .env file. Please update it with your settings."
    else
        echo "⚠️  .env.example not found. Creating basic .env..."
        cat > .env << EOF
# Database
DB_USER=roompilot
DB_PASSWORD=roompilot123
DB_NAME=roompilot
DB_PORT=5432

# Backend
SECRET_KEY=dev-secret-key-change-in-production
DEBUG=true
BACKEND_PORT=8000

# Frontend
FRONTEND_PORT=5173
VITE_API_BASE_URL=http://localhost:8000
EOF
        echo "✅ Created basic .env file."
    fi
fi

# Start services
echo "📦 Starting Docker containers..."
docker-compose -f docker-compose.dev.yml up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 5

# Check PostgreSQL
echo "🔍 Checking PostgreSQL..."
if docker-compose -f docker-compose.dev.yml exec -T postgres pg_isready -U roompilot > /dev/null 2>&1; then
    echo -e "${GREEN}✅ PostgreSQL is ready${NC}"
else
    echo -e "${YELLOW}⚠️  PostgreSQL is starting...${NC}"
fi

# Check Backend
echo "🔍 Checking Backend..."
sleep 3
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend is ready${NC}"
else
    echo -e "${YELLOW}⚠️  Backend is starting... (this may take a moment)${NC}"
fi

# Check Frontend
echo "🔍 Checking Frontend..."
sleep 2
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend is ready${NC}"
else
    echo -e "${YELLOW}⚠️  Frontend is starting... (this may take a moment)${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}🎉 Development environment started!${NC}"
echo "=========================================="
echo ""
echo "📍 Services:"
echo "  • PostgreSQL:  localhost:5432"
echo "  • Backend API: http://localhost:8000"
echo "  • Frontend:    http://localhost:5173"
echo "  • API Docs:    http://localhost:8000/docs"
echo ""
echo "📝 Useful commands:"
echo "  • View logs:    docker-compose -f docker-compose.dev.yml logs -f"
echo "  • Stop all:     docker-compose -f docker-compose.dev.yml down"
echo "  • Restart:      docker-compose -f docker-compose.dev.yml restart"
echo ""













