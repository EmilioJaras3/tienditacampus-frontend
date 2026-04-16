'use client';

import { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { Loader2, BrainCircuit, CalendarDays, TrendingUp, AlertCircle, ShoppingBag } from 'lucide-react';
import { forecastService } from '@/services/forecast.service';
import { productsService, Product } from '@/services/products.service';
import { Label } from '@/components/ui/label';
import { Button } from '@/components/ui/button';

const fadeInUp = {
    hidden: { opacity: 0, y: 20 },
    visible: { opacity: 1, y: 0, transition: { duration: 0.5 } }
};

const daysOfWeek = [
    { value: 1, label: 'Lunes' },
    { value: 2, label: 'Martes' },
    { value: 3, label: 'Miércoles' },
    { value: 4, label: 'Jueves' },
    { value: 5, label: 'Viernes' },
    { value: 6, label: 'Sábado' },
    { value: 7, label: 'Domingo' }
];

export default function ForecastPage() {
    const [products, setProducts] = useState<Product[]>([]);
    const [selectedProductId, setSelectedProductId] = useState<string>('');
    const [selectedDay, setSelectedDay] = useState<number>(new Date().getDay() || 7);
    
    const [loadingProducts, setLoadingProducts] = useState(true);
    const [calculating, setCalculating] = useState(false);
    const [error, setError] = useState('');
    const [prediction, setPrediction] = useState<number | null>(null);

    useEffect(() => {
        loadProducts();
    }, []);

    const loadProducts = async () => {
        try {
            const data = await productsService.getAll();
            setProducts(data);
            if (data.length > 0) setSelectedProductId(data[0].id);
        } catch (err) {
            console.error('Error loading products for forecast:', err);
            setError('Error al cargar productos. Por favor, intenta de nuevo.');
        } finally {
            setLoadingProducts(false);
        }
    };

    const handleCalculate = async () => {
        if (!selectedProductId) return;
        setCalculating(true);
        setError('');
        setPrediction(null);
        
        try {
            const result = await forecastService.getForecast(selectedProductId, selectedDay);
            setPrediction(result);
        } catch (err: any) {
            console.error('Error calculating forecast:', err);
            setError(err?.message || 'Error calculando la predicción (IQR no convergió o datos insuficientes).');
        } finally {
            setCalculating(false);
        }
    };

    if (loadingProducts) {
        return (
            <div className="h-screen flex items-center justify-center">
                <Loader2 className="w-12 h-12 animate-spin text-primary" />
            </div>
        );
    }

    return (
        <div className="p-8 space-y-12 pb-20">
            <header className="space-y-4">
                <div className="flex items-center gap-4">
                    <div className="bg-primary/10 p-3 rounded-2xl">
                        <BrainCircuit className="text-primary w-8 h-8" />
                    </div>
                    <h1 className="text-5xl font-black uppercase tracking-tighter italic">
                        Modelo de <span className="text-primary">Predicción</span>
                    </h1>
                </div>
                <p className="text-foreground/40 font-bold uppercase tracking-widest text-sm">
                    Filtro Intercuartílico (IQR) para optimización de inventario
                </p>
            </header>

            <motion.div 
                initial="hidden" animate="visible" variants={fadeInUp}
                className="grid grid-cols-1 lg:grid-cols-2 gap-8"
            >
                {/* Configuración del Modelo */}
                <section className="bg-card border-4 border-foreground/5 p-8 rounded-[2.5rem] shadow-neo-sm space-y-8">
                    <div className="mb-2">
                        <h2 className="text-2xl font-black uppercase italic tracking-tight">Análisis Predictivo</h2>
                        <p className="text-xs font-bold text-foreground/40 uppercase mt-1">Configura las variables objetivo</p>
                    </div>

                    {error && (
                        <div className="bg-destructive/10 text-destructive p-4 rounded-xl flex items-center text-sm font-bold border border-destructive/20 uppercase tracking-wide">
                            <AlertCircle className="w-5 h-5 mr-3 shrink-0" />
                            {error}
                        </div>
                    )}

                    <div className="space-y-6">
                        <div className="space-y-3">
                            <Label className="text-xs font-black uppercase tracking-widest text-foreground/60 flex items-center gap-2">
                                <ShoppingBag className="w-4 h-4" /> Producto a analizar
                            </Label>
                            <select 
                                value={selectedProductId}
                                onChange={(e) => setSelectedProductId(e.target.value)}
                                className="w-full flex h-14 w-full rounded-2xl border-4 border-foreground/10 bg-background px-4 py-2 text-sm font-bold uppercase ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:border-primary disabled:cursor-not-allowed disabled:opacity-50 transition-colors"
                            >
                                {products.length === 0 && <option value="">No tienes productos...</option>}
                                {products.map((p) => (
                                    <option key={p.id} value={p.id}>{p.name}</option>
                                ))}
                            </select>
                        </div>

                        <div className="space-y-3">
                            <Label className="text-xs font-black uppercase tracking-widest text-foreground/60 flex items-center gap-2">
                                <CalendarDays className="w-4 h-4" /> Proyectar hacia Día de la Semana
                            </Label>
                            <div className="grid grid-cols-2 lg:grid-cols-4 gap-2">
                                {daysOfWeek.map(day => (
                                    <button
                                        key={day.value}
                                        onClick={() => setSelectedDay(day.value)}
                                        className={`py-3 px-2 rounded-xl text-[10px] font-black uppercase tracking-wider transition-all border-2 ${
                                            selectedDay === day.value 
                                                ? 'bg-foreground text-background border-foreground shadow-md' 
                                                : 'bg-background text-foreground/60 border-foreground/10 hover:border-primary/50 hover:text-foreground'
                                        }`}
                                    >
                                        {day.label}
                                    </button>
                                ))}
                            </div>
                        </div>

                        <Button 
                            onClick={handleCalculate}
                            disabled={calculating || !selectedProductId}
                            className="w-full h-16 rounded-2xl text-lg uppercase font-black tracking-widest shadow-neo bg-primary text-primary-foreground hover:bg-primary/90 mt-4 active:translate-y-1 active:shadow-none transition-all"
                        >
                            {calculating ? (
                                <><Loader2 className="w-6 h-6 mr-3 animate-spin" /> PROCESANDO MATRIZ (IQR)</>
                            ) : (
                                "GENERAR PREDICCIÓN"
                            )}
                        </Button>
                    </div>
                </section>

                {/* Resultado */}
                <section className={`flex flex-col items-center justify-center p-8 rounded-[2.5rem] border-4 transition-all duration-500 min-h-[400px] shadow-neo-sm relative overflow-hidden ${prediction !== null ? 'bg-secondary text-secondary-foreground border-transparent' : 'bg-transparent border-dashed border-foreground/20 text-foreground/40'}`}>
                    {prediction !== null ? (
                        <div className="text-center z-10 space-y-6">
                            <div className="inline-block bg-background/20 backdrop-blur-md px-6 py-2 rounded-full font-black text-xs uppercase tracking-[0.3em] shadow-sm mb-4">
                                Proyección Exitosa
                            </div>
                            <h3 className="text-sm font-bold uppercase tracking-widest opacity-80">
                                Producción Sugerida para el día {daysOfWeek.find(d => d.value === selectedDay)?.label}
                            </h3>
                            <div className="flex items-center justify-center gap-4">
                                <span className="text-8xl md:text-[8rem] font-black italic tracking-tighter leading-none drop-shadow-md">
                                    {prediction}
                                </span>
                                <span className="text-2xl font-black uppercase tracking-widest leading-none rotate-90 transform translate-y-4 opacity-50">UNIDADES</span>
                            </div>
                            <p className="text-xs font-bold w-3/4 mx-auto opacity-75 mt-8 px-4 bg-background/10 py-3 rounded-xl border border-background/20">
                                Esta recomendación excluye días atípicos aplicando el filtro de Rango Intercuartílico (IQR) sobre el historial reciente.
                            </p>
                        </div>
                    ) : (
                        <div className="text-center z-10 flex flex-col items-center">
                            <TrendingUp className="w-24 h-24 opacity-20 mb-6" />
                            <h3 className="text-2xl font-black uppercase tracking-tighter italic">Esperando Variables</h3>
                            <p className="text-xs font-bold uppercase tracking-widest mt-2 px-8">
                                Configura el producto y el día para obtener la recomendación con el modelo Predictivo Estadístico.
                            </p>
                        </div>
                    )}
                </section>
            </motion.div>
        </div>
    );
}
