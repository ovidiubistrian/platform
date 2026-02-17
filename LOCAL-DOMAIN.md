# Testare cu domeniu local (pine-hill.ro)

Pentru a rula aplicația pe **http://pine-hill.ro** (fără port în URL) și a o lega de tenantul **pine-hill**.

---

## Variantă cu Docker (recomandat)

Nginx rulează **în containerul frontend**; nu ai nevoie de nginx instalat pe mașina ta.

### 1. Adaugă domeniul în /etc/hosts

```
127.0.0.1 pine-hill.ro
```

### 2. Pornește stack-ul

Din `360Booking/migration-platform`:

```bash
docker compose up -d
# sau: docker-compose up -d
```

Frontend-ul este expus pe **port 80** (containerul folosește nginx pe 80; mapare `80:80`). Backend pe 8000.

### 3. Deschide în browser

- **http://pine-hill.ro** → redirect la **http://pine-hill.ro/pine-hill** (site tenant pine-hill)
- **http://localhost** → același site (port 80)

Dacă vrei frontend pe alt port (ex. 5173), pune în `.env`: `FRONTEND_PORT=5173`. Atunci folosești **http://localhost:5173** sau, pentru pine-hill.ro, trebuie nginx pe host (vezi secțiunea „Fără Docker” mai jos).

---

## Fără Docker (Vite + backend local + nginx pe host)

### 1. Adaugă domeniul în /etc/hosts

Deschide `/etc/hosts` cu drepturi de admin și adaugă:

```
127.0.0.1 pine-hill.ro
```

Exemplu (macOS/Linux):

```bash
sudo nano /etc/hosts
# adaugă linia 127.0.0.1 pine-hill.ro, salvează
```

### 2. Pornește aplicațiile (fără nginx)

În terminale separate:

- **Backend:** din `360Booking/migration-backend` rulează serverul FastAPI (ex. pe portul **8000**).
- **Frontend:** din `360Booking/migration-frontend` rulează Vite (ex. `npm run dev` pe portul **5173**).

### 3. Nginx pe port 80

Ca să accesezi **http://pine-hill.ro** (port 80), trebuie un reverse proxy care ascultă pe 80 și trimite traficul către 5173 (frontend) și 8000 (backend).

### Instalare nginx (dacă nu e instalat)

- **macOS (Homebrew):** `brew install nginx`
- **Ubuntu/Debian:** `sudo apt install nginx`

### Folosirea config-ului local

1. Copiază sau leagă config-ul în locul unde nginx citește fișierele de site (ex. un `sites-available` sau `conf.d`):

   **macOS (Homebrew):**
   ```bash
   sudo cp 360Booking/migration-platform/nginx.local.conf /opt/homebrew/etc/nginx/servers/pine-hill.local.conf
   # sau
   sudo cp 360Booking/migration-platform/nginx.local.conf /usr/local/etc/nginx/servers/pine-hill.local.conf
   ```

   **Linux (Ubuntu/Debian):**
   ```bash
   sudo cp 360Booking/migration-platform/nginx.local.conf /etc/nginx/sites-available/pine-hill.local.conf
   sudo ln -s /etc/nginx/sites-available/pine-hill.local.conf /etc/nginx/sites-enabled/
   ```

2. Verifică configurația și repornește nginx:

   ```bash
   sudo nginx -t && sudo nginx -s reload
   # sau
   sudo nginx -t && sudo systemctl reload nginx
   ```

După asta, **http://pine-hill.ro** și **http://localhost** (pe port 80) vor trimite traficul către frontend (5173) și către backend (8000) pentru `/api/` și `/uploads/`.

### 4. Comportament în aplicație

- Când intri pe **http://pine-hill.ro/** (path `/`), aplicația te redirecționează la **http://pine-hill.ro/pine-hill**, astfel că se încarcă site-ul tenantului **pine-hill**.
- Tenantul este identificat după **slug** din URL (`/pine-hill`), nu după room; totul rămâne legat de tenant.

## Rezumat

| Ce vrei | Cu Docker | Fără Docker |
|--------|-----------|--------------|
| Domeniu local | `127.0.0.1 pine-hill.ro` în `/etc/hosts` | La fel |
| Acces pe port 80 | `docker compose up` – frontend e deja pe 80 | Nginx pe host cu `nginx.local.conf` |
| Tenant pine-hill | http://pine-hill.ro → redirect la /pine-hill | La fel |

**Cu Docker**: nginx este în containerul frontend; nu mai ai nevoie de nginx instalat local.
