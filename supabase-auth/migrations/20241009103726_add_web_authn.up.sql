alter table mfa_factors add column if not exists web_authn_credential jsonb null;
alter table mfa_factors add column if not exists web_authn_aaguid uuid null;
alter table mfa_challenges add column if not exists web_authn_session_data jsonb null;
