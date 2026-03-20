'use client';

import { useState, useEffect } from 'react';
import { 
    ShieldCheck, 
    Search, 
    Filter, 
    Clock, 
    User, 
    Activity, 
    FileText,
    Download,
    RefreshCw,
    AlertCircle,
    CheckCircle2,
    Loader2
} from 'lucide-react';
import { toast } from 'sonner';

// Simulating audit service fetch since we need to confirm the exact endpoint
// but based on controllers, it should be something like this:
import { auditService, AuditLog } from '@/services/audit.service';

export default function AuditPage() {
    const [logs, setLogs] = useState<AuditLog[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchQuery, setSearchQuery] = useState('');

    useEffect(() => {
        loadLogs();
    }, []);

    const loadLogs = async () => {
        try {
            setLoading(true);
            const data = await auditService.getLogs();
            setLogs(data);
        } catch (error) {
            console.error(error);
            toast.error('Error al cargar logs de auditoría');
        } finally {
            setLoading(false);
        }
    };

    const filteredLogs = logs.filter(log => 
        log.action.toLowerCase().includes(searchQuery.toLowerCase()) ||
        log.userName.toLowerCase().includes(searchQuery.toLowerCase()) ||
        log.description.toLowerCase().includes(searchQuery.toLowerCase())
    );

    const getTypeColor = (type: AuditLog['type']) => {
        switch (type) {
            case 'success': return 'text-primary';
            case 'error': return 'text-destructive';
            case 'warning': return 'text-primary/70';
            default: return 'text-muted-foreground';
        }
    };

    const getTypeIcon = (type: AuditLog['type']) => {
        switch (type) {
            case 'success': return <CheckCircle2 size={16} />;
            case 'error': return <AlertCircle size={16} />;
            case 'warning': return <AlertCircle size={16} />;
            default: return <Activity size={16} />;
        }
    };

    return (
        <div className="p-4 md:p-10 space-y-12 font-display min-h-screen bg-background selection:bg-primary/20 pb-24">
            {/* Header */}
            <div className="flex flex-col lg:flex-row lg:items-end justify-between gap-6 border-b-4 border-foreground/10 pb-8">
                <div className="space-y-2">
                    <div className="inline-block bg-primary text-primary-foreground border border-primary/10 px-3 py-1 font-semibold text-xs tracking-widest shadow-neo-sm transform -rotate-1 mb-2 rounded-sm">
                        SISTEMA DE SEGURIDAD
                    </div>
                    <h1 className="text-5xl md:text-7xl font-semibold tracking-tighter leading-none text-foreground uppercase italic">
                        AUDITORÍA <span className="text-primary italic">CMS</span>
                    </h1>
                    <p className="text-lg font-bold text-muted-foreground uppercase tracking-tight max-w-md border-l-4 border-foreground pl-4">
                        Historial completo de acciones y movimientos del sistema.
                    </p>
                </div>
                <div className="flex gap-4">
                    <button 
                        onClick={loadLogs}
                        className="flex items-center gap-3 px-6 h-14 bg-card border border-foreground/10 font-bold text-xs tracking-widest uppercase hover:bg-muted transition-all rounded-xl shadow-neo-sm"
                    >
                        <RefreshCw size={18} className={loading ? 'animate-spin' : ''} /> RECARGAR
                    </button>
                    <button className="flex items-center gap-3 px-6 h-14 bg-foreground text-background border border-foreground/10 font-bold text-xs tracking-widest uppercase hover:opacity-90 transition-all rounded-xl shadow-neo">
                        <Download size={18} /> EXPORTAR
                    </button>
                </div>
            </div>

            {/* Content Table */}
            <div className="bg-card border border-foreground/10 shadow-neo-sm rounded-[3rem] overflow-hidden">
                <div className="p-8 border-b border-foreground/5 flex flex-col md:flex-row gap-6 items-center justify-between">
                    <h3 className="text-2xl font-bold tracking-tighter uppercase italic flex items-center gap-3">
                        <FileText className="text-primary" /> Historial de Logs
                    </h3>
                    <div className="relative w-full md:w-96 group">
                        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground group-focus-within:text-primary transition-colors" size={18} />
                        <input 
                            type="text"
                            placeholder="Buscar por usuario o acción..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full h-12 pl-12 pr-4 bg-muted/30 border border-foreground/5 font-bold text-xs uppercase focus:outline-none focus:bg-primary/5 focus:border-primary/20 transition-all rounded-xl"
                        />
                    </div>
                </div>

                <div className="overflow-x-auto">
                    {loading ? (
                        <div className="py-32 flex flex-col items-center justify-center gap-4 text-muted-foreground">
                            <Loader2 className="animate-spin text-primary" size={48} />
                            <p className="font-bold text-[10px] tracking-[0.2em] uppercase italic">Analizando registros de seguridad...</p>
                        </div>
                    ) : filteredLogs.length === 0 ? (
                        <div className="py-32 text-center text-muted-foreground font-bold uppercase italic tracking-widest">
                            No se encontraron registros coincidentes.
                        </div>
                    ) : (
                        <table className="w-full text-left">
                            <thead className="bg-muted/50 text-muted-foreground text-[10px] font-bold uppercase tracking-[0.2em]">
                                <tr>
                                    <th className="px-8 py-4">Status</th>
                                    <th className="px-8 py-4">Usuario</th>
                                    <th className="px-8 py-4">Acción</th>
                                    <th className="px-8 py-4">Descripción</th>
                                    <th className="px-8 py-4">Fecha</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-foreground/5">
                                {filteredLogs.map((log) => (
                                    <tr key={log.id} className="hover:bg-muted/30 transition-colors group">
                                        <td className="px-8 py-6">
                                            <div className={`flex items-center gap-2 font-bold text-[10px] uppercase italic ${getTypeColor(log.type)}`}>
                                                {getTypeIcon(log.type)} {log.type}
                                            </div>
                                        </td>
                                        <td className="px-8 py-6">
                                            <div className="flex items-center gap-3">
                                                <div className="w-8 h-8 bg-foreground text-background flex items-center justify-center font-bold text-xs uppercase rounded-lg group-hover:rotate-6 transition-transform">
                                                    {log.userName.charAt(0)}
                                                </div>
                                                <div className="font-bold text-sm tracking-tighter uppercase italic">{log.userName}</div>
                                            </div>
                                        </td>
                                        <td className="px-8 py-6">
                                            <span className="bg-muted px-3 py-1 border border-foreground/5 font-bold text-[9px] uppercase tracking-widest rounded-full">
                                                {log.action}
                                            </span>
                                        </td>
                                        <td className="px-8 py-6">
                                            <p className="text-xs font-bold text-muted-foreground group-hover:text-foreground transition-colors max-w-xs">{log.description}</p>
                                        </td>
                                        <td className="px-8 py-6">
                                            <div className="flex flex-col">
                                                <span className="text-[10px] font-bold uppercase italic text-foreground tracking-tighter flex items-center gap-2">
                                                    <Clock size={12} className="text-primary" /> {new Date(log.createdAt).toLocaleTimeString()}
                                                </span>
                                                <span className="text-[9px] font-bold text-muted-foreground uppercase tracking-widest mt-1">
                                                    {new Date(log.createdAt).toLocaleDateString()}
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    )}
                </div>
                
                <div className="p-8 bg-muted/20 border-t border-foreground/5 flex items-center justify-between">
                    <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest italic">
                        Mostrando {filteredLogs.length} de {logs.length} registros totales.
                    </p>
                    <div className="flex items-center gap-3 text-primary font-bold text-[9px] uppercase tracking-[0.3em] italic">
                        <ShieldCheck size={16} /> Sistema Protegido por CampusGuard
                    </div>
                </div>
            </div>
        </div>
    );
}
