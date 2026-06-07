-- =============================================================================
-- MA Tax CRM — Supabase Schema
-- Córrelo UNA vez en Supabase → SQL Editor → New query → pega esto → Run.
-- Reutiliza el mismo proyecto Supabase de Mayor/EZBooks (mismo login).
-- Tabla compartida: cualquier usuario autenticado del equipo ve y edita los leads.
-- =============================================================================

create table if not exists crm_leads (
  id          uuid primary key default gen_random_uuid(),
  nombre      text not null,
  tel         text,
  email       text,
  servicio    text,
  estado      text not null default 'lead'
              check (estado in ('lead','activo','cotizado','cerrado','perdido','pausa')),
  valor       numeric default 0,
  tipo        text default 'mensual' check (tipo in ('mensual','unico')),
  paso        text,
  proxfecha   date,
  notas       text,
  ultima      date,
  origen      text,
  motivo      text,
  historial   jsonb default '[]'::jsonb,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now(),
  created_by  uuid references auth.users(id) on delete set null
);

-- columnas nuevas (idempotente, por si la tabla ya existía)
alter table crm_leads add column if not exists origen    text;
alter table crm_leads add column if not exists motivo    text;
alter table crm_leads add column if not exists historial jsonb default '[]'::jsonb;

create index if not exists idx_crm_leads_estado on crm_leads(estado);
create index if not exists idx_crm_leads_updated on crm_leads(updated_at desc);

-- keep updated_at fresh
create or replace function crm_touch_updated() returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

drop trigger if exists trg_crm_touch on crm_leads;
create trigger trg_crm_touch before update on crm_leads
  for each row execute function crm_touch_updated();

-- Row Level Security: solo usuarios autenticados (equipo MA Tax)
alter table crm_leads enable row level security;

drop policy if exists "crm select" on crm_leads;
drop policy if exists "crm insert" on crm_leads;
drop policy if exists "crm update" on crm_leads;
drop policy if exists "crm delete" on crm_leads;

create policy "crm select" on crm_leads for select using (auth.uid() is not null);
create policy "crm insert" on crm_leads for insert with check (auth.uid() is not null);
create policy "crm update" on crm_leads for update using (auth.uid() is not null);
create policy "crm delete" on crm_leads for delete using (auth.uid() is not null);
