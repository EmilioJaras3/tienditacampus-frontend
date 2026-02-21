'use client';

import { useEffect, useState } from 'react';
import {
    DollarSign,
    Package,
    TrendingUp,
    PieChart,
    AlertCircle,
    Loader2,
    CheckCircle2
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { salesService, RoiStats, DailySale } from '@/services/sales.service';
import { ordersService, Order } from '@/services/orders.service';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from 'recharts';

import { CloseDayDialog } from '@/components/sales/close-day-dialog';

export default function DashboardPage() {
    const [stats, setStats] = useState<RoiStats | null>(null);
    const [history, setHistory] = useState<DailySale[]>([]);
    const [recentSales, setRecentSales] = useState<Order[]>([]);
    const [prediction, setPrediction] = useState<{ productName: string; suggested: number; confidence: number } | null>(null);
    const [loading, setLoading] = useState(true);

    const [startDate, setStartDate] = useState<string>('');
    const [endDate, setEndDate] = useState<string>('');

    const loadDashboardData = async () => {
        setLoading(true);
        try {
            const [statsData, historyData, predictionData, salesData] = await Promise.all([
                salesService.getRoiStats(startDate, endDate),
                salesService.getHistory(),
                salesService.getPrediction(),
                ordersService.getSellerSales()
            ]);
            setStats(statsData);
            setHistory(historyData);
            setPrediction(predictionData);
            setRecentSales(salesData);
        } catch (error) {
            console.error("Error loading dashboard:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleAccept = async (orderId: string) => {
        try {
            await ordersService.accept(orderId);
            setRecentSales(recentSales.map(s => s.id === orderId ? { ...s, status: 'pending' } : s));
        } catch (e) {
            console.error('Error accepting:', e);
        }
    };

    const handleReject = async (orderId: string) => {
        try {
            await ordersService.reject(orderId);
            setRecentSales(recentSales.map(s => s.id === orderId ? { ...s, status: 'rejected' } : s));
        } catch (e) {
            console.error('Error rejecting:', e);
        }
    };

    const handleDeliver = async (orderId: string) => {
        try {
            await ordersService.deliver(orderId);
            setRecentSales(recentSales.map(s => s.id === orderId ? { ...s, status: 'completed' } : s));
        } catch (error) {
            console.error('Error confirming delivery:', error);
        }
    };

    useEffect(() => {
        loadDashboardData();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [startDate, endDate]);

    if (loading && !stats) {
        return (
            <div className="h-full flex items-center justify-center p-8">
                <Loader2 className="animate-spin text-primary" size={40} />
            </div>
        );
    }

    // Preparar datos para el gráfico
    const chartData = history.map(day => ({
        date: new Date(day.saleDate).toLocaleDateString('es-MX', { day: 'numeric', month: 'short' }),
        Ventas: parseFloat(String(day.totalRevenue)),
        Inversión: parseFloat(String(day.totalInvestment)),
    }));

    return (
        <div className="p-8 space-y-8 animate-fade-in pb-20 bg-[#f7f7f7]">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div>
                    <div className="inline-flex items-center gap-2 border-2 border-slate-900 dark:border-white bg-white px-3 py-1 text-xs font-black uppercase tracking-widest">
                        Dashboard
                    </div>
                    <h2 className="mt-3 text-3xl sm:text-4xl font-black uppercase tracking-tight text-slate-900">Dashboard financiero</h2>
                </div>
                <div className="flex flex-wrap items-center gap-3">
                    <div className="flex items-center gap-2 bg-white px-3 py-2 border-2 border-slate-900 dark:border-white shadow-[4px_4px_0px_0px_#FFC72C]">
                        <input
                            type="date"
                            className="text-sm outline-none bg-transparent font-mono"
                            value={startDate}
                            onChange={(e) => setStartDate(e.target.value)}
                        />
                        <span className="text-slate-700 font-black">a</span>
                        <input
                            type="date"
                            className="text-sm outline-none bg-transparent font-mono"
                            value={endDate}
                            onChange={(e) => setEndDate(e.target.value)}
                        />
                    </div>
                    <div className="border-2 border-slate-900 dark:border-white shadow-[4px_4px_0px_0px_#E31837] bg-white">
                        <CloseDayDialog onClosed={loadDashboardData} />
                    </div>
                </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                {/* Total Revenue Card */}
                <Card className="border-2 border-slate-900 dark:border-white rounded-none bg-white shadow-[6px_6px_0px_0px_#E31837]">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-xs font-black uppercase tracking-widest text-slate-600">
                            Ingresos Totales (Ventas)
                        </CardTitle>
                        <DollarSign className="h-4 w-4 text-slate-900" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-black text-slate-900">
                            ${stats?.revenue.toFixed(2) || '0.00'}
                        </div>
                    </CardContent>
                </Card>

                {/* Investment Card */}
                <Card className="border-2 border-slate-900 dark:border-white rounded-none bg-white shadow-[6px_6px_0px_0px_#FFC72C]">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-xs font-black uppercase tracking-widest text-slate-600">
                            Inversión Total (Costo)
                        </CardTitle>
                        <Package className="h-4 w-4 text-slate-900" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-black text-slate-900">
                            ${stats?.investment.toFixed(2) || '0.00'}
                        </div>
                    </CardContent>
                </Card>

                {/* Net Profit Card */}
                <Card className="border-2 border-slate-900 dark:border-white rounded-none bg-white shadow-[6px_6px_0px_0px_#1a1a1a]">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-xs font-black uppercase tracking-widest text-slate-600">
                            Ganancia Neta
                        </CardTitle>
                        <TrendingUp className="h-4 w-4 text-slate-900" />
                    </CardHeader>
                    <CardContent>
                        <div className={`text-2xl font-black ${(stats?.netProfit || 0) >= 0 ? 'text-green-600' : 'text-[#E31837]'}`}>
                            ${stats?.netProfit.toFixed(2) || '0.00'}
                        </div>
                    </CardContent>
                </Card>

                {/* ROI Card */}
                <Card className="border-2 border-slate-900 dark:border-white rounded-none bg-white shadow-[6px_6px_0px_0px_#E31837]">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-xs font-black uppercase tracking-widest text-slate-600">
                            ROI (Rentabilidad)
                        </CardTitle>
                        <PieChart className="h-4 w-4 text-slate-900" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-black text-slate-900">
                            {stats?.roi.toFixed(1) || '0.0'}%
                        </div>
                        <p className="text-xs text-slate-600 font-medium">
                            Retorno sobre la inversión
                        </p>
                    </CardContent>
                </Card>
            </div>

            <div className="grid gap-4 md:grid-cols-1 lg:grid-cols-7">
                <Card className="col-span-4 border-2 border-slate-900 dark:border-white rounded-none bg-white shadow-[8px_8px_0px_0px_#E31837] flex flex-col">
                    <CardHeader>
                        <CardTitle className="text-slate-900 font-black uppercase tracking-tight">
                            Historial de rentabilidad
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="pl-2 flex-grow">
                        {chartData.length > 0 ? (
                            <div className="h-[300px] w-full pr-4">
                                <ResponsiveContainer width="100%" height="100%">
                                    <BarChart data={chartData}>
                                        <CartesianGrid strokeDasharray="3 3" vertical={false} />
                                        <XAxis dataKey="date" fontSize={12} tickLine={false} axisLine={false} />
                                        <YAxis fontSize={12} tickLine={false} axisLine={false} tickFormatter={(value) => `$${value}`} />
                                        <Tooltip
                                            formatter={(value) => [`$${value}`, '']}
                                            contentStyle={{ borderRadius: '0px', border: '2px solid #0f172a', boxShadow: '6px 6px 0px 0px #FFC72C' }}
                                        />
                                        <Legend />
                                        <Bar dataKey="Inversión" fill="#f97316" radius={[4, 4, 0, 0]} name="Inversión" />
                                        <Bar dataKey="Ventas" fill="#2563eb" radius={[4, 4, 0, 0]} name="Ventas" />
                                    </BarChart>
                                </ResponsiveContainer>
                            </div>
                        ) : (
                            <div className="h-[300px] flex flex-col items-center justify-center bg-white border-2 border-slate-900/20 text-center p-6 mr-4">
                                <div className="mb-3 w-fit border-2 border-slate-900 dark:border-white bg-[#FFC72C] px-3 py-1 text-xs font-black uppercase tracking-widest">
                                    Sin datos
                                </div>
                                <AlertCircle className="w-8 h-8 mb-2 text-slate-900" />
                                <p className="font-black uppercase tracking-tight text-slate-900">No hay datos para mostrar la grafica.</p>
                                <p className="text-sm text-slate-700 font-medium mt-2 max-w-md">
                                    Tus ventas se graficarán aquí cuando los compradores realicen pagos o cuando registres el cierre de día.
                                </p>
                            </div>
                        )}
                    </CardContent>
                </Card>

                {/* Suggestions / Predictions (HU-03) */}
                <Card className="col-span-3 border-2 border-slate-900 dark:border-white rounded-none bg-white shadow-[8px_8px_0px_0px_#FFC72C] flex flex-col">
                    <CardHeader>
                        <CardTitle className="text-slate-900 font-black uppercase tracking-tight flex items-center gap-2">
                            <TrendingUp size={18} className="text-slate-900" />
                            Sugerencia del dia (IA)
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="flex-grow">
                        {prediction ? (
                            <div className="border-2 border-slate-900/20 bg-white p-4">
                                <div className="flex items-start gap-4">
                                    <div className="bg-[#FFC72C] p-2 border-2 border-slate-900 dark:border-white text-slate-900">
                                        <Package size={20} />
                                    </div>
                                    <div>
                                        <div className="inline-flex border-2 border-slate-900 dark:border-white bg-white px-2 py-0.5 text-[10px] font-black uppercase tracking-widest">
                                            Recomendacion
                                        </div>
                                        <h4 className="mt-2 font-black uppercase tracking-tight text-slate-900">
                                            Prepara mas {prediction.productName}
                                        </h4>
                                        <p className="text-sm text-slate-700 font-medium mt-1">
                                            Basado en tus ventas históricas de los {new Date().toLocaleDateString('es-MX', { weekday: 'long' })}s, el algoritmo sugiere preparar:
                                        </p>
                                        <div className="mt-3 inline-flex border-2 border-slate-900 dark:border-white bg-[#E31837] px-3 py-1 font-black uppercase tracking-wide text-white">
                                            {prediction.suggested} unidades
                                        </div>
                                        <p className="text-xs text-slate-600 font-mono uppercase mt-2">
                                            Confianza {(prediction.confidence * 100).toFixed(0)}%
                                        </p>
                                    </div>
                                </div>
                            </div>
                        ) : (
                            <div className="flex flex-col items-center justify-center h-full text-center p-6 border-2 border-slate-900/20 bg-white">
                                <div className="mb-3 w-fit border-2 border-slate-900 dark:border-white bg-[#FFC72C] px-3 py-1 text-xs font-black uppercase tracking-widest">
                                    Sin datos
                                </div>
                                <AlertCircle className="w-8 h-8 mb-2 text-slate-900" />
                                <p className="font-black uppercase tracking-tight text-slate-900">Aun no hay suficientes datos</p>
                                <p className="text-xs mt-1 text-slate-700 font-medium">Sigue recibiendo pedidos para entrenar el modelo.</p>
                            </div>
                        )}
                    </CardContent>
                </Card>
            </div>

            <Card className="hover-card">
                <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                        <CheckCircle2 className="text-emerald-500" />
                        Trazabilidad de Ventas Recientes
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    {recentSales.length > 0 ? (
                        <div className="overflow-x-auto">
                            <table className="w-full text-sm text-left">
                                <thead className="text-xs text-gray-500 uppercase bg-gray-50 border-b">
                                    <tr>
                                        <th className="px-6 py-3 font-semibold">Fecha y Hora</th>
                                        <th className="px-6 py-3 font-semibold">Comprador</th>
                                        <th className="px-6 py-3 font-semibold">Productos</th>
                                        <th className="px-6 py-3 font-semibold">Estado y Acción</th>
                                        <th className="px-6 py-3 font-semibold text-right">Potencial / Cobrado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {recentSales.slice(0, 10).map((sale) => (
                                        <tr key={sale.id} className="bg-white border-b hover:bg-gray-50 transition-colors">
                                            <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                                                {new Date(sale.createdAt).toLocaleDateString()} - {new Date(sale.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                            </td>
                                            <td className="px-6 py-4">
                                                <p className="font-medium text-gray-900">
                                                    {sale.buyer?.firstName} {sale.buyer?.lastName} {sale.buyer?.major ? `(${sale.buyer.major})` : ''}
                                                </p>
                                                {sale.deliveryMessage && (
                                                    <p className="text-xs text-blue-600 mt-1">
                                                        &quot;{sale.deliveryMessage}&quot;
                                                    </p>
                                                )}
                                            </td>
                                            <td className="px-6 py-4">
                                                <ul className="list-disc list-inside text-gray-600">
                                                    {sale.items.map(item => (
                                                        <li key={item.id}>{item.quantity}x {item.product?.name}</li>
                                                    ))}
                                                </ul>
                                            </td>
                                            <td className="px-6 py-4">
                                                <div className="flex flex-col gap-2 items-start">
                                                    <span className={`px-2 py-1 text-xs font-bold rounded-lg uppercase ${sale.status === 'requested' ? 'bg-blue-100 text-blue-700' :
                                                        sale.status === 'pending' ? 'bg-orange-100 text-orange-700' :
                                                            sale.status === 'completed' ? 'bg-emerald-100 text-emerald-700' :
                                                                'bg-red-100 text-red-700'
                                                        }`}>
                                                        {sale.status === 'requested' ? 'Solicitado' :
                                                            sale.status === 'pending' ? 'Por Entregar' :
                                                                sale.status === 'completed' ? 'Pagado' :
                                                                    'Rechazado'}
                                                    </span>
                                                    {sale.status === 'requested' && (
                                                        <div className="flex gap-2 mt-1">
                                                            <button
                                                                onClick={() => handleAccept(sale.id)}
                                                                className="text-white bg-blue-600 hover:bg-blue-700 font-medium rounded-md text-xs px-2.5 py-1 transition-colors"
                                                            >
                                                                Aceptar
                                                            </button>
                                                            <button
                                                                onClick={() => handleReject(sale.id)}
                                                                className="text-gray-700 bg-gray-200 hover:bg-gray-300 font-medium rounded-md text-xs px-2.5 py-1 transition-colors"
                                                            >
                                                                Rechazar
                                                            </button>
                                                        </div>
                                                    )}
                                                    {sale.status === 'pending' && (
                                                        <div className="flex gap-2 mt-1">
                                                            <button
                                                                onClick={() => handleDeliver(sale.id)}
                                                                className="text-white bg-emerald-600 hover:bg-emerald-700 font-medium rounded-md text-xs px-2.5 py-1 shadow-sm transition-colors"
                                                            >
                                                                Confirmar Entrega
                                                            </button>
                                                        </div>
                                                    )}
                                                </div>
                                            </td>
                                            <td className={`px-6 py-4 text-right font-bold ${sale.status === 'requested' || sale.status === 'pending' ? 'text-gray-400' :
                                                sale.status === 'completed' ? 'text-emerald-600' : 'text-red-300 line-through'
                                                }`}>
                                                +${Number(sale.totalAmount).toFixed(2)}
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    ) : (
                        <div className="flex flex-col items-center justify-center p-8 bg-gray-50 rounded-lg border border-dashed">
                            <Package className="w-10 h-10 text-gray-300 mb-3" />
                            <p className="text-gray-500 font-medium text-center">Todavía no has recibido compras automáticas</p>
                            <p className="text-sm text-gray-400 mt-1 max-w-sm text-center">Cuando los compradores realicen compras en el marketplace, el inventario se reducirá automáticamente y aparecerán aquí.</p>
                        </div>
                    )}
                </CardContent>
            </Card>
        </div>
    );
}
