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
        <div className="p-8 space-y-8 animate-fade-in pb-20">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between space-y-4 sm:space-y-0">
                <h2 className="text-3xl font-bold tracking-tight text-foreground">Dashboard Financiero</h2>
                <div className="flex flex-wrap items-center gap-4">
                    <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded-md border border-gray-200">
                        <input
                            type="date"
                            className="text-sm outline-none bg-transparent"
                            value={startDate}
                            onChange={(e) => setStartDate(e.target.value)}
                        />
                        <span className="text-gray-400">a</span>
                        <input
                            type="date"
                            className="text-sm outline-none bg-transparent"
                            value={endDate}
                            onChange={(e) => setEndDate(e.target.value)}
                        />
                    </div>
                    <CloseDayDialog onClosed={loadDashboardData} />
                </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                {/* Total Revenue Card */}
                <Card className="hover-card border-l-4 border-l-primary">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            Ingresos Totales (Ventas)
                        </CardTitle>
                        <DollarSign className="h-4 w-4 text-primary" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold text-foreground">
                            ${stats?.revenue.toFixed(2) || '0.00'}
                        </div>
                    </CardContent>
                </Card>

                {/* Investment Card */}
                <Card className="hover-card border-l-4 border-l-orange-500">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            Inversión Total (Costo)
                        </CardTitle>
                        <Package className="h-4 w-4 text-orange-500" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold text-foreground">
                            ${stats?.investment.toFixed(2) || '0.00'}
                        </div>
                    </CardContent>
                </Card>

                {/* Net Profit Card */}
                <Card className="hover-card border-l-4 border-l-green-500">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            Ganancia Neta
                        </CardTitle>
                        <TrendingUp className="h-4 w-4 text-green-500" />
                    </CardHeader>
                    <CardContent>
                        <div className={`text-2xl font-bold ${(stats?.netProfit || 0) >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                            ${stats?.netProfit.toFixed(2) || '0.00'}
                        </div>
                    </CardContent>
                </Card>

                {/* ROI Card */}
                <Card className="hover-card border-l-4 border-l-violet-500">
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            ROI (Rentabilidad)
                        </CardTitle>
                        <PieChart className="h-4 w-4 text-violet-500" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold text-foreground">
                            {stats?.roi.toFixed(1) || '0.0'}%
                        </div>
                        <p className="text-xs text-muted-foreground">
                            Retorno sobre la inversión
                        </p>
                    </CardContent>
                </Card>
            </div>

            <div className="grid gap-4 md:grid-cols-1 lg:grid-cols-7">
                <Card className="col-span-4 hover-card flex flex-col">
                    <CardHeader>
                        <CardTitle>Historial de Rentabilidad (Ventas vs Inversión)</CardTitle>
                    </CardHeader>
                    <CardContent className="pl-2 flex-grow">
                        {chartData.length > 0 ? (
                            <div className="h-[300px] w-full">
                                <ResponsiveContainer width="100%" height="100%">
                                    <BarChart data={chartData}>
                                        <CartesianGrid strokeDasharray="3 3" vertical={false} />
                                        <XAxis dataKey="date" fontSize={12} tickLine={false} axisLine={false} />
                                        <YAxis fontSize={12} tickLine={false} axisLine={false} tickFormatter={(value) => `$${value}`} />
                                        <Tooltip
                                            formatter={(value) => [`$${value}`, '']}
                                            contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                                        />
                                        <Legend />
                                        <Bar dataKey="Inversión" fill="#f97316" radius={[4, 4, 0, 0]} name="Inversión" />
                                        <Bar dataKey="Ventas" fill="#2563eb" radius={[4, 4, 0, 0]} name="Ventas" />
                                    </BarChart>
                                </ResponsiveContainer>
                            </div>
                        ) : (
                            <div className="h-[300px] flex flex-col items-center justify-center text-muted-foreground bg-gray-50 rounded-lg border border-dashed text-center p-4">
                                <AlertCircle className="w-8 h-8 mb-2 text-gray-400" />
                                <p>No hay datos suficientes para mostrar la gráfica.</p>
                                <p className="text-sm">Tus ventas se graficarán aquí cuando los compradores realicen pagos o cuando registres el Cierre de Día.</p>
                            </div>
                        )}
                    </CardContent>
                </Card>

                {/* Suggestions / Predictions (HU-03) */}
                <Card className="col-span-3 hover-card bg-gradient-to-br from-violet-50 to-white border-violet-100 flex flex-col">
                    <CardHeader>
                        <CardTitle className="text-violet-900 flex items-center gap-2">
                            <TrendingUp size={20} />
                            Sugerencia del Día (IA)
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="flex-grow">
                        {prediction ? (
                            <div className="space-y-4">
                                <div className="flex items-start gap-4 p-4 bg-white rounded-xl shadow-sm border border-violet-100 h-full">
                                    <div className="bg-violet-100 p-2 rounded-lg text-violet-600">
                                        <Package size={24} />
                                    </div>
                                    <div>
                                        <h4 className="font-semibold text-gray-900">Prepara más {prediction.productName}</h4>
                                        <p className="text-sm text-gray-600 mt-1">
                                            Basado en tus ventas históricas de los {new Date().toLocaleDateString('es-MX', { weekday: 'long' })}s,
                                            el algoritmo sugiere preparar:
                                        </p>
                                        <p className="text-2xl font-bold text-violet-600 mt-2">
                                            {prediction.suggested} unidades
                                        </p>
                                        <p className="text-xs text-gray-400 mt-1">
                                            Confianza estadística: {(prediction.confidence * 100).toFixed(0)}%
                                        </p>
                                    </div>
                                </div>
                            </div>
                        ) : (
                            <div className="flex flex-col items-center justify-center h-full text-center p-6 text-gray-500 bg-white/50 rounded-xl border border-dashed border-violet-200">
                                <AlertCircle className="w-8 h-8 mb-2 text-violet-300" />
                                <p>Aún no tenemos suficientes datos para generar predicciones.</p>
                                <p className="text-xs mt-1">Sigue recibiendo pedidos para entrenar el modelo.</p>
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
                                        <th className="px-6 py-3 font-semibold text-right">Total Generado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {recentSales.slice(0, 10).map((sale) => (
                                        <tr key={sale.id} className="bg-white border-b hover:bg-gray-50 transition-colors">
                                            <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                                                {new Date(sale.createdAt).toLocaleDateString()} - {new Date(sale.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                            </td>
                                            <td className="px-6 py-4 font-medium text-gray-900">
                                                {sale.buyer?.firstName} {sale.buyer?.lastName}
                                            </td>
                                            <td className="px-6 py-4">
                                                <ul className="list-disc list-inside text-gray-600">
                                                    {sale.items.map(item => (
                                                        <li key={item.id}>{item.quantity}x {item.product?.name}</li>
                                                    ))}
                                                </ul>
                                            </td>
                                            <td className="px-6 py-4 text-right font-bold text-emerald-600">
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
