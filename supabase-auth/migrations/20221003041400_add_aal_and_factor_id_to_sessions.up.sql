-- add factor_id to sessions
 alter table sessions add column if not exists factor_id uuid null;
 alter table sessions add column if not exists aal aal_level null;
