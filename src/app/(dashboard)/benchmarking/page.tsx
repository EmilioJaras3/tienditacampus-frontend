'use client';

import { useState, useEffect } from 'react';
import { 
    TrendingUp, 
    Zap, 
    BarChart3, 
    Target, 
    Users, 
    ArrowUpRight, 
    ArrowDownRight,
    RefreshCw,
    Download,
    Star,
    Trophy,
    Loader2,
    Database,
    Send,
    Globe
} from 'lucide-react';
import { benchmarkingService, QueryMetric } from '@/services/benchmarking.service';
import { useAuthStore } from '@/store/auth.store';
import { toast } from 'sonner';
import { useGoogleLogin } from '@react-oauth/google';

export default function BenchmarkingPage() {
    const [loading, setLoading] = useState(true);
    const [sending, setSending] = useState(false);
    const [sendingHistorical, setSendingHistorical] = useState(false);
    const [metrics, setMetrics] = useState<QueryMetric[]>([]);
    const { token, googleToken, setGoogleToken, user } = useAuthStore();

    const isAdmin = user?.email === 'jarassanchezl@gmail.com';

    const googleLogin = useGoogleLogin({
        onSuccess: async (tokenResponse) => {
            setGoogleToken(tokenResponse.access_token);
            toast.success('Cuenta de Google vinculada correctamente para BigQuery');
        },
        onError: () => {
            toast.error('Error al autenticar con Google');
        },
        scope: 'https://www.googleapis.com/auth/bigquery'
    });

    useEffect(() => {
        loadData();
    }, []);

    const loadData = async () => {
        try {
            setLoading(true);
            const data = await benchmarkingService.getMetrics(10);
            setMetrics(data || []);
        } catch (error) {
            console.error(error);
            toast.error('Error al cargar métricas reales de la base de datos');
        } finally {
            setLoading(false);
        }
    };

    const handleSendSnapshot = async () => {
        if (!googleToken) {
            toast.info('Debes vincular tu cuenta de Google para enviar datos a BigQuery');
            googleLogin();
            return;
        }

        try {
            setSending(true);
            await benchmarkingService.sendSnapshot(googleToken);
            toast.success('Snapshot enviado correctamente a BigQuery');
        } catch (error: any) {
            console.error(error);
            // Si el error es de autenticación, limpiamos el token viejo
            if (error?.message?.includes('authentication') || error?.message?.includes('token')) {
                setGoogleToken(null);
                toast.error('Token de Google expirado. Por favor, vincula de nuevo.');
            } else {
                toast.error(error?.message || 'Error al enviar snapshot');
            }
        } finally {
            setSending(false);
        }
    };

    const handleSendHistoricalSnapshot = async () => {
        if (!googleToken) {
            toast.info('Debes vincular tu cuenta de Google para enviar datos a BigQuery');
            googleLogin();
            return;
        }

        try {
            setSendingHistorical(true);
            await benchmarkingService.sendHistoricalSnapshot(googleToken, 30);
            toast.success('Snapshot histórico (30 días) enviado correctamente a BigQuery');
        } catch (error: any) {
            console.error(error);
            if (error?.message?.includes('authentication') || error?.message?.includes('token')) {
                setGoogleToken(null);
                toast.error('Token de Google expirado. Por favor, vincula de nuevo.');
            } else {
                toast.error(error?.message || 'Error al enviar snapshot histórico');
            }
        } finally {
            setSendingHistorical(false);
        }
    };

    const handleDownloadCSV = () => {
        if (metrics.length === 0) {
            toast.error('No hay datos para descargar');
            return;
        }

        const headers = ['Query', 'Llamadas', 'Tiempo Total (ms)', 'Tiempo Promedio (ms)'];
        const csvContent = [
            headers.join(','),
            ...metrics.map(m => [
                `"${m.query.replace(/"/g, '""')}"`,
                m.calls,
                m.total_time_ms,
                m.avg_time_ms
            ].join(','))
        ].join('\n');

        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.setAttribute('href', url);
        link.setAttribute('download', `benchmarking_${new Date().toISOString().split('T')[0]}.csv`);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        toast.success('Métricas descargadas en CSV');
    };

    if (loading) return (
        <div className="h-screen flex items-center justify-center bg-background">
            <div className="flex flex-col items-center gap-4">
                <Loader2 className="animate-spin text-primary" size={64} />
                <p className="font-bold text-[10px] tracking-widest uppercase animate-pulse">Consultando métricas reales...</p>
            </div>
        </div>
    );

    return (
        <div className="p-4 md:p-10 space-y-12 font-display min-h-screen bg-background selection:bg-primary/20 pb-24">
            {/* Admin Instructions Section */}
            {isAdmin && (
                <div className="bg-card border-4 border-primary/20 p-8 rounded-[2rem] shadow-neo-sm space-y-6 relative overflow-hidden">
                    <div className="absolute top-0 right-0 bg-primary text-primary-foreground px-4 py-1 font-bold text-[10px] tracking-widest uppercase rounded-bl-xl shadow-sm">
                        ADMIN ACCESS ONLY
                    </div>
                    
                    <div className="flex items-start gap-6">
                        <div className="w-16 h-16 bg-primary/10 text-primary flex items-center justify-center rounded-2xl shrink-0">
                            <Trophy size={32} />
                        </div>
                        <div className="space-y-4">
                            <div>
                                <h2 className="text-3xl font-bold tracking-tighter uppercase italic text-foreground">
                                    EVALUACIÓN - UNIDAD 2 - <span className="text-primary">BENCHMARKING</span>
                                </h2>
                                <p className="text-sm font-bold text-muted-foreground uppercase tracking-widest">
                                    Docente: Dr. Horacio Irán Solís Cisneros • 100 Puntos
                                </p>
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 text-[11px] font-medium leading-relaxed uppercase tracking-tight text-foreground/80">
                                <div className="space-y-4">
                                    <div className="space-y-2">
                                        <h4 className="font-bold text-primary flex items-center gap-2">
                                            <Target size={14} /> OBJETIVO PRINCIPAL
                                        </h4>
                                        <p>Implementar la estructura de BD descrita, ejecutar pruebas controladas y enviar periódicamente métricas a BigQuery vía OAuth.</p>
                                    </div>
                                    
                                    <div className="space-y-2">
                                        <h4 className="font-bold text-primary flex items-center gap-2">
                                            <Database size={14} /> ESTRUCTURA OBLIGATORIA
                                        </h4>
                                        <p>Tablas: <span className="text-foreground font-bold">PROJECTS, QUERIES, EXECUTIONS</span>. Respetar tipos, CHECKs y llaves. No modificar nombres de columnas.</p>
                                    </div>

                                    <div className="space-y-2">
                                        <h4 className="font-bold text-primary flex items-center gap-2">
                                            <Zap size={14} /> CONFIGURACIÓN POSTGRES
                                        </h4>
                                        <p>Habilitar <code className="bg-muted px-1 rounded text-[10px]">pg_stat_statements</code>. El reset solo se ejecuta si el envío a BigQuery es exitoso.</p>
                                    </div>
                                </div>

                                <div className="space-y-4">
                                    <div className="space-y-2">
                                        <h4 className="font-bold text-primary flex items-center gap-2">
                                            <Send size={14} /> SNAPSHOT DIARIO
                                        </h4>
                                        <p>Consultar vista <span className="text-foreground font-bold">V_DAILY_EXPORT</span>, serializar en JSON y enviar a BigQuery antes de finalizar la sesión.</p>
                                    </div>

                                    <div className="space-y-2">
                                        <h4 className="font-bold text-primary flex items-center gap-2">
                                            <Users size={14} /> AUTENTICACIÓN OAUTH
                                        </h4>
                                        <p>Uso obligatorio de <span className="text-foreground font-bold">ACCESS_TOKEN</span> obtenido vía Google Login. No se permiten envíos manuales o cuentas no registradas.</p>
                                    </div>

                                    <div className="p-4 bg-muted/50 border border-foreground/5 rounded-xl">
                                        <h4 className="font-bold text-foreground text-[10px] mb-2 border-b border-foreground/10 pb-1">FACTORES DE EVALUACIÓN</h4>
                                        <ul className="grid grid-cols-2 gap-x-4 gap-y-1">
                                            <li className="flex items-center gap-1">✓ Modelo Relacional</li>
                                            <li className="flex items-center gap-1">✓ Configuración PG</li>
                                            <li className="flex items-center gap-1">✓ Consistencia de Datos</li>
                                            <li className="flex items-center gap-1">✓ Flujo OAuth</li>
                                            <li className="flex items-center gap-1">✓ Automatización</li>
                                            <li className="flex items-center gap-1">✓ Integridad Exp.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )}

            {/* Header */}
            <div className="flex flex-col lg:flex-row lg:items-end justify-between gap-6 border-b-4 border-foreground/10 pb-8">
                <div className="space-y-2">
                    <div className="inline-block bg-primary text-primary-foreground border border-primary/10 px-3 py-1 font-semibold text-xs tracking-widest shadow-neo-sm transform -rotate-1 mb-2 rounded-sm">
                        BIGQUERY INTEGRATION
                    </div>
                    <h1 className="text-5xl md:text-7xl font-semibold tracking-tighter leading-none text-foreground uppercase italic">
                        BENCHMARKING <span className="text-primary italic">DATA</span>
                    </h1>
                    <p className="text-lg font-bold text-muted-foreground uppercase tracking-tight max-w-md border-l-4 border-foreground pl-4">
                        Analiza el rendimiento de tus consultas y envía snapshots.
                    </p>
                </div>
                <div className="flex gap-4">
                    <button 
                        onClick={loadData}
                        className="flex items-center gap-3 px-6 h-14 bg-card border border-foreground/10 font-bold text-xs tracking-widest uppercase hover:bg-muted transition-all rounded-xl shadow-neo-sm"
                    >
                        <RefreshCw size={18} /> ACTUALIZAR
                    </button>
                    <button 
                        onClick={handleDownloadCSV}
                        className="flex items-center gap-3 px-6 h-14 bg-card border border-foreground/10 font-bold text-xs tracking-widest uppercase hover:bg-muted transition-all rounded-xl shadow-neo-sm"
                    >
                        <Download size={18} /> EXPORTAR
                    </button>
                    <button 
                        onClick={handleSendHistoricalSnapshot}
                        disabled={sendingHistorical || sending}
                        className="flex items-center gap-3 px-8 h-14 bg-foreground text-background border border-foreground/20 font-bold text-xs tracking-widest uppercase hover:opacity-90 transition-all rounded-xl shadow-neo disabled:opacity-50"
                    >
                        {sendingHistorical ? <Loader2 className="animate-spin" size={18} /> : <Database size={18} />}
                        ENVIAR HISTÓRICO (30D)
                    </button>
                    <button 
                        onClick={handleSendSnapshot}
                        disabled={sending || sendingHistorical}
                        className="flex items-center gap-3 px-8 h-14 bg-primary text-primary-foreground border border-primary/20 font-bold text-xs tracking-widest uppercase hover:opacity-90 transition-all rounded-xl shadow-neo disabled:opacity-50"
                    >
                        {sending ? <Loader2 className="animate-spin" size={18} /> : <Send size={18} />}
                        ENVIAR SNAPSHOT DIARIO
                    </button>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-10">
                {/* Real Metrics Table */}
                <div className="lg:col-span-2 bg-card border border-foreground/10 shadow-neo-sm rounded-[3rem] overflow-hidden">
                    <div className="p-8 border-b border-foreground/5 flex items-center justify-between">
                        <h3 className="text-2xl font-bold tracking-tighter uppercase italic flex items-center gap-4">
                            <Database className="text-primary" /> Métricas de DB (pg_stat)
                        </h3>
                    </div>

                    <div className="overflow-x-auto">
                        <table className="w-full text-left">
                            <thead className="bg-muted text-muted-foreground text-[10px] font-bold uppercase tracking-widest">
                                <tr>
                                    <th className="px-6 py-4">Query (Fragmento)</th>
                                    <th className="px-6 py-4">Llamadas</th>
                                    <th className="px-6 py-4">Tiempo Total</th>
                                    <th className="px-6 py-4">Promedio</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-foreground/5">
                                {metrics.map((m, i) => (
                                    <tr key={i} className="hover:bg-muted/30 transition-colors group">
                                        <td className="px-6 py-4">
                                            <code className="text-[10px] font-mono text-foreground break-all bg-muted/50 px-2 py-1 rounded block max-w-xs truncate">
                                                {m.query}
                                            </code>
                                        </td>
                                        <td className="px-6 py-4 font-bold text-sm tracking-tighter italic">
                                            {m.calls}
                                        </td>
                                        <td className="px-6 py-4 text-xs font-bold text-muted-foreground italic">
                                            {Number(m.total_time_ms || 0).toFixed(2)}ms
                                        </td>
                                        <td className="px-6 py-4">
                                            <span className={`font-bold text-xs italic ${Number(m.avg_time_ms || 0) > 100 ? 'text-destructive' : 'text-primary'}`}>
                                                {Number(m.avg_time_ms || 0).toFixed(2)}ms
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {metrics.length === 0 && (
                                    <tr>
                                        <td colSpan={4} className="px-6 py-20 text-center font-bold text-muted-foreground uppercase italic tracking-widest">
                                            No hay métricas disponibles en pg_stat_statements.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* BigQuery Status Card */}
                <div className="space-y-8">
                    <div className="bg-foreground text-background p-10 shadow-neo rounded-[3rem] space-y-8 rotate-1">
                        <h3 className="text-3xl font-bold tracking-tighter uppercase italic border-b-2 border-background/10 pb-6">
                            BigQuery Status
                        </h3>
                        
                        <div className="space-y-6">
                            <div className="flex items-center gap-4">
                                <div className={`w-12 h-12 flex items-center justify-center rounded-xl ${googleToken ? 'bg-primary/20 text-primary' : 'bg-destructive/20 text-destructive'}`}>
                                    <Globe size={24} />
                                </div>
                                <div className="space-y-1">
                                    <div className="flex items-center gap-2">
                                        <h4 className="font-bold text-lg uppercase tracking-tighter leading-none">Cuenta Google</h4>
                                        {!googleToken && (
                                            <button 
                                                onClick={() => googleLogin()}
                                                className="text-[10px] bg-primary text-primary-foreground px-2 py-0.5 rounded font-bold hover:scale-110 transition-transform"
                                            >
                                                VINCULAR
                                            </button>
                                        )}
                                    </div>
                                    <p className={`text-[10px] font-bold uppercase tracking-widest italic ${googleToken ? 'text-primary' : 'text-destructive'}`}>
                                        {googleToken ? 'VINCULADA' : 'NO VINCULADA'}
                                    </p>
                                </div>
                            </div>

                            <p className="text-xs font-bold opacity-60 leading-relaxed uppercase italic">
                                Envía un snapshot para registrar el desempeño de tu base de datos en la nube y comparar métricas históricas.
                            </p>

                            <button 
                                onClick={async () => {
                                    try {
                                        await benchmarkingService.runQueries();
                                        toast.success('Test de estrés ejecutado. ¡Datos generados!');
                                        loadData();
                                    } catch (e) {
                                        toast.error('Error al ejecutar test de estrés');
                                    }
                                }}
                                className="w-full h-16 bg-background text-foreground font-bold text-xs tracking-widest uppercase shadow-md hover:-translate-y-1 transition-all rounded-2xl border border-background/10 flex items-center justify-center gap-3"
                            >
                                <Zap className="text-primary" size={18} /> EJECUTAR TEST STRESS
                            </button>
                        </div>
                    </div>

                    <div className="bg-card border border-foreground/10 p-8 shadow-neo-sm rounded-[2.5rem] flex items-center gap-6 group">
                        <div className="w-16 h-16 bg-primary text-primary-foreground flex items-center justify-center font-bold text-2xl rotate-[-4deg] shadow-neo-sm rounded-2xl transition-transform group-hover:rotate-0">
                            ?
                        </div>
                        <div className="space-y-1">
                            <h4 className="font-bold text-sm uppercase tracking-widest italic">¿Qué se envía?</h4>
                            <p className="text-[9px] font-bold text-muted-foreground uppercase tracking-wider leading-relaxed">
                                Se envía el ID del proyecto, timestamp y las métricas de rendimiento agregadas del vendedor.
                            </p>
                        </div>
                    </div>
                </div>

                {/* Looker Studio / Data Studio Iframe */}
                {isAdmin && (
                    <div className="lg:col-span-3 mt-4 bg-card border-4 border-primary/20 p-8 shadow-neo-sm rounded-[2.5rem] flex flex-col gap-6 group">
                        <div className="space-y-2">
                            <h3 className="text-2xl font-bold tracking-tighter uppercase italic flex items-center gap-3 text-foreground">
                                <BarChart3 className="text-primary" /> Visualización de Panel BigQuery
                            </h3>
                            <p className="text-xs font-bold text-muted-foreground uppercase tracking-widest leading-relaxed border-l-2 border-primary/50 pl-3">
                                Aquí puedes incrustar tu reporte interactivo de Looker Studio conectando directamente con las vistas de BigQuery.
                            </p>
                        </div>
                        
                        <div className="w-full h-[500px] bg-foreground/5 rounded-2xl flex items-center justify-center border-2 border-dashed border-foreground/20 relative overflow-hidden group-hover:border-primary/50 transition-colors">
                            {/* ALUMNO: Reemplaza todo el contenido de este DIV con el iframe generado por Looker Studio */}
                            {/* Ejemplo: <iframe width="100%" height="100%" src="https://lookerstudio.google.com/embed/reporting/tu-id/page/1" frameBorder="0" style={{border:0}} allowFullScreen></iframe> */}
                            <div className="text-center space-y-4 px-6 relative z-10 p-6 bg-background/80 backdrop-blur-md rounded-xl shadow-xl border border-foreground/10">
                                <div className="mx-auto w-16 h-16 bg-primary/20 text-primary rounded-2xl flex items-center justify-center animate-bounce">
                                    <BarChart3 size={32} />
                                </div>
                                <h4 className="font-bold text-base uppercase tracking-widest">AÑADIR DASHBOARD LOOKER STUDIO</h4>
                                <p className="text-xs text-muted-foreground font-medium max-w-sm mx-auto">
                                    Ve a Looker Studio, conecta tu proyecto "data-from-software", crea tu reporte visual, genera el link de Inserción (Embed) y reemplaza este placeholder en el código del Frontend para visualizar los gráficos aquí.
                                </p>
                                <a href="https://lookerstudio.google.com/" target="_blank" rel="noreferrer" className="inline-block mt-4 bg-primary text-primary-foreground px-6 py-3 rounded-xl text-xs font-bold uppercase tracking-widest hover:opacity-90 transition shadow-neo-sm">
                                    Abrir Looker Studio
                                </a>
                            </div>
                            <div className="absolute inset-x-0 bottom-0 h-1/2 bg-gradient-to-t from-background to-transparent pointer-events-none"></div>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
}
