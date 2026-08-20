-- LANEA Books v5: recurring expenses (rent, subscriptions... auto-added monthly).
-- Run once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.

create table if not exists public.recurring_expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  description text not null,
  category text not null,
  amount numeric not null,
  day_of_month numeric not null default 1,
  start_date date not null default now(),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.recurring_expenses enable row level security;
drop policy if exists "own rows" on public.recurring_expenses;
create policy "own rows" on public.recurring_expenses for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
