# 🚀 SmartBooking Platform - Orchestration

Acest repository conține configurația Docker Compose pentru a rula întreaga aplicație SmartBooking.

## 📁 Structură

```
migration-platform/
├── docker-compose.yml          # Production setup
├── docker-compose.dev.yml      # Development setup
├── scripts/
│   ├── start-dev.sh           # Start development environment
│   ├── stop-dev.sh            # Stop all services
│   └── start-local.sh         # Start only PostgreSQL
└── README.md

migration-backend/              # FastAPI Backend
migration-frontend/            # React Frontend
```

## 🚀 Quick Start

### Rulare direct în Docker

**Variantă 1 – tot în Docker (PostgreSQL + Backend + Frontend):**

```bash
cd 360Booking/migration-platform
docker compose up -d
```

- Frontend: **http://localhost:80** (sau portul din `FRONTEND_PORT` din `.env`)
- Backend/API: **http://localhost:8000**
- Docs: **http://localhost:8000/docs**

Oprești cu: `docker compose down`.

**Prima rulare:** asigură-te că ai `.env` în `migration-platform/` (vezi secțiunea Configuration). După ce containerele sunt up, rulează migrațiile în containerul backend:  
`docker compose exec backend alembic upgrade head`

**Variantă 2 – development (hot reload):**

```bash
cd 360Booking/migration-platform
docker compose -f docker-compose.dev.yml up -d
```

- Frontend: **http://localhost:5173**
- Backend: **http://localhost:8000**

*Notă:* `docker-compose.dev.yml` folosește un PostgreSQL de pe host (`host.docker.internal:5432`). Fie ai deja Postgres rulând local, fie pornești doar DB-ul cu `./scripts/start-local.sh` sau cu `docker compose up -d postgres` din `docker-compose.yml`.

### Development (Docker) – script

```bash
cd migration-platform
./scripts/start-dev.sh
```

Aceasta va porni:
- PostgreSQL (port 5432)
- FastAPI Backend (port 8000)
- React Frontend (port 5173)

### Development (Local)

```bash
# 1. Start PostgreSQL
cd migration-platform
./scripts/start-local.sh

# 2. Start Backend (în alt terminal)
cd ../migration-backend
poetry run uvicorn src.api.main:app --reload

# 3. Start Frontend (în alt terminal)
cd ../migration-frontend
npm run dev
```

## 📝 Services

| Service | Port | URL |
|---------|------|-----|
| PostgreSQL | 5432 | localhost:5432 |
| Backend API | 8000 | http://localhost:8000 |
| Frontend | 5173 | http://localhost:5173 |
| API Docs | 8000 | http://localhost:8000/docs |

## 🔧 Configuration

Creează `.env` în `migration-platform/`:

```env
# Database
DB_USER=roompilot
DB_PASSWORD=roompilot123
DB_NAME=roompilot
DB_PORT=5432

# Backend
SECRET_KEY=your-secret-key-here
DEBUG=true
BACKEND_PORT=8000

# Frontend
FRONTEND_PORT=5173
VITE_API_BASE_URL=http://localhost:8000
```

## 📚 Documentation

Vezi [TESTING_GUIDE.md](./TESTING_GUIDE.md) pentru instrucțiuni detaliate de testare.

## 🛑 Stop Services

```bash
./scripts/stop-dev.sh
```

Sau:
```bash
docker-compose -f docker-compose.dev.yml down
```













