-- LANEA Books v3: losses (damaged products, expired DLC, theft…)
-- Run once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.

create table if not exists public.losses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date date not null,
  product_id uuid not null references public.products (id) on delete cascade,
  pos_id uuid references public.pos (id) on delete cascade,   -- null = warehouse
  qty numeric not null,
  reason text,
  created_at timestamptz not null default now()
);

alter table public.losses enable row level security;
drop policy if exists "own rows" on public.losses;
create policy "own rows" on public.losses for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
