'use client';

import { motion } from 'framer-motion';
import { ShieldCheck, Scale, ScrollText, Users, AlertCircle, ArrowLeft } from 'lucide-react';
import Link from 'next/link';

export default function TermsPage() {
    return (
        <div className="bg-background text-foreground font-display min-h-screen flex flex-col pt-24 pb-12 selection:bg-primary/20">
            <div className="max-w-4xl mx-auto px-6 lg:px-10 space-y-16">
                {/* Header */}
                <motion.div 
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="space-y-6"
                >
                    <Link href="/">
                        <motion.button 
                            whileHover={{ x: -5 }}
                            className="flex items-center gap-2 text-[10px] font-bold uppercase tracking-[0.3em] text-foreground/40 hover:text-primary transition-colors mb-8"
                        >
                            <ArrowLeft size={14} /> Volver al Inicio
                        </motion.button>
                    </Link>
                    <h1 className="text-5xl md:text-7xl font-bold tracking-tighter uppercase italic leading-none">
                        MARCO LEGAL & <br /><span className="text-primary italic">CONVIVENCIA</span>
                    </h1>
                    <p className="text-foreground/40 font-bold text-xs uppercase tracking-[0.2em] border-l-4 border-primary pl-8 max-w-2xl">
                        Lineamientos para el uso responsable de la plataforma dentro de la comunidad universitaria.
                    </p>
                </motion.div>

                {/* Content Sections */}
                <div className="grid grid-cols-1 gap-12">
                    <Section 
                        icon={Scale} 
                        title="1. Naturaleza del Servicio" 
                        text="Tiendita Campus funciona como un nexo tecnológico para facilitar el intercambio de productos alimenticios (snacks y comida artesanal) entre estudiantes. La plataforma no interviene en las transacciones, las cuales se realizan bajo la modalidad pago contra entrega."
                    />

                    <Section 
                        icon={ShieldCheck} 
                        title="2. Responsabilidad del Vendedor" 
                        text="Todo usuario que publique un producto garantiza la calidad e higiene del mismo. Está estrictamente prohibido el comercio de sustancias ilícitas, alcohol, tabaco, medicamentos o cualquier artículo que contravenga el reglamento universitario vigente."
                    />

                    <Section 
                        icon={Users} 
                        title="3. Comunidad y Respeto" 
                        text="El uso de la plataforma requiere la validación de identidad universitaria. Conductas fraudulentas, acoso o abuso del sistema resultarán en la suspensión definitiva de la cuenta y, de ser necesario, el reporte a las autoridades universitarias."
                    />

                    <Section 
                        icon={ScrollText} 
                        title="4. Privacidad de Datos" 
                        text="Los datos proporcionados serán utilizados exclusivamente para la funcionalidad del marketplace. Tiendita Campus no comparte información sensible con terceros externos a la red universitaria, operando bajo principios de transparencia y seguridad."
                    />

                    <div className="bg-primary/5 border border-primary/20 p-8 rounded-[2.5rem] space-y-4">
                        <div className="flex items-center gap-3 text-primary">
                            <AlertCircle size={24} />
                            <h3 className="font-bold text-xs uppercase tracking-[0.3em]">Nota Importante</h3>
                        </div>
                        <p className="text-[10px] font-bold text-foreground/60 uppercase tracking-widest leading-relaxed">
                            Al operar en este entorno, aceptas someterte al marco legal aplicado y los términos de convivencia aquí descritos. Tiendita Campus se reserva el derecho de actualizar estos términos para garantizar la seguridad de todos los usuarios.
                        </p>
                    </div>
                </div>

                {/* Footer del Marco Legal */}
                <footer className="pt-12 border-t border-foreground/5 text-center">
                    <p className="text-[8px] font-bold text-foreground/20 uppercase tracking-[0.4em]">Tiendita Campus © 2026 | Seguridad Universitaria Aplicada</p>
                </footer>
            </div>
        </div>
    );
}

function Section({ icon: Icon, title, text }: { icon: any, title: string, text: string }) {
    return (
        <motion.div 
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="space-y-4 group"
        >
            <div className="flex items-center gap-4">
                <div className="w-10 h-10 bg-foreground text-background flex items-center justify-center rounded-xl rotate-3 group-hover:rotate-0 transition-transform">
                    <Icon size={20} />
                </div>
                <h2 className="text-xl font-bold uppercase italic tracking-tight">{title}</h2>
            </div>
            <p className="text-foreground/50 font-bold text-xs uppercase tracking-tight leading-relaxed pl-14">
                {text}
            </p>
        </motion.div>
    );
}
