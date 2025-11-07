do $$ begin
    -- enable RLS policy on auth tables
    alter table schema_migrations enable row level security;
    alter table instances enable row level security;
    alter table users enable row level security;
    alter table audit_log_entries enable row level security;
    alter table saml_relay_states enable row level security;
    alter table refresh_tokens enable row level security;
    alter table mfa_factors enable row level security;
    alter table sessions enable row level security;
    alter table sso_providers enable row level security;
    alter table sso_domains enable row level security;
    alter table mfa_challenges enable row level security;
    alter table mfa_amr_claims enable row level security;
    alter table saml_providers enable row level security;
    alter table flow_state enable row level security;
    alter table identities enable row level security;
    alter table one_time_tokens enable row level security;
    -- allow postgres role to select from auth tables and allow it to grant select to other roles
    grant select on schema_migrations to postgres with grant option;
    grant select on instances to postgres with grant option;
    grant select on users to postgres with grant option;
    grant select on audit_log_entries to postgres with grant option;
    grant select on saml_relay_states to postgres with grant option;
    grant select on refresh_tokens to postgres with grant option;
    grant select on mfa_factors to postgres with grant option;
    grant select on sessions to postgres with grant option;
    grant select on sso_providers to postgres with grant option;
    grant select on sso_domains to postgres with grant option;
    grant select on mfa_challenges to postgres with grant option;
    grant select on mfa_amr_claims to postgres with grant option;
    grant select on saml_providers to postgres with grant option;
    grant select on flow_state to postgres with grant option;
    grant select on identities to postgres with grant option;
    grant select on one_time_tokens to postgres with grant option;
end $$;
