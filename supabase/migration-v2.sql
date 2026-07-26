-- LANEA Books v2 migration: points of sale, purchases (invoices), initial inventory.
-- Run once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.
-- Safe to run on a database that already has the v1 tables (products/sales/gifts/expenses).

-- products: initial inventory replaces the old qty_purchased/cost_per_unit columns
alter table public.products add column if not exists ref text;
alter table public.products add column if not exists category text;
alter table public.products add column if not exists initial_qty numeric not null default 0;
alter table public.products add column if not exists initial_cost numeric not null default 0;

do $$ begin
  if exists (select 1 from information_schema.columns
             where table_schema = 'public' and table_name = 'products' and column_name = 'qty_purchased') then
    update public.products set initial_qty = coalesce(qty_purchased, 0) where initial_qty = 0;
    alter table public.products drop column qty_purchased;
  end if;
  if exists (select 1 from information_schema.columns
             where table_schema = 'public' and table_name = 'products' and column_name = 'cost_per_unit') then
    update public.products set initial_cost = coalesce(cost_per_unit, 0) where initial_cost = 0;
    alter table public.products drop column cost_per_unit;
  end if;
end $$;

-- points of sale
create table if not exists public.pos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

-- price list: one price per product per point of sale
create table if not exists public.pos_prices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  pos_id uuid not null references public.pos (id) on delete cascade,
  product_id uuid not null references public.products (id) on delete cascade,
  price numeric not null default 0,
  created_at timestamptz not null default now(),
  unique (pos_id, product_id)
);

-- purchases: supplier invoice lines (adds stock, feeds average cost)
create table if not exists public.purchases (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date date not null,
  invoice_ref text,
  product_id uuid not null references public.products (id) on delete cascade,
  qty numeric not null,
  unit_cost numeric not null default 0,
  created_at timestamptz not null default now()
);

-- sales gain a point of sale
alter table public.sales add column if not exists pos_id uuid references public.pos (id) on delete set null;

-- row level security for the new tables
alter table public.pos enable row level security;
alter table public.pos_prices enable row level security;
alter table public.purchases enable row level security;

drop policy if exists "own rows" on public.pos;
drop policy if exists "own rows" on public.pos_prices;
drop policy if exists "own rows" on public.purchases;

create policy "own rows" on public.pos for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on public.pos_prices for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on public.purchases for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
