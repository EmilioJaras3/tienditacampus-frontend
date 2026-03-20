'use client';

import { useState, useEffect } from 'react';
import { ordersService, Order } from '@/services/orders.service';
import { Package, Clock, CheckCircle2, RefreshCw, HandPlatter, AlertTriangle, User, MessageCircle, DollarSign } from 'lucide-react';
import { toast } from 'sonner';
import { CloseDayDialog } from '@/components/sales/close-day-dialog';

export default function ManageOrdersPage() {
    const [orders, setOrders] = useState<Order[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<'all' | 'requested' | 'accepted' | 'completed'>('all');

    useEffect(() => {
        loadOrders();
    }, []);

    const loadOrders = async () => {
        try {
            setLoading(true);
            const data = await ordersService.getIncomingOrders();
            setOrders(data);
        } catch (error) {
            console.error("Error loading orders", error);
            toast.error("Error cargando pedidos");
        } finally {
            setLoading(false);
        }
    };

    const handleAccept = async (orderId: string) => {
        try {
            await ordersService.acceptOrder(orderId);
            toast.success("¡PEDIDO ACEPTADO! A prepararlo.", {
                icon: <HandPlatter className="text-neo-yellow" />
            });
            loadOrders();
        } catch (error) {
            toast.error("Error al aceptar pedido");
        }
    };

    const handleReject = async (orderId: string) => {
        if (!confirm('¿Seguro que quieres RECHAZAR este pedido?')) return;
        try {
            await ordersService.rejectOrder(orderId);
            toast.success("Pedido enviado a la papelera.");
            loadOrders();
        } catch (error) {
            toast.error("Error al rechazar");
        }
    };

    const handleDeliver = async (orderId: string) => {
        try {
            await ordersService.markAsDelivered(orderId);
            toast.success("¡PEDIDO ENTREGADO! ¡Felicidades por la venta!", {
                icon: <CheckCircle2 className="text-neo-green" />
            });
            loadOrders();
        } catch (error) {
            toast.error("Error al completar");
        }
    };

    const filteredOrders = orders.filter(o => {
        if (activeTab === 'all') return true;
        if (activeTab === 'completed') return ['completed', 'delivered'].includes(o.status);
        if (activeTab === 'accepted') return ['accepted', 'pending'].includes(o.status);
        return o.status === activeTab;
    });

    const getStatusInfo = (status: string) => {
        switch (status) {
            case 'requested': return { bg: 'bg-secondary', text: 'text-secondary-foreground', label: 'PENDIENTE', icon: <Clock size={16} /> };
            case 'pending':
            case 'accepted': return { bg: 'bg-primary', text: 'text-primary-foreground', label: 'PREPARANDO', icon: <HandPlatter size={16} /> };
            case 'completed':
            case 'delivered': return { bg: 'bg-accent', text: 'text-accent-foreground', label: 'ENTREGADO', icon: <CheckCircle2 size={16} /> };
            case 'rejected': return { bg: 'bg-foreground', text: 'text-background', label: 'RECHAZADO', icon: <AlertTriangle size={16} /> };
            default: return { bg: 'bg-muted', text: 'text-foreground', label: status, icon: <Package size={16} /> };
        }
    };

    return (
        <div className="p-4 md:p-10 space-y-10 font-display min-h-screen bg-background selection:bg-primary/20 text-foreground pb-24">
            {/* Header */}
            <div className="flex flex-col lg:flex-row lg:items-end justify-between gap-6 border-b-2 border-foreground/5 pb-8">
                <div className="space-y-2">
                    <div className="inline-block bg-secondary text-primary-foreground border border-foreground/5 px-4 py-1.5 font-bold text-xs tracking-[0.2em] shadow-neo-sm transform -rotate-1 mb-2 rounded-sm">
                        SELLER COMMAND CENTER
                    </div>
                    <h1 className="text-5xl md:text-7xl font-semibold tracking-tighter leading-none text-foreground uppercase">
                        GESTIÓN <span className="text-primary">VENTAS</span>
                    </h1>
                    <p className="text-lg font-bold text-foreground uppercase tracking-tight max-w-md border-l-2 border-primary pl-4">
                        Controla el flujo de tus pedidos en tiempo real.
                    </p>
                </div>
                <div className="flex items-center gap-4">
                    <CloseDayDialog onClosed={loadOrders} />
                    <button
                        onClick={loadOrders}
                        disabled={loading}
                        className="group bg-background border-2 border-foreground/10 px-8 py-4 font-bold flex items-center justify-center gap-3 hover:bg-primary hover:text-white shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all disabled:opacity-50 text-foreground rounded-2xl"
                    >
                        <RefreshCw className={`w-6 h-6 ${loading ? 'animate-spin' : ''}`} />
                        {loading ? 'ACTUALIZANDO...' : 'REFRESCAR'}
                    </button>
                </div>
            </div>

            {/* Quick Stats Tabs */}
            <div className="grid grid-cols-2 lg:grid-cols-4 gap-6">
                {[
                    { id: 'all', label: 'TODOS', count: orders.length, color: 'bg-card', text: 'text-foreground' },
                    { id: 'requested', label: 'PENDIENTES', count: orders.filter(o => o.status === 'requested').length, color: 'bg-secondary', text: 'text-secondary-foreground' },
                    { id: 'accepted', label: 'PREPARANDO', count: orders.filter(o => o.status === 'accepted' || o.status === 'pending').length, color: 'bg-primary', text: 'text-primary-foreground' },
                    { id: 'completed', label: 'COMPLETADOS', count: orders.filter(o => ['completed', 'delivered'].includes(o.status)).length, color: 'bg-accent', text: 'text-accent-foreground' }
                ].map((tab) => (
                    <button
                        key={tab.id}
                        onClick={() => setActiveTab(tab.id as any)}
                        className={`p-6 border-2 flex flex-col items-center justify-center text-center transition-all rounded-2xl ${activeTab === tab.id
                            ? `${tab.color} ${tab.text || 'text-foreground'} shadow-neo border-foreground/10 scale-105 z-10`
                            : 'bg-background text-foreground border-foreground/5 opacity-60 hover:opacity-100 hover:border-primary hover:shadow-neo-sm'
                            }`}
                    >
                        <span className={`text-5xl font-bold tracking-tighter mb-1`}>{tab.count}</span>
                        <span className="font-bold tracking-[0.2em] text-[10px] uppercase">{tab.label}</span>
                    </button>
                ))}
            </div>

            {/* Orders Feed */}
            <div className="space-y-8">
                {loading ? (
                    <div className="py-20 text-center font-bold text-foreground/20 tracking-[0.5em] animate-pulse">
                        <Package className="w-24 h-24 mx-auto mb-6" />
                        SINCRONIZANDO...
                    </div>
                ) : filteredOrders.length === 0 ? (
                    <div className="border-4 border-primary/20 border-dashed p-24 text-center bg-background rounded-3xl shadow-inner">
                        <Package className="w-24 h-24 mx-auto mb-8 text-foreground/10" />
                        <h3 className="text-4xl font-bold text-foreground">SIN PEDIDOS</h3>
                        <p className="font-bold text-primary uppercase mt-4 italic text-sm tracking-widest">Pronto llegarán clientes hambrientos</p>
                    </div>
                ) : (
                    filteredOrders.map(order => {
                        const style = getStatusInfo(order.status);
                        return (
                            <article key={order.id} className="bg-background border border-foreground/5 flex flex-col lg:grid lg:grid-cols-[220px_1fr] shadow-neo-sm group hover:-translate-y-1 transition-transform overflow-hidden rounded-3xl">
                                {/* Lateral Status / Amount */}
                                <div className={`${style.bg} ${style.text} p-10 border-b-2 lg:border-b-0 lg:border-r-2 border-foreground/10 flex flex-col items-center justify-center text-center`}>
                                    <div className="w-20 h-20 border-2 border-foreground/10 bg-background flex items-center justify-center rotate-[-8deg] mb-6 group-hover:rotate-0 transition-transform shadow-neo-sm">
                                        <DollarSign className="w-10 h-10 text-foreground" />
                                    </div>
                                    <div className="text-4xl font-bold tracking-tighter mb-2">
                                        ${Number(order.totalAmount).toFixed(2)}
                                    </div>
                                    <div className="inline-flex items-center gap-2 font-bold tracking-[0.2em] text-[10px] px-3 py-1.5 border-2 border-foreground bg-background text-foreground shadow-neo-sm rounded-sm">
                                        {style.icon} {style.label}
                                    </div>
                                </div>

                                {/* Order Info */}
                                <div className="p-8 flex flex-col">
                                    <div className="flex flex-col md:flex-row md:items-start justify-between gap-6 mb-8">
                                        <div className="space-y-3">
                                            <div className="flex items-center gap-4">
                                                <span className="bg-foreground text-background px-3 py-1 font-bold text-xs uppercase tracking-[0.3em] rounded-sm">
                                                    ORD #{order.id.slice(-6).toUpperCase()}
                                                </span>
                                                <span className="font-bold text-foreground/40 text-xs flex items-center gap-1.5 uppercase tracking-widest">
                                                    <Clock size={16} /> {new Date(order.createdAt).toLocaleTimeString()}
                                                </span>
                                            </div>
                                            <h3 className="text-3xl font-bold leading-tight text-foreground pt-2 uppercase tracking-tight">
                                                {order.items.map(i => `${i.quantity}X ${i.product?.name}`).join(' | ')}
                                            </h3>
                                        </div>
                                        <div className="bg-muted border border-foreground/10 p-4 flex flex-col min-w-[200px] hover:bg-secondary/30 transition-colors rounded-xl">
                                            <div className="flex items-center gap-2 mb-1">
                                                <User size={14} className="text-primary" />
                                                <span className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest">Cliente</span>
                                            </div>
                                            <p className="font-semibold text-sm text-foreground">{order.buyer?.firstName ? `${order.buyer.firstName} ${order.buyer.lastName || ''}` : 'ANÓNIMO'}</p>
                                        </div>
                                    </div>

                                    {order.deliveryMessage && (
                                        <div className="bg-accent/30 border border-primary/20 border-dashed p-4 mb-8 relative rounded-xl">
                                            <MessageCircle className="absolute -top-3 -left-3 text-primary fill-background" size={24} />
                                            <p className="text-sm font-bold italic text-foreground leading-snug">
                                                &quot;{order.deliveryMessage}&quot;
                                            </p>
                                        </div>
                                    )}

                                    {/* Actions */}
                                    <div className="mt-auto flex flex-col sm:flex-row justify-end gap-5 border-t-2 border-foreground/10 border-dashed pt-8">
                                        {order.status === 'requested' && (
                                            <>
                                                <button
                                                    onClick={() => handleReject(order.id)}
                                                    className="px-6 py-3 font-semibold text-xs tracking-[0.2em] text-destructive hover:bg-destructive hover:text-destructive-foreground border-2 border-transparent hover:border-destructive transition-all rounded-xl"
                                                >
                                                    Declinar Pedido
                                                </button>
                                                <button
                                                    onClick={() => handleAccept(order.id)}
                                                    className="px-8 py-3 bg-secondary text-secondary-foreground border border-foreground/10 font-semibold text-sm tracking-[0.1em] shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all flex items-center justify-center gap-2 rounded-xl"
                                                >
                                                    <HandPlatter className="w-5 h-5" /> EMPEZAR PREPARACIÓN
                                                </button>
                                            </>
                                        )}
                                        {['accepted', 'pending'].includes(order.status) && (
                                            <button
                                                onClick={() => handleDeliver(order.id)}
                                                className="w-full sm:w-auto px-10 py-4 bg-accent text-accent-foreground border border-foreground/10 font-semibold text-lg tracking-[0.1em] shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all flex items-center justify-center gap-3 rounded-xl"
                                            >
                                                <CheckCircle2 className="w-6 h-6" /> MARCAR COMO ENTREGADO
                                            </button>
                                        )}
                                        {['completed', 'delivered'].includes(order.status) && (
                                            <div className="flex items-center gap-2 px-6 py-3 bg-muted border border-foreground/10 font-semibold text-[10px] text-muted-foreground rounded-xl">
                                                <CheckCircle2 size={14} /> TRANSACCIÓN FINALIZADA
                                            </div>
                                        )}
                                        {order.status === 'rejected' && (
                                            <div className="flex items-center gap-3 px-8 py-4 bg-foreground text-background border border-foreground/10 font-bold text-xs uppercase tracking-widest rounded-xl">
                                                <AlertTriangle size={18} /> PEDIDO RECHAZADO
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </article>
                        );
                    })
                )}
            </div>
        </div>
    );
}
