'use client';

import { useState, useEffect } from 'react';
import { ordersService, Order } from '@/services/orders.service';
import { Package, Clock, CheckCircle2, ChevronDown, RefreshCw, HandPlatter } from 'lucide-react';
import { toast } from 'sonner';

export default function ManageOrdersPage() {
    const [orders, setOrders] = useState<Order[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<'all' | 'requested' | 'pending' | 'completed'>('all');

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
            toast.success("Pedido aceptado. A cocinar!");
            loadOrders();
        } catch (error) {
            toast.error("Error al aceptar pedido");
        }
    };

    const handleReject = async (orderId: string) => {
        try {
            await ordersService.rejectOrder(orderId);
            toast.success("Pedido rechazado");
            loadOrders();
        } catch (error) {
            toast.error("Error al rechazar");
        }
    };

    const handleDeliver = async (orderId: string) => {
        try {
            await ordersService.markAsDelivered(orderId);
            toast.success("Pedido completado!");
            loadOrders();
        } catch (error) {
            toast.error("Error al completar");
        }
    };

    const filteredOrders = orders.filter(o => {
        if (activeTab === 'all') return true;
        return o.status === activeTab;
    });

    const getStatusStyle = (status: string) => {
        switch (status) {
            case 'requested': return { bg: 'bg-neo-yellow', text: 'text-black', label: 'Nuevo' };
            case 'pending': return { bg: 'bg-neo-red', text: 'text-white', label: 'En Cocina' };
            case 'completed':
            case 'delivered': return { bg: 'bg-neo-green', text: 'text-black', label: 'Completado' };
            case 'rejected': return { bg: 'bg-black', text: 'text-white', label: 'Cancelado' };
            default: return { bg: 'bg-gray-200', text: 'text-black', label: status };
        }
    };

    return (
        <div className="bg-neo-black font-display text-white min-h-screen selection:bg-neo-yellow selection:text-black p-4 md:p-8">
            <header className="mb-10 flex flex-col md:flex-row md:items-end justify-between gap-6 border-b-4 border-white/20 pb-6">
                <div>
                    <h1 className="text-4xl md:text-6xl font-black uppercase tracking-tighter text-white mb-2">
                        Gestionar <span className="text-neo-yellow">Pedidos</span>
                    </h1>
                    <p className="font-bold text-gray-400 uppercase tracking-widest text-sm flex items-center gap-2">
                        <Clock className="w-4 h-4" /> Centro de Operaciones
                    </p>
                </div>
                <button
                    onClick={loadOrders}
                    className="bg-white text-black border-4 border-white px-4 py-2 font-black uppercase flex items-center gap-2 hover:bg-neo-yellow hover:-translate-y-1 transition-transform shadow-[4px_4px_0px_0px_#ffffff]"
                >
                    <RefreshCw className={`w-5 h-5 ${loading ? 'animate-spin' : ''}`} /> Actualizar
                </button>
            </header>

            <main className="max-w-7xl mx-auto space-y-8">
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <button
                        onClick={() => setActiveTab('all')}
                        className={`p-4 border-4 border-white flex flex-col items-center justify-center text-center transition-transform hover:-translate-y-1 ${activeTab === 'all' ? 'bg-white text-black shadow-[4px_4px_0px_0px_#FFC72C]' : 'bg-transparent text-white'}`}
                    >
                        <span className="font-black text-3xl mb-1">{orders.length}</span>
                        <span className="font-bold uppercase tracking-widest text-xs">Todos</span>
                    </button>
                    <button
                        onClick={() => setActiveTab('requested')}
                        className={`p-4 border-4 flex flex-col items-center justify-center text-center transition-transform hover:-translate-y-1 ${activeTab === 'requested' ? 'bg-neo-yellow text-black border-neo-yellow shadow-[4px_4px_0px_0px_#ffffff]' : 'border-neo-yellow text-neo-yellow'}`}
                    >
                        <span className="font-black text-3xl mb-1">{orders.filter(o => o.status === 'requested').length}</span>
                        <span className="font-bold uppercase tracking-widest text-xs">Pendientes</span>
                    </button>
                    <button
                        onClick={() => setActiveTab('pending')}
                        className={`p-4 border-4 flex flex-col items-center justify-center text-center transition-transform hover:-translate-y-1 ${activeTab === 'pending' ? 'bg-neo-red text-white border-neo-red shadow-[4px_4px_0px_0px_#ffffff]' : 'border-neo-red text-neo-red'}`}
                    >
                        <span className="font-black text-3xl mb-1">{orders.filter(o => o.status === 'pending').length}</span>
                        <span className="font-bold uppercase tracking-widest text-xs">En Cocina</span>
                    </button>
                    <button
                        onClick={() => setActiveTab('completed')}
                        className={`p-4 border-4 flex flex-col items-center justify-center text-center transition-transform hover:-translate-y-1 ${activeTab === 'completed' ? 'bg-neo-green text-black border-neo-green shadow-[4px_4px_0px_0px_#ffffff]' : 'border-neo-green text-neo-green'}`}
                    >
                        <span className="font-black text-3xl mb-1">{orders.filter(o => ['completed', 'delivered'].includes(o.status)).length}</span>
                        <span className="font-bold uppercase tracking-widest text-xs">Completados</span>
                    </button>
                </div>

                <div className="grid gap-6">
                    {loading ? (
                        [1, 2].map(i => <div key={i} className="h-48 border-4 border-white/20 bg-white/5 animate-pulse" />)
                    ) : filteredOrders.length === 0 ? (
                        <div className="border-4 border-white/20 border-dashed p-12 text-center text-gray-400 font-bold uppercase tracking-widest">
                            No hay pedidos en esta categoría
                        </div>
                    ) : (
                        filteredOrders.map(order => {
                            const style = getStatusStyle(order.status);
                            const total = Number(order.totalAmount).toFixed(2);
                            return (
                                <article key={order.id} className="bg-surface-dark border-4 border-white flex flex-col lg:flex-row shadow-[6px_6px_0px_0px_#ffffff]">
                                    <div className={`${style.bg} ${style.text} p-6 border-b-4 lg:border-b-0 lg:border-r-4 border-white flex flex-col items-center justify-center min-w-[150px]`}>
                                        <Package className="w-12 h-12 mb-2" />
                                        <div className="font-black uppercase tracking-widest text-sm text-center">
                                            {style.label}
                                        </div>
                                    </div>
                                    <div className="p-6 flex-1 flex flex-col justify-between">
                                        <div className="flex flex-col md:flex-row md:items-start justify-between gap-4 mb-4">
                                            <div>
                                                <div className="flex items-center gap-3 mb-2">
                                                    <span className="bg-white text-black px-2 py-0.5 font-bold text-xs uppercase tracking-widest">
                                                        #{order.id.slice(-6)}
                                                    </span>
                                                    <span className="text-gray-400 font-mono text-sm">
                                                        {new Date(order.createdAt).toLocaleTimeString()}
                                                    </span>
                                                </div>
                                                <h3 className="text-xl font-black uppercase mb-1">
                                                    {order.items.map(i => `${i.quantity}x ${i.product?.name}`).join(', ')}
                                                </h3>
                                                <p className="text-sm font-bold text-gray-400">
                                                    Comprador: <span className="text-white border-b-2 border-neo-red">{order.buyer?.fullName}</span>
                                                </p>
                                            </div>
                                            <div className="text-3xl font-black text-neo-yellow">${total}</div>
                                        </div>

                                        {order.deliveryMessage && (
                                            <div className="bg-white/5 border-l-4 border-neo-yellow p-3 mb-6">
                                                <p className="text-sm font-medium italic text-gray-300">
                                                    "{order.deliveryMessage}"
                                                </p>
                                            </div>
                                        )}

                                        <div className="flex justify-end gap-3 mt-auto">
                                            {order.status === 'requested' && (
                                                <>
                                                    <button onClick={() => handleReject(order.id)} className="bg-transparent border-2 border-white text-white font-bold uppercase px-4 py-2 hover:bg-white/10 transition-colors">
                                                        Rechazar
                                                    </button>
                                                    <button onClick={() => handleAccept(order.id)} className="bg-neo-yellow text-black border-2 border-neo-yellow font-black uppercase px-6 py-2 shadow-[2px_2px_0_0_#ffffff] hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-none transition-all flex items-center gap-2">
                                                        <HandPlatter className="w-4 h-4" /> Aceptar
                                                    </button>
                                                </>
                                            )}
                                            {order.status === 'pending' && (
                                                <button onClick={() => handleDeliver(order.id)} className="bg-neo-green text-black border-2 border-neo-green font-black uppercase px-6 py-2 shadow-[2px_2px_0_0_#ffffff] hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-none transition-all flex items-center gap-2">
                                                    <CheckCircle2 className="w-5 h-5" /> Marcar Entregado
                                                </button>
                                            )}
                                            {['completed', 'delivered', 'rejected'].includes(order.status) && (
                                                <button disabled className="bg-white/10 text-white/50 border-2 border-white/20 font-black uppercase px-6 py-2 cursor-not-allowed">
                                                    Sin Acción
                                                </button>
                                            )}
                                        </div>
                                    </div>
                                </article>
                            )
                        })
                    )}
                </div>
            </main>
        </div>
    );
}
