'use client';

import { useEffect, useState } from 'react';
import { Package, TrendingUp, CheckCircle2, ChevronRight, AlertCircle, Loader2 } from "lucide-react";
import { salesService, RoiStats } from '@/services/sales.service';
import { ordersService, Order } from '@/services/orders.service';
import { useAuthStore } from '@/store/auth.store';
import Link from 'next/link';
import { toast } from 'sonner';

export default function DashboardPage() {
    const { user } = useAuthStore();
    const [stats, setStats] = useState<RoiStats | null>(null);
    const [orders, setOrders] = useState<Order[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadDashboardData();
    }, []);

    const loadDashboardData = async () => {
        setLoading(true);
        try {
            const [statsData, ordersData] = await Promise.all([
                salesService.getRoiStats('', ''),
                ordersService.getIncomingOrders()
            ]);
            setStats(statsData);
            setOrders(ordersData);
        } catch (error) {
            console.error("Error loading dashboard:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleAccept = async (orderId: string) => {
        try {
            await ordersService.acceptOrder(orderId);
            toast.success('Pedido aceptado');
            loadDashboardData();
        } catch (e) {
            console.error('Error accepting:', e);
            toast.error('Error al aceptar');
        }
    };

    const handleReject = async (orderId: string) => {
        try {
            await ordersService.rejectOrder(orderId);
            toast.success('Pedido rechazado');
            loadDashboardData();
        } catch (e) {
            console.error('Error rejecting:', e);
            toast.error('Error al rechazar');
        }
    };

    const pendingOrdersCount = orders.filter(o => o.status === 'requested').length;

    if (loading && !stats) {
        return (
            <div className="h-screen flex items-center justify-center bg-neo-white">
                <Loader2 className="animate-spin" size={64} />
            </div>
        );
    }

    return (
        <div className="font-display selection:bg-neo-red selection:text-white bg-neo-white min-h-screen p-4 md:p-8">
            <header className="mb-12 border-b-4 border-black pb-6 flex flex-col md:flex-row md:items-end justify-between gap-4">
                <div>
                    <div className="inline-block bg-neo-yellow px-3 py-1 border-2 border-black font-black uppercase text-xs tracking-widest mb-4 shadow-neo-sm transform -rotate-2">
                        SELLER SPACE
                    </div>
                    <h1 className="text-5xl md:text-7xl font-black uppercase tracking-tighter leading-none">
                        HELLO, <span className="text-neo-red">{user?.firstName?.toUpperCase() || 'SELLER'}</span>
                    </h1>
                </div>
                <div className="text-right">
                    <p className="font-bold text-gray-500 uppercase tracking-widest text-sm">
                        {new Date().toLocaleDateString('es-MX', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}
                    </p>
                </div>
            </header>

            <main className="max-w-7xl mx-auto space-y-12">
                <section className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <article className="bg-neo-yellow border-4 border-black p-6 shadow-neo-lg hover:-translate-y-1 transition-transform group">
                        <div className="flex justify-between items-start mb-6">
                            <h3 className="font-black uppercase tracking-widest text-sm">Pedidos sin ver</h3>
                            <Package className="w-8 h-8 group-hover:scale-110 transition-transform" />
                        </div>
                        <div className="text-6xl font-black tracking-tighter mb-2">
                            {pendingOrdersCount}
                        </div>
                        <Link href="/sales" className="text-sm font-bold uppercase underline decoration-2 underline-offset-4 hover:text-white transition-colors">
                            Ir a pedidos
                        </Link>
                    </article>

                    <article className="bg-white border-4 border-black p-6 shadow-neo hover:-translate-y-1 transition-transform">
                        <div className="flex justify-between items-start mb-6">
                            <h3 className="font-black uppercase tracking-widest text-sm text-gray-500">Ventas (Total)</h3>
                        </div>
                        <div className="text-5xl font-black tracking-tighter mb-2">
                            ${stats?.revenue.toFixed(2) || '0.00'}
                        </div>
                    </article>

                    <article className="bg-black text-white border-4 border-black p-6 shadow-neo hover:-translate-y-1 transition-transform relative overflow-hidden">
                        <div className="absolute -right-4 -top-4 w-24 h-24 bg-neo-red rounded-full blur-xl opacity-50"></div>
                        <div className="flex justify-between items-start mb-6 relative z-10">
                            <h3 className="font-black uppercase tracking-widest text-sm text-gray-400">Ganancia Neta</h3>
                            <TrendingUp className="w-8 h-8 text-neo-green" />
                        </div>
                        <div className={`text-5xl font-black tracking-tighter mb-2 relative z-10 ${(stats?.netProfit || 0) < 0 ? 'text-neo-red' : ''}`}>
                            ${stats?.netProfit.toFixed(2) || '0.00'}
                        </div>
                    </article>
                </section>

                <section>
                    <div className="flex items-end justify-between mb-6">
                        <h2 className="text-3xl font-black uppercase flex items-center gap-2">
                            <CheckCircle2 className="w-8 h-8 text-neo-red" /> Quick Actions
                        </h2>
                        <Link href="/sales" className="hidden md:flex font-bold uppercase text-sm items-center gap-1 hover:text-neo-red transition-colors">
                            Ver todos <ChevronRight className="w-4 h-4" />
                        </Link>
                    </div>

                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        {orders.filter(o => o.status === 'requested').slice(0, 4).map(order => (
                            <div key={order.id} className="bg-white border-4 border-black p-5 flex flex-col sm:flex-row gap-4 justify-between items-start sm:items-center hover:bg-gray-50 transition-colors shadow-neo-sm">
                                <div>
                                    <span className="bg-black text-white px-2 py-0.5 text-xs font-bold uppercase tracking-widest mb-2 inline-block">
                                        Nuevo
                                    </span>
                                    <h4 className="font-black text-lg uppercase leading-tight">
                                        {order.items?.[0]?.product?.name || 'Producto'}
                                        {order.items?.length > 1 && <span className="text-gray-500 ml-2">+{order.items.length - 1} más</span>}
                                    </h4>
                                    <p className="text-sm font-bold text-gray-600 mt-1">
                                        Comprador: <span className="text-black uppercase">{order.buyer?.fullName || 'Anónimo'}</span>
                                    </p>
                                    {order.deliveryMessage && (
                                        <p className="text-xs text-blue-600 mt-1 uppercase italic border-l-2 border-blue-600 pl-2">
                                            {order.deliveryMessage}
                                        </p>
                                    )}
                                </div>
                                <div className="flex gap-2 w-full sm:w-auto mt-2 sm:mt-0">
                                    <button
                                        onClick={() => handleAccept(order.id)}
                                        className="flex-1 sm:flex-none bg-neo-green border-2 border-black px-4 py-2 font-black text-sm uppercase shadow-[2px_2px_0_0_#000] hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-none transition-all"
                                    >
                                        Aceptar
                                    </button>
                                    <button
                                        onClick={() => handleReject(order.id)}
                                        className="flex-1 sm:flex-none bg-white border-2 border-black px-4 py-2 font-black text-sm uppercase text-gray-500 hover:text-neo-red hover:bg-red-50 transition-colors"
                                    >
                                        Pasar
                                    </button>
                                </div>
                            </div>
                        ))}
                        {orders.filter(o => o.status === 'requested').length === 0 && (
                            <div className="col-span-full bg-white border-4 border-black p-8 text-center border-dashed font-bold uppercase text-gray-500">
                                No hay pedidos nuevos por revisar.
                            </div>
                        )}
                    </div>
                </section>
            </main>
        </div>
    );
}
