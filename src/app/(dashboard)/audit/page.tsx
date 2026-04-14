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
    Loader2,
    Eye,
    Database,
    Globe,
    Terminal
} from 'lucide-react';
import { toast } from 'sonner';
import { auditService, AuditLog } from '@/services/audit.service';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';

export default function AuditPage() {
    const [logs, setLogs] = useState<AuditLog[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedLog, setSelectedLog] = useState<AuditLog | null>(null);

    useEffect(() => {
        loadLogs();
    }, []);

    const loadLogs = async () => {
        try {
            setLoading(true);
            const data = await auditService.getRecent(100);
            setLogs(data);
        } catch (error) {
            console.error(error);
            toast.error('Error al cargar logs de auditoría');
        } finally {
            setLoading(false);
        }
    };

    const filteredLogs = logs.filter(log => {
        const userName = log.user ? `${log.user.firstName} ${log.user.lastName}` : 'Sistema';
        return (
            log.action.toLowerCase().includes(searchQuery.toLowerCase()) ||
            userName.toLowerCase().includes(searchQuery.toLowerCase()) ||
            (log.description && log.description.toLowerCase().includes(searchQuery.toLowerCase()))
        );
    });

    const getLevelConfig = (level: AuditLog['level']) => {
        switch (level) {
            case 'info': return { color: 'text-blue-500 bg-blue-500/10', icon: <Activity size={14} /> };
            case 'warn': return { color: 'text-amber-500 bg-amber-500/10', icon: <AlertCircle size={14} /> };
            case 'error': return { color: 'text-rose-500 bg-rose-500/10', icon: <AlertCircle size={14} /> };
            case 'debug': return { color: 'text-purple-500 bg-purple-500/10', icon: <Terminal size={14} /> };
            default: return { color: 'text-muted-foreground bg-muted/10', icon: <Activity size={14} /> };
        }
    };

    return (
        <div className="p-4 md:p-8 space-y-8 font-sans min-h-screen bg-background/50 backdrop-blur-3xl selection:bg-primary/20 pb-24">
            {/* Header Section */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div className="space-y-1">
                    <div className="flex items-center gap-2 text-primary font-bold text-[10px] tracking-[0.2em] uppercase">
                        <ShieldCheck size={14} className="animate-pulse" /> Seguridad & Vigilancia
                    </div>
                    <h1 className="text-4xl font-extrabold tracking-tight text-foreground sm:text-5xl">
                        Auditoría de <span className="bg-clip-text text-transparent bg-gradient-to-r from-primary to-primary/60">Sistema</span>
                    </h1>
                    <p className="text-muted-foreground text-sm font-medium"> Monitoreo en tiempo real de toda la actividad de TienditaCampus. </p>
                </div>

                <div className="flex items-center gap-3">
                    <button 
                        onClick={loadLogs}
                        disabled={loading}
                        className="flex items-center gap-2 px-4 py-2.5 bg-card border border-border hover:bg-muted/50 transition-all rounded-xl text-sm font-semibold shadow-sm disabled:opacity-50"
                    >
                        <RefreshCw size={16} className={loading ? 'animate-spin' : ''} /> Actualizar
                    </button>
                    <button className="flex items-center gap-2 px-4 py-2.5 bg-primary text-primary-foreground hover:opacity-90 transition-all rounded-xl text-sm font-semibold shadow-md shadow-primary/20">
                        <Download size={16} /> Exportar Reporte
                    </button>
                </div>
            </div>

            {/* Stats Summary (Mini) */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                {[
                    { label: 'Eventos Hoy', value: logs.length, icon: <Activity className="text-blue-500" /> },
                    { label: 'Usuarios Activos', value: [...new Set(logs.map(l => l.userId))].length, icon: <User className="text-purple-500" /> },
                    { label: 'Entidades', value: [...new Set(logs.map(l => l.entityType))].length - (logs.some(l => !l.entityType) ? 1 : 0), icon: <Database className="text-amber-500" /> },
                    { label: 'Estado', value: 'Sincronizado', icon: <Globe className="text-green-500" /> },
                ].map((stat, i) => (
                    <div key={i} className="p-4 bg-card/40 border border-border/50 rounded-2xl flex items-center gap-4 hover:border-primary/20 transition-colors">
                        <div className="p-2.5 bg-background rounded-xl shadow-inner">{stat.icon}</div>
                        <div>
                            <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest leading-none mb-1">{stat.label}</p>
                            <p className="text-xl font-bold tracking-tight">{stat.value}</p>
                        </div>
                    </div>
                ))}
            </div>

            {/* Main Log Viewer */}
            <div className="bg-card border border-border shadow-xl shadow-foreground/5 rounded-3xl overflow-hidden">
                {/* Table Filters */}
                <div className="p-6 border-b border-border flex flex-col md:flex-row gap-4 items-center justify-between bg-muted/10">
                    <div className="relative w-full md:w-96 group">
                        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground group-focus-within:text-primary transition-colors" size={16} />
                        <input 
                            type="text"
                            placeholder="Buscar acción, descripción o usuario..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full h-11 pl-11 pr-4 bg-background border border-border font-medium text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary/40 transition-all rounded-xl"
                        />
                    </div>
                    <div className="flex items-center gap-2">
                         <span className="text-xs font-bold text-muted-foreground uppercase mr-2 tracking-widest">Ver:</span>
                         <div className="flex bg-background border border-border p-1 rounded-lg">
                            {['Todo', 'Error', 'Warn', 'Info'].map((f) => (
                                <button key={f} className={`px-3 py-1.5 rounded-md text-[10px] font-bold uppercase tracking-tight transition-all ${f === 'Todo' ? 'bg-primary text-primary-foreground shadow-sm' : 'hover:bg-muted'}`}>
                                    {f}
                                </button>
                            ))}
                         </div>
                    </div>
                </div>

                {/* Table */}
                <div className="overflow-x-auto">
                    {loading ? (
                        <div className="py-32 flex flex-col items-center justify-center gap-4 text-muted-foreground">
                            <div className="relative">
                                <Loader2 className="animate-spin text-primary" size={48} />
                                <ShieldCheck className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-primary/40" size={24} />
                            </div>
                            <p className="font-bold text-xs uppercase tracking-widest animate-pulse">Analizando registros de seguridad en tiempo real...</p>
                        </div>
                    ) : filteredLogs.length === 0 ? (
                        <div className="py-32 flex flex-col items-center justify-center text-center px-6">
                            <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mb-4">
                                <Search size={32} className="text-muted-foreground/50" />
                            </div>
                            <h3 className="text-lg font-bold">Sin resultados</h3>
                            <p className="text-muted-foreground text-sm max-w-xs">No encontramos ningún registro que coincida con "{searchQuery}". Intenta con otros términos.</p>
                        </div>
                    ) : (
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="bg-muted/30 text-muted-foreground text-[10px] font-bold uppercase tracking-[0.15em] border-b border-border">
                                    <th className="px-6 py-4">Nivel</th>
                                    <th className="px-6 py-4">Operador</th>
                                    <th className="px-6 py-4">Acción</th>
                                    <th className="px-6 py-4">Entidad</th>
                                    <th className="px-6 py-4">Timestamp</th>
                                    <th className="px-6 py-4 text-right">Detalles</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-border">
                                {filteredLogs.map((log) => {
                                    const config = getLevelConfig(log.level);
                                    const operatorName = log.user ? `${log.user.firstName} ${log.user.lastName}` : 'Sistema Central';
                                    const operatorInitials = log.user ? `${log.user.firstName[0]}${log.user.lastName[0]}` : 'SC';
                                    
                                    return (
                                        <tr key={log.id} className="hover:bg-muted/20 transition-all group">
                                            <td className="px-6 py-5">
                                                <div className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full font-bold text-[9px] uppercase tracking-wider ${config.color}`}>
                                                    {config.icon} {log.level}
                                                </div>
                                            </td>
                                            <td className="px-6 py-5">
                                                <div className="flex items-center gap-3">
                                                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center text-[10px] font-bold shadow-sm border border-border ${log.user ? 'bg-indigo-500 text-white' : 'bg-slate-700 text-white'}`}>
                                                        {operatorInitials}
                                                    </div>
                                                    <div className="flex flex-col">
                                                        <span className="text-xs font-bold leading-none mb-0.5">{operatorName}</span>
                                                        <span className="text-[10px] text-muted-foreground font-medium">{log.ipAddress || 'Interno'}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td className="px-6 py-5">
                                                <div className="flex flex-col">
                                                    <span className="text-xs font-bold text-foreground mb-1">
                                                        {log.action.replace(/_/g, ' ')}
                                                    </span>
                                                    <p className="text-[10px] text-muted-foreground line-clamp-1 max-w-[200px]">
                                                        {log.description || 'Sin descripción adicional'}
                                                    </p>
                                                </div>
                                            </td>
                                            <td className="px-6 py-5">
                                                {log.entityType ? (
                                                    <div className="flex items-center gap-1.5">
                                                        <span className="px-2 py-0.5 bg-muted border border-border rounded-md text-[9px] font-bold text-muted-foreground uppercase tracking-widest">
                                                            {log.entityType}
                                                        </span>
                                                        <span className="text-[9px] font-mono text-muted-foreground opacity-50">#{log.entityId?.slice(-6)}</span>
                                                    </div>
                                                ) : (
                                                    <span className="text-[10px] text-muted-foreground italic">—</span>
                                                )}
                                            </td>
                                            <td className="px-6 py-5">
                                                <div className="flex flex-col">
                                                    <span className="text-[11px] font-bold text-foreground">
                                                        {format(new Date(log.createdAt), 'HH:mm:ss', { locale: es })}
                                                    </span>
                                                    <span className="text-[10px] text-muted-foreground font-medium">
                                                        {format(new Date(log.createdAt), 'dd MMM, yyyy', { locale: es })}
                                                    </span>
                                                </div>
                                            </td>
                                            <td className="px-6 py-5 text-right">
                                                <button 
                                                    onClick={() => setSelectedLog(log)}
                                                    className="p-2 hover:bg-primary/10 hover:text-primary transition-colors rounded-lg text-muted-foreground"
                                                >
                                                    <Eye size={18} />
                                                </button>
                                            </td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    )}
                </div>
                
                <div className="p-6 bg-muted/10 border-t border-border flex items-center justify-between">
                    <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-[0.1em] italic">
                        Mostrando <span className="text-foreground">{filteredLogs.length}</span> registros operativos.
                    </p>
                    <div className="flex items-center gap-4">
                        <div className="flex items-center gap-1.5 text-[10px] font-bold text-green-500 uppercase">
                            <div className="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse" /> Live Feed
                        </div>
                    </div>
                </div>
            </div>

            {/* Selected Log Drawer/Modal (Simplified Overlay) */}
            {selectedLog && (
                <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4" onClick={() => setSelectedLog(null)}>
                    <div className="bg-card border border-border shadow-2xl rounded-3xl w-full max-w-2xl overflow-hidden animate-in fade-in zoom-in duration-200" onClick={e => e.stopPropagation()}>
                        <div className="p-6 border-b border-border bg-muted/30 flex items-center justify-between">
                            <h3 className="text-xl font-bold flex items-center gap-3 italic tracking-tight">
                                <Terminal size={20} className="text-primary" /> Detalles del Evento
                            </h3>
                            <button onClick={() => setSelectedLog(null)} className="p-2 hover:bg-muted rounded-full">
                                <AlertCircle size={20} className="rotate-45" />
                            </button>
                        </div>
                        <div className="p-8 space-y-6">
                            <div className="grid grid-cols-2 gap-8">
                                <div className="space-y-1">
                                    <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest">Operador</p>
                                    <p className="font-bold text-sm">{selectedLog.user ? `${selectedLog.user.firstName} ${selectedLog.user.lastName}` : 'Sistema'}</p>
                                    <p className="text-xs text-muted-foreground">{selectedLog.user?.email || 'Automático'}</p>
                                </div>
                                <div className="space-y-1">
                                    <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest">Acción</p>
                                    <p className="font-bold text-sm text-primary uppercase italic tracking-tight">{selectedLog.action}</p>
                                    <p className="text-xs text-muted-foreground">{format(new Date(selectedLog.createdAt), "PPPP 'a las' HH:mm:ss", { locale: es })}</p>
                                </div>
                            </div>

                            <div className="space-y-2">
                                <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest">Metadata Cruda</p>
                                <div className="bg-muted/50 p-4 rounded-2xl border border-border font-mono text-[11px] overflow-auto max-h-48 shadow-inner">
                                    <pre>{JSON.stringify(selectedLog.metadata, null, 2)}</pre>
                                </div>
                            </div>
                        </div>
                        <div className="p-6 bg-muted/30 border-t border-border flex justify-end">
                            <button onClick={() => setSelectedLog(null)} className="px-6 py-2 bg-foreground text-background font-bold text-xs uppercase tracking-widest rounded-xl hover:opacity-90 transition-all">
                                Cerrar Visor
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}

