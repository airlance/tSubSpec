ALTER TABLE mfa_factors
ADD COLUMN IF NOT EXISTS last_webauthn_challenge_data JSONB;

COMMENT ON COLUMN mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';
