'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
    LayoutDashboard,
    Package,
    ShoppingCart,
    BarChart3,
    LogOut,
    ShoppingBag,
    ShoppingBasket,
    Menu,
    X,
    ShieldCheck,
    TrendingUp,
    Zap,
    Settings
} from 'lucide-react';
import { useAuthStore } from '../../store/auth.store';
import { useState } from 'react';

const routes = [
    {
        label: 'Ver Tienda',
        icon: ShoppingBag,
        href: '/marketplace',
        color: 'bg-secondary text-secondary-foreground',
        roles: ['seller', 'admin', 'buyer'],
    },
    {
        label: 'Mis Compras',
        icon: ShoppingCart,
        href: '/mis-compras',
        color: 'bg-primary text-primary-foreground',
        roles: ['buyer', 'seller', 'admin'],
    },

    {
        label: 'Panel de Ventas',
        icon: LayoutDashboard,
        href: '/dashboard',
        color: 'bg-secondary text-secondary-foreground',
        roles: ['seller', 'admin'],
    },
    {
        label: 'Mi Inventario',
        icon: Package,
        href: '/products',
        color: 'bg-primary text-primary-foreground',
        roles: ['seller', 'admin'],
    },
    {
        label: 'Gestión Ventas',
        icon: ShoppingCart,
        href: '/sales',
        color: 'bg-accent text-accent-foreground',
        roles: ['seller', 'admin'],
    },
    {
        label: 'Reportes Pro',
        icon: BarChart3,
        href: '/reports',
        color: 'bg-secondary/20 text-secondary',
        roles: ['seller', 'admin'],
    },
    {
        label: 'Benchmarking',
        icon: TrendingUp,
        href: '/benchmarking',
        color: 'bg-secondary text-secondary-foreground',
        roles: ['admin'],
    },
];

interface SidebarContentProps {
    pathname: string;
    logout: () => void;
    user: any;
    setOpen: (open: boolean) => void;
    filteredRoutes: typeof routes;
}

const SidebarContent = ({ pathname, logout, user, setOpen, filteredRoutes }: SidebarContentProps) => (
    <div className="flex flex-col h-full bg-card border-r-2 border-foreground/10 p-6 font-display">
        {/* Header / Logo */}
        <Link href="/" className="flex items-center gap-3 mb-10 group" onClick={() => setOpen(false)}>
            <div className="bg-primary text-primary-foreground p-2 border border-foreground/10 shadow-md rotate-[-5deg] group-hover:rotate-0 transition-transform">
                <ShoppingBasket className="h-6 w-6" />
            </div>
            <div>
                <h1 className="text-xl font-semibold tracking-tighter leading-none text-foreground uppercase">
                    Tiendita
                </h1>
                <span className="text-[10px] font-semibold tracking-[0.2em] text-primary">
                    Campus Admin
                </span>
            </div>
        </Link>

        {/* User Info Brief */}
        <div className="mb-8 p-4 border border-foreground/10 bg-background relative group shadow-sm rounded-xl">
            <div className="absolute -top-3 -right-3 w-10 h-10 bg-primary/10 border border-foreground/5 rotate-12 -z-10 group-hover:rotate-0 transition-transform rounded-lg"></div>
            <div className="flex items-center gap-4 relative z-10">
                <div className="w-12 h-12 shrink-0 border border-border bg-foreground text-background flex items-center justify-center font-bold text-lg uppercase shadow-neo-sm rounded-lg">
                    {user?.firstName?.charAt(0) || 'U'}
                </div>
                <div className="flex flex-col min-w-0">
                    <p className="font-bold text-[11px] uppercase truncate text-foreground leading-tight">
                        {user?.firstName} {user?.lastName}
                    </p>
                    <p className="text-[9px] font-bold text-primary uppercase tracking-widest mt-1">
                        Nivel {user?.role === 'admin' ? 'Master' : 'Vendedor'}
                    </p>
                </div>
            </div>
        </div>

        {/* Navigation */}
        <div className="flex-1 space-y-2 overflow-y-auto pr-2 custom-scrollbar">
            <p className="text-[10px] font-bold text-muted-foreground uppercase tracking-widest pl-2 mb-2">Menú Principal</p>
            {filteredRoutes.map((route) => (
                <Link
                    key={route.href}
                    href={route.href}
                    className={`group flex items-center p-3 w-full font-bold text-xs tracking-widest border border-transparent transition-all rounded-lg ${pathname === route.href
                        ? 'bg-primary text-primary-foreground border-primary/20 shadow-neo-sm'
                        : 'bg-transparent text-muted-foreground hover:bg-primary/5 hover:text-primary'
                        }`}
                    onClick={() => setOpen(false)}
                >
                    <div className={`w-8 h-8 flex items-center justify-center border border-border mr-3 transition-transform group-hover:rotate-[-5deg] rounded-md ${pathname === route.href ? 'bg-primary-foreground text-primary shadow-inner' : 'bg-muted text-foreground'}`}>
                        <route.icon className="h-4 w-4 shrink-0" />
                    </div>
                    {route.label}
                </Link>
            ))}
        </div>

        {/* Footer Actions */}
        <div className="mt-auto space-y-2 pt-6 border-t border-foreground/10 border-dashed">
            <Link
                href="/marketplace"
                className="flex items-center p-3 w-full font-bold uppercase text-[10px] tracking-wider text-muted-foreground hover:text-foreground hover:bg-foreground/5 transition-all"
                onClick={() => setOpen(false)}
            >
                <ShoppingBag className="h-4 w-4 mr-3" />
                Regresar a la Tienda
            </Link>
            <button
                onClick={() => { logout(); setOpen(false); }}
                className="flex items-center p-3 w-full font-bold text-[10px] tracking-wider text-primary hover:bg-primary hover:text-primary-foreground transition-all group rounded-lg border border-transparent hover:border-primary/20"
            >
                <LogOut className="h-4 w-4 mr-3 transition-transform group-hover:-translate-x-1" />
                Cerrar Sesión
            </button>
        </div>
    </div>
);

export function Sidebar() {
    const pathname = usePathname();
    const logout = useAuthStore((state) => state.logout);
    const user = useAuthStore((state) => state.user);
    const [open, setOpen] = useState(false);

    const filteredRoutes = routes.filter(route =>
        !user || route.roles.includes(user.role)
    );

    return (
        <>
            {/* Desktop Sidebar */}
            <div className="hidden h-full md:flex md:w-72 md:flex-col md:fixed md:inset-y-0 z-[80] border-r-2 border-foreground/10">
                <SidebarContent
                    pathname={pathname}
                    logout={logout}
                    user={user}
                    setOpen={setOpen}
                    filteredRoutes={filteredRoutes}
                />
            </div>

            {/* Mobile Header/Menu */}
            <div className="md:hidden flex items-center justify-between p-4 bg-background border-b-4 border-foreground/10 fixed top-0 left-0 right-0 z-50">
                <Link href="/" className="flex items-center gap-2">
                    <div className="bg-primary text-primary-foreground p-1.5 border border-primary/10 rounded-lg shadow-neo-sm">
                        <ShoppingBasket className="h-5 w-5" />
                    </div>
                    <span className="text-lg font-bold tracking-tighter text-foreground uppercase">Tiendita</span>
                </Link>
                <button
                    onClick={() => setOpen(!open)}
                    className="p-2 border-2 border-primary/20 bg-secondary text-secondary-foreground shadow-neo-sm rounded-lg active:scale-95 transition-all"
                >
                    {open ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
                </button>
            </div>

            {/* Mobile Sidebar Overlay */}
            {open && (
                <div className="md:hidden fixed inset-0 z-50 bg-foreground/50 backdrop-blur-sm" onClick={() => setOpen(false)}>
                    <div className="w-72 h-full" onClick={e => e.stopPropagation()}>
                        <SidebarContent
                            pathname={pathname}
                            logout={logout}
                            user={user}
                            setOpen={setOpen}
                            filteredRoutes={filteredRoutes}
                        />
                    </div>
                </div>
            )}
        </>
    );
}
