'use client';

import { useState, useEffect } from 'react';
import { ShieldCheck, ArrowRight, Lock } from 'lucide-react';
import Link from 'next/link';

export function TermsBlockingOverlay() {
    const [isVisible, setIsVisible] = useState(false);

    useEffect(() => {
        const accepted = localStorage.getItem('tc-accepted-terms');
        if (!accepted) {
            setIsVisible(true);
        }
    }, []);

    const handleAccept = () => {
        localStorage.setItem('tc-accepted-terms', 'true');
        setIsVisible(false);
    };

    if (!isVisible) return null;

    return (
        <div className="fixed inset-0 z-[9999] bg-background/95 backdrop-blur-2xl flex items-center justify-center p-6 sm:p-10 animate-in fade-in duration-1000">
            <div className="max-w-2xl w-full bg-card border border-primary/30 shadow-neo-lg rounded-[3rem] p-10 md:p-16 space-y-12 transform animate-in slide-in-from-bottom-12 duration-700">
                <div className="flex items-center gap-6">
                    <div className="w-16 h-16 bg-primary text-primary-foreground flex items-center justify-center rounded-2xl rotate-3 shadow-neo-sm group-hover:rotate-0 transition-transform">
                        <Lock size={32} />
                    </div>
                    <div>
                        <h2 className="text-4xl md:text-5xl font-bold tracking-tighter uppercase italic text-foreground">Acceso Seguro</h2>
                        <p className="text-[10px] font-bold text-primary uppercase tracking-[0.3em]">Protocolo de Convivencia</p>
                    </div>
                </div>

                <div className="space-y-8 text-foreground/70">
                    <p className="text-2xl font-bold leading-tight text-foreground uppercase tracking-tight italic underline decoration-primary/30 decoration-8 underline-offset-8">
                        Para entrar a <span className="text-primary italic">Tiendita Campus</span>, debes aceptar el marco legal universitario.
                    </p>
                    
                    <div className="bg-background/50 border border-foreground/5 p-8 rounded-3xl space-y-6">
                        <p className="text-[10px] font-bold uppercase tracking-widest text-primary flex items-center gap-2 border-b border-primary/10 pb-4">
                            <ShieldCheck size={16} /> Reglas de la Comunidad:
                        </p>
                        <ul className="text-[11px] font-bold uppercase tracking-widest space-y-4 list-none opacity-80">
                            <li className="flex items-start gap-3 leading-relaxed">
                                <span className="text-primary mt-0.5">•</span> Cumplimiento normativo. El comercio se rige por reglamentos universitarios vigentes.
                            </li>
                            <li className="flex items-start gap-3 leading-relaxed">
                                <span className="text-primary mt-0.5">•</span> Solo snacks y comida. No se permiten productos prohibidos o ilegales.
                            </li>
                            <li className="flex items-start gap-3 leading-relaxed">
                                <span className="text-primary mt-0.5">•</span> Transparencia total. Honestidad en precios y calidad de los alimentos.
                            </li>
                        </ul>
                    </div>

                    <div className="p-4 rounded-xl border border-primary/10 bg-primary/5">
                        <p className="text-[9px] font-bold text-foreground/40 uppercase tracking-[0.15em] leading-relaxed text-center">
                            Al hacer clic en "Aceptar", confirmas que comprendes el marco legal aplicado y te comprometes a seguir las reglas.
                        </p>
                    </div>
                </div>

                <div className="space-y-4">
                    <button
                        onClick={handleAccept}
                        className="w-full h-20 bg-primary text-primary-foreground border border-foreground/5 font-bold text-xs uppercase tracking-[0.3em] shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all rounded-2xl flex items-center justify-center gap-4 group"
                    >
                        ACEPTAR Y ENTRAR <ArrowRight size={20} className="group-hover:translate-x-2 transition-transform" />
                    </button>
                    <Link href="/terms" className="block text-center text-[9px] font-bold uppercase tracking-widest text-foreground/30 hover:text-primary transition-colors underline decoration-foreground/10 underline-offset-4">
                        Leer Marco Legal Completo
                    </Link>
                </div>
            </div>
        </div>
    );
}
