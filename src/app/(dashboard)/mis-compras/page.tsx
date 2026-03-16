'use client';

import { useState, useEffect } from 'react';
import { ordersService, Order } from '@/services/orders.service';
import {
    Package,
    Clock,
    CheckCircle2,
    XCircle,
    ShoppingBag,
    TrendingUp,
    Zap,
    ArrowRight,
    Loader2,
    Calendar,
    ChevronRight,
    MapPin
} from 'lucide-react';
import { toast } from 'sonner';
import { useAuthStore } from '@/store/auth.store';
import Link from 'next/link';

export default function MisComprasPage() {
    const { user } = useAuthStore();
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
            toast.error("Error cargando tus pedidos");
        } finally {
            setLoading(false);
        }
    };

    const filteredOrders = orders.filter((order: Order) => {
        if (filter === 'activos') return ['requested', 'accepted', 'pending'].includes(order.status);
        if (filter === 'completados') return ['completed', 'delivered'].includes(order.status);
        if (filter === 'cancelados') return order.status === 'rejected';
        return true;
    });

    const getStatusInfo = (status: string) => {
        switch (status) {
            case 'requested': return { bg: 'bg-secondary text-primary-foreground', text: 'text-foreground', label: 'PEDIDO', icon: <Clock size={16} /> };
            case 'pending':
            case 'accepted': return { bg: 'bg-primary text-primary-foreground', text: 'text-foreground', label: 'PREPARANDO', icon: <Package size={16} /> };
            case 'completed':
            case 'delivered': return { bg: 'bg-green-600/20 text-green-600', text: 'text-foreground', label: 'ENTREGADO', icon: <CheckCircle2 size={16} /> };
            case 'rejected': return { bg: 'bg-foreground text-background', text: 'text-foreground', label: 'CANCELADO', icon: <XCircle size={16} /> };
            default: return { bg: 'bg-foreground/5', text: 'text-foreground', label: status, icon: <Package size={16} /> };
        }
    };

    return (
        <div className="bg-background font-display text-foreground min-h-screen selection:bg-primary/20 p-4 md:p-10">
            {/* Header / Profile Hero */}
            <div className="bg-card border-b-2 border-foreground/5 py-16 px-4 md:px-10 relative overflow-hidden rounded-[3rem] shadow-neo-sm">
                <div className="absolute top-0 right-0 w-[30rem] h-[30rem] bg-primary/5 blur-[100px] -mr-32 -mt-32"></div>
                <div className="relative z-10 flex flex-col md:flex-row items-center gap-10">
                    <div className="w-32 h-32 border border-foreground/5 bg-primary text-primary-foreground flex items-center justify-center text-5xl font-bold rotate-[-3deg] hover:rotate-0 transition-transform shadow-neo rounded-[2.5rem]">
                        {user?.firstName?.charAt(0) || 'U'}
                    </div>
                    <div className="text-center md:text-left space-y-4">
                        <div className="inline-block bg-primary text-primary-foreground border border-foreground/5 px-4 py-1.5 font-bold text-[10px] tracking-[0.3em] shadow-neo-sm transform -rotate-1 mb-2 uppercase rounded-full">
                            Perfil Comprador
                        </div>
                        <h1 className="text-5xl md:text-7xl font-bold tracking-tighter leading-[0.8] uppercase italic">
                            MIS <br /><span className="text-primary italic">COMPRAS</span>
                        </h1>
                        <p className="text-xs font-bold text-foreground/30 uppercase tracking-widest pt-2">
                             {user?.firstName} {user?.lastName} • Membresía Smart
                        </p>
                    </div>
                </div>
            </div>

            <div className="grid grid-cols-1 gap-16 mt-16 max-w-7xl mx-auto">
                {/* Apartado 1: Resumen de Actividad (Stats) */}
                <section className="space-y-8">
                    <div className="flex items-center gap-4 border-b-2 border-foreground/5 pb-4">
                        <TrendingUp className="text-primary w-8 h-8" />
                        <h2 className="text-3xl font-bold tracking-tighter uppercase italic">Resumen de Actividad</h2>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        {[
                            { label: 'Total Pedidos', value: orders.length, color: 'text-foreground' },
                            { label: 'En Camino', value: orders.filter((o: any) => ['requested', 'accepted', 'pending'].includes(o.status)).length, color: 'text-primary' },
                            { label: 'Completados', value: orders.filter((o: any) => ['completed', 'delivered'].includes(o.status)).length, color: 'text-secondary' },
                            { label: 'Inversión Total', value: `$${orders.reduce((acc: any, o: any) => acc + Number(o.totalAmount), 0).toFixed(0)}`, color: 'text-primary' }
                        ].map((stat, i) => (
                            <div key={i} className="bg-card border border-foreground/5 p-8 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all rounded-[2.5rem]">
                                <p className="text-[9px] font-bold text-foreground/30 tracking-[0.3em] uppercase mb-1">{stat.label}</p>
                                <h4 className={`text-4xl font-bold tracking-tighter ${stat.color}`}>{stat.value}</h4>
                            </div>
                        ))}
                    </div>
                </section>

                {/* Apartado 2: Historial de Pedidos (Filters) */}
                <section className="space-y-10">
                    <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 border-b-2 border-foreground/5 pb-6">
                        <div className="flex items-center gap-4">
                            <Zap className="text-primary w-8 h-8" />
                            <h2 className="text-3xl font-bold tracking-tighter uppercase italic">Tus Pedidos</h2>
                        </div>
                        <div className="flex gap-4">
                            {(['activos', 'completados', 'cancelados'] as const).map((tab) => (
                                <button
                                    key={tab}
                                    onClick={() => setFilter(tab)}
                                    className={`px-6 py-2.5 border-2 font-bold text-[10px] tracking-[0.2em] uppercase transition-all rounded-xl ${filter === tab
                                        ? 'bg-foreground text-background border-foreground shadow-neo-sm -translate-y-1'
                                        : 'bg-background text-foreground/30 border-foreground/5 hover:border-foreground/20 hover:text-foreground'
                                        }`}
                                >
                                    {tab}
                                </button>
                            ))}
                        </div>
                    </div>

                    <div className="space-y-6">
                        {loading ? (
                            <div className="py-20 flex flex-col items-center justify-center gap-4 text-foreground/20">
                                <Loader2 className="animate-spin" size={48} />
                                <p className="font-bold text-[10px] tracking-[0.2em] uppercase">Rastreando paquetes...</p>
                            </div>
                        ) : filteredOrders.length === 0 ? (
                            <div className="border-4 border-foreground/5 border-dashed p-20 text-center bg-card rounded-[3rem]">
                                <Package className="w-16 h-16 mx-auto mb-4 text-foreground/5" />
                                <h3 className="text-xl font-bold text-foreground/20 italic uppercase tracking-widest">No hay pedidos en esta categoría</h3>
                                <Link href="/marketplace">
                                    <button className="mt-8 px-8 h-12 bg-primary text-primary-foreground font-bold text-[10px] tracking-[0.2em] shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all rounded-xl uppercase">
                                        Ir al marketplace
                                    </button>
                                </Link>
                            </div>
                        ) : (
                            filteredOrders.map((order: any) => {
                                const statusInfo = getStatusInfo(order.status);
                                return (
                                    <div key={order.id} className="bg-card border border-foreground/5 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all overflow-hidden flex flex-col md:flex-row rounded-[2.5rem] group">
                                        <div className={`p-8 md:w-48 flex flex-col items-center justify-center border-b md:border-b-0 md:border-r border-foreground/5 ${statusInfo.bg}`}>
                                            <Package size={40} className="mb-3 group-hover:scale-110 transition-transform opacity-80" />
                                            <span className="font-bold text-[9px] tracking-[0.3em] uppercase">{statusInfo.label}</span>
                                        </div>
                                        <div className="p-10 flex-1 flex flex-col md:flex-row justify-between gap-8 items-center">
                                            <div className="space-y-5 text-center md:text-left w-full">
                                                <div className="flex flex-col md:flex-row items-center gap-4">
                                                    <span className="bg-foreground text-background px-4 py-1 font-bold text-[9px] uppercase tracking-[0.3em] rounded-full shadow-sm">
                                                        #{order.id.slice(-6).toUpperCase()}
                                                    </span>
                                                    <span className="text-[9px] font-bold text-foreground/20 uppercase tracking-[0.2em] flex items-center gap-2">
                                                        <Calendar size={12} /> {new Date(order.createdAt).toLocaleDateString()}
                                                    </span>
                                                </div>
                                                <h4 className="text-2xl font-bold tracking-tighter leading-none uppercase italic text-foreground border-l-4 border-primary/20 pl-4 py-1">
                                                    {order.items.map((i: any) => `${i.quantity}x ${i.product?.name}`).join(' + ')}
                                                </h4>
                                                <div className="flex flex-wrap items-center justify-center md:justify-start gap-6 pt-2">
                                                    <div className="flex items-center gap-3">
                                                        <div className="w-8 h-8 bg-primary text-primary-foreground border border-foreground/5 flex items-center justify-center font-bold text-xs rotate-3 group-hover:rotate-0 transition-transform rounded-lg">
                                                            {order.seller?.firstName?.charAt(0) || 'V'}
                                                        </div>
                                                        <span className="text-[10px] font-bold text-foreground/40 uppercase tracking-widest italic hover:text-primary transition-colors cursor-default">@{((order.seller?.firstName || '') + (order.seller?.lastName || '')).replace(/\s/g, '').toLowerCase()}</span>
                                                    </div>
                                                    <div className="flex items-center gap-2 text-foreground/10">
                                                        <MapPin size={14} />
                                                        <span className="text-[10px] font-bold tracking-widest uppercase italic">Campus</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div className="flex flex-col items-center md:items-end justify-between gap-6 min-w-[180px]">
                                                <div className="text-5xl font-bold tracking-tighter text-foreground">${Number(order.totalAmount).toFixed(0)}</div>
                                                <button className="w-full h-12 bg-background text-foreground border border-foreground/10 font-bold text-[10px] tracking-[0.2em] uppercase hover:bg-foreground hover:text-background transition-all flex items-center justify-center gap-3 rounded-xl shadow-neo-sm">
                                                    VER DETALLES <ChevronRight size={16} />
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })
                        )}
                    </div>
                </section>

                {/* Apartado 3: Descubrimiento / Sugerencias (Cards) */}
                <section className="bg-card border border-foreground/5 p-12 shadow-neo-lg relative overflow-hidden rounded-[3.5rem] group min-h-[400px] flex items-center">
                    <div className="absolute top-0 right-0 w-64 h-64 bg-primary opacity-5 blur-[80px] -mr-20 -mt-20 group-hover:opacity-10 transition-opacity"></div>
                    <div className="relative z-10 flex flex-col md:flex-row items-center justify-between gap-12 w-full">
                        <div className="space-y-8 text-center md:text-left flex-1">
                            <h2 className="text-5xl md:text-7xl font-bold tracking-tighter italic leading-[0.85] uppercase">¿Hambre <br />de <span className="text-primary italic">algo nuevo?</span></h2>
                            <p className="max-w-md text-sm font-bold text-foreground/30 uppercase leading-relaxed tracking-wider border-l-4 border-primary pl-6 py-2">
                                Explora las tendencias del día y descubre emprendedores nuevos en tu facultad. Las mejores ofertas están a un clic.
                            </p>
                            <Link href="/marketplace">
                                <button className="mt-4 h-14 px-10 bg-primary text-primary-foreground font-bold text-[10px] tracking-[0.3em] uppercase border border-foreground/5 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all flex items-center gap-4 rounded-xl group/btn">
                                    IR A LA TIENDA <ArrowRight size={20} className="group-hover/btn:translate-x-2 transition-transform" />
                                </button>
                            </Link>
                        </div>
                        <div className="grid grid-cols-2 gap-6 flex-shrink-0 opacity-20 group-hover:opacity-100 transition-opacity">
                            {[1, 2, 3, 4].map(i => (
                                <div key={i} className="w-24 h-24 border border-foreground/5 bg-background rotate-6 hover:rotate-0 transition-all flex items-center justify-center grayscale group-hover:grayscale-0 rounded-2xl shadow-sm">
                                    <ShoppingBag className="text-foreground/10 group-hover:text-primary transition-colors" size={32} />
                                </div>
                            ))}
                        </div>
                    </div>
                </section>
            </div>
        </div>
    );
}
