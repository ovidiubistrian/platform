# Recuperare după pierderea datelor (bază goală)

După ce ai șters volumul Postgres sau ai pornit cu o bază nouă, următorii pași te aduc rapid înapoi la un cont funcțional.

## 1. Migrări (dacă nu le-ai rulat deja)

```bash
cd 360Booking/migration-platform
docker compose exec backend alembic upgrade head
```

## 2. Creează contul tău (tenant + admin)

- Deschide aplicația: **http://localhost:5173** (sau portul tău).
- Click pe **„Sau creează un cont nou”** (linkul de sub titlul de login).
- Completează: nume, email, parolă, nume business → **Înregistrare**.

Acest flow creează automat **un tenant** și **un user tenant_admin** și poți folosi imediat admin-ul (dashboard, unități, rezervări, restaurant, pachete etc.).

## 3. (Opțional) Conținut demo pentru restaurant

Dacă vrei meniu demo (categorii + preparate) pentru noul tenant:

```bash
docker compose exec backend python scripts/seed_restaurant_demo.py
```

Scriptul adaugă conținut pentru **toți** tenantii existenți din bază.

## 4. (Opțional) Primul utilizator Super Admin

Dacă ai nevoie de **panoul Super Admin** (gestiune tenanti, planuri, etc.), creează manual primul user super_admin:

```bash
docker compose exec backend python scripts/create_super_admin.py
```

Va rula un prompt pentru email și parolă (sau folosește variabile de mediu). După ce rulezi scriptul, te poți loga cu acel email și vei avea acces la `/super-admin`.

---

## Backup pentru viitor

- **PostgreSQL în Docker:** periodic poți face un dump:  
  `docker compose exec postgres pg_dump -U smartbooking smartbooking > backup_$(date +%Y%m%d).sql`
- **Restaurare:**  
  `docker compose exec -T postgres psql -U smartbooking smartbooking < backup_YYYYMMDD.sql`
- Sau folosește **PostgreSQL de pe host** cu `docker-compose.dev.yml`; datele rămân în baza ta locală, pe care o poți include în backup-urile obișnuite.
