CREATE EXTENSION IF NOT EXISTS pgcrypto;
ALTER TABLE two_factor_codes ALTER COLUMN id SET DEFAULT gen_random_uuid();
SELECT column_name, column_default FROM information_schema.columns WHERE table_name='two_factor_codes' AND column_name='id';
