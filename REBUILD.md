# Rebuild și repornire (Docker)

După modificări în backend sau frontend, rebuild + repornire:

```bash
cd migration-platform

# Rebuild imagini backend + frontend, apoi repornește containerele
docker-compose build backend frontend && docker-compose up -d
```

Sau într-un singur pas (rebuild doar ce s-a schimbat și repornire):

```bash
cd migration-platform
docker-compose up -d --build
```

**Doar repornire** (fără rebuild – dacă ai doar volume mount și backend cu --reload):

```bash
cd migration-platform
docker-compose restart backend frontend
```

**Verificare:**
- Frontend: http://localhost:5173
- Backend: http://localhost:8000
- Logs: `docker-compose logs -f backend`
