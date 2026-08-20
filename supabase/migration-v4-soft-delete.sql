-- LANEA Books v4: soft delete for inventories and losses.
-- Deleted records stay visible (marked DELETED) and stop affecting stock;
-- they can be restored anytime.
-- Run once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.

alter table public.inventories add column if not exists deleted boolean not null default false;
alter table public.losses add column if not exists deleted boolean not null default false;
