'use client';

import { useEffect, useState } from 'react';
import { Package, TrendingUp, ChevronRight, Loader2, DollarSign, ShoppingBasket, Rocket, Target, Trash2 } from "lucide-react";
import { salesService, RoiStats, DailySale } from '@/services/sales.service';
import { ordersService, Order } from '@/services/orders.service';
import { financeService, DashboardComparisonResponse } from '@/services/finance.service';
import { useAuthStore } from '@/store/auth.store';
import Link from 'next/link';
import { toast } from 'sonner';
import { motion, AnimatePresence } from 'framer-motion';

// Variantes de animación
const fadeInUp: any = {
    hidden: { opacity: 0, y: 30 },
    visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: "easeOut" } },
    exit: { opacity: 0, y: -20, transition: { duration: 0.3 } }
};

const staggerContainer = {
    hidden: { opacity: 0 },
    visible: {
        opacity: 1,
        transition: {
            staggerChildren: 0.1
        }
    }
};

const scaleIn: any = {
    hidden: { opacity: 0, scale: 0.9 },
    visible: { opacity: 1, scale: 1, transition: { duration: 0.5, type: "spring", bounce: 0.4 } }
};

export default function DashboardPage() {
    const { user } = useAuthStore();
    const [stats, setStats] = useState<RoiStats | null>(null);
    const [todaySale, setTodaySale] = useState<DailySale | null>(null);
    const [orders, setOrders] = useState<Order[]>([]);
    const [comparison, setComparison] = useState<DashboardComparisonResponse | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadDashboardData();
    }, []);

    const loadDashboardData = async () => {
        setLoading(true);
        try {
            const [statsData, ordersData, todayData] = await Promise.all([
                salesService.getRoiStats('', ''),
                ordersService.getIncomingOrders(),
                salesService.getToday()
            ]);

            const comparisonData = await financeService.getDashboardComparison();
            setStats(statsData);
            setOrders(ordersData);
            setTodaySale(todayData);
            setComparison(comparisonData);
        } catch (error) {
            console.error("Error loading dashboard:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleAccept = async (orderId: string) => {
        try {
            await ordersService.acceptOrder(orderId);
            toast.success('¡Aceptado! Manos a la obra.');
            loadDashboardData();
        } catch (e) {
            toast.error('Error al aceptar');
        }
    };

    const handleReject = async (orderId: string) => {
        try {
            await ordersService.rejectOrder(orderId);
            toast.success('Pedido rechazado');
            loadDashboardData();
        } catch (e) {
            toast.error('Error al rechazar');
        }
    };

    const pendingOrders = orders.filter((o: Order) => o.status === 'requested' || o.status === 'accepted' || o.status === 'pending');

    const toMoney = (value?: string | number) => Number(value || 0).toFixed(2);

    if (loading && !stats) {
        return (
            <div className="h-screen flex flex-col items-center justify-center bg-background gap-6">
                <motion.div 
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                    className="w-20 h-20 border-8 border-foreground/5 border-t-primary rounded-full"
                />
                <motion.p 
                    animate={{ opacity: [0.5, 1, 0.5] }}
                    transition={{ duration: 1.5, repeat: Infinity, ease: "easeInOut" }}
                    className="font-bold tracking-[0.5em] text-foreground uppercase"
                >
                    Preparando tu Despacho...
                </motion.p>
            </div>
        );
    }

    return (
        <motion.div 
            initial="hidden"
            animate="visible"
            variants={staggerContainer}
            className="font-display selection:bg-primary/20 text-foreground bg-background min-h-screen p-4 md:p-10 pb-24 space-y-16 overflow-x-hidden"
        >
            {/* Header / Hero Section */}
            <motion.header variants={fadeInUp} className="flex flex-col md:flex-row md:items-end justify-between gap-8 border-b-2 border-foreground/5 pb-10">
                <div className="space-y-4">
                    <div className="flex items-center gap-4">
                        <motion.div 
                            whileHover={{ rotate: 0 }}
                            className="bg-primary text-primary-foreground border border-foreground/5 px-4 py-1.5 font-bold text-[10px] tracking-[0.3em] shadow-neo-sm transform -rotate-1 rounded-full cursor-default"
                        >
                            ESTADO: ONLINE
                        </motion.div>
                        <div className="flex items-center gap-2">
                            <motion.div 
                                animate={{ scale: [1, 1.2, 1] }}
                                transition={{ duration: 2, repeat: Infinity }}
                                className="w-2.5 h-2.5 bg-secondary rounded-full shadow-sm"
                            />
                            <span className="text-[10px] font-bold text-foreground/30 uppercase tracking-widest">Live Server</span>
                        </div>
                    </div>
                    <h1 className="text-7xl md:text-9xl font-bold tracking-tighter leading-[0.8] uppercase">
                        ¡HOLA, <br />
                        <span className="text-primary italic">{user?.firstName}!</span>
                    </h1>
                </div>
                <div className="flex flex-col items-end gap-3 text-right">
                    <motion.p 
                        whileHover={{ rotate: 0 }}
                        className="font-bold text-background uppercase tracking-[0.3em] text-[10px] bg-foreground border border-foreground/5 px-5 py-2 shadow-neo-sm transform rotate-1 rounded-sm cursor-default"
                    >
                        {new Date().toLocaleDateString('es-MX', { weekday: 'long', month: 'long', day: '2-digit', year: 'numeric' }).toUpperCase()}
                    </motion.p>
                    <p className="text-[10px] font-bold text-foreground/20 uppercase tracking-[0.2em] italic">Panel de Control de Ventas</p>
                </div>
            </motion.header>
            
            {/* Admin Evaluation Section */}
            {user?.email === 'jarassanchezl@gmail.com' && (
                <motion.section 
                    variants={fadeInUp}
                    className="bg-neo-yellow border-4 border-black p-8 shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] rounded-xl relative overflow-hidden"
                >
                    <div className="absolute top-2 right-2 flex gap-2">
                        <div className="w-4 h-4 rounded-full border-2 border-black bg-neo-red"></div>
                        <div className="w-4 h-4 rounded-full border-2 border-black bg-neo-blue"></div>
                    </div>
                    
                    <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                        <div className="space-y-2">
                            <h2 className="text-3xl md:text-4xl font-black uppercase tracking-tighter">
                                EVALUACIÓN - UNIDAD 2
                            </h2>
                            <p className="text-xl font-bold uppercase tracking-tight">
                                IMPLEMENTACIÓN DE BENCHMARKING
                            </p>
                            <div className="flex flex-wrap items-center gap-4 pt-2">
                                <span className="bg-black text-white px-3 py-1 text-xs font-bold uppercase rounded">
                                    Horacio Irán Solís Cisneros
                                </span>
                                <span className="bg-white border-2 border-black px-3 py-1 text-xs font-bold uppercase rounded flex items-center gap-2">
                                    <span className="w-2 h-2 bg-neo-red rounded-full"></span>
                                    22 FEB
                                </span>
                                <span className="bg-neo-blue text-white px-3 py-1 text-xs font-bold uppercase rounded border-2 border-black">
                                    100 PUNTOS
                                </span>
                            </div>
                        </div>
                        
                        <div className="bg-white border-4 border-black p-4 rotate-2 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] max-w-sm">
                            <p className="font-bold text-xs uppercase underline mb-2">Instrucciones:</p>
                            <p className="text-[10px] font-bold uppercase leading-tight">
                                Implementar la estructura de base de datos descrita en el documento, ejecutar pruebas controladas y enviar métricas a BigQuery utilizando autenticación OAuth.
                            </p>
                        </div>
                    </div>
                </motion.section>
            )}

            {/* Main Stats Grid */}
            <motion.section variants={staggerContainer} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10">
                {/* Pending Orders Card */}
                <motion.article 
                    variants={scaleIn}
                    whileHover={{ y: -5, scale: 1.02 }}
                    className="bg-primary text-primary-foreground p-8 shadow-neo hover:shadow-neo-lg transition-all flex flex-col justify-between min-h-[300px] rounded-[3rem] relative overflow-hidden group cursor-pointer"
                >
                    <div className="absolute -right-10 -bottom-10 opacity-10 transition-transform duration-500 group-hover:scale-110 group-hover:rotate-12">
                        <ShoppingBasket className="w-48 h-48" />
                    </div>
                    <div className="flex justify-between items-start relative z-10">
                        <h3 className="font-bold tracking-[0.3em] text-[10px] uppercase">Pedidos por atender</h3>
                        <motion.div whileHover={{ rotate: 15, scale: 1.2 }}>
                            <ShoppingBasket className="w-8 h-8" />
                        </motion.div>
                    </div>
                    <div className="relative z-10">
                        <div className="text-8xl font-bold tracking-tighter leading-none mb-4">
                            {pendingOrders.length}
                        </div>
                        <Link href="/sales" className="inline-flex items-center gap-2 font-bold text-[10px] border-b-2 border-primary-foreground/50 pb-1 hover:gap-4 transition-all uppercase tracking-widest">
                            GESTIONAR VENTAS <ChevronRight size={18} />
                        </Link>
                    </div>
                </motion.article>

                {[
                    { label: 'Ventas Totales', value: `$${toMoney(stats?.revenue)}`, icon: DollarSign, color: 'text-foreground', sub: 'Ingresos brutos' },
                    { label: 'Costos Totales', value: `$${toMoney((stats?.revenue || 0) - (stats?.netProfit || 0))}`, icon: Package, color: 'text-primary', sub: 'Gastos operativos' },
                    { label: 'Ganancia Neta', value: `$${toMoney(stats?.netProfit)}`, icon: TrendingUp, color: (stats?.netProfit || 0) < 0 ? 'text-primary' : 'text-secondary', sub: 'Utilidad real', highlight: true },
                    { label: 'Margen de Ganancia', value: stats?.revenue ? `${((Number(stats.netProfit) / Number(stats.revenue)) * 100).toFixed(1)}%` : '0%', icon: Target, color: 'text-foreground', sub: 'Rentabilidad' },
                    { label: 'Merma Acumulada', value: `$${toMoney(todaySale?.totalWasteCost)}`, icon: Trash2, color: 'text-primary', sub: 'Pérdida por desperdicio' }
                ].map((stat, i) => (
                    <motion.article 
                        key={i} 
                        variants={scaleIn}
                        whileHover={{ y: -5 }}
                        className={`bg-card border border-foreground/5 p-8 shadow-neo-sm hover:shadow-neo transition-all flex flex-col justify-between min-h-[250px] rounded-[2.5rem] relative overflow-hidden cursor-default ${stat.highlight ? 'ring-2 ring-primary/5' : ''}`}
                    >
                        {stat.highlight && <div className="absolute -right-8 -bottom-8 w-40 h-40 bg-primary/5 rounded-full blur-3xl"></div>}
                        <div className="flex justify-between items-start relative z-10">
                            <h3 className="font-bold tracking-[0.3em] text-[10px] uppercase text-foreground/30">{stat.label}</h3>
                            <motion.div whileHover={{ scale: 1.2, rotate: 10 }}>
                                <stat.icon className={`w-8 h-8 ${stat.label === 'Ganancia Neta' ? 'text-secondary' : 'text-primary/40'}`} />
                            </motion.div>
                        </div>
                        <div className="relative z-10">
                            <div className={`text-6xl font-bold tracking-tighter leading-none mb-4 ${stat.color}`}>
                                {stat.value}
                            </div>
                            <p className="font-bold uppercase text-[9px] text-foreground/20 tracking-widest flex items-center gap-1.5">
                                {stat.sub}
                            </p>
                        </div>
                    </motion.article>
                ))}
            </motion.section>

            {/* Quick Content Section */}
            <div className="grid grid-cols-1 lg:grid-cols-5 gap-10">
                <motion.section variants={fadeInUp} className="lg:col-span-12 space-y-8">
                    <div className="flex items-center justify-between border-b-2 border-foreground/5 pb-6">
                        <h2 className="text-4xl font-bold tracking-tighter flex items-center gap-4 uppercase italic">
                            <motion.div animate={{ y: [-2, 2, -2] }} transition={{ duration: 4, repeat: Infinity }}>
                                <Rocket className="text-primary w-10 h-10" />
                            </motion.div>
                            Pedidos Recientes
                        </h2>
                        <Link href="/sales">
                            <motion.button 
                                whileHover={{ scale: 1.05, rotate: 0 }}
                                whileTap={{ scale: 0.95 }}
                                className="text-[10px] font-bold text-foreground border-2 border-foreground/10 px-6 py-2.5 hover:bg-foreground hover:text-background transition-all uppercase tracking-[0.3em] shadow-neo-sm transform -rotate-1 rounded-xl"
                            >
                                Ver Todo
                            </motion.button>
                        </Link>
                    </div>

                    <AnimatePresence mode="popLayout">
                        {orders.length === 0 ? (
                            <motion.div 
                                initial={{ opacity: 0, scale: 0.9 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.9 }}
                                className="bg-card border-2 border-dashed border-foreground/10 p-20 text-center rounded-[3rem]"
                            >
                                <motion.div animate={{ y: [0, -10, 0] }} transition={{ duration: 3, repeat: Infinity }}>
                                    <ShoppingBasket size={48} className="mx-auto text-foreground/10 mb-6" />
                                </motion.div>
                                <h3 className="text-2xl font-bold tracking-tighter text-foreground/30 uppercase italic">Sin pedidos hoy</h3>
                                <p className="mt-4 text-[10px] font-bold text-foreground/20 uppercase tracking-widest">Cuando tus compañeros compren, aparecerán aquí.</p>
                            </motion.div>
                        ) : (
                            <motion.div 
                                variants={staggerContainer}
                                initial="hidden"
                                animate="visible"
                                className="grid grid-cols-1 md:grid-cols-2 gap-6"
                            >
                                {orders.slice(0, 4).map((order: Order) => (
                                    <motion.article 
                                        key={order.id}
                                        variants={scaleIn}
                                        layout
                                        className="bg-card border border-foreground/5 p-8 shadow-neo-sm hover:shadow-neo transition-all rounded-[2.5rem] group"
                                    >
                                        <div className="flex items-center justify-between mb-6">
                                            <div className="flex items-center gap-4">
                                                <div className="w-12 h-12 bg-primary text-primary-foreground border border-foreground/5 flex items-center justify-center font-bold text-lg rotate-[-3deg] rounded-2xl group-hover:rotate-0 transition-transform">
                                                    {(order.buyer && order.buyer.firstName) ? order.buyer.firstName.charAt(0) : 'U'}
                                                </div>
                                                <div>
                                                    <p className="font-bold tracking-tight text-foreground uppercase italic">{order.buyer?.firstName} {order.buyer?.lastName}</p>
                                                    <p className="text-[9px] font-medium text-foreground/30 uppercase tracking-widest">{new Date(order.createdAt).toLocaleTimeString()}</p>
                                                </div>
                                            </div>
                                            <div className={`px-4 py-1.5 rounded-full text-[9px] font-bold uppercase tracking-widest border border-foreground/5 ${
                                                order.status === 'requested' ? 'bg-primary text-primary-foreground shadow-neo-sm' : 'bg-secondary text-secondary-foreground'
                                            }`}>
                                                {order.status === 'requested' ? 'SOLICITADO' : order.status.toUpperCase()}
                                            </div>
                                        </div>
                                        
                                        <div className="space-y-4 mb-8">
                                            {order.items?.map((item, idx) => (
                                                <div key={idx} className="flex justify-between items-center text-sm border-b border-foreground/5 pb-2">
                                                    <span className="font-bold text-foreground/60">{item.quantity}x {item.product?.name}</span>
                                                    <span className="font-bold text-foreground tracking-tighter">${toMoney(item.subtotal)}</span>
                                                </div>
                                            ))}
                                            <div className="flex justify-between items-center pt-2">
                                                <span className="text-[10px] font-bold uppercase tracking-widest text-foreground/30">Total del Pedido</span>
                                                <span className="text-2xl font-bold text-primary tracking-tighter">${toMoney(order.totalAmount)}</span>
                                            </div>
                                        </div>

                                        {order.status === 'requested' && (
                                            <div className="flex gap-4">
                                                <motion.button 
                                                    whileHover={{ scale: 1.02, y: -2 }}
                                                    whileTap={{ scale: 0.98 }}
                                                    onClick={() => handleAccept(order.id)}
                                                    className="flex-1 h-14 bg-foreground text-background font-bold text-xs uppercase tracking-[0.2em] shadow-neo-sm hover:shadow-neo transition-all rounded-xl"
                                                >
                                                    ACEPTAR
                                                </motion.button>
                                                <motion.button 
                                                    whileHover={{ scale: 1.02 }}
                                                    whileTap={{ scale: 0.98 }}
                                                    onClick={() => handleReject(order.id)}
                                                    className="px-8 h-14 border-2 border-foreground/10 text-foreground/40 font-bold text-xs uppercase hover:text-primary hover:border-primary transition-all rounded-xl"
                                                >
                                                    IGNORAR
                                                </motion.button>
                                            </div>
                                        )}
                                    </motion.article>
                                ))}
                            </motion.div>
                        )}
                    </AnimatePresence>
                </motion.section>

                {/* Secondary Stats/Analysis */}
                <motion.article variants={fadeInUp} className="lg:col-span-12 bg-background border border-foreground/5 p-10 shadow-sm text-foreground rounded-[3rem]">
                    <h3 className="font-bold text-2xl tracking-tighter mb-10 text-foreground uppercase italic border-b-2 border-foreground/5 pb-4">Rentabilidad por Producto</h3>
                    <div className="space-y-4">
                        {(comparison?.profitabilityByProduct || []).slice(0, 5).map((item: any, i: number) => (
                            <motion.div 
                                key={item.product_id} 
                                initial={{ opacity: 0, x: -20 }}
                                animate={{ opacity: 1, x: 0 }}
                                transition={{ delay: i * 0.1 }}
                                whileHover={{ scale: 1.01, x: 10 }}
                                className="grid grid-cols-[1fr_auto_auto_auto] gap-8 bg-card border border-foreground/5 p-6 text-sm text-foreground items-center hover:bg-primary/5 transition-all rounded-2xl group shadow-sm cursor-default"
                            >
                                <span className="font-bold truncate text-foreground uppercase tracking-tight text-lg italic">{item.product_name}</span>
                                <div className="flex flex-col items-end">
                                    <span className="text-[9px] font-bold text-foreground/20 uppercase tracking-widest">Utilidad</span>
                                    <span className="font-bold text-foreground text-lg">${toMoney(item.profit)}</span>
                                </div>
                                <div className="flex flex-col items-end">
                                    <span className="text-[9px] font-bold text-foreground/20 uppercase tracking-widest">Merma</span>
                                    <span className="font-bold text-primary text-lg">-${toMoney(item.total_waste_cost)}</span>
                                </div>
                                <div className="bg-primary text-primary-foreground px-4 py-2 rounded-xl text-center shadow-sm font-bold tracking-tighter text-lg group-hover:scale-110 transition-transform">
                                    {Number(item.margin_pct || 0).toFixed(1)}%
                                </div>
                            </motion.div>
                        ))}
                        {(!comparison?.profitabilityByProduct || comparison.profitabilityByProduct.length === 0) && (
                            <p className="text-xs font-bold text-foreground/20 uppercase tracking-widest italic text-center py-12">Sin datos de rentabilidad en el periodo.</p>
                        )}
                    </div>
                </motion.article>
            </div>
        </motion.div>
    );
}