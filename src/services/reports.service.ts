import { api } from './api';

export interface WeeklyReport {
    id: string;
    weekStart: string;
    weekEnd: string;
    totalInvestment: number;
    totalRevenue: number;
    totalProfit: number;
    avgProfitMargin: number;
    totalWasteCost: number;
    totalUnitsSold: number;
    totalUnitsLost: number;
    lossPercentage: number;
    createdAt: string;
    bestSellingProduct?: {
        id: string;
        name: string;
    } | null;
}

export const reportsService = {
    /**
     * Obtiene el historial de reportes semanales del vendedor.
     */
    async getWeeklyReports(): Promise<WeeklyReport[]> {
        return api.get<WeeklyReport[]>('/reports/weekly');
    },

    /**
     * Genera un nuevo reporte semanal basado en los cierres de caja.
     */
    async generateWeekly(): Promise<WeeklyReport> {
        return api.post<WeeklyReport>('/reports/weekly/generate', {});
    },

    /**
     * Elimina un reporte histórico.
     */
    async deleteReport(id: string): Promise<void> {
        return api.delete(`/reports/weekly/${id}`);
    },

    /**
     * Obtiene un reporte específico por ID.
     */
    async getReportById(id: string): Promise<WeeklyReport> {
        return api.get<WeeklyReport>(`/reports/weekly/${id}`);
    }
};
