# Tenant-configurable tracking (GTM, GA4, Facebook Pixel)

Each tenant (pensiune) can configure tracking for their public website. No cross-tenant leakage: config is resolved by tenant slug only.

## How tenant admin config works

1. **Admin page:** Tenant admin goes to **Setări → Tracking & Analiză** (`/admin/settings/tracking`).
2. **Settings stored in backend:** Values are saved in `tenants.settings` JSON under the key `tracking` (e.g. `tenants.settings.tracking.enabled`, `gtmContainerId`, `ga4MeasurementId`, `fbPixelId`, `consentRequired`, `trackingDebug`).
3. **API (tenant-admin only):**
   - `GET /api/tenant/settings/tracking` — returns current tenant’s tracking settings (auth required; tenant from JWT).
   - `PUT /api/tenant/settings/tracking` — updates current tenant’s tracking settings (auth required; tenant from JWT).
4. **Public config:** The tenant’s public website loads config via `GET /api/public/tenant/tracking?tenant_slug=<slug>`. Tenant is resolved **only** from `tenant_slug` (from URL/host). Never pass `tenant_id` to this endpoint.
5. **Script injection:** The frontend `TrackingProvider` fetches public config for the current tenant (from URL/host), then injects GTM and/or GA4 and/or Facebook Pixel when tracking is enabled. If **Require cookie consent** is on, scripts load only after the user accepts cookies (same `cookie-consent` localStorage key as the existing banner).

## Env / dev behaviour

- **Disable tracking in dev:** Set `VITE_DISABLE_TRACKING=true` in the frontend env. When set, the provider does nothing even if the tenant has tracking enabled (so you don’t pollute GA4/FB in development).
- **Backend:** No extra env vars for tracking; uses existing auth and tenant resolution.

## How to test locally

1. **Backend:** Run the API and ensure you have a tenant and an admin user for that tenant.
2. **Frontend:**  
   - For **admin:** Log in as tenant admin → **Setări** → **Tracking & Analiză**. Enter a test GTM container ID (e.g. `GTM-XXXX`) or GA4 ID (`G-XXXX`) and/or Facebook Pixel ID (e.g. `1234567890123456`). Enable tracking and save.
   - For **public site:** Open the tenant’s public URL (e.g. `http://localhost:5173/pine-hill` or your tenant slug). Accept cookies if consent is required. Scripts should load for that tenant only.
3. **With tracking disabled in dev:** Set `VITE_DISABLE_TRACKING=true` and restart the frontend. No scripts should load on the public site even if the tenant has tracking enabled.

## Verifying events in GA4 and Meta Pixel Helper

- **GA4:**  
  - In GA4, go to **Admin → DebugView** (or use the “DebugView” report).  
  - In the frontend, enable **Mod debug** in the tracking settings and open the tenant’s public site.  
  - You should see `page_view`, and when going through the booking flow: `view_item` (view_unit/view_property), `begin_checkout`, `add_payment_info`, `purchase`.
- **Meta Pixel Helper (Chrome extension):**  
  - Install the “Meta Pixel Helper” extension.  
  - On the tenant’s public site (with FB Pixel ID set and tracking enabled), the extension should show the pixel firing and events (PageView, ViewContent, InitiateCheckout, Purchase, etc.).

## Example events and where they are sent

| Event (internal name) | When it’s sent | GA4 event | Facebook event |
|-----------------------|----------------|-----------|-----------------|
| `page_view`           | Route change on public site (TrackingProvider) | `page_view` | `PageView` |
| `view_property`       | Tenant homepage loaded (TenantHomePage)         | `view_item` | `ViewContent` |
| `view_unit`           | Unit details page loaded (UnitDetailsPage)     | `view_item` | `ViewContent` |
| `begin_checkout`      | User reaches step 2 (dates) on booking (BookingPage) | `begin_checkout` | `InitiateCheckout` |
| `add_payment_info`    | User submits booking (step 4) (BookingPage)     | `add_payment_info` | `AddPaymentInfo` |
| `purchase`            | User lands on booking success (BookingSuccessPage)   | `purchase` | `Purchase` |

**Where to call tracking in the booking flow:**

- **view_property:** `TenantHomePage.tsx` — once when tenant data is loaded.
- **view_unit:** `UnitDetailsPage.tsx` — when unit data is loaded (both route variants).
- **begin_checkout:** `BookingPage.tsx` — in a `useEffect` when `step === 2` and a room is selected (tracked once per flow).
- **add_payment_info:** `BookingPage.tsx` — right before `navigate` to success after a successful booking submit.
- **purchase:** `BookingSuccessPage.tsx` — on mount when `location.state.purchaseTracking` is present (passed from BookingPage after submit).

All of these use the shared `track()` from `@/lib/tracking`, which sends to both GA4 (gtag) and Facebook Pixel (fbq) when the respective scripts are loaded.
