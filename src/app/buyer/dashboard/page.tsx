'use client';

import { useState, useEffect } from 'react';
import { ordersService, Order } from '@/services/orders.service';
import { Package, Clock, CheckCircle, XCircle, ChevronRight, Store } from 'lucide-react';
import Link from 'next/link';

export default function BuyerDashboardPage() {
    const [orders, setOrders] = useState<Order[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<'activos' | 'completados' | 'cancelados'>('activos');

    useEffect(() => {
        loadOrders();
    }, []);

    const loadOrders = async () => {
        try {
            setLoading(true);
            const data = await ordersService.getMyPurchases();
            setOrders(data);
        } catch (error) {
            console.error("Error loading orders", error);
        } finally {
            setLoading(false);
        }
    };

    const getStatusStyle = (status: string) => {
        switch (status) {
            case 'requested':
            case 'pending':
                return {
                    bg: 'bg-neo-yellow',
                    text: 'text-black',
                    icon: <Clock className="w-5 h-5" />,
                    label: status === 'requested' ? 'SOLICITADO' : 'EN PREPARACIÓN'
                };
            case 'delivered':
            case 'completed':
                return {
                    bg: 'bg-neo-green',
                    text: 'text-black',
                    icon: <CheckCircle className="w-5 h-5" />,
                    label: 'ENTREGADO'
                };
            case 'rejected':
                return {
                    bg: 'bg-neo-red',
                    text: 'text-white',
                    icon: <XCircle className="w-5 h-5" />,
                    label: 'CANCELADO'
                };
            default:
                return {
                    bg: 'bg-gray-200',
                    text: 'text-black',
                    icon: <Package className="w-5 h-5" />,
                    label: status
                };
        }
    };

    const filteredOrders = orders.filter(o => {
        if (filter === 'activos') return ['requested', 'pending'].includes(o.status);
        if (filter === 'completados') return ['delivered', 'completed'].includes(o.status);
        if (filter === 'cancelados') return o.status === 'rejected';
        return true;
    });

    return (
        <div className="bg-neo-white font-display text-black min-h-screen selection:bg-neo-yellow selection:text-black">
            <header className="border-b-4 border-black bg-white sticky top-[64px] z-40">
                <div className="max-w-4xl mx-auto px-4 py-6 md:px-8">
                    <h1 className="text-4xl md:text-5xl font-black uppercase tracking-tighter flex flex-col md:flex-row md:items-center gap-2">
                        <span>Mis</span>
                        <span className="bg-neo-red text-white px-4 py-1 border-2 border-black inline-block -rotate-2 transform">
                            Compras
                        </span>
                    </h1>
                </div>
            </header>

            <main className="max-w-4xl mx-auto px-4 py-8 md:px-8">
                {/* Tabs */}
                <div className="flex overflow-x-auto gap-4 pb-4 mb-6 border-b-4 border-black hide-scrollbar">
                    {['activos', 'completados', 'cancelados'].map((tab) => (
                        <button
                            key={tab}
                            onClick={() => setFilter(tab as any)}
                            className={`px-6 py-3 font-black text-sm uppercase tracking-widest border-2 border-black whitespace-nowrap transition-transform hover:-translate-y-1 ${filter === tab
                                    ? 'bg-black text-white shadow-none translate-y-0'
                                    : 'bg-white text-black shadow-neo-sm hover:shadow-neo'
                                }`}
                        >
                            {tab}
                        </button>
                    ))}
                </div>

                {/* Lista de Pedidos */}
                <div className="flex flex-col gap-6">
                    {loading ? (
                        [1, 2, 3].map(i => <div key={i} className="h-48 bg-gray-200 border-4 border-black animate-pulse" />)
                    ) : filteredOrders.length === 0 ? (
                        <div className="bg-white border-4 border-black p-12 text-center shadow-neo-lg transform rotate-1">
                            <Store className="w-16 h-16 mx-auto mb-4 text-gray-300" />
                            <h3 className="text-2xl font-black uppercase text-gray-500 mb-6">No hay pedidos aquí.</h3>
                            <Link href="/marketplace" className="inline-block bg-neo-yellow text-black font-black uppercase tracking-wider px-8 py-4 border-4 border-black shadow-neo hover:-translate-y-1 transition-transform">
                                Explorar Campus
                            </Link>
                        </div>
                    ) : (
                        filteredOrders.map(order => {
                            const style = getStatusStyle(order.status);
                            const productCount = order.items?.reduce((acc, i) => acc + i.quantity, 0) || 0;
                            const mainProduct = order.items?.[0]?.product?.name || `Producto #${order.items?.[0]?.productId.substring(0, 4)}`;

                            return (
                                <article key={order.id} className="bg-white border-4 border-black p-6 shadow-neo-lg flex flex-col md:flex-row gap-6 hover:-translate-y-1 transition-transform group">
                                    <div className={`w-16 h-16 md:w-24 md:w-24 border-4 border-black flex items-center justify-center shrink-0 -rotate-3 group-hover:rotate-0 transition-transform ${style.bg} ${style.text}`}>
                                        <Package className="w-8 h-8 md:w-12 md:h-12" />
                                    </div>

                                    <div className="flex-grow flex flex-col justify-between">
                                        <div>
                                            <div className="flex items-center justify-between mb-2">
                                                <span className={`inline-flex items-center gap-1.5 px-3 py-1 text-xs font-black uppercase border-2 border-black shadow-neo-sm ${style.bg} ${style.text}`}>
                                                    {style.icon} {style.label}
                                                </span>
                                                <span className="text-xl font-black">${Number(order.totalAmount).toFixed(2)}</span>
                                            </div>
                                            <h3 className="text-xl md:text-2xl font-black uppercase leading-tight mb-1">
                                                {mainProduct}
                                                {productCount > 1 && <span className="text-gray-500 ml-2">+{productCount - 1} más</span>}
                                            </h3>
                                            <p className="font-bold text-sm text-gray-600">
                                                Vendido por: <span className="text-black uppercase underline decoration-2 underline-offset-4 decoration-neo-red">{order.seller?.fullName || 'Vendedor Oculto'}</span>
                                            </p>
                                        </div>
                                        <div className="mt-4 flex items-center justify-between pt-4 border-t-4 border-dashed border-gray-200">
                                            <div className="text-xs font-bold font-mono text-gray-500">
                                                {new Date(order.createdAt).toLocaleString()}
                                            </div>
                                            <button className="flex items-center gap-2 font-black uppercase text-sm tracking-widest text-neo-red hover:text-black transition-colors group">
                                                Ver Recibo <ChevronRight className="w-5 h-5 group-hover:translate-x-1 transition-transform border-2 border-current rounded-full p-0.5" />
                                            </button>
                                        </div>
                                    </div>
                                </article>
                            );
                        })
                    )}
                </div>
            </main>
        </div>
    );
}
