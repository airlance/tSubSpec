alter table if exists sessions
  add column if not exists oauth_client_id uuid;

alter table sessions
  add constraint sessions_oauth_client_id_fkey foreign key (oauth_client_id)
  references oauth_clients(id) on delete cascade not valid;

alter table sessions
  validate constraint sessions_oauth_client_id_fkey;

create index if not exists sessions_oauth_client_id_idx on sessions (oauth_client_id);
