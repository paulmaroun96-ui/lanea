-- LANEA Books — Supabase schema
-- Run this once in your Supabase project: Dashboard -> SQL Editor -> New query -> paste -> Run.

create table public.products (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  name text not null,
  supplier text,
  qty_purchased numeric not null default 0,
  cost_per_unit numeric not null default 0,
  created_at timestamptz not null default now()
);

create table public.sales (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date date not null,
  product_id uuid not null references public.products (id) on delete cascade,
  qty numeric not null,
  price_per_unit numeric not null,
  created_at timestamptz not null default now()
);

create table public.gifts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date date not null,
  product_id uuid not null references public.products (id) on delete cascade,
  qty numeric not null,
  note text,
  created_at timestamptz not null default now()
);

create table public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date date not null,
  description text not null,
  category text not null,
  amount numeric not null,
  created_at timestamptz not null default now()
);

-- Row Level Security: each signed-in user sees only their own rows.
alter table public.products enable row level security;
alter table public.sales    enable row level security;
alter table public.gifts    enable row level security;
alter table public.expenses enable row level security;

create policy "own rows" on public.products for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on public.sales for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on public.gifts for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on public.expenses for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
