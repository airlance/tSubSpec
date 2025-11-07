alter table if exists sessions
  add column if not exists tag text;
