import { api } from './api';

export interface AuditLog {
    id: string;
    action: string;
    description?: string;
    userId: string;
    entityType?: string;
    entityId?: string;
    level: 'info' | 'warn' | 'error' | 'debug';
    metadata: Record<string, any>;
    ipAddress?: string;
    createdAt: string;
    user?: {
        firstName: string;
        lastName: string;
        email: string;
    };
}

export const auditService = {
    async getRecent(limit = 50): Promise<AuditLog[]> {
        return api.get<AuditLog[]>(`/audit/recent?limit=${limit}`);
    },

    async searchByMetadata(key: string, value: string): Promise<AuditLog[]> {
        return api.get<AuditLog[]>(`/audit/search?key=${key}&value=${value}`);
    },

    async getMyActivity(): Promise<AuditLog[]> {
        return api.get<AuditLog[]>('/audit/my-activity');
    }
};

