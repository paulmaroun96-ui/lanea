-- migration v8: optional end month for recurring expenses
-- (rules like "Qudra $800 from Sept till Dec" stop adding entries after end_date)
alter table recurring_expenses add column if not exists end_date date;
