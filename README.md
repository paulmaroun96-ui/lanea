# LÂNEA Books

Business accounting & inventory web app for LÂNEA: products & stock, supplier invoices (purchases), sales by point of sale with per-POS price lists, gifts, expenses, and a filterable cumulative dashboard — all in EUR.

**v2 highlights**
- `invoices-data.js`: 8 Au pays des Ânes invoices (233 lines, 109 products) extracted from the PDFs, one-click import inside the app. Discounts and shipping are spread into each unit cost; the credit note AV00000221 is already applied inside FA050897.
- Points of sale with per-POS prices (remembered automatically when you log a sale).
- Initial inventory per product; COGS uses the weighted-average cost of initial stock + all purchases.
- Dashboard filters: month range, point of sale, product.
- Existing v1 databases must run `supabase/migration-v2.sql` once (SQL Editor).

- **Zero build step** — a single static `index.html`. Open it locally or deploy anywhere.
- **Works offline** — data is stored in the browser (localStorage) by default.
- **Optional cloud sync** — connect a Supabase project (Settings tab in the app) to sync across devices, protected by email/password sign-in and row-level security.
- **Export** — CSV (P&L or full data), JSON backup/restore, print-to-PDF.

## Setup

### 1. Supabase (cloud sync)
1. Create a project at [supabase.com](https://supabase.com).
2. In the dashboard: **SQL Editor → New query**, paste the contents of [`supabase/schema.sql`](supabase/schema.sql), **Run**.
3. **Authentication → Users → Add user** — create your email + password (check "auto-confirm").
4. **Settings → API** — copy the **Project URL** and the **anon public** key.
5. Open the app → **Settings** tab → paste both → **Save & connect** → sign in.
6. If you already entered data locally, click **Upload local data to cloud** once.

### 2. Vercel (hosting)
1. Push this repo to GitHub (see below).
2. At [vercel.com](https://vercel.com): **Add New → Project → Import** the GitHub repo.
3. Framework preset: **Other** (it's a static site). No build command, no env vars. **Deploy**.

### 3. GitHub

```bash
git init
git add .
git commit -m "LANEA Books"
gh repo create lanea-books --private --source . --push
```

## Data model

Four tables (`products`, `sales`, `gifts`, `expenses`), each row owned by the signed-in user (`user_id` = `auth.uid()`, enforced by RLS). Sales and gifts reference `products.id`; deleting a product cascades to its sales/gifts. All derived numbers (COGS, margins, stock, monthly P&L) are computed in the client from these four tables.
