-- LANEA Books v7: historical sales/gifts can carry their own unit cost
-- (old purchases had different costs than today's average). Empty = use the
-- product's average cost, as before. Run once in Supabase:
-- Dashboard -> SQL Editor -> New query -> paste -> Run.

alter table public.sales add column if not exists unit_cost numeric;
alter table public.gifts add column if not exists unit_cost numeric;
