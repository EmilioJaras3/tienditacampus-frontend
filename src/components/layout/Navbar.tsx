'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useAuthStore } from '@/store/auth.store';
import { Button } from '@/components/ui/button';
import {
    LayoutDashboard,
    ShoppingBag,
    Package,
    LogOut,
    User,
    ShoppingBasket
} from 'lucide-react';

export function Navbar() {
    const pathname = usePathname();
    const { user, logout, isAuthenticated } = useAuthStore();

    // No mostrar la Navbar estándar en el Dashboard de Seller (usa Sidebar propia)
    if (pathname.startsWith('/dashboard')) return null;

    const isBuyer = user?.role === 'buyer';
    const isSeller = user?.role === 'seller';

    return (
        <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between h-16 items-center">
                    {/* Logo */}
                    <Link href="/" className="flex items-center space-x-2">
                        <div className="bg-indigo-600 p-1.5 rounded-lg">
                            <ShoppingBasket className="h-6 w-6 text-white" />
                        </div>
                        <span className="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-violet-600">
                            TienditaCampus
                        </span>
                    </Link>

                    {/* Links Izquierda / Centro */}
                    <div className="hidden md:flex items-center space-x-8">
                        <Link
                            href="/marketplace"
                            className={`text-sm font-medium transition-colors hover:text-indigo-600 ${pathname === '/marketplace' ? 'text-indigo-600' : 'text-slate-600'
                                }`}
                        >
                            Marketplace
                        </Link>
                        {isAuthenticated && isBuyer && (
                            <Link
                                href="/buyer/orders"
                                className={`text-sm font-medium transition-colors hover:text-indigo-600 ${pathname.startsWith('/buyer/orders') ? 'text-indigo-600' : 'text-slate-600'
                                    }`}
                            >
                                Mis Pedidos
                            </Link>
                        )}
                        {isAuthenticated && isSeller && (
                            <Link
                                href="/dashboard"
                                className="text-sm font-medium text-slate-600 hover:text-indigo-600 transition-colors"
                            >
                                Ir a Panel Vendedor
                            </Link>
                        )}
                    </div>

                    {/* Botones Derecha */}
                    <div className="flex items-center space-x-4">
                        {!isAuthenticated ? (
                            <>
                                <Link href="/login">
                                    <Button variant="ghost" size="sm">Iniciar Sesión</Button>
                                </Link>
                                <Link href="/register">
                                    <Button size="sm" className="bg-indigo-600 hover:bg-indigo-700">Crear Cuenta</Button>
                                </Link>
                            </>
                        ) : (
                            <div className="flex items-center space-x-4">
                                <Link href={isBuyer ? "/buyer/settings" : "/dashboard/settings"}>
                                    <div className="flex items-center space-x-2 text-sm text-slate-700 hover:text-indigo-600 transition-colors cursor-pointer">
                                        <div className="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center border border-slate-200">
                                            <User className="h-4 w-4" />
                                        </div>
                                        <span className="hidden sm:inline font-medium">{user?.firstName}</span>
                                    </div>
                                </Link>
                                <Button
                                    variant="ghost"
                                    size="sm"
                                    onClick={logout}
                                    className="text-slate-500 hover:text-red-600"
                                >
                                    <LogOut className="h-4 w-4 sm:mr-2" />
                                    <span className="hidden sm:inline">Salir</span>
                                </Button>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </nav>
    );
}
