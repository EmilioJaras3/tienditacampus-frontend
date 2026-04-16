import { api } from './api';

export interface RoiStats {
    investment: number;
    revenue: number;
    netProfit: number;
    roi: number;
}

export interface SaleDetail {
    id: string;
    productId: string;
    quantityPrepared: number;
    quantitySold: number;
    quantityLost: number;
    unitPrice: number;
    product: {
        id: string;
        name: string;
    };
    wasteReason?: 'expired' | 'damaged' | 'other' | null;
    wasteCost?: number;
}

export interface DailySale {
    id: string;
    saleDate: string;
    totalRevenue: number | string;
    totalInvestment: number | string;
    unitsSold: number;
    unitsLost: number;
    totalWasteCost?: number;
    breakEvenUnits?: number | null;
    isClosed: boolean;
    details: SaleDetail[];
}

export interface WeekdayAnalyticsItem {
    weekday: number;
    weekdayName: string;
    daysCount: number;
    revenueSum: string;
    unitsSoldSum: number;
    revenueAvg: string;
}

export interface PrepareSaleItem {
    productId: string;
    quantityPrepared: number;
}

export interface UnifiedPrediction {
    productId: string;
    productName: string | null;
    dayOfWeek: number;
    recommendedQuantity: number;
    sampleSize: number;
    outliersRemoved: number;
    confidenceInterval: [number, number] | null;
    hasSufficientData: boolean;
    message: string;
    source: 'iqr';
    scope: 'personal' | 'public-demo';
}

export interface UserPredictionSummary {
    dayOfWeek: number;
    suggestions: UnifiedPrediction[];
    hasSufficientData: boolean;
    message: string;
}

export const salesService = {
    async getRoiStats(): Promise<RoiStats> {
        return api.get<RoiStats>('/sales/roi');
    },

    async getHistory(): Promise<DailySale[]> {
        const response = await api.get<{ data: DailySale[]; total: number; page: number; limit: number }>('/sales/history');
        return response.data;
    },

    async getToday(): Promise<any> {
        return api.get<any>('/sales/today');
    },

    async getPrediction(): Promise<UserPredictionSummary> {
        return api.get<UserPredictionSummary>('/sales/prediction');
    },

    async getWeekdayAnalytics(): Promise<WeekdayAnalyticsItem[]> {
        return api.get<WeekdayAnalyticsItem[]>('/sales/analytics/by-weekday');
    },

    async prepareDay(items: PrepareSaleItem[]): Promise<DailySale> {
        return api.post<DailySale>('/sales/prepare', { items });
    },

    async trackProduct(productId: string, sold: number, lost: number): Promise<DailySale> {
        return api.post<DailySale>('/sales/track', { productId, quantitySold: sold, quantityLost: lost });
    },

    async closeDay(items: { productId: string; waste: number; wasteReason?: 'expired' | 'damaged' | 'other' }[]): Promise<void> {
        return api.post('/sales/close-day', { items });
    },
};
