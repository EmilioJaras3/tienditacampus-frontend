-- Habilitar extensión
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Asegurar tablas de benchmarking (por si acaso)
CREATE TABLE IF NOT EXISTS projects (
    project_id INTEGER PRIMARY KEY,
    project_type VARCHAR(50) NOT NULL,
    description TEXT,
    db_engine VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS queries (
    query_id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(project_id),
    query_description TEXT NOT NULL,
    query_sql TEXT NOT NULL,
    target_table VARCHAR(50),
    query_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vista para BigQuery exigida en la evaluación
CREATE OR REPLACE VIEW v_daily_export AS
SELECT 
    2 as project_id, -- ID fijo según requerimiento
    queryid::text as query_id,
    query,
    calls,
    total_exec_time as total_exec_time_ms,
    rows as rows_returned,
    CURRENT_DATE as snapshot_date
FROM pg_stat_statements
WHERE calls > 0 
AND query NOT LIKE '%pg_stat_statements%'
AND query NOT LIKE '%v_daily_export%';
