'use client';

import { Package, Store, Users, Zap, ShieldCheck, TrendingUp } from 'lucide-react';
import Link from 'next/link';
import { motion } from 'framer-motion';

// Variantes de animación
const fadeInUp = {
    hidden: { opacity: 0, y: 40 },
    visible: { opacity: 1, y: 0, transition: { duration: 0.8, ease: "easeOut" } }
};

const staggerContainer = {
    hidden: { opacity: 0 },
    visible: {
        opacity: 1,
        transition: {
            staggerChildren: 0.2
        }
    }
};

const floatAnimation = {
    initial: { y: 0 },
    animate: {
        y: [-10, 10, -10],
        transition: { duration: 6, repeat: Infinity, ease: "easeInOut" }
    }
};

export default function Home() {
    return (
        <div className="bg-background text-foreground font-display min-h-screen flex flex-col selection:bg-primary/20 pt-16 overflow-x-hidden">
            {/* Banner superior animado */}
            <div className="bg-primary text-primary-foreground overflow-hidden py-3 border-b border-foreground/5 z-40">
                <div className="whitespace-nowrap flex animate-marquee font-bold text-[10px] tracking-[0.4em] uppercase">
                    {[1, 2, 3, 4, 5, 6, 7, 8].map(i => (
                        <span key={i} className="mx-8">COMPRA SNACKS Y COMIDA A TUS COMPAÑEROS UNIVERSITARIOS • VENDE TUS PRODUCTOS SIN INTERMEDIARIOS</span>
                    ))}
                </div>
            </div>

            <header className="relative overflow-hidden pt-12 pb-24 lg:pt-20 lg:pb-32">
                <div className="absolute inset-0 z-0 opacity-5" style={{ backgroundImage: 'radial-gradient(var(--primary) 1.5px, transparent 1.5px)', backgroundSize: '30px 30px' }}></div>
                <div className="max-w-7xl mx-auto px-6 lg:px-10 relative z-10">
                    <div className="grid grid-cols-1 lg:grid-cols-12 gap-16 items-center">
                        <motion.div 
                            className="lg:col-span-7 flex flex-col items-start text-left space-y-8"
                            variants={staggerContainer}
                            initial="hidden"
                            animate="visible"
                        >
                            <motion.div variants={fadeInUp} className="inline-block px-5 py-2 border border-primary/20 text-primary font-bold text-[10px] uppercase tracking-[0.3em] bg-primary/5 rounded-full shadow-sm">
                                La red #1 de emprendedores universitarios
                            </motion.div>
                            <motion.h1 
                                variants={fadeInUp}
                                className="text-6xl md:text-8xl font-bold tracking-tighter leading-[0.85] uppercase italic text-foreground"
                            >
                                <span className="text-primary italic underline decoration-primary/20 decoration-[12px] underline-offset-[12px]">COMPRA</span> <br />
                                A COMPAÑEROS, <br />
                                <span className="text-secondary italic">SIN INTERMEDIARIOS</span>
                            </motion.h1>
                            <motion.p 
                                variants={fadeInUp}
                                className="text-lg md:text-xl text-foreground/40 max-w-lg font-bold leading-relaxed border-l-4 border-primary pl-8 py-2 uppercase tracking-tight"
                            >
                                Compra snacks y comida artesanal a tus compañeros universitarios. Vende tus productos sin intermediarios.
                            </motion.p>
                            <motion.div variants={fadeInUp} className="flex flex-col sm:flex-row gap-6 w-full sm:w-auto pt-4">
                                <Link href="/marketplace">
                                    <motion.button
                                        whileHover={{ scale: 1.05, y: -5 }}
                                        whileTap={{ scale: 0.95 }}
                                        className="w-full sm:w-auto relative h-16 px-10 bg-primary text-primary-foreground font-bold text-xs uppercase tracking-[0.2em] rounded-2xl shadow-neo-sm hover:shadow-neo transition-shadow flex items-center justify-center gap-4 group"
                                    >
                                        EXPLORAR TIENDA
                                        <Package size={20} className="group-hover:translate-x-1 transition-transform" />
                                    </motion.button>
                                </Link>
                                <Link href="/register">
                                    <motion.button
                                        whileHover={{ scale: 1.05, y: -5 }}
                                        whileTap={{ scale: 0.95 }}
                                        className="w-full sm:w-auto h-16 px-10 bg-card text-foreground border border-foreground/5 font-bold text-xs uppercase tracking-[0.2em] rounded-2xl shadow-neo-sm hover:shadow-neo transition-shadow flex items-center justify-center gap-4 group"
                                    >
                                        CREAR CUENTA
                                        <Users size={20} className="w-5 h-5 group-hover:scale-110 transition-transform opacity-40" />
                                    </motion.button>
                                </Link>
                            </motion.div>
                        </motion.div>

                        {/* Ilustración Hero Animada */}
                        <motion.div 
                            className="lg:col-span-5 relative"
                            initial={{ opacity: 0, scale: 0.8, rotate: -5 }}
                            animate={{ opacity: 1, scale: 1, rotate: 0 }}
                            transition={{ duration: 1, type: "spring", bounce: 0.5 }}
                        >
                            <motion.div 
                                variants={floatAnimation}
                                initial="initial"
                                animate="animate"
                                className="relative z-10 border border-foreground/5 bg-card/50 p-4 shadow-neo-lg rotate-3 hover:rotate-0 transition-all duration-500 rounded-[3rem]"
                            >
                                <div className="relative aspect-[4/5] overflow-hidden group rounded-[2.5rem]">
                                    <motion.img
                                        whileHover={{ scale: 1.1 }}
                                        transition={{ duration: 0.5 }}
                                        alt="Estudiantes en el campus"
                                        className="object-cover w-full h-full grayscale group-hover:grayscale-0 transition-all duration-700 opacity-60 group-hover:opacity-100"
                                        src="https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=2070&auto=format&fit=crop"
                                    />
                                    <div className="absolute inset-0 bg-primary/5 mix-blend-multiply pointer-events-none group-hover:opacity-0 transition-opacity"></div>
                                    <div className="absolute bottom-8 left-8 right-8 bg-background/90 backdrop-blur-md border border-foreground/5 p-6 rounded-[2rem] shadow-neo-sm transform translate-y-2 group-hover:translate-y-0 transition-transform">
                                        <div className="flex items-center justify-between mb-3">
                                            <span className="bg-primary text-primary-foreground px-3 py-1 text-[8px] font-bold uppercase tracking-[0.3em] rounded-full">Trending Now</span>
                                        </div>
                                        <div className="text-foreground font-bold text-xl uppercase italic tracking-tighter">BROWNIES FACU</div>
                                        <div className="flex justify-between items-end mt-4">
                                            <span className="text-3xl font-bold text-primary italic">$25.00</span>
                                            <div className="w-10 h-10 bg-foreground text-background flex items-center justify-center rounded-xl shadow-sm hover:rotate-12 transition-transform cursor-pointer">
                                                <Store size={18} />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </motion.div>
                            <div className="absolute -top-16 -right-12 w-48 h-48 bg-primary/10 rounded-full blur-[80px] z-0"></div>
                            <div className="absolute -bottom-12 -left-12 w-40 h-40 border-2 border-dashed border-primary/20 z-0 rounded-full animate-spin-slow"></div>
                        </motion.div>
                    </div>
                </div>
            </header>

            {/* Sección: Propuesta de valor */}
            <section id="como-funciona" className="py-32 border-y border-foreground/5 bg-card/30">
                <div className="max-w-7xl mx-auto px-6 lg:px-10">
                    <motion.div 
                        initial="hidden"
                        whileInView="visible"
                        viewport={{ once: true, margin: "-100px" }}
                        variants={fadeInUp}
                        className="text-center mb-24"
                    >
                        <h2 className="text-5xl md:text-7xl font-bold text-foreground uppercase tracking-tighter italic mb-6">
                            ¿POR QUÉ <span className="text-primary italic">TIENDITA CAMPUS?</span>
                        </h2>
                        <p className="text-foreground/30 max-w-2xl mx-auto text-sm font-bold uppercase tracking-[0.2em] border-t border-foreground/5 pt-6">
                            Compra a compañeros, vende sin intermediarios.
                        </p>
                    </motion.div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-10">
                        {[
                            {
                                icon: Zap,
                                title: "PUBLICA FAST",
                                text: "Sube tu producto con foto, precio y descripción. En menos de un minuto ya estás vendiendo.",
                                color: "bg-primary",
                                iconColor: "text-primary-foreground"
                            },
                            {
                                icon: ShieldCheck,
                                title: "COMPRA SAFE",
                                text: "Estudiantes verificados. Pago contra entrega, sin intermediarios ni sorpresas extrañas.",
                                color: "bg-secondary",
                                iconColor: "text-secondary-foreground"
                            },
                            {
                                icon: TrendingUp,
                                title: "METRICAS PRO",
                                text: "Dashboard con ganancia real, historial de ventas y reportes operativos para crecer.",
                                color: "bg-foreground",
                                iconColor: "text-primary"
                            }
                        ].map((feature, i) => (
                            <motion.div 
                                key={i}
                                initial={{ opacity: 0, y: 50 }}
                                whileInView={{ opacity: 1, y: 0 }}
                                viewport={{ once: true, margin: "-50px" }}
                                transition={{ duration: 0.6, delay: i * 0.2 }}
                                whileHover={{ scale: 1.05, y: -10 }}
                                className="group border border-foreground/5 rounded-[3rem] p-12 bg-background shadow-neo-sm hover:shadow-neo transition-all duration-300"
                            >
                                <div className={`w-16 h-16 ${feature.color} flex items-center justify-center mb-10 rounded-2xl shadow-sm rotate-3 group-hover:rotate-0 transition-transform`}>
                                    <feature.icon className={`w-8 h-8 ${feature.iconColor}`} />
                                </div>
                                <h3 className="text-2xl font-bold mb-4 text-foreground uppercase italic tracking-tighter">{feature.title}</h3>
                                <p className="text-foreground/40 font-bold text-xs uppercase tracking-tight leading-relaxed">
                                    {feature.text}
                                </p>
                            </motion.div>
                        ))}
                    </div>
                </div>
            </section>

            {/* Sección: CTA Final */}
            <section className="py-32 bg-foreground text-background relative overflow-hidden">
                <div className="absolute inset-0 opacity-5" style={{ backgroundImage: 'radial-gradient(var(--primary) 2px, transparent 2px)', backgroundSize: '40px 40px' }}></div>
                <motion.div 
                    initial="hidden"
                    whileInView="visible"
                    viewport={{ once: true }}
                    variants={staggerContainer}
                    className="max-w-4xl mx-auto px-6 text-center relative z-10 space-y-12"
                >
                    <motion.h2 variants={fadeInUp} className="text-6xl md:text-9xl font-bold tracking-tighter leading-none italic uppercase">
                        ¿LISTO PARA <br /><span className="text-primary italic">EMPRENDER?</span>
                    </motion.h2>
                    <motion.p variants={fadeInUp} className="text-lg md:text-xl text-background/40 font-bold uppercase tracking-[0.1em] max-w-2xl mx-auto leading-relaxed border-l-4 border-primary pl-8 text-left inline-block">
                        Únete a cientos de estudiantes que ya están generando ingresos dentro de su universidad con el marketplace más auténtico.
                    </motion.p>
                    <motion.div variants={fadeInUp} className="flex flex-col sm:flex-row gap-6 justify-center pt-8">
                        <Link href="/register">
                            <motion.button
                                whileHover={{ scale: 1.05 }}
                                whileTap={{ scale: 0.95 }}
                                className="w-full sm:w-auto h-16 px-12 bg-primary text-primary-foreground rounded-2xl font-bold text-xs uppercase tracking-[0.2em] shadow-neo-sm hover:shadow-neo transition-all flex items-center justify-center"
                            >
                                EMPEZAR GRATIS
                            </motion.button>
                        </Link>
                        <Link href="/login">
                            <motion.button
                                whileHover={{ scale: 1.05 }}
                                whileTap={{ scale: 0.95 }}
                                className="w-full sm:w-auto h-16 px-12 bg-transparent text-background border border-background/20 rounded-2xl font-bold text-xs uppercase tracking-[0.2em] hover:bg-background hover:text-foreground transition-all flex items-center justify-center"
                            >
                                YA TENGO CUENTA
                            </motion.button>
                        </Link>
                    </motion.div>
                </motion.div>
            </section>

             {/* Footer */}
            <footer className="bg-card text-foreground/40 border-t border-foreground/5 py-12">
                <div className="max-w-7xl mx-auto px-6 lg:px-10 flex flex-col sm:flex-row justify-between items-center gap-8">
                    <div className="flex items-center gap-4">
                        <motion.div 
                            whileHover={{ rotate: 180 }}
                            transition={{ duration: 0.5 }}
                            className="w-10 h-10 bg-primary text-primary-foreground flex items-center justify-center rounded-xl shadow-sm cursor-pointer"
                        >
                            <Store size={20} />
                        </motion.div>
                        <span className="font-bold text-[10px] tracking-[0.3em] uppercase">Tiendita Campus © 2026</span>
                    </div>
                    <div className="flex gap-8 text-[10px] font-bold uppercase tracking-[0.3em]">
                        <Link href="/marketplace" className="hover:text-primary transition-colors">Tienda</Link>
                        <Link href="/login" className="hover:text-primary transition-colors">Entrar</Link>
                        <Link href="/register" className="hover:text-primary transition-colors">Registrarse</Link>
                        <Link href="/terms" className="hover:text-primary transition-colors">Términos</Link>
                    </div>
                </div>
            </footer>
        </div>
    );
}

function ShoppingBasket(props: any) {
    return (
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" {...props}>
            <path d="m15 11-1 9" /><path d="m19 11-4-7" /><path d="M2 11h20" /><path d="m3.5 11 1.6 7.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6l1.7-7.4" /><path d="m4.5 15.5h15" /><path d="m5 11 4-7" /><path d="m9 11 1 9" />
        </svg>
    );
}
