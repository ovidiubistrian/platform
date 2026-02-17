# 🚀 Quick Start - Testing

## ✅ Status: Serviciile Rulează!

Backend și Frontend sunt pornite și funcționale!

## 📍 Accesează Aplicația

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Docs (Swagger)**: http://localhost:8000/docs
- **PostgreSQL**: localhost:5432 (folosește containerul existent)

## 🧪 Testează Rapid

### 1. Health Check
```bash
curl http://localhost:8000/health
```
Expected: `{"status":"ok","version":"0.1.0"}`

### 2. Deschide Frontend
Deschide în browser: http://localhost:5173

### 3. Testează API
Deschide: http://localhost:8000/docs

## 📝 Comenzi Utile

### Verifică Status
```bash
cd migration-platform
docker-compose -f docker-compose.dev.yml ps
```

### Vezi Logs
```bash
# Backend logs
docker-compose -f docker-compose.dev.yml logs -f backend

# Frontend logs
docker-compose -f docker-compose.dev.yml logs -f frontend

# Toate logs
docker-compose -f docker-compose.dev.yml logs -f
```

### Oprește Serviciile
```bash
cd migration-platform
docker-compose -f docker-compose.dev.yml down
```

### Repornește Serviciile
```bash
cd migration-platform
docker-compose -f docker-compose.dev.yml restart
```

## ⚠️ Note

- PostgreSQL folosește containerul existent (`smartbooking-postgres-local`)
- Dacă vrei un PostgreSQL nou, decomentează serviciul `postgres` în `docker-compose.dev.yml`
- Backend și Frontend rulează cu hot-reload (schimbările se reflectă automat)

## 🐛 Troubleshooting

### Backend nu răspunde
```bash
docker-compose -f docker-compose.dev.yml logs backend
```

### Frontend nu răspunde
```bash
docker-compose -f docker-compose.dev.yml logs frontend
```

### Port ocupat
```bash
# Verifică ce rulează pe port
lsof -i :8000
lsof -i :5173
```

---

**Happy Testing! 🎉**













