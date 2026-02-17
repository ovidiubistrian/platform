# 🧪 Testing Guide - SmartBooking Migration

## 📋 Pre-requisites

1. **Docker** installed and running
2. **Node.js** 20+ installed (for local frontend)
3. **Python** 3.11+ installed (for local backend)
4. **Poetry** installed (for Python dependencies)

## 🚀 Quick Start - Docker (Recommended)

### Option 1: Full Docker Setup

```bash
cd migration-platform
chmod +x scripts/*.sh
./scripts/start-dev.sh
```

Aceasta va porni:
- ✅ PostgreSQL (port 5432)
- ✅ FastAPI Backend (port 8000)
- ✅ React Frontend (port 5173)

**Accesează:**
- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- PostgreSQL: localhost:5432

### Option 2: Local Development (PostgreSQL în Docker)

```bash
# 1. Pornește doar PostgreSQL
cd migration-platform
./scripts/start-local.sh

# 2. În alt terminal - Backend
cd migration-backend
poetry install
poetry run uvicorn src.api.main:app --reload

# 3. În alt terminal - Frontend
cd migration-frontend
npm install
npm run dev
```

## 🔧 Setup Manual

### 1. PostgreSQL (Docker)

```bash
cd migration-platform
docker-compose -f docker-compose.dev.yml up -d postgres
```

Verifică:
```bash
docker-compose -f docker-compose.dev.yml exec postgres psql -U roompilot -d roompilot -c "SELECT 1;"
```

### 2. Backend (Local)

```bash
cd migration-backend

# Install dependencies
poetry install

# Setup .env
cp .env.example .env
# Edit .env with your DATABASE_URL

# Run migrations (if needed)
poetry run alembic upgrade head

# Start server
poetry run uvicorn src.api.main:app --reload
```

Backend va rula pe: http://localhost:8000

### 3. Frontend (Local)

```bash
cd migration-frontend

# Install dependencies
npm install

# Create .env.local
echo "VITE_API_BASE_URL=http://localhost:8000" > .env.local

# Start dev server
npm run dev
```

Frontend va rula pe: http://localhost:5173

## ✅ Testing Checklist

### Backend API

1. **Health Check**
   ```bash
   curl http://localhost:8000/health
   ```
   Expected: `{"status":"ok","version":"0.1.0"}`

2. **API Docs**
   - Deschide: http://localhost:8000/docs
   - Ar trebui să vezi Swagger UI cu endpoint-urile de autentificare

3. **Register**
   ```bash
   curl -X POST http://localhost:8000/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "name": "Test User",
       "email": "test@example.com",
       "password": "testpassword123",
       "business_name": "Test Business"
     }'
   ```

4. **Login**
   ```bash
   curl -X POST http://localhost:8000/api/auth/login \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "username=test@example.com&password=testpassword123"
   ```

### Frontend

1. **Homepage**
   - Deschide: http://localhost:5173
   - Ar trebui să vezi homepage-ul

2. **Register Page**
   - Navighează la: http://localhost:5173/auth/register
   - Completează formularul
   - Ar trebui să fii redirecționat la login

3. **Login Page**
   - Navighează la: http://localhost:5173/auth/login
   - Login cu credențialele create
   - Ar trebui să fii redirecționat la dashboard

4. **Admin Dashboard**
   - După login, ar trebui să vezi dashboard-ul
   - Menu items ar trebui să fie vizibile

5. **Bookings Page**
   - Click pe "Rezervări" din dashboard
   - Ar trebui să vezi pagina de bookings (poate fi goală)

## 🐛 Troubleshooting

### PostgreSQL Connection Error

```bash
# Verifică dacă PostgreSQL rulează
docker-compose -f docker-compose.dev.yml ps

# Verifică logs
docker-compose -f docker-compose.dev.yml logs postgres

# Restart PostgreSQL
docker-compose -f docker-compose.dev.yml restart postgres
```

### Backend nu pornește

```bash
# Verifică logs
docker-compose -f docker-compose.dev.yml logs backend

# Verifică dacă portul 8000 este liber
lsof -i :8000

# Verifică .env
cd migration-backend
cat .env
```

### Frontend nu pornește

```bash
# Verifică logs
docker-compose -f docker-compose.dev.yml logs frontend

# Verifică dacă portul 5173 este liber
lsof -i :5173

# Reinstall dependencies
cd migration-frontend
rm -rf node_modules
npm install
```

### CORS Errors

Asigură-te că în `migration-backend/.env` ai:
```
CORS_ORIGINS=http://localhost:5173,http://localhost:3000
```

## 📊 Status Services

```bash
# Verifică statusul tuturor serviciilor
docker-compose -f docker-compose.dev.yml ps

# Verifică health checks
docker-compose -f docker-compose.dev.yml ps --format json | jq '.[] | {name: .Name, status: .State}'
```

## 🛑 Stop Services

```bash
# Stop all
cd migration-platform
./scripts/stop-dev.sh

# Sau manual
docker-compose -f docker-compose.dev.yml down
```

## 📝 Environment Variables

### Backend (.env)
```env
DATABASE_URL=postgresql://roompilot:roompilot123@localhost:5432/roompilot
SECRET_KEY=your-secret-key-here
DEBUG=true
CORS_ORIGINS=http://localhost:5173,http://localhost:3000
```

### Frontend (.env.local)
```env
VITE_API_BASE_URL=http://localhost:8000
```

## 🎯 Next Steps After Testing

După ce ai testat:
1. ✅ Verifică că toate paginile se încarcă
2. ✅ Testează flow-ul de autentificare
3. ✅ Verifică că API-urile răspund corect
4. ✅ Testează navigarea între pagini

---

**Happy Testing! 🚀**













