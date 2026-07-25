# LANEA Books

Business accounting & inventory web app for LANEA: products, sales, gifts, expenses, and an automatic P&L report — all in EUR.

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
