'use client';

import type { ElementType } from 'react';
import { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';
import {
    BarChart3,
    Package,
    TrendingUp,
    ShieldCheck,
    ArrowRight,
    Store,
    Users,
    Zap,
    ChevronDown,
    Menu,
    X,
} from 'lucide-react';
import { Button } from '../components/ui/button';

function MarqueeBar() {
    const items = useMemo(() => new Array<string>(8).fill('🔥 Compra Local • Vende en tu U • TienditaCampus'), []);

    return (
        <div className="bg-[#E31837] text-white overflow-hidden py-2 border-b-2 border-slate-900 dark:border-white z-50">
            <div className="whitespace-nowrap flex animate-marquee font-bold text-sm tracking-widest uppercase">
                {items.map((text: string, idx: number) => (
                    <span key={idx} className="mx-4">{text}</span>
                ))}
                {items.map((text: string, idx: number) => (
                    <span key={`dup-${idx}`} className="mx-4">{text}</span>
                ))}
            </div>
        </div>
    );
}

/* ───────── Navbar ───────── */
function Navbar() {
    const [mobileOpen, setMobileOpen] = useState(false);

    return (
        <nav className="border-b-2 border-slate-900 dark:border-white bg-white/95 dark:bg-[#1a1a1a]/95 backdrop-blur sticky top-0 z-40">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between items-center h-20">
                    <Link href="/" className="flex-shrink-0 flex items-center gap-2 group cursor-pointer">
                        <div className="w-10 h-10 bg-[#FFC72C] border-2 border-slate-900 dark:border-white flex items-center justify-center transition-all duration-200">
                            <Store className="text-slate-900" size={20} />
                        </div>
                        <span className="font-bold text-xl tracking-tighter uppercase dark:text-white">
                            Tiendita<span className="text-[#E31837]">Campus</span>
                        </span>
                    </Link>

                    <div className="hidden md:flex items-center space-x-4">
                        <a className="text-sm font-bold uppercase hover:text-[#E31837] transition-colors px-4 py-2" href="#features">
                            Sobre Nosotros
                        </a>
                        <a className="text-sm font-bold uppercase hover:text-[#E31837] transition-colors px-4 py-2" href="#cta">
                            Contacto
                        </a>
                        <div className="h-8 w-[2px] bg-slate-200 dark:bg-slate-700 mx-2" />
                        <Link
                            className="text-sm font-bold uppercase px-6 py-2 border-2 border-slate-900 dark:border-white hover:bg-slate-900 hover:text-white dark:hover:bg-white dark:hover:text-slate-900 transition-all duration-200"
                            href="/login"
                        >
                            Iniciar Sesión
                        </Link>
                        <Link
                            className="text-sm font-bold uppercase px-6 py-2 bg-[#FFC72C] text-slate-900 border-2 border-slate-900 dark:border-white hover:translate-x-[2px] hover:translate-y-[2px] transition-all duration-200"
                            href="/register"
                        >
                            Crear Cuenta
                        </Link>
                    </div>

                    <div className="md:hidden flex items-center">
                        <button
                            className="text-slate-900 dark:text-white hover:text-[#FFC72C] p-2"
                            onClick={() => setMobileOpen((v: boolean) => !v)}
                            aria-label={mobileOpen ? 'Cerrar menú' : 'Abrir menú'}
                        >
                            {mobileOpen ? <X size={28} /> : <Menu size={28} />}
                        </button>
                    </div>
                </div>
            </div>

            {mobileOpen && (
                <div className="md:hidden border-t-2 border-slate-900 dark:border-white bg-white dark:bg-[#1a1a1a]">
                    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 space-y-2">
                        <a className="block text-sm font-bold uppercase px-4 py-3 border-2 border-slate-900 dark:border-white" href="#features">
                            Sobre Nosotros
                        </a>
                        <a className="block text-sm font-bold uppercase px-4 py-3 border-2 border-slate-900 dark:border-white" href="#cta">
                            Contacto
                        </a>
                        <Link className="block text-sm font-bold uppercase px-4 py-3 border-2 border-slate-900 dark:border-white" href="/login">
                            Iniciar Sesión
                        </Link>
                        <Link className="block text-sm font-bold uppercase px-4 py-3 bg-[#FFC72C] text-slate-900 border-2 border-slate-900 dark:border-white" href="/register">
                            Crear Cuenta
                        </Link>
                    </div>
                </div>
            )}
        </nav>
    );
}

/* ───────── Feature Card ───────── */
function FeatureCard({
    icon: Icon,
    title,
    description,
    gradient,
}: {
    icon: ElementType;
    title: string;
    description: string;
    gradient: string;
}) {
    return (
        <div className="group relative overflow-hidden rounded-2xl border border-border bg-surface p-8 transition-all duration-300 hover:shadow-xl hover:shadow-primary/5 hover:-translate-y-1">
            <div className={`mb-5 flex h-14 w-14 items-center justify-center rounded-xl ${gradient} text-white shadow-lg transition-transform duration-300 group-hover:scale-110`}>
                <Icon size={26} />
            </div>
            <h3 className="mb-2 text-xl font-bold text-text">{title}</h3>
            <p className="text-sm leading-relaxed text-text-secondary">{description}</p>
            <div className="absolute -right-8 -top-8 h-32 w-32 rounded-full bg-primary/5 transition-transform duration-500 group-hover:scale-150" />
        </div>
    );
}

/* ───────── Stat Counter ───────── */
function StatItem({ value, label }: { value: string; label: string }) {
    return (
        <div className="text-center">
            <div className="text-4xl font-extrabold text-white md:text-5xl">{value}</div>
            <div className="mt-1.5 text-sm font-medium text-white/70">{label}</div>
        </div>
    );
}

/* ───────── Page ───────── */
export default function Home() {
    // Registrar Service Worker para PWA
    useEffect(() => {
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker
                .register('/sw.js')
                .then((registration) => {
                    console.log('SW registrado:', registration.scope);
                })
                .catch((error) => {
                    console.error('Error al registrar SW:', error);
                });
        }
    }, []);

    return (
        <>
            <MarqueeBar />
            <Navbar />

            {/* ─── Hero ─── */}
            <section className="relative flex min-h-screen flex-col items-center justify-center overflow-hidden px-6 pt-16">
                {/* Background decorations */}
                <div className="pointer-events-none absolute inset-0 overflow-hidden">
                    <div className="absolute -left-40 -top-40 h-[500px] w-[500px] rounded-full bg-primary/10 blur-3xl" />
                    <div className="absolute -bottom-20 -right-40 h-[400px] w-[400px] rounded-full bg-secondary/10 blur-3xl" />
                    <div className="absolute left-1/2 top-1/4 h-[300px] w-[300px] -translate-x-1/2 rounded-full bg-success/5 blur-3xl" />
                </div>

                <div className="relative z-10 mx-auto max-w-4xl text-center animate-fade-in">
                    {/* Badge */}
                    <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-4 py-1.5 text-xs font-semibold text-primary">
                        <Zap size={14} />
                        Plataforma para vendedores universitarios
                    </div>

                    <h1 className="text-4xl font-extrabold leading-tight tracking-tight text-text sm:text-5xl md:text-6xl lg:text-7xl">
                        Gestiona tu negocio{' '}
                        <span className="bg-gradient-to-r from-primary via-blue-500 to-primary bg-clip-text text-transparent">
                            dentro del campus
                        </span>
                    </h1>

                    <p className="mx-auto mt-6 max-w-2xl text-lg leading-relaxed text-text-secondary md:text-xl">
                        Herramientas digitales que te ayudan a entender tu rentabilidad real,
                        reducir pérdidas y tomar mejores decisiones de inventario.
                    </p>

                    {/* CTAs */}
                    <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row">
                        <Link href="/marketplace">
                            <Button size="lg" className="group gap-2 text-base font-bold shadow-xl shadow-primary/25 hover:shadow-2xl hover:shadow-primary/30 transition-all px-8 bg-blue-600 hover:bg-blue-700">
                                <Store size={18} />
                                Explorar Tienda
                            </Button>
                        </Link>
                        <Link href="/register">
                            <Button variant="outline" size="lg" className="group gap-2 text-base font-bold px-8">
                                Comenzar Gratis
                                <ArrowRight size={18} className="transition-transform group-hover:translate-x-1" />
                            </Button>
                        </Link>
                    </div>
                </div>

                {/* Scroll indicator */}
                <a
                    href="#features"
                    className="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-1 text-text-secondary/50 hover:text-primary transition-colors animate-bounce"
                >
                    <span className="text-[10px] font-medium uppercase tracking-widest">Descubre más</span>
                    <ChevronDown size={18} />
                </a>
            </section>

            {/* ─── Features ─── */}
            <section id="features" className="relative bg-bg py-24 px-6">
                <div className="mx-auto max-w-7xl">
                    <div className="mb-16 text-center">
                        <p className="mb-3 text-sm font-bold uppercase tracking-widest text-primary">
                            Funciones Principales
                        </p>
                        <h2 className="text-3xl font-extrabold tracking-tight text-text sm:text-4xl">
                            Todo lo que necesitas para vender mejor
                        </h2>
                        <p className="mx-auto mt-4 max-w-xl text-text-secondary">
                            Diseñado específicamente para las necesidades de vendedores dentro del campus universitario.
                        </p>
                    </div>

                    <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
                        <FeatureCard
                            icon={BarChart3}
                            title="Rentabilidad Real"
                            description="Calcula automáticamente tus márgenes de ganancia diarios y semanales. Sabe exactamente cuánto ganas por cada producto."
                            gradient="bg-gradient-to-br from-primary to-blue-600"
                        />
                        <FeatureCard
                            icon={Package}
                            title="Control de Inventario"
                            description="Registra productos perecederos, controla fechas de vencimiento y minimiza las pérdidas por caducidad."
                            gradient="bg-gradient-to-br from-secondary to-orange-600"
                        />
                        <FeatureCard
                            icon={TrendingUp}
                            title="Reportes Semanales"
                            description="Visualiza tu progreso con reportes automatizados. Identifica tendencias y toma decisiones informadas."
                            gradient="bg-gradient-to-br from-success to-emerald-600"
                        />
                    </div>
                </div>
            </section>

            {/* ─── Stats ─── */}
            <section id="stats" className="relative overflow-hidden bg-gradient-to-br from-primary-dark via-primary to-blue-600 py-20 px-6">
                {/* Decorative circles */}
                <div className="pointer-events-none absolute inset-0">
                    <div className="absolute -left-20 -top-20 h-60 w-60 rounded-full bg-white/5" />
                    <div className="absolute -bottom-10 -right-10 h-40 w-40 rounded-full bg-white/5" />
                </div>

                <div className="relative z-10 mx-auto max-w-5xl">
                    <div className="mb-14 text-center">
                        <p className="mb-3 text-sm font-bold uppercase tracking-widest text-white/60">
                            Nuestro Impacto
                        </p>
                        <h2 className="text-3xl font-extrabold text-white sm:text-4xl">
                            Números que hablan por sí solos
                        </h2>
                    </div>

                    <div className="grid grid-cols-2 gap-8 md:grid-cols-4">
                        <StatItem value="50+" label="Vendedores Activos" />
                        <StatItem value="200+" label="Productos Registrados" />
                        <StatItem value="95%" label="Satisfacción" />
                        <StatItem value="30%" label="Menos Pérdidas" />
                    </div>
                </div>
            </section>

            {/* ─── Security ─── */}
            <section className="bg-bg py-24 px-6">
                <div className="mx-auto max-w-7xl">
                    <div className="flex flex-col items-center gap-12 lg:flex-row lg:gap-20">
                        <div className="flex-1 text-center lg:text-left">
                            <p className="mb-3 text-sm font-bold uppercase tracking-widest text-primary">
                                Seguridad
                            </p>
                            <h2 className="text-3xl font-extrabold tracking-tight text-text sm:text-4xl">
                                Tus datos están protegidos
                            </h2>
                            <p className="mt-4 text-text-secondary leading-relaxed">
                                Implementamos las mejores prácticas de seguridad para que tu información esté siempre a salvo.
                            </p>
                        </div>
                        <div className="flex-1 grid grid-cols-1 gap-4 sm:grid-cols-2">
                            {[
                                { icon: ShieldCheck, text: 'Autenticación JWT segura' },
                                { icon: Store, text: 'Datos cifrados con Argon2' },
                                { icon: Users, text: 'Roles y permisos granulares' },
                                { icon: Zap, text: 'Infraestructura Docker aislada' },
                            ].map(({ icon: I, text }, idx) => (
                                <div
                                    key={idx}
                                    className="flex items-center gap-3 rounded-xl border border-border bg-surface p-4 transition-all hover:shadow-md hover:border-primary/30"
                                >
                                    <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary">
                                        <I size={20} />
                                    </div>
                                    <span className="text-sm font-medium text-text">{text}</span>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            </section>

            {/* ─── Final CTA ─── */}
            <section id="cta" className="relative overflow-hidden bg-surface py-24 px-6">
                <div className="pointer-events-none absolute inset-0">
                    <div className="absolute left-1/2 top-0 h-[600px] w-[600px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-primary/5 blur-3xl" />
                </div>

                <div className="relative z-10 mx-auto max-w-2xl text-center">
                    <div className="mb-5 inline-flex h-16 w-16 items-center justify-center rounded-2xl bg-primary/10 text-primary">
                        <Store size={32} />
                    </div>
                    <h2 className="text-3xl font-extrabold tracking-tight text-text sm:text-4xl">
                        ¿Listo para vender mejor?
                    </h2>
                    <p className="mx-auto mt-4 max-w-md text-text-secondary">
                        Únete a la comunidad de vendedores universitarios que ya optimizan su negocio con TienditaCampus.
                    </p>
                    <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
                        <Link href="/register">
                            <Button size="lg" className="group gap-2 text-base font-bold shadow-xl shadow-primary/25 px-8">
                                Crear mi Cuenta Gratis
                                <ArrowRight size={18} className="transition-transform group-hover:translate-x-1" />
                            </Button>
                        </Link>
                    </div>
                </div>
            </section>

            {/* ─── Footer ─── */}
            <footer className="border-t border-border bg-surface py-12 px-6">
                <div className="mx-auto max-w-7xl">
                    <div className="flex flex-col items-center justify-between gap-6 md:flex-row">
                        <div className="flex items-center gap-2.5">
                            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-white font-bold text-xs shadow-sm">
                                TC
                            </div>
                            <span className="text-sm font-bold text-text">TienditaCampus</span>
                        </div>
                        <div className="flex items-center gap-6">
                            <Link href="/login" className="text-sm text-text-secondary hover:text-primary transition-colors">
                                Iniciar Sesión
                            </Link>
                            <Link href="/register" className="text-sm text-text-secondary hover:text-primary transition-colors">
                                Registrarse
                            </Link>
                            <a href="#features" className="text-sm text-text-secondary hover:text-primary transition-colors">
                                Funciones
                            </a>
                        </div>
                    </div>
                    <div className="mt-8 border-t border-border pt-6 text-center">
                        <p className="text-xs text-text-secondary/60">
                            © 2026 TienditaCampus — Universidad Politécnica de Chiapas. Proyecto Integrador.
                        </p>
                    </div>
                </div>
            </footer>
        </>
    );
}
