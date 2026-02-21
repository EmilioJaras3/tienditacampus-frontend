'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuthStore } from '@/store/auth.store';
import { Loader2, Store, ShoppingBag, Search, ExternalLink, Package } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { ordersService, Order } from '@/services/orders.service';

export default function BuyerDashboardPage() {
    const router = useRouter();
    const { user, isAuthenticated, token, logout } = useAuthStore();
    const [isChecking, setIsChecking] = useState(true);
    const [purchases, setPurchases] = useState<Order[]>([]);
    const [loadingPurchases, setLoadingPurchases] = useState(true);

    useEffect(() => {
        if (!token || !isAuthenticated || !user) {
            router.push('/login');
        } else if (user.role === 'seller') {
            router.push('/dashboard');
        } else {
            setIsChecking(false);
            loadPurchases();
        }
    }, [token, isAuthenticated, user, router]);

    const loadPurchases = async () => {
        try {
            const data = await ordersService.getMyPurchases();
            setPurchases(data);
        } catch (error) {
            console.error('Failure fetching purchases:', error);
        } finally {
            setLoadingPurchases(false);
        }
    };

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

                {/* Mis Compras */}
                <div>
                    <h2 className="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
                        <Package className="text-primary" /> Mis Compras Recientes
                    </h2>

                    {loadingPurchases ? (
                        <div className="flex justify-center py-10">
                            <Loader2 className="animate-spin text-primary" size={32} />
                        </div>
                    ) : purchases.length > 0 ? (
                        <div className="space-y-4">
                            {purchases.map((order) => (
                                <Card key={order.id} className="border-none shadow-sm">
                                    <CardContent className="p-6">
                                        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-4 border-b border-gray-100 pb-4">
                                            <div>
                                                <p className="text-sm font-medium text-gray-500">
                                                    Pedido el {new Date(order.createdAt).toLocaleDateString()} a las {new Date(order.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                                </p>
                                                <p className="font-semibold text-gray-900">
                                                    Vendedor: {order.seller?.firstName} {order.seller?.lastName}
                                                </p>
                                            </div>
                                            <div className="text-left sm:text-right">
                                                <p className="text-sm text-gray-500">Total pagado</p>
                                                <p className="text-xl font-bold text-emerald-600">${Number(order.totalAmount).toFixed(2)}</p>
                                            </div>
                                        </div>
                                        <div className="space-y-3">
                                            {order.items.map((item) => (
                                                <div key={item.id} className="flex items-center justify-between">
                                                    <div className="flex items-center gap-3">
                                                        <div className="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center text-gray-400 font-bold overflow-hidden">
                                                            {item.product?.imageUrl ? (
                                                                <img src={item.product.imageUrl} className="w-full h-full object-cover" alt="" />
                                                            ) : (
                                                                item.product?.name.charAt(0)
                                                            )}
                                                        </div>
                                                        <div>
                                                            <p className="font-medium text-gray-900">{item.quantity}x {item.product?.name}</p>
                                                            <p className="text-xs text-gray-500">Unitario: ${Number(item.unitPrice).toFixed(2)}</p>
                                                        </div>
                                                    </div>
                                                    <div className="font-semibold text-gray-900">
                                                        ${Number(item.subtotal).toFixed(2)}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    </CardContent>
                                </Card>
                            ))}
                        </div>
                    ) : (
                        <div className="text-center py-12 bg-white rounded-xl border border-dashed border-gray-300">
                            <ShoppingBag size={48} className="mx-auto text-gray-300 mb-4" />
                            <h3 className="text-lg font-medium text-gray-900">Aún no has hecho compras</h3>
                            <p className="text-gray-500 mb-4">Explora el marketplace y apoya a tus compañeros.</p>
                            <Link href="/marketplace">
                                <Button>Ver Catálogo</Button>
                            </Link>
                        </div>
                    )}
                </div>
            </main>
        </div>
    );
}
