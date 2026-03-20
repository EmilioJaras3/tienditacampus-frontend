import { api } from './api';

export interface BenchmarkingProject {
    project_id: number;
}

export interface QueryMetric {
    id: string;
    query: string;
    calls: number;
    total_time_ms: number;
    avg_time_ms: number;
    rows_returned: number;
    shared_blks_hit: number;
    shared_blks_read: number;
}

export const benchmarkingService = {
    /**
     * Envía el snapshot diario a BigQuery.
     * @param googleToken El token de acceso obtenido de Google OAuth.
     */
    async sendSnapshot(googleToken: string) {
        return api.post('/benchmarking/snapshot', {}, {
            headers: {
                'x-google-token': googleToken
            }
        });
    },

    /**
     * Envía el snapshot histórico (ej. 30 días) a BigQuery.
     * @param googleToken El token de acceso obtenido de Google OAuth.
     * @param days Días a enviar (por defecto 30).
     */
    async sendHistoricalSnapshot(googleToken: string, days: number = 30) {
        return api.post('/benchmarking/snapshot/historical', { days }, {
            headers: {
                'x-google-token': googleToken
            }
        });
    },

    /**
     * Ejecuta las consultas registradas para estresar la BD y generar métricas.
     */
    async runQueries() {
        return api.post('/benchmarking/run-queries', {});
    },

    /**
     * Obtiene información del proyecto actual.
     */
    async getProject(): Promise<BenchmarkingProject> {
        return api.get<BenchmarkingProject>('/benchmarking/project');
    },

    /**
     * Obtiene métricas reales de pg_stat_statements.
     */
    async getMetrics(limit = 20): Promise<QueryMetric[]> {
        return api.get<QueryMetric[]>(`/benchmarking/metrics?limit=${limit}`);
    },

    /**
     * Verifica cuántos registros existen en BigQuery para el proyecto actual.
     */
    async verifyStatus(googleToken: string) {
        return api.post('/benchmarking/verify-status', {}, {
            headers: {
                'x-google-token': googleToken
            }
        });
    }
};
