CREATE TABLE IF NOT EXISTS two_factor_codes (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  code_hash varchar(255) NOT NULL,
  expires_at timestamptz NOT NULL,
  used boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_two_factor_codes_user_id
  ON two_factor_codes(user_id);

CREATE INDEX IF NOT EXISTS idx_two_factor_codes_expires_at
  ON two_factor_codes(expires_at);
