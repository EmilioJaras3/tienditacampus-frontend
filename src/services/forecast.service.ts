import { api } from './api';

export interface ForecastResponse {
    productId: string;
    dayOfWeek: number;
    recommendedQuantity: number;
}

export const forecastService = {
    /**
     * Obtener predicción de demanda de ventas basada en el modelo IQR
     * @param productId ID del producto a analizar
     * @param dayOfWeek Día de la semana (1 = Lunes, 7 = Domingo)
     */
    async getForecast(productId: string, dayOfWeek: number): Promise<number> {
        const response = await api.get<ForecastResponse>(`/forecast/${productId}/day/${dayOfWeek}`);
        return response.recommendedQuantity;
    }
};
