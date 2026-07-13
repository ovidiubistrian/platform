# Arhitectură: platformă multi-tenant cu web + mobil + backend unic

Brief scris ca **instrucțiuni**, nu ca descriere — de dat direct unui agent (Claude) care pornește o platformă cu aceeași formă: SaaS multi-tenant, un panou web, una sau mai multe aplicații native, un backend.

Fiecare regulă de mai jos e o decizie luată în producție la 360booking, iar unde scrie „am învățat-o pe pielea noastră" e un bug real care a ajuns la client.

---

## 0. Repo-uri

**Un singur backend, câte un repo per aplicație client.**

| Repo | Ce e | Deploy |
|---|---|---|
| `backend` | FastAPI + SQLAlchemy + Alembic, Postgres — unul singur, servește tot | Docker; push pe `main` → build + `alembic upgrade head` |
| `frontend` | React + Vite (panou admin + site public + POS web) | Docker + nginx |
| `app-mobile-A` | Expo / React Native | EAS build + OTA |
| `app-mobile-B` | Expo / React Native | EAS build + OTA |
| `platform` | meta-repo: `deploy/`, documentație | — |

**Nu face backend separat per aplicație.** Ajungi cu două state machine care diverg și cu bug-uri de tipul „webul zice `ready`, mobilul zice `served`".

---

## 1. Un backend, mai multe fronturi

Segmentează prin **prefixe de rută**, nu prin procese:

- `/api/*` — panoul de admin web (sesiune de browser)
- `/api/mobile/*` — aplicațiile native (JWT + refresh token)
- `/api/public/*` — orice atinge clientul final, neautentificat (tokenul din URL = singurul secret)
- `/api/super-admin/*` — cross-tenant, rol dedicat

Rutele mobile **oglindesc** rutele web unde e nevoie, dar sunt endpoint-uri distincte: mobilul are alte payload-uri și alt model de push. Logica stă în `services/*.py`; endpoint-urile sunt subțiri și nu conțin reguli de business.

---

## 2. Tenancy

Tenantul se rezolvă din **header-ul `Host`** — subdomeniu (`*.platforma.ro`) sau domeniu propriu al clientului. Reverse proxy (Caddy) cu TLS on-demand, plus un endpoint `check-domain` prin care proxy-ul întreabă backendul dacă domeniul e valid înainte să emită certificat.

Fiecare tabelă are `tenant_id` indexat. **Fiecare query filtrează pe el** — fără excepție, inclusiv în cron-uri și în joburi de background. Rolul `super_admin` e singurul care trece peste, printr-un dependency separat (`require_super_admin`), niciodată printr-un `if` strecurat în business logic.

---

## 3. Sursa unică de adevăr pentru stări

Enumurile de status stau **în modelele backend**, ca constante (`ORDER_STATUS_READY = "ready"`). Frontendurile nu redefinesc stările — doar le mapează la etichete afișabile.

**Regula de aur: fiecare stare trebuie să aibă cine s-o scoată din ea.**

Aveam bucătăria care ducea comanda în `ready` și *nimic* în tot sistemul care s-o ducă mai departe în `served` — niciun buton, niciun endpoint. Comenzile rămâneau blocate acolo pentru totdeauna, iar harta sălii nu se actualiza niciodată. Când adaugi o stare, scrie explicit **cine face fiecare tranziție și din ce ecran**.

**Corolar: nu deriva „e deschis?" din statusul de proces.**

Aveam o gardă care refuza regenerarea planului sălii dacă existau comenzi cu status `ready`. Dar o notă plătită și închisă își păstrează pe veci ultimul status de bucătărie — deci ownerul era blocat de note încasate acum trei zile, fără să aibă ce să mai închidă. Ține un boolean explicit (`is_open`) și interoghează-l pe ăla.

---

## 4. Roluri și granițe de securitate prin absența endpoint-ului

Dependency-uri de rol: `require_tenant_admin`, `require_staff_role_X`, `require_super_admin`.

Dar cel mai puternic control **nu e un rol — e să nu existe endpoint-ul.**

La noi, ospătarii furau scoțând produse de pe notă. Soluția n-a fost un rol mai strict, ci: acțiunea de retur **nu are endpoint mobil deloc**. Angajatul nu poate scoate un produs de pe notă de pe telefonul lui, stând la masă — trebuie să meargă la terminalul fix, de față cu lumea. Când o acțiune e riscantă, întreabă-te **de pe ce dispozitiv ar trebui să fie fizic posibilă**.

Peste asta, **coadă de aprobare**, cu flag configurabil per tenant (`void_requires_approval`, pornit implicit):

- cererea **nu schimbă nimic** (banii rămân pe notă) până când un manager aprobă;
- rândul din DB supraviețuiește aprobării *și* refuzului — un angajat care cere trei retururi pe seară e un tipar pe care vrei să-l vezi;
- tenantul care are încredere în echipă poate opri aprobarea; acțiunea se aplică pe loc, dar tot se jurnalizează.

**Nu șterge fizic rânduri cu semnificație financiară.** Soft-void: păstrezi rândul, îl treci pe zero, îi pui `status = void`. Bonul fiscal și rapoartele au nevoie de el.

---

## 5. Timp real: polling, nu websockets

Zero websockets, și nu ne lipsesc.

- **Polling cu interval**, calibrat pe urgență: ecranul bucătăriei la 4s, harta sălii la 8s, comanda activă la 5s. Pe web `setInterval`, pe mobil `refetchInterval` (react-query).
- **Push** (Expo) doar pentru evenimente care cer atenție când aplicația e închisă: „mâncarea e gata", „masa 5 te cheamă".

Polling-ul e mult mai simplu de întreținut și de raționat decât un canal persistent, iar la 4 secunde omul nu simte diferența. Adaugă websockets doar când ai o dovadă că e nevoie.

---

## 6. Configurare per tenant

Două mecanisme, alese după rol:

- **Coloane boolean** pentru comutatoare care poartă logică de business (`orders_enabled`, `void_requires_approval`): interogabile, indexabile, cu `server_default`.
- **Un blob JSON** (`pos_config_json`) pentru configurări opționale de integrări (credențiale WhatsApp, stații de bucătărie). Ce nu apare niciodată într-un `WHERE` nu merită coloană.

**Feature flag pe două niveluri:** unul global (super admin) × unul per tenant. Tenantul nu poate porni un modul pe care platforma nu i l-a activat.

---

## 7. Mobil: Expo + EAS

- `runtimeVersion` fix (ex. `"1.0.0"`) → poți trimite **OTA update** (`eas update --branch production --platform all`) pentru orice schimbare de JS, **fără build nou în store**. Build nou doar când atingi cod nativ.
- Canale: `production` (magazine), `preview` (intern).
- **Consecință de arhitectură:** dacă o funcție e doar în backend + web, aplicațiile nu trebuie atinse deloc. Ține minte asta când decizi unde pui o funcționalitate — „doar pe terminalul fix" înseamnă și „zero ship pe mobil".

---

## 8. Deploy

Push pe `main` → GitHub Actions pe **self-hosted runner** pe serverul de producție → `docker build` local → `docker compose up -d`. Backendul rulează `alembic upgrade head` la pornire.

**Migrări aditive**: coloană nouă cu `server_default`, tabelă nouă. Nu strica niciodată forma veche într-o singură migrare — containerul vechi mai servește trafic câteva secunde în timpul deploy-ului.

---

## 9. Randare de documente

PDF-uri (bonuri, meniuri, carduri QR) generate **în backend** cu WeasyPrint + HTML (Jinja sau f-string), QR cu **segno** (SVG inline).

**Fără servicii externe de QR sau de randare** — pică exact când ownerul apasă print, sau sunt blocate în rețeaua localului.

Atenție: **WeasyPrint nu suportă flexbox ca lumea.** Layout-urile de print se fac cu `float`, `inline-block` și `position: absolute`. Am pierdut o iterație pe asta.

Pentru foi tipăribile, ține **dimensiunea cardului fixă**, nu întinsă ca să umple pagina — altfel ultima pagină, cu 2 elemente în loc de 6, le printează la altă mărime.

---

## 10. Copy-ul e parte din arhitectură

Avem două tipuri de local (restaurant / beach bar) și textele erau parametrizate **doar prin substantiv**. Rezultatul: un bistro primea „Rândul 1 e cel mai aproape de mare" și eroarea „Nu am putut genera plaja".

Dacă ai două tipuri de tenant cu **modele mentale diferite**, nu schimba substantivul — **schimbă fluxul**. Restaurantul gândește în niveluri (Parter, Etaj 1, Terasă); plaja gândește în rânduri față de mare. Backend comun, wizard-uri diferite.
