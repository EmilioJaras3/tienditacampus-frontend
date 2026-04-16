import { api } from './api';

export interface ForecastResponse {
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

export const forecastService = {
    async getForecast(productId: string, dayOfWeek: number): Promise<ForecastResponse> {
        return api.get<ForecastResponse>(`/forecast/${productId}/day/${dayOfWeek}`);
    },

    async getDemoForecast(productId: string, dayOfWeek: number): Promise<ForecastResponse> {
        return api.get<ForecastResponse>(`/forecast/demo/${productId}/day/${dayOfWeek}`, {
            requiresAuth: false,
        });
    }
};
