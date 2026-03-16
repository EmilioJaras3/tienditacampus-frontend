'use client';

import { useState, useEffect } from 'react';
import { ShieldCheck, ArrowRight, Lock } from 'lucide-react';

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
        <div className="fixed inset-0 z-[9999] bg-background/80 backdrop-blur-xl flex items-center justify-center p-6 sm:p-10 animate-in fade-in duration-700">
            <div className="max-w-2xl w-full bg-card border-2 border-primary shadow-neo-lg rounded-[3rem] p-10 md:p-16 space-y-12 transform animate-in slide-in-from-bottom-8 duration-500">
                <div className="flex items-center gap-6">
                    <div className="w-16 h-16 bg-primary text-primary-foreground flex items-center justify-center rounded-2xl rotate-3 shadow-neo-sm">
                        <Lock size={32} />
                    </div>
                    <div>
                        <h2 className="text-4xl md:text-5xl font-bold tracking-tighter uppercase italic">Protocolo de Acceso</h2>
                        <p className="text-[10px] font-bold text-foreground/30 uppercase tracking-[0.3em]">Seguridad & Confianza</p>
                    </div>
                </div>

                <div className="space-y-6 text-foreground/70">
                    <p className="text-xl font-bold leading-tight decoration-primary/20 underline decoration-4 underline-offset-4">
                        Para entrar a la TienditaCampus, necesitamos que aceptes nuestros términos de convivencia.
                    </p>
                    
                    <div className="bg-background border border-foreground/5 p-8 rounded-2xl space-y-4">
                        <p className="text-sm font-bold uppercase tracking-widest text-primary flex items-center gap-2">
                            <ShieldCheck size={18} /> Marco Legal & Convivencia:
                        </p>
                        <ul className="text-xs font-bold uppercase tracking-wider space-y-3 list-none">
                            <li className="flex items-start gap-3">
                                <span className="text-primary">•</span> Cumplimiento normativo. El comercio se rige por el marco legal vigente y reglamentos universitarios.
                            </li>
                            <li className="flex items-start gap-3">
                                <span className="text-primary">•</span> Comerciantes responsables. No se permiten productos ilegales o prohibidos.
                            </li>
                            <li className="flex items-start gap-3">
                                <span className="text-primary">•</span> Transparencia total. Los precios y condiciones deben ser claros para evitar malentendidos.
                            </li>
                        </ul>
                    </div>

                    <p className="text-[10px] font-bold text-foreground/40 uppercase tracking-widest leading-relaxed">
                        Al hacer clic en "Aceptar", confirmas que comprendes el marco legal y te comprometes a seguir las reglas de la comunidad.
                    </p>
                </div>

                <button
                    onClick={handleAccept}
                    className="w-full h-20 bg-primary text-primary-foreground border border-foreground/5 font-bold text-xs uppercase tracking-[0.2em] shadow-neo hover:shadow-neo-lg hover:-translate-y-1 transition-all rounded-2xl flex items-center justify-center gap-4"
                >
                    ACEPTAR Y ENTRAR <ArrowRight size={20} />
                </button>
            </div>
        </div>
    );
}
