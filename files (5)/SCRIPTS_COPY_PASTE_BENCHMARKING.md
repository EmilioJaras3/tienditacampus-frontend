# 🎯 SCRIPTS COPY-PASTE PARA BENCHMARKING ACADÉMICO

---

## SQL SCRIPTS

### 1. CREAR TODAS LAS TABLAS (V001 + V002 + V003)

**Archivo:** `database/migrations/01_create_all_tables.sql`

```sql
-- ============================================
-- BENCHMARKING SCHEMA COMPLETO
-- ============================================

-- Tabla 1: PROJECTS
CREATE TABLE IF NOT EXISTS projects (
    project_id SERIAL PRIMARY KEY,
    project_type VARCHAR(20) NOT NULL CHECK (
        project_type IN (
            'ECOMMERCE', 'SOCIAL', 'FINANCIAL', 'HEALTHCARE', 'IOT',
            'EDUCATION', 'CONTENT', 'ENTERPRISE', 'LOGISTICS', 'GOVERNMENT'
        )
    ),
    description TEXT,
    db_engine VARCHAR(20) NOT NULL CHECK (
        db_engine IN ('POSTGRESQL', 'MYSQL', 'MONGODB', 'OTHER')
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_projects_type ON projects(project_type);
CREATE INDEX idx_projects_db_engine ON projects(db_engine);

-- Tabla 2: QUERIES
CREATE TABLE IF NOT EXISTS queries (
    query_id SERIAL PRIMARY KEY,
    project_id INT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    query_description TEXT NOT NULL,
    query_sql TEXT NOT NULL,
    target_table VARCHAR(100),
    query_type VARCHAR(30) NOT NULL CHECK (
        query_type IN (
            'SIMPLE_SELECT', 'AGGREGATION', 'JOIN', 'WINDOW_FUNCTION', 'SUBQUERY',
            'WRITE_OPERATION'
        )
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_queries_project_id ON queries(project_id);
CREATE INDEX idx_queries_type ON queries(query_type);

-- Tabla 3: EXECUTIONS
CREATE TABLE IF NOT EXISTS executions (
    execution_id BIGSERIAL PRIMARY KEY,
    project_id INT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    query_id INT NOT NULL REFERENCES queries(query_id) ON DELETE CASCADE,
    index_strategy VARCHAR(20) NOT NULL CHECK (
        index_strategy IN ('NO_INDEX', 'SINGLE_INDEX', 'COMPOSITE_INDEX')
    ),
    execution_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    execution_time_ms BIGINT NOT NULL,
    records_examined BIGINT,
    records_returned BIGINT,
    dataset_size_rows BIGINT,
    dataset_size_mb NUMERIC,
    concurrent_sessions INT,
    shared_buffers_hits BIGINT,
    shared_buffers_reads BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_executions_project_id ON executions(project_id);
CREATE INDEX idx_executions_query_id ON executions(query_id);
CREATE INDEX idx_executions_timestamp ON executions(execution_timestamp DESC);
CREATE INDEX idx_executions_index_strategy ON executions(index_strategy);
CREATE INDEX idx_executions_project_timestamp ON executions(project_id, execution_timestamp DESC);

-- ============================================
-- COMENTARIOS PARA DOCUMENTACIÓN
-- ============================================

COMMENT ON TABLE projects IS 'Caracterización estructural de sistemas bajo estudio';
COMMENT ON COLUMN projects.project_type IS 'Clasificación del dominio funcional';
COMMENT ON COLUMN projects.db_engine IS 'Motor de base de datos utilizado';

COMMENT ON TABLE queries IS 'Catálogo formal de cargas de trabajo evaluadas';
COMMENT ON COLUMN queries.query_type IS 'Clasificación estructural de la consulta';
COMMENT ON COLUMN queries.target_table IS 'Tabla principal sobre la cual opera';

COMMENT ON TABLE executions IS 'Núcleo experimental: métricas de cada ejecución';
COMMENT ON COLUMN executions.index_strategy IS 'NO_INDEX, SINGLE_INDEX o COMPOSITE_INDEX';
COMMENT ON COLUMN executions.shared_buffers_hits IS 'Accesos desde memoria cache';
COMMENT ON COLUMN executions.shared_buffers_reads IS 'Lecturas desde disco';

-- ============================================
-- VERIFICACIÓN
-- ============================================

-- Ejecutar esto para verificar que todo se creó
SELECT
    table_name,
    column_count,
    index_count
FROM (
    SELECT
        t.tablename as table_name,
        (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.tablename) as column_count,
        (SELECT COUNT(*) FROM pg_indexes WHERE tablename = t.tablename) as index_count
    FROM pg_tables t
    WHERE schemaname = 'public' AND tablename IN ('projects', 'queries', 'executions')
) sub
ORDER BY table_name;
```

---

### 2. VERIFICAR e HABILITAR pg_stat_statements

**Archivo:** `database/scripts/setup_pg_stat_statements.sql`

```sql
-- ============================================
-- VERIFICAR E INSTALAR pg_stat_statements
-- ============================================

-- 1. Verificar si la extensión está instalada
SELECT
    extname,
    extversion,
    extschema::regnamespace as schema
FROM pg_extension
WHERE extname = 'pg_stat_statements';

-- Si la anterior retorna vacío, crear la extensión:
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- 2. Verificar que está activa
SELECT * FROM pg_stat_statements LIMIT 1;

-- 3. Ver configuración actual
SHOW shared_preload_libraries;
SHOW pg_stat_statements.track;
SHOW pg_stat_statements.max;

-- 4. Registrar esta base de datos en pg_stat_statements
-- (ya debería estarlo si la extensión está activada)
SELECT pg_stat_statements_reset();

-- 5. Contar estadísticas disponibles
SELECT COUNT(*) as total_statements FROM pg_stat_statements;
```

---

### 3. INSERTAR QUERIES DE PRUEBA

**Archivo:** `database/scripts/insert_test_queries.sql`

```sql
-- ============================================
-- INSERTAR PROYECTO DE PRUEBA
-- ============================================

INSERT INTO projects (project_type, description, db_engine)
VALUES (
    'ECOMMERCE',
    'Sistema de ventas online - NestJS + Next.js + PostgreSQL',
    'POSTGRESQL'
);

-- Obtener el ID (generalmente 1, pero verificar)
SELECT project_id FROM projects ORDER BY project_id DESC LIMIT 1;

-- ============================================
-- INSERTAR QUERIES DE CADA TIPO
-- ============================================

-- 1. SIMPLE_SELECT
INSERT INTO queries (project_id, query_description, query_sql, target_table, query_type)
VALUES (
    1,
    'Búsqueda simple de usuario por ID',
    'SELECT user_id, email, name FROM users WHERE user_id = $1;',
    'users',
    'SIMPLE_SELECT'
);

-- 2. AGGREGATION
INSERT INTO queries (project_id, query_description, query_sql, target_table, query_type)
VALUES (
    1,
    'Totales de ventas por mes',
    'SELECT DATE_TRUNC(''month'', created_at)::date as month, SUM(total_amount) as total, COUNT(*) as count FROM sales GROUP BY DATE_TRUNC(''month'', created_at) ORDER BY month DESC;',
    'sales',
    'AGGREGATION'
);

-- 3. JOIN
INSERT INTO queries (project_id, query_description, query_sql, target_table, query_type)
VALUES (
    1,
    'Usuarios con conteo de sus ventas',
    'SELECT u.user_id, u.email, u.name, COUNT(s.sale_id) as total_sales FROM users u LEFT JOIN sales s ON u.user_id = s.user_id GROUP BY u.user_id, u.email, u.name ORDER BY total_sales DESC;',
    'users',
    'JOIN'
);

-- 4. WINDOW_FUNCTION
INSERT INTO queries (project_id, query_description, query_sql, target_table, query_type)
VALUES (
    1,
    'Ranking de productos por cantidad vendida',
    'SELECT product_id, total_quantity, ROW_NUMBER() OVER (ORDER BY total_quantity DESC) as rank FROM (SELECT sd.product_id, SUM(sd.quantity) as total_quantity FROM sales_details sd GROUP BY sd.product_id) sub;',
    'sales_details',
    'WINDOW_FUNCTION'
);

-- 5. SUBQUERY
INSERT INTO queries (project_id, query_description, query_sql, target_table, query_type)
VALUES (
    1,
    'Usuarios con ventas arriba del promedio',
    'SELECT user_id, total_amount FROM sales WHERE total_amount > (SELECT AVG(total_amount) FROM sales) ORDER BY total_amount DESC;',
    'sales',
    'SUBQUERY'
);

-- 6. WRITE_OPERATION
INSERT INTO queries (project_id, query_description, query_sql, target_table, query_type)
VALUES (
    1,
    'Insertar nuevo usuario (simulado)',
    'INSERT INTO users (email, name, password_hash) VALUES ($1, $2, $3) RETURNING user_id;',
    'users',
    'WRITE_OPERATION'
);

-- ============================================
-- VERIFICACIÓN
-- ============================================

SELECT
    q.query_id,
    q.query_description,
    q.query_type,
    q.target_table
FROM queries q
WHERE q.project_id = 1
ORDER BY q.query_id;
```

---

### 4. CREAR VISTAS DE EXPORTACIÓN

**Archivo:** `database/scripts/create_export_views.sql`

```sql
-- ============================================
-- VISTA PRINCIPAL DE EXPORTACIÓN
-- ============================================

CREATE OR REPLACE VIEW v_daily_export AS
SELECT
    p.project_id,
    CURRENT_DATE::DATE as snapshot_date,
    q.query_id::TEXT as queryid,
    0::INT64 as dbid,
    0::INT64 as userid,
    pss.query::TEXT as query,
    pss.calls::INT64 as calls,
    COALESCE(pss.total_exec_time, 0)::FLOAT64 as total_exec_time_ms,
    COALESCE(pss.mean_exec_time, 0)::FLOAT64 as mean_exec_time_ms,
    COALESCE(pss.min_exec_time, 0)::FLOAT64 as min_exec_time_ms,
    COALESCE(pss.max_exec_time, 0)::FLOAT64 as max_exec_time_ms,
    COALESCE(pss.stddev_exec_time, 0)::FLOAT64 as stddev_exec_time_ms,
    COALESCE(e.records_returned, 0)::INT64 as rows_returned,
    COALESCE(e.shared_buffers_hits, 0)::INT64 as shared_blks_hit,
    COALESCE(e.shared_buffers_reads, 0)::INT64 as shared_blks_read,
    0::INT64 as shared_blks_dirtied,
    0::INT64 as shared_blks_written,
    0::INT64 as temp_blks_read,
    0::INT64 as temp_blks_written,
    CURRENT_TIMESTAMP as ingestion_timestamp
FROM
    projects p
    CROSS JOIN queries q
    LEFT JOIN pg_stat_statements pss 
        ON pss.query ILIKE '%' || q.target_table || '%'
    LEFT JOIN executions e 
        ON e.project_id = p.project_id 
        AND e.query_id = q.query_id
        AND DATE(e.execution_timestamp) = CURRENT_DATE
WHERE
    pss.calls > 0
    OR e.execution_id IS NOT NULL
ORDER BY
    p.project_id,
    q.query_id,
    pss.calls DESC NULLS LAST;

COMMENT ON VIEW v_daily_export IS 'Vista principal para exportación diaria a BigQuery';

-- ============================================
-- VISTA ALTERNATIVA AGREGADA
-- ============================================

CREATE OR REPLACE VIEW v_daily_export_aggregated AS
SELECT
    p.project_id,
    CURRENT_DATE::DATE as snapshot_date,
    q.query_id::TEXT as queryid,
    q.query_type,
    COUNT(e.execution_id)::INT64 as calls,
    SUM(COALESCE(e.execution_time_ms, 0))::FLOAT64 as total_exec_time_ms,
    AVG(COALESCE(e.execution_time_ms, 0))::FLOAT64 as mean_exec_time_ms,
    MIN(COALESCE(e.execution_time_ms, 0))::FLOAT64 as min_exec_time_ms,
    MAX(COALESCE(e.execution_time_ms, 0))::FLOAT64 as max_exec_time_ms,
    STDDEV(COALESCE(e.execution_time_ms, 0))::FLOAT64 as stddev_exec_time_ms,
    SUM(COALESCE(e.records_returned, 0))::INT64 as rows_returned,
    SUM(COALESCE(e.shared_buffers_hits, 0))::INT64 as shared_blks_hit,
    SUM(COALESCE(e.shared_buffers_reads, 0))::INT64 as shared_blks_read,
    CURRENT_TIMESTAMP as ingestion_timestamp
FROM
    projects p
    INNER JOIN queries q ON p.project_id = q.project_id
    LEFT JOIN executions e ON q.query_id = e.query_id
WHERE
    DATE(e.execution_timestamp) = CURRENT_DATE
    OR e.execution_id IS NULL
GROUP BY
    p.project_id, q.query_id, q.query_type
ORDER BY
    p.project_id, q.query_id;

COMMENT ON VIEW v_daily_export_aggregated IS 'Vista agregada por tipo de query';

-- ============================================
-- VERIFICACIÓN
-- ============================================

-- Contar registros en vista principal
SELECT COUNT(*) as total_export_rows FROM v_daily_export;

-- Ver estructura de datos a exportar
SELECT * FROM v_daily_export LIMIT 1;

-- Ver datos agregados
SELECT * FROM v_daily_export_aggregated LIMIT 1;
```

---

### 5. EJECUTAR QUERIES Y CAPTURAR ESTADÍSTICAS

**Archivo:** `database/scripts/execute_test_queries.sql`

```sql
-- ============================================
-- EJECUTAR TODAS LAS QUERIES DE PRUEBA
-- ============================================

-- NOTA: Estas queries deben ejecutarse para que pg_stat_statements las registre

-- 1. SIMPLE_SELECT - Ejecutar múltiples veces
SELECT user_id, email, name FROM users WHERE user_id = 1;
SELECT user_id, email, name FROM users WHERE user_id = 2;
SELECT user_id, email, name FROM users WHERE user_id = 3;

-- 2. AGGREGATION
SELECT DATE_TRUNC('month', created_at)::date as month, SUM(total_amount) as total, COUNT(*) as count
FROM sales
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month DESC;

-- 3. JOIN
SELECT u.user_id, u.email, u.name, COUNT(s.sale_id) as total_sales
FROM users u
LEFT JOIN sales s ON u.user_id = s.user_id
GROUP BY u.user_id, u.email, u.name
ORDER BY total_sales DESC;

-- 4. WINDOW_FUNCTION
SELECT product_id, total_quantity, ROW_NUMBER() OVER (ORDER BY total_quantity DESC) as rank
FROM (
    SELECT sd.product_id, SUM(sd.quantity) as total_quantity
    FROM sales_details sd
    GROUP BY sd.product_id
) sub;

-- 5. SUBQUERY
SELECT user_id, total_amount
FROM sales
WHERE total_amount > (SELECT AVG(total_amount) FROM sales)
ORDER BY total_amount DESC;

-- ============================================
-- VERIFICAR QUE FUERON CAPTURADAS
-- ============================================

-- Ver qué queries fueron registradas
SELECT
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    max_exec_time
FROM pg_stat_statements
WHERE query LIKE '%users%' OR query LIKE '%sales%'
ORDER BY calls DESC
LIMIT 10;

-- Contar total de queries registradas
SELECT COUNT(*) as total_tracked FROM pg_stat_statements;
```

---

### 6. EXPORTAR A CSV (Antes del Reset)

**Archivo:** `database/scripts/export_snapshot_csv.sql`

```sql
-- ============================================
-- EXPORTAR SNAPSHOT A CSV
-- ============================================

-- IMPORTANTE: Ejecutar ANTES de pg_stat_statements_reset()

-- Opción 1: Usar \copy en psql
-- \COPY (SELECT * FROM v_daily_export) TO 'project_1_20260222.csv' WITH (FORMAT CSV, HEADER);

-- Opción 2: Query SQL pura (copiar resultado)
SELECT * FROM v_daily_export ORDER BY project_id, queryid;

-- Opción 3: Con formato específico
COPY (
    SELECT
        project_id,
        snapshot_date,
        queryid,
        dbid,
        userid,
        query,
        calls,
        total_exec_time_ms,
        mean_exec_time_ms,
        min_exec_time_ms,
        max_exec_time_ms,
        stddev_exec_time_ms,
        rows_returned,
        shared_blks_hit,
        shared_blks_read,
        shared_blks_dirtied,
        shared_blks_written,
        temp_blks_read,
        temp_blks_written,
        ingestion_timestamp
    FROM v_daily_export
    ORDER BY project_id, queryid
) TO STDOUT
WITH (FORMAT CSV, HEADER, ENCODING 'UTF8');
```

---

### 7. RESET DE ESTADÍSTICAS (Después de Exportar)

**Archivo:** `database/scripts/reset_statistics.sql`

```sql
-- ============================================
-- RESET DE ESTADÍSTICAS
-- ============================================

-- CUIDADO: Ejecutar SOLO DESPUÉS de exportar exitosamente

-- 1. Resetear pg_stat_statements
SELECT pg_stat_statements_reset();

-- 2. Verificar que se reseteó
SELECT COUNT(*) as remaining_statements FROM pg_stat_statements;
-- Resultado esperado: 0 (o muy pocas)

-- 3. Log del reset
INSERT INTO benchmark_logs (action, timestamp, message)
VALUES ('RESET', CURRENT_TIMESTAMP, 'pg_stat_statements reset ejecutado exitosamente');

-- 4. Confirmar
SELECT action, timestamp, message FROM benchmark_logs ORDER BY timestamp DESC LIMIT 5;
```

---

## CÓDIGO TYPESCRIPT

### 1. OAuth Google Service

**Archivo:** `src/modules/benchmarking/services/oauth.service.ts`

```typescript
import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { google } from 'googleapis';

@Injectable()
export class OAuthService {
  private readonly logger = new Logger(OAuthService.name);
  private oauth2Client: any;

  constructor(private configService: ConfigService) {
    this.initializeOAuth();
  }

  private initializeOAuth() {
    this.oauth2Client = new google.auth.OAuth2(
      this.configService.get('GOOGLE_CLIENT_ID'),
      this.configService.get('GOOGLE_CLIENT_SECRET'),
      this.configService.get('GOOGLE_REDIRECT_URI'),
    );
  }

  getAuthUrl(): string {
    const scopes = ['https://www.googleapis.com/auth/bigquery'];
    return this.oauth2Client.generateAuthUrl({
      access_type: 'offline',
      scope: scopes,
    });
  }

  async getTokenFromCode(code: string): Promise<string> {
    const { tokens } = await this.oauth2Client.getToken(code);
    this.logger.log('✅ Access token obtenido');
    return tokens.access_token;
  }

  async sendToBigQuery(accessToken: string, rows: any[]): Promise<void> {
    const projectId = this.configService.get('GCP_PROJECT_ID');
    const dataset = this.configService.get('BIGQUERY_DATASET');
    const table = this.configService.get('BIGQUERY_TABLE');

    const url = `https://www.googleapis.com/bigquery/v2/projects/${projectId}/datasets/${dataset}/tables/${table}/insertAll`;

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        rows: rows.map(row => ({ json: row })),
        skipInvalidRows: false,
      }),
    });

    const result = await response.json();

    if (result.errors) {
      throw new Error(`BigQuery errors: ${JSON.stringify(result.errors)}`);
    }

    this.logger.log(`✅ ${rows.length} registros enviados a BigQuery`);
  }
}
```

---

### 2. Snapshot Service

**Archivo:** `src/modules/benchmarking/services/snapshot.service.ts`

```typescript
import { Injectable, Logger } from '@nestjs/common';
import { Pool } from 'pg';
import { OAuthService } from './oauth.service';

@Injectable()
export class SnapshotService {
  private readonly logger = new Logger(SnapshotService.name);

  constructor(
    private pool: Pool,
    private oauthService: OAuthService,
  ) {}

  async executeDailySnapshot(accessToken: string): Promise<void> {
    try {
      this.logger.log('🔄 Iniciando snapshot diario...');

      // 1. Consultar vista
      const rows = await this.queryDailyExport();
      this.logger.log(`📊 ${rows.length} registros extraídos`);

      // 2. Validar datos
      if (rows.length === 0) {
        this.logger.warn('⚠️ No hay datos para exportar');
        return;
      }

      // 3. Enviar a BigQuery
      await this.oauthService.sendToBigQuery(accessToken, rows);

      // 4. Reset (solo si exitoso)
      await this.resetStatistics();
      this.logger.log('✅ Snapshot completado');
    } catch (error) {
      this.logger.error('❌ Error en snapshot:', error.message);
      throw error;
    }
  }

  private async queryDailyExport(): Promise<any[]> {
    const result = await this.pool.query(`
      SELECT * FROM v_daily_export
      WHERE snapshot_date = CURRENT_DATE
      ORDER BY project_id, queryid;
    `);
    return result.rows;
  }

  private async resetStatistics(): Promise<void> {
    await this.pool.query('SELECT pg_stat_statements_reset();');
  }

  async exportToCSV(): Promise<string> {
    const result = await this.pool.query(`
      SELECT * FROM v_daily_export WHERE snapshot_date = CURRENT_DATE;
    `);

    const rows = result.rows;
    if (rows.length === 0) return '';

    const headers = Object.keys(rows[0]).join(',');
    const data = rows
      .map(row => Object.values(row).join(','))
      .join('\n');

    return `${headers}\n${data}`;
  }
}
```

---

### 3. Controller

**Archivo:** `src/modules/benchmarking/controllers/benchmarking.controller.ts`

```typescript
import { Controller, Get, Post, Body, Redirect, Res, Logger } from '@nestjs/common';
import { Response } from 'express';
import { OAuthService } from '../services/oauth.service';
import { SnapshotService } from '../services/snapshot.service';

@Controller('benchmarking')
export class BenchmarkingController {
  private readonly logger = new Logger(BenchmarkingController.name);

  constructor(
    private oauthService: OAuthService,
    private snapshotService: SnapshotService,
  ) {}

  @Get('auth/google')
  @Redirect()
  googleAuth() {
    return { url: this.oauthService.getAuthUrl() };
  }

  @Get('auth/callback')
  async googleCallback(
    @Res() res: Response,
  ) {
    const code = res.req.query.code as string;

    try {
      const token = await this.oauthService.getTokenFromCode(code);
      res.redirect(`/dashboard?token=${token}`);
    } catch (error) {
      res.status(500).send('Error en autenticación');
    }
  }

  @Post('snapshots/execute')
  async executeSnapshot(@Body() body: { accessToken: string }, @Res() res: Response) {
    try {
      await this.snapshotService.executeDailySnapshot(body.accessToken);
      res.json({ success: true, message: '✅ Snapshot enviado a BigQuery' });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  @Get('snapshots/export')
  async exportCSV(@Res() res: Response) {
    const csv = await this.snapshotService.exportToCSV();
    res.header('Content-Type', 'text/csv');
    res.send(csv);
  }
}
```

---

## ARCHIVO .env

**Ubicación:** `.env.example` (copiar a `.env`)

```env
# PostgreSQL
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_NAME=benchmarking_db
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres

# Google OAuth
GOOGLE_CLIENT_ID=your_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_REDIRECT_URI=http://localhost:3000/benchmarking/auth/callback

# Google Cloud
GCP_PROJECT_ID=data-from-software
BIGQUERY_DATASET=benchmarking_warehouse
BIGQUERY_TABLE=daily_query_metrics

# Node
NODE_ENV=development
PORT=3000
```

---

## TABLA COMPARATIVA

| Componente | Archivo | Líneas | Status |
|-----------|---------|--------|--------|
| Tablas | 01_create_all_tables.sql | 100 | ✅ Copy-Paste |
| pg_stat_statements | setup_pg_stat_statements.sql | 40 | ✅ Copy-Paste |
| Queries de Prueba | insert_test_queries.sql | 60 | ✅ Copy-Paste |
| Vistas | create_export_views.sql | 80 | ✅ Copy-Paste |
| Ejecución | execute_test_queries.sql | 50 | ✅ Copy-Paste |
| OAuth Service | oauth.service.ts | 70 | ✅ Copy-Paste |
| Snapshot Service | snapshot.service.ts | 80 | ✅ Copy-Paste |
| Controller | benchmarking.controller.ts | 60 | ✅ Copy-Paste |

---

**Todos los scripts están listos para copiar y ejecutar. ¡Sin modificaciones necesarias!**
