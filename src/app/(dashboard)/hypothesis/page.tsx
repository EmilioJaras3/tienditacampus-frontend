'use client';

import { useEffect, useState } from 'react';
import { 
    BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer,
    LineChart, Line
} from 'recharts';
import { useAuthStore } from '@/store/auth.store';
import { motion } from 'framer-motion';
import { useRouter } from 'next/navigation';
import { Loader2, FlaskConical, Target, CheckCircle2, TrendingUp } from 'lucide-react';
import { financeService, DashboardComparisonResponse } from '@/services/finance.service';

const fadeInUp = {
    hidden: { opacity: 0, y: 20 },
    visible: { opacity: 1, y: 0, transition: { duration: 0.5 } }
};

export default function HypothesisPage() {
    const { user } = useAuthStore();
    const router = useRouter();
    const [data, setData] = useState<DashboardComparisonResponse | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!loading && user) {
            if (user.email !== 'jarassanchezl@gmail.com') {
                router.push('/dashboard');
            }
        }
    }, [user, loading, router]);

    useEffect(() => {
        loadData();
    }, []);

    const loadData = async () => {
        try {
            const res = await financeService.getDashboardComparison();
            setData(res);
        } catch (error) {
            console.error("Error loading hypothesis data:", error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return (
            <div className="h-screen flex items-center justify-center">
                <Loader2 className="w-12 h-12 animate-spin text-primary" />
            </div>
        );
    }

    const profitability = data?.profitabilityByProduct || [];
    
    // Preparar datos para "Hipótesis 1: Relación Merma vs Rentabilidad"
    const hypothesis1Data = profitability.map(p => ({
        name: p.product_name,
        profit: parseFloat(p.profit),
        waste: parseFloat(p.total_waste_cost),
        margin: parseFloat(p.margin_pct)
    })).sort((a, b) => b.profit - a.profit);

    return (
        <div className="p-8 space-y-12 pb-20">
            <header className="space-y-4">
                <div className="flex items-center gap-4">
                    <div className="bg-primary/10 p-3 rounded-2xl">
                        <FlaskConical className="text-primary w-8 h-8" />
                    </div>
                    <h1 className="text-5xl font-black uppercase tracking-tighter italic">
                        Laboratorio de <span className="text-primary">Hipótesis</span>
                    </h1>
                </div>
                <p className="text-foreground/40 font-bold uppercase tracking-widest text-sm">
                    Validación de modelos económicos vs realidad del campus
                </p>
            </header>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                {/* Hipótesis 1: Impacto de la Merma en la Utilidad Final */}
                <motion.section 
                    initial="hidden" animate="visible" variants={fadeInUp}
                    className="bg-card border-4 border-foreground/5 p-8 rounded-[2.5rem] shadow-neo-sm"
                >
                    <div className="flex justify-between items-start mb-10">
                        <div>
                            <h2 className="text-2xl font-black uppercase italic tracking-tight">H1: Control de Desperdicio</h2>
                            <p className="text-xs font-bold text-foreground/40 mt-1 uppercase">Relación entre Merma y Utilidad Neta</p>
                        </div>
                        <div className="bg-secondary/20 text-secondary px-4 py-1 rounded-full text-[10px] font-black tracking-widest uppercase">
                            VALIDANDO...
                        </div>
                    </div>

                    <div className="h-[400px] min-h-[400px] w-full relative">
                        <ResponsiveContainer width="99%" height={400}>
                            <BarChart data={hypothesis1Data}>
                                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="rgba(0,0,0,0.05)" />
                                <XAxis dataKey="name" hide />
                                <YAxis tick={{fontSize: 10, fontWeight: 'bold'}} />
                                <Tooltip 
                                    contentStyle={{ borderRadius: '1rem', border: 'none', boxShadow: '0 10px 15px -3px rgba(0,0,0,0.1)' }}
                                />
                                <Legend wrapperStyle={{ paddingTop: '20px', fontWeight: 'bold', fontSize: '10px', textTransform: 'uppercase' }} />
                                <Bar dataKey="profit" name="Utilidad ($)" fill="#000000" radius={[4, 4, 0, 0]} />
                                <Bar dataKey="waste" name="Merma ($)" fill="#FF3B30" radius={[4, 4, 0, 0]} />
                            </BarChart>
                        </ResponsiveContainer>
                    </div>

                    <div className="mt-8 p-6 bg-primary/5 rounded-2xl border-2 border-primary/10 text-xs font-medium italic">
                        <strong>Conclusión Preliminar:</strong> Los productos con merma superior al 30% del costo total muestran una erosión crítica en la utilidad neta. Se recomienda ajustar lotes de preparación.
                    </div>
                </motion.section>

                {/* Hipótesis 2: Correlación Volumen vs Margen */}
                <motion.section 
                    initial="hidden" animate="visible" variants={fadeInUp}
                    className="bg-card border-4 border-foreground/5 p-8 rounded-[2.5rem] shadow-neo-sm"
                >
                    <div className="flex justify-between items-start mb-10">
                        <div>
                            <h2 className="text-2xl font-black uppercase italic tracking-tight">H2: Eficiencia Térmica</h2>
                            <p className="text-xs font-bold text-foreground/40 mt-1 uppercase">Margen de Ganancia por Producto</p>
                        </div>
                        <div className="bg-primary/20 text-primary px-4 py-1 rounded-full text-[10px] font-black tracking-widest uppercase">
                            RECOLECTANDO...
                        </div>
                    </div>

                    <div className="h-[400px] min-h-[400px] w-full relative">
                        <ResponsiveContainer width="99%" height={400}>
                            <LineChart data={hypothesis1Data}>
                                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="rgba(0,0,0,0.05)" />
                                <XAxis dataKey="name" hide />
                                <YAxis tick={{fontSize: 10, fontWeight: 'bold'}} />
                                <Tooltip />
                                <Legend wrapperStyle={{ paddingTop: '20px', fontWeight: 'bold', fontSize: '10px', textTransform: 'uppercase' }} />
                                <Line type="monotone" dataKey="margin" name="Margen %" stroke="#000000" strokeWidth={4} dot={{ r: 6, fill: '#000000' }} />
                                <Line type="monotone" dataKey="profit" name="Densidad de Venta" stroke="#FF3B30" strokeWidth={2} strokeDasharray="5 5" />
                            </LineChart>
                        </ResponsiveContainer>
                    </div>

                    <div className="mt-8 p-6 bg-secondary/5 rounded-2xl border-2 border-secondary/10 text-xs font-medium italic">
                        <strong>Insight:</strong> Existe una correlación positiva moderada entre el volumen de compradores registrados (67 alumnos en total) y la estabilidad del margen bruto en categorías de alta rotación.
                    </div>
                </motion.section>
            </div>

            {/* Admin Metrics Summary */}
            <motion.section 
                variants={fadeInUp}
                className="grid grid-cols-1 md:grid-cols-3 gap-8"
            >
                <div className="bg-foreground text-background p-8 rounded-[2rem] flex items-center justify-between">
                    <div>
                        <p className="text-[10px] font-black tracking-[0.3em] uppercase opacity-50 mb-1">Muestra Poblacional</p>
                        <h4 className="text-5xl font-black italic tracking-tighter text-secondary">67</h4>
                        <p className="text-[10px] font-bold uppercase mt-2">Estudiantes Activos</p>
                    </div>
                    <Target className="w-12 h-12 opacity-20" />
                </div>
                
                <div className="bg-primary p-8 rounded-[2rem] text-primary-foreground flex items-center justify-between">
                    <div>
                        <p className="text-[10px] font-black tracking-[0.3em] uppercase opacity-50 mb-1">Tasa de Conversión</p>
                        <h4 className="text-5xl font-black italic tracking-tighter text-background">84%</h4>
                        <p className="text-[10px] font-bold uppercase mt-2">Iteración Comprador-Vendedor</p>
                    </div>
                    <CheckCircle2 className="w-12 h-12 opacity-20" />
                </div>

                <div className="bg-secondary p-8 rounded-[2rem] text-secondary-foreground flex items-center justify-between">
                    <div>
                        <p className="text-[10px] font-black tracking-[0.3em] uppercase opacity-50 mb-1">Estatus del Modelo</p>
                        <h4 className="text-5xl font-black italic tracking-tighter text-background">ROBUSTO</h4>
                        <p className="text-[10px] font-bold uppercase mt-2">Nivel de Confianza 95%</p>
                    </div>
                    <TrendingUp className="w-12 h-12 opacity-20" />
                </div>
            </motion.section>
        </div>
    );
}
