'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuthStore } from '@/store/auth.store';
import { Loader2, Store, ShoppingBag, Search, ExternalLink } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

export default function BuyerDashboardPage() {
    const router = useRouter();
    const { user, isAuthenticated, token, logout } = useAuthStore();
    const [isChecking, setIsChecking] = useState(true);

    useEffect(() => {
        // Verificar auth y rol
        if (!token || !isAuthenticated || !user) {
            router.push('/login');
        } else if (user.role === 'seller') {
            router.push('/dashboard');
        } else {
            setIsChecking(false);
        }
    }, [token, isAuthenticated, user, router]);

    if (isChecking || !user) {
        return (
            <div className="flex h-screen w-full items-center justify-center bg-gray-50">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 pb-20">
            {/* Header del comprador */}
            <header className="bg-white border-b border-gray-200 sticky top-0 z-30 shadow-sm">
                <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
                    <Link href="/marketplace" className="flex items-center gap-2">
                        <div className="bg-primary text-white p-1.5 rounded-lg">
                            <ShoppingBag size={20} />
                        </div>
                        <span className="font-bold text-xl text-gray-900 hidden sm:block">TienditaCampus</span>
                    </Link>
                    <div className="flex items-center gap-4">
                        <div className="hidden sm:flex items-center gap-4 mr-2">
                            <Link href="/" className="text-sm font-medium text-gray-500 hover:text-primary transition-colors">
                                Inicio
                            </Link>
                        </div>
                        <div className="text-right hidden sm:block border-l border-gray-200 pl-4">
                            <p className="text-sm font-semibold text-gray-900">{user.firstName} {user.lastName}</p>
                            <p className="text-xs text-gray-500 capitalize">{user.role}</p>
                        </div>
                        <Button variant="ghost" className="text-gray-500 hover:text-red-600" onClick={logout}>
                            Salir
                        </Button>
                    </div>
                </div>
            </header>

            <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 animate-fade-in">
                {/* Bienvenida */}
                <div className="bg-gradient-to-r from-emerald-600 to-teal-500 rounded-2xl p-6 sm:p-10 text-white shadow-lg">
                    <h1 className="text-3xl sm:text-4xl font-bold mb-2">¡Hola, {user.firstName}! 👋</h1>
                    <p className="text-emerald-50 text-lg max-w-2xl mb-6">
                        Descubre lo que tus compañeros están vendiendo hoy en el campus. Desde snacks hasta materiales.
                    </p>
                    <div className="flex flex-wrap gap-4">
                        <Link href="/marketplace">
                            <Button className="bg-white text-emerald-700 hover:bg-gray-100 border-none font-bold h-12 px-6 shadow-md">
                                <Search className="mr-2" size={20} />
                                Explorar Tienda
                            </Button>
                        </Link>
                    </div>
                </div>

                {/* Accesos rápidos */}
                <div>
                    <h2 className="text-xl font-bold text-gray-900 mb-4">Accesos Rápidos</h2>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <Card className="hover-card border-none shadow-sm cursor-pointer group" onClick={() => router.push('/marketplace')}>
                            <CardContent className="p-6 flex items-center gap-4">
                                <div className="bg-emerald-100 p-4 rounded-xl text-emerald-600 group-hover:scale-110 transition-transform">
                                    <Store size={28} />
                                </div>
                                <div className="flex-1">
                                    <h3 className="font-bold text-lg text-gray-900 group-hover:text-emerald-700 transition-colors">Marketplace</h3>
                                    <p className="text-sm text-gray-500">Ver todos los productos disponibles ahora mismo</p>
                                </div>
                                <ExternalLink size={20} className="text-gray-300 group-hover:text-emerald-500 transition-colors" />
                            </CardContent>
                        </Card>

                        <Card className="hover-card border-none shadow-sm opacity-70 cursor-not-allowed">
                            <CardContent className="p-6 flex items-center gap-4">
                                <div className="bg-blue-100 p-4 rounded-xl text-blue-600">
                                    <Search size={28} />
                                </div>
                                <div>
                                    <div className="flex items-center gap-2 mb-1">
                                        <h3 className="font-bold text-lg text-gray-900">Buscar Vendedores</h3>
                                        <span className="text-[10px] uppercase font-bold bg-gray-200 text-gray-600 px-2 py-0.5 rounded-full">Próximamente</span>
                                    </div>
                                    <p className="text-sm text-gray-500">Encuentra a tus vendedores favoritos del campus</p>
                                </div>
                            </CardContent>
                        </Card>
                    </div>
                </div>
            </main>
        </div>
    );
}
