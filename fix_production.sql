ALTER TABLE "products" ALTER COLUMN "image_url" TYPE text;
ALTER TABLE "inventory_records" ADD COLUMN IF NOT EXISTS "unit_cost" numeric(10,2) NOT NULL DEFAULT 0;
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
