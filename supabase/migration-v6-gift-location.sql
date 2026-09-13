-- LANEA Books v6: gifts can be given from a specific location (POS).
-- Empty = Home (the default). Run once in Supabase:
-- Dashboard -> SQL Editor -> New query -> paste -> Run.

alter table public.gifts add column if not exists pos_id uuid references public.pos (id) on delete set null;
