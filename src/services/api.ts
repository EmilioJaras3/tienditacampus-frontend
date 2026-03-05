// Cliente HTTP centralizado para el backend

import { useAuthStore } from '../store/auth.store';

// Validación de URL base
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL;

if (!API_BASE_URL && process.env.NODE_ENV === 'production') {
    throw new Error('CRITICAL: NEXT_PUBLIC_API_URL is not defined in production environment.');
}

const BASE_URL = API_BASE_URL || 'http://localhost:3001/api';

// Error personalizado de API
export class ApiError extends Error {
    public status: number;
    public data: any;

    constructor(status: number, message: string, data?: any) {
        super(message);
        this.name = 'ApiError';
        this.status = status;
        this.data = data;
    }
}

interface RequestOptions extends RequestInit {
    params?: Record<string, string>;
    requiresAuth?: boolean;
}

class ApiClient {
    private baseUrl: string;

    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }

    private async request<T>(
        endpoint: string,
        options: RequestOptions = {},
    ): Promise<T> {
        const { params, requiresAuth = true, ...fetchOptions } = options;

        let url = `${this.baseUrl}${endpoint}`;
        if (params) {
            const searchParams = new URLSearchParams(params);
            url += `?${searchParams.toString()}`;
        }

        // Headers con JSON por defecto
        const headers: Record<string, string> = {
            'Content-Type': 'application/json',
            ...(fetchOptions.headers as Record<string, string>),
        };

        // Inyectar token JWT si no hay uno explícito
        if (requiresAuth && !headers['Authorization']) {
            const token = useAuthStore.getState().token;
            if (token) {
                headers['Authorization'] = `Bearer ${token}`;
            }
        }

        try {
            const response = await fetch(url, {
                ...fetchOptions,
                headers,
            });

            // Si la sesión expiró (401)
            if (response.status === 401) {
                useAuthStore.getState().logout();
                throw new ApiError(401, 'Sesión expirada. Por favor, inicia sesión nuevamente.');
            }

            // Manejo de errores 4xx/5xx
            if (!response.ok) {
                let errorMessage = `API Error: ${response.status} ${response.statusText}`;
                let errorData = null;

                try {
                    errorData = await response.json();
                    if (errorData && errorData.message) {
                        errorMessage = Array.isArray(errorData.message)
                            ? errorData.message.join(', ')
                            : errorData.message;
                    }
                } catch (e) {
                    // Si no es JSON, nos quedamos con el mensaje genérico
                }

                throw new ApiError(response.status, errorMessage, errorData);
            }

            // Procesar respuesta exitosa
            if (response.status === 204) {
                return {} as T;
            }

            const text = await response.text();
            if (!text || text.length === 0) {
                return null as T;
            }

            try {
                return JSON.parse(text);
            } catch {
                return text as unknown as T;
            }

        } catch (error) {
            if (error instanceof ApiError) {
                throw error;
            }
            // Error de red o algo inesperado en el fetch
            throw new ApiError(500, error instanceof Error ? error.message : 'Error desconocido de red');
        }
    }

    get<T>(endpoint: string, options?: RequestOptions) {
        return this.request<T>(endpoint, { ...options, method: 'GET' });
    }

    post<T>(endpoint: string, data?: unknown, options?: RequestOptions) {
        return this.request<T>(endpoint, {
            ...options,
            method: 'POST',
            body: JSON.stringify(data),
        });
    }

    put<T>(endpoint: string, data?: unknown, options?: RequestOptions) {
        return this.request<T>(endpoint, {
            ...options,
            method: 'PUT',
            body: JSON.stringify(data),
        });
    }

    patch<T>(endpoint: string, data?: unknown, options?: RequestOptions) {
        return this.request<T>(endpoint, {
            ...options,
            method: 'PATCH',
            body: JSON.stringify(data),
        });
    }

    delete<T>(endpoint: string, options?: RequestOptions) {
        return this.request<T>(endpoint, { ...options, method: 'DELETE' });
    }
}

export const api = new ApiClient(BASE_URL);
