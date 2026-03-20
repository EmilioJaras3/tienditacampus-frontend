import { api } from './api';

export interface AuditLog {
    id: string;
    action: string;
    description: string;
    userId: string;
    userName: string;
    createdAt: string;
    type: 'success' | 'warning' | 'error' | 'info';
}

export const auditService = {
    async getLogs(): Promise<AuditLog[]> {
        return api.get<AuditLog[]>('/audit/recent');
    }
};
