'use client';

import { useState, useEffect } from 'react';
import { 
    Download, 
    CalendarDays, 
    ArrowUpRight, 
    TrendingUp, 
    Package, 
    DollarSign, 
    Zap,
    Loader2,
    RefreshCw,
    Trash2
} from "lucide-react";
import { salesService, RoiStats } from '@/services/sales.service';
import { financeService } from '@/services/finance.service';
import { reportsService, WeeklyReport } from '@/services/reports.service';
import { toast } from 'sonner';

export default function ReportsPage() {
    const [stats, setStats] = useState<RoiStats | null>(null);
    const [reports, setReports] = useState<WeeklyReport[]>([]);
    const [loading, setLoading] = useState(true);
    const [generating, setGenerating] = useState(false);

    useEffect(() => {
        loadData();
    }, []);

    const loadData = async () => {
        try {
            setLoading(true);
            const [roiData, weeklyData] = await Promise.all([
                salesService.getRoiStats('', ''),
                reportsService.getWeeklyReports()
            ]);
            setStats(roiData);
            setReports(weeklyData || []);
        } catch (error) {
            console.error(error);
            toast.error('Error al cargar datos de reportes');
        } finally {
            setLoading(false);
        }
    };

    const handleGenerateReport = async () => {
        try {
            setGenerating(true);
            await reportsService.generateWeekly();
            toast.success('¡Reporte generado correctamente!');
            await loadData();
        } catch (error: any) {
            console.error(error);
            toast.error(error?.message || 'Error al generar el reporte');
        } finally {
            setGenerating(false);
        }
    };

    const handleDeleteReport = async (id: string) => {
        if (!confirm('¿Estás seguro de eliminar este reporte histórico?')) return;
        try {
            await reportsService.deleteReport(id);
            toast.success('Reporte eliminado');
            loadData();
        } catch (error) {
            toast.error('No se pudo eliminar el reporte');
        }
    };

    const toMoney = (val?: string | number) => Number(val || 0).toFixed(2);

    const handleDownloadCSV = (report: WeeklyReport) => {
        const headers = ['Métrica', 'Valor'];
        const rows = [
            ['Semana', report.week_number.toString()],
            ['Año', report.year.toString()],
            ['Ventas Totales', report.total_sales.toString()],
            ['Ganancia Total', report.total_profit.toString()],
            ['Mermas (Waste)', report.total_waste.toString()],
            ['ROI %', report.roi_pct.toString()],
            ['Fecha Generación', new Date(report.createdAt).toLocaleDateString()],
        ];

        const csvContent = [
            headers.join(','),
            ...rows.map(row => row.join(','))
        ].join('\n');

        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.setAttribute('href', url);
        link.setAttribute('download', `reporte_semana${report.week_number}_${report.year}.csv`);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        toast.success(`Reporte Semana ${report.week_number} descargado`);
    };

    if (loading && !stats) {
        return (
            <div className="h-screen flex items-center justify-center bg-background">
                <Loader2 className="animate-spin text-primary" size={64} />
            </div>
        );
    }

    return (
        <div className="p-4 md:p-10 space-y-12 font-display min-h-screen bg-background selection:bg-primary/20 pb-24">
            {/* Header */}
            <div className="flex flex-col lg:flex-row lg:items-end justify-between gap-6 border-b-4 border-foreground/10 pb-8">
                <div className="space-y-2">
                    <div className="inline-block bg-primary text-primary-foreground border border-primary/10 px-3 py-1 font-semibold text-xs tracking-widest shadow-neo-sm transform -rotate-1 mb-2 rounded-sm">
                        BUSINESS INTELLIGENCE
                    </div>
                    <h1 className="text-5xl md:text-7xl font-semibold tracking-tighter leading-none text-foreground uppercase italic">
                        REPORTES <span className="text-primary italic">PRO</span>
                    </h1>
                    <p className="text-lg font-bold text-muted-foreground uppercase tracking-tight max-w-md border-l-4 border-primary pl-4">
                        Analiza tu rendimiento, márgenes y proyecciones de stock.
                    </p>
                </div>
                <div className="flex gap-4">
                    <button 
                        onClick={handleGenerateReport}
                        disabled={generating}
                        className="flex items-center gap-3 px-8 h-16 bg-foreground text-background border border-foreground/10 font-bold text-xs tracking-widest uppercase hover:opacity-90 transition-all rounded-xl shadow-neo disabled:opacity-50"
                    >
                        {generating ? <Loader2 className="animate-spin" size={18} /> : <Zap size={18} />}
                        GENERAR REPORTE
                    </button>
                    <button 
                        onClick={loadData}
                        className="flex items-center gap-3 px-6 h-16 bg-card border border-foreground/10 font-bold text-xs tracking-widest uppercase hover:bg-muted transition-all rounded-xl shadow-neo-sm"
                    >
                        <RefreshCw size={18} />
                    </button>
                </div>
            </div>

            {/* Stats Overview */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-10">
                <div className="bg-card border border-foreground/10 p-10 shadow-neo-sm rounded-[3rem] relative overflow-hidden group">
                    <div className="flex justify-between items-start mb-6">
                        <p className="text-[10px] font-bold text-muted-foreground tracking-widest uppercase">Ventas Brutas</p>
                        <DollarSign className="text-primary" />
                    </div>
                    <h3 className="text-5xl font-bold tracking-tighter">${toMoney(stats?.revenue)}</h3>
                    <p className="text-[10px] font-bold text-primary uppercase mt-2">Ingresos totales acumulados</p>
                </div>

                <div className="bg-foreground text-background p-10 shadow-neo rounded-[3rem] relative overflow-hidden group rotate-1">
                    <div className="flex justify-between items-start mb-6 text-primary">
                        <p className="text-[10px] font-bold opacity-60 tracking-widest uppercase text-background">Ganancia Neta</p>
                        <TrendingUp />
                    </div>
                    <h3 className="text-5xl font-bold tracking-tighter">${toMoney(stats?.netProfit)}</h3>
                    <p className="text-[10px] font-bold text-primary uppercase mt-2">Utilidad después de costos</p>
                </div>

                <div className="bg-card border border-foreground/10 p-10 shadow-neo-sm rounded-[3rem]">
                    <div className="flex justify-between items-start mb-6">
                        <p className="text-[10px] font-bold text-muted-foreground tracking-widest uppercase">Margen ROI</p>
                        <Zap className="text-primary" />
                    </div>
                    <h3 className="text-5xl font-bold tracking-tighter">
                        {stats?.revenue ? ((Number(stats.netProfit) / Number(stats.revenue)) * 100).toFixed(1) : '0'}%
                    </h3>
                    <div className="w-full h-2 bg-muted rounded-full mt-4 overflow-hidden">
                        <div 
                            className="h-full bg-primary" 
                            style={{ width: `${Math.min(100, (Number(stats?.netProfit) / Number(stats?.revenue)) * 100 || 0)}%` }}
                        ></div>
                    </div>
                </div>
            </div>

            {/* Historical Reports Table */}
            <div className="bg-card border border-foreground/10 shadow-neo-sm rounded-[3rem] overflow-hidden">
                <div className="p-8 border-b border-foreground/5 bg-muted/30">
                    <h3 className="text-3xl font-bold tracking-tighter uppercase italic flex items-center gap-4">
                        <CalendarDays className="text-primary" /> Reportes Históricos
                    </h3>
                </div>

                <div className="overflow-x-auto">
                    <table className="w-full text-left">
                        <thead className="bg-muted text-muted-foreground text-[10px] font-bold uppercase tracking-widest">
                            <tr>
                                <th className="px-8 py-5">Periodo</th>
                                <th className="px-8 py-5">Ventas</th>
                                <th className="px-8 py-5">Ganancia</th>
                                <th className="px-8 py-5">Acciones</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-foreground/5">
                            {reports.map((report) => (
                                <tr key={report.id} className="hover:bg-muted/30 transition-colors group">
                                    <td className="px-8 py-6">
                                        <div className="font-bold text-lg tracking-tighter uppercase italic text-foreground">
                                            Semana {report.week_number} - {report.year}
                                        </div>
                                        <span className="text-[10px] font-bold text-muted-foreground uppercase">{new Date(report.createdAt).toLocaleDateString()}</span>
                                    </td>
                                    <td className="px-8 py-6">
                                        <span className="text-xl font-bold tracking-tighter text-foreground">${toMoney(report.total_sales)}</span>
                                    </td>
                                    <td className="px-8 py-6">
                                        <span className={`text-xl font-bold tracking-tighter ${Number(report.total_profit) >= 0 ? 'text-primary' : 'text-destructive'}`}>
                                            ${toMoney(report.total_profit)}
                                        </span>
                                    </td>
                                    <td className="px-8 py-6">
                                        <div className="flex gap-4">
                                            <button 
                                                onClick={() => handleDeleteReport(report.id)}
                                                className="p-3 bg-muted border border-foreground/5 hover:bg-destructive hover:text-destructive-foreground transition-all rounded-xl shadow-neo-sm"
                                            >
                                                <Trash2 size={18} />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                            {reports.length === 0 && (
                                <tr>
                                    <td colSpan={4} className="px-8 py-20 text-center font-bold text-muted-foreground uppercase italic tracking-widest">
                                        No hay reportes semanales generados aún.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
