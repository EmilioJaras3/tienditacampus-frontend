import { api } from './api';
import { useAuthStore } from '../store/auth.store';

// ── Tipos ─────────────────────────────────────────────

export interface LoginDto {
    email: string;
    password?: string;
}

export interface RegisterDto {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
    phone?: string;
    role?: 'seller' | 'buyer';
}

export interface User {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: 'admin' | 'seller' | 'buyer';
    major?: string;
    campusLocation?: string;
    lastLoginAt?: string;
    loginCount?: number;
}

export interface AuthResponse {
    user: User;
    accessToken: string;
}

// Respuesta del login cuando 2FA está habilitado
export interface LoginResponse {
    user: User;
    accessToken?: string;
    requiresTwoFactor?: boolean;
}

export interface Verify2FADto {
    email: string;
    code: string;
}

export interface UserProfile extends User {
    phone?: string;
    avatarUrl?: string;
    isEmailVerified: boolean;
    createdAt: string;
}

// ── Servicio ──────────────────────────────────────────

export const authService = {
    /**
     * Iniciar sesión - puede requerir 2FA
     */
    async login(credentials: LoginDto): Promise<LoginResponse> {
        const response = await api.post<LoginResponse>('/auth/login', credentials, {
            requiresAuth: false,
        });

        // Si NO requiere 2FA, guardar token directamente
        if (!response.requiresTwoFactor && response.accessToken) {
            useAuthStore.getState().login(response.accessToken, response.user);
        }

        return response;
    },

    /**
     * Verificar código 2FA y completar login
     */
    async verify2FA(data: Verify2FADto): Promise<AuthResponse> {
        const response = await api.post<AuthResponse>('/auth/verify-2fa', data, {
            requiresAuth: false,
        });

        // Guardar token tras verificación exitosa
        useAuthStore.getState().login(response.accessToken, response.user);

        return response;
    },

    /**
     * Reenviar código 2FA
     */
    async resend2FA(email: string): Promise<void> {
        await api.post('/auth/resend-2fa', { email }, {
            requiresAuth: false,
        });
    },

    /**
     * Iniciar sesión / Registro Automático con Google OAuth2
     */
    async loginWithGoogle(token: string): Promise<AuthResponse> {
        const response = await api.post<AuthResponse>('/auth/google', { token }, {
            requiresAuth: false,
        });

        // Guardar en store
        useAuthStore.getState().login(response.accessToken, response.user);

        return response;
    },

    /**
     * Registrarse y guardar estado (auto-login)
     */
    async register(data: RegisterDto): Promise<AuthResponse> {
        const response = await api.post<AuthResponse>('/auth/register', data, {
            requiresAuth: false,
        });

        // Guardar en store
        useAuthStore.getState().login(response.accessToken, response.user);

        return response;
    },

    /**
     * Obtener perfil del usuario actual
     */
    async getProfile(): Promise<UserProfile> {
        const user = await api.get<UserProfile>('/auth/profile');

        // Actualizar usuario en store
        useAuthStore.getState().updateUser(user);

        return user;
    },

    /**
     * Cerrar sesión
     */
    logout() {
        useAuthStore.getState().logout();
    },
};
