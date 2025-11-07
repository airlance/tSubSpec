do $$ begin
alter table saml_providers add column if not exists name_id_format text null;
end $$
