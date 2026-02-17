# Fix: PostgreSQL "No space left on device" / recovery mode

## Cauză
- Logurile arată: `PANIC: could not write to file "pg_logical/replorigin_checkpoint.tmp": No space left on device`
- Fie discul Docker (Desktop) e plin, fie volumul PostgreSQL e plin/corupt după oprire bruscă.

## Varianta 1: Eliberare spațiu Docker + volum nou Postgres (recomandat)

**Atenție:** Vei pierde datele din baza de date din container (pachete, rezervări etc. din acest proiect). Dacă ai backup, refă după pași.

```bash
cd 360Booking/migration-platform

# Oprește toate containerele
docker compose down

# Șterge doar volumul Postgres (baza de date) ca să poată porni din nou
docker volume rm migration-platform_postgres_data 2>/dev/null || true

# (Opțional) Eliberare spațiu Docker: imagini/containere/volume nefolosite
docker system prune -f
# Pentru mai mult spațiu (inclusiv imagini nefolosite):
# docker system prune -a -f

# Pornește din nou stack-ul (Postgres va crea o bază goală)
docker compose up -d

# Așteaptă ~30 secunde ca Postgres să devină healthy, apoi rulează migrările
docker compose exec backend alembic upgrade head
```

După aceea poți deschide din nou aplicația; va fi nevoie să recreezi utilizatori/tenant dacă nu ai backup.

---

## Varianta 2: Folosești PostgreSQL de pe host (fără container Postgres)

Dacă ai deja PostgreSQL instalat local (ex. `roompilot` / `roompilot123` pe port 5432), poți rula doar backend + frontend și să te conectezi la baza de pe host:

```bash
cd 360Booking/migration-platform
docker compose -f docker-compose.dev.yml up -d
```

În `docker-compose.dev.yml` backend-ul folosește deja:
`DATABASE_URL=postgresql://roompilot:roompilot123@host.docker.internal:5432/roompilot`

Deci **nu** pornește containerul `smartbooking-db`; totul merge pe baza ta locală.

---

## Varianta 3: Mărești discul alocat Docker Desktop

- **Docker Desktop** → Settings → Resources → Disk image size: mărește (ex. la 64 GB) și Apply.
- Apoi repeti Varianta 1 (down, remove volume, up).
