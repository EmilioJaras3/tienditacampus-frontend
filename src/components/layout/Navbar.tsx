'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useAuthStore } from '@/store/auth.store';
import {
    LayoutDashboard,
    ShoppingBag,
    Package,
    LogOut,
    User,
    ShoppingBasket,
    Menu,
    X
} from 'lucide-react';
import { useState } from 'react';

export function Navbar() {
    const pathname = usePathname();
    const { user, logout, isAuthenticated, _hasHydrated } = useAuthStore();
    const [mobileOpen, setMobileOpen] = useState(false);

    // No mostrar la Navbar en el Dashboard de Seller (usa Sidebar propia)
    if (pathname.startsWith('/dashboard') || pathname.startsWith('/products') || pathname.startsWith('/sales') || pathname.startsWith('/reports') || pathname.startsWith('/audit')) return null;

    const isBuyer = user?.role === 'buyer';
    const isSeller = user?.role === 'seller' || user?.role === 'admin';

    return (
        <nav className="fixed top-0 left-0 right-0 z-50 bg-background border-b-4 border-foreground/10 font-display transition-colors duration-300">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16 items-center">
                    {/* Logo */}
                    <Link href="/" className="flex items-center gap-2 group">
                        <div className="bg-primary text-primary-foreground p-1.5 border border-primary/10 shadow-md group-hover:shadow-neo transition-all rounded-lg">
                            <ShoppingBasket className="h-5 w-5" />
                        </div>
                        <span className="text-lg font-bold tracking-tighter text-foreground">
                            TienditaCampus
                        </span>
                    </Link>

                    {/* Links Centro - Desktop */}
                    <div className="hidden md:flex items-center gap-1">
                        <Link
                            href="/marketplace"
                            className={`px-4 py-2 text-sm font-bold uppercase tracking-wider transition-all border-2 rounded-lg ${pathname === '/marketplace'
                                ? 'bg-secondary text-secondary-foreground border-secondary shadow-neo-sm'
                                : 'bg-transparent text-foreground border-transparent hover:border-secondary/20 hover:bg-secondary/5'
                                }`}
                        >
                            <span className="flex items-center gap-1.5">
                                <ShoppingBag className="w-4 h-4" /> Tienda
                            </span>
                        </Link>
                        {isAuthenticated && isBuyer && (
                            <Link
                                href="/dashboard"
                                className={`px-4 py-2 text-sm font-bold uppercase tracking-wider transition-all border-2 rounded-lg ${pathname.startsWith('/dashboard')
                                    ? 'bg-secondary text-secondary-foreground border-secondary shadow-neo-sm'
                                    : 'bg-transparent text-foreground border-transparent hover:border-secondary/20 hover:bg-secondary/5'
                                    }`}
                            >
                                <span className="flex items-center gap-1.5">
                                    <Package className="w-4 h-4" /> Mis Pedidos
                                </span>
                            </Link>
                        )}
                        {isAuthenticated && isSeller && (
                            <Link
                                href="/dashboard"
                                className={`px-4 py-2 text-sm font-bold uppercase tracking-wider transition-all border-2 border-transparent hover:border-primary/20 hover:bg-primary/5 rounded-lg text-foreground`}
                            >
                                <span className="flex items-center gap-1.5">
                                    <LayoutDashboard className="w-4 h-4" /> Panel Vendedor
                                </span>
                            </Link>
                        )}
                    </div>

                    {/* Botones Derecha - Desktop */}
                    <div className="hidden md:flex items-center gap-3">
                        {!isAuthenticated ? (
                            <>
                                <Link
                                    href="/login"
                                    className="px-5 py-2 text-sm font-bold uppercase tracking-wider text-foreground border border-border hover:bg-foreground hover:text-background transition-all rounded-lg"
                                >
                                    Entrar
                                </Link>
                                <Link
                                    href="/register"
                                    className="px-5 py-2 text-sm font-bold uppercase tracking-wider text-primary-foreground bg-primary border border-primary/10 shadow-neo-sm hover:shadow-neo hover:-translate-y-0.5 transition-all rounded-lg"
                                >
                                    Crear Cuenta
                                </Link>
                            </>
                        ) : (
                            <div className="flex items-center gap-3">
                                <div className="flex items-center gap-2 px-3 py-1.5 border border-border bg-muted/30 rounded-lg">
                                    <div className="w-7 h-7 bg-primary text-primary-foreground border border-primary/10 flex items-center justify-center font-bold text-xs rounded-full">
                                        {user?.firstName?.charAt(0)?.toUpperCase() || 'U'}
                                    </div>
                                    <span className="text-sm font-bold text-foreground hidden sm:inline">{user?.firstName}</span>
                                </div>
                                <button
                                    onClick={logout}
                                    className="px-3 py-2 text-sm font-bold uppercase text-foreground border border-border hover:bg-primary hover:text-primary-foreground hover:border-primary transition-all rounded-lg"
                                >
                                    <LogOut className="h-4 w-4" />
                                </button>
                            </div>
                        )}
                    </div>

                    {/* Mobile hamburger */}
                    <button
                        className="md:hidden p-2 border border-primary/10"
                        onClick={() => setMobileOpen(!mobileOpen)}
                    >
                        {mobileOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
                    </button>
                </div>
            </div>

            {/* Mobile Menu */}
            {mobileOpen && (
                <div className="md:hidden border-t-4 border-foreground/10 bg-background">
                    <div className="flex flex-col p-4 gap-2">
                        <Link href="/marketplace" onClick={() => setMobileOpen(false)} className="px-4 py-3 font-bold uppercase text-sm border border-primary/10 bg-secondary text-white/20 hover:bg-secondary text-white transition-colors">
                            <span className="flex items-center gap-2"><ShoppingBag className="w-4 h-4" /> Tienda</span>
                        </Link>
                        {isAuthenticated && isBuyer && (
                            <Link href="/dashboard" onClick={() => setMobileOpen(false)} className="px-4 py-3 font-bold uppercase text-sm border border-primary/10 hover:bg-secondary text-white/20 transition-colors">
                                <span className="flex items-center gap-2"><Package className="w-4 h-4" /> Mis Pedidos</span>
                            </Link>
                        )}
                        {isAuthenticated && isSeller && (
                            <Link href="/dashboard" onClick={() => setMobileOpen(false)} className="px-4 py-3 font-bold uppercase text-sm border border-primary/10 hover:bg-primary text-white/10 transition-colors">
                                <span className="flex items-center gap-2"><LayoutDashboard className="w-4 h-4" /> Panel Vendedor</span>
                            </Link>
                        )}
                        <hr className="border border-primary/10 my-2" />
                        {!isAuthenticated ? (
                            <>
                                <Link href="/login" onClick={() => setMobileOpen(false)} className="px-4 py-3 font-bold uppercase text-sm text-center border-2 border-primary hover:bg-primary hover:text-primary-foreground transition-all shadow-neo-sm rounded-xl">
                                    INICIAR SESIÓN
                                </Link>
                                <Link href="/register" onClick={() => setMobileOpen(false)} className="px-4 py-3 font-bold uppercase text-sm text-center border border-primary/10 bg-primary text-white text-white hover:bg-red-700 transition-colors">
                                    Crear Cuenta
                                </Link>
                            </>
                        ) : (
                            <button onClick={() => { logout(); setMobileOpen(false); }} className="px-4 py-3 font-bold uppercase text-sm text-center border border-primary/10 text-neo-red hover:bg-primary text-white hover:text-white transition-colors">
                                <span className="flex items-center justify-center gap-2"><LogOut className="w-4 h-4" /> Cerrar Sesión</span>
                            </button>
                        )}
                    </div>
                </div>
            )}
        </nav>
    );
}
