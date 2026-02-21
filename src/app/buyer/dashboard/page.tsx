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
    const { user, isAuthenticated, token, logout, _hasHydrated } = useAuthStore();
    const [isChecking, setIsChecking] = useState(true);
    const [purchases, setPurchases] = useState<Order[]>([]);
    const [loadingPurchases, setLoadingPurchases] = useState(true);

    useEffect(() => {
        if (!_hasHydrated) return;

        if (!token || !isAuthenticated || !user) {
            router.push('/login');
        } else if (user.role === 'seller') {
            router.push('/dashboard');
        } else {
            setIsChecking(false);
            loadPurchases();
        }
    }, [token, isAuthenticated, user, router, _hasHydrated]);

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

    const handleDeliver = async (orderId: string) => {
        try {
            await ordersService.deliver(orderId);
            setPurchases(purchases.map(o => o.id === orderId ? { ...o, status: 'completed' } : o));
        } catch (error) {
            console.error('Error confirming delivery:', error);
        }
    };

    if (isChecking || !user || !_hasHydrated) {
        return (
            <div className="flex h-screen w-full items-center justify-center bg-gray-50">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-[#f7f7f7] pb-20">
            {/* Header del comprador */}
            <header className="bg-white sticky top-0 z-30 border-b-2 border-slate-900 dark:border-white">
                <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
                    <Link href="/marketplace" className="flex items-center gap-2">
                        <div className="w-9 h-9 bg-[#FFC72C] flex items-center justify-center border-2 border-slate-900 dark:border-white shadow-[3px_3px_0px_0px_#E31837]">
                            <ShoppingBag size={16} className="text-slate-900" />
                        </div>
                        <span className="font-black text-lg sm:text-xl uppercase tracking-tight text-slate-900">
                            Tiendita<span className="text-[#E31837]">Campus</span>
                        </span>
                    </Link>
                    <div className="flex items-center gap-3">
                        <Link
                            href="/"
                            className="hidden sm:inline-flex px-3 py-1.5 text-sm font-black uppercase tracking-wide text-slate-900 border-2 border-slate-900 dark:border-white hover:bg-[#FFC72C] transition-colors"
                        >
                            Inicio
                        </Link>
                        <div className="hidden sm:block border-l-2 border-slate-900 dark:border-white pl-4 text-right">
                            <p className="text-sm font-black text-slate-900 uppercase tracking-tight">{user.firstName} {user.lastName}</p>
                            <p className="text-xs text-slate-600 font-mono uppercase">{user.role}</p>
                        </div>
                        <Button
                            variant="outline"
                            className="border-2 border-slate-900 dark:border-white font-black uppercase"
                            onClick={logout}
                        >
                            Salir
                        </Button>
                    </div>
                </div>
            </header>

            <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 animate-fade-in">
                {/* Bienvenida */}
                <div className="border-2 border-slate-900 dark:border-white bg-[#FFC72C] shadow-[8px_8px_0px_0px_#E31837] p-6 sm:p-10">
                    <div className="inline-flex items-center gap-2 border-2 border-slate-900 dark:border-white bg-white px-3 py-1 text-xs font-black uppercase tracking-widest">
                        Area comprador
                    </div>
                    <h1 className="mt-4 text-3xl sm:text-5xl font-black uppercase tracking-tight text-slate-900">
                        Hola, {user.firstName}
                    </h1>
                    <p className="mt-3 text-slate-800 font-medium text-base sm:text-lg max-w-2xl">
                        Descubre lo que tus compañeros están vendiendo hoy en el campus. Desde snacks hasta materiales.
                    </p>
                    <div className="mt-8 flex flex-wrap gap-4">
                        <Link
                            href="/marketplace"
                            className="group relative px-7 py-3.5 bg-[#E31837] text-white font-black text-base uppercase tracking-wide border-2 border-slate-900 dark:border-white shadow-[6px_6px_0px_0px_#ffffff] hover:shadow-none hover:translate-x-[3px] hover:translate-y-[3px] transition-all duration-200"
                        >
                            <span className="flex items-center gap-2">
                                <Search size={18} />
                                Explorar tienda
                            </span>
                        </Link>
                    </div>
                </div>

                {/* Accesos rápidos */}
                <div>
                    <div className="inline-flex items-center gap-2 border-2 border-slate-900 dark:border-white bg-white px-3 py-1 text-xs font-black uppercase tracking-widest mb-4">
                        Accesos rapidos
                    </div>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <Card
                            className="cursor-pointer group border-2 border-slate-900 dark:border-white rounded-none shadow-[6px_6px_0px_0px_#FFC72C] hover:shadow-none hover:translate-x-[2px] hover:translate-y-[2px] transition-all"
                            onClick={() => router.push('/marketplace')}
                        >
                            <CardContent className="p-6 flex items-center gap-4">
                                <div className="bg-[#FFC72C] p-4 border-2 border-slate-900 dark:border-white text-slate-900">
                                    <Store size={26} />
                                </div>
                                <div className="flex-1">
                                    <h3 className="font-black text-lg uppercase tracking-tight text-slate-900">Marketplace</h3>
                                    <p className="text-sm text-slate-700 font-medium">Ver productos disponibles ahora mismo</p>
                                </div>
                                <ExternalLink size={18} className="text-slate-900 opacity-70 group-hover:opacity-100 transition-opacity" />
                            </CardContent>
                        </Card>

                        <Card className="opacity-70 cursor-not-allowed border-2 border-slate-900 dark:border-white rounded-none bg-white shadow-[6px_6px_0px_0px_#E31837]">
                            <CardContent className="p-6 flex items-center gap-4">
                                <div className="bg-white p-4 border-2 border-slate-900 dark:border-white text-slate-900">
                                    <Search size={26} />
                                </div>
                                <div>
                                    <div className="flex items-center gap-2 mb-1">
                                        <h3 className="font-black text-lg uppercase tracking-tight text-slate-900">Buscar vendedores</h3>
                                        <span className="text-[10px] uppercase font-black bg-[#E31837] text-white px-2 py-0.5 border-2 border-slate-900 dark:border-white">Proximamente</span>
                                    </div>
                                    <p className="text-sm text-slate-700 font-medium">Encuentra a tus vendedores favoritos del campus</p>
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
                                            <div className="text-left sm:text-right flex flex-col items-start sm:items-end">
                                                <p className="text-sm text-gray-500 mb-1">Total {order.status === 'completed' ? 'pagado' : 'a pagar'}</p>
                                                <p className="text-xl font-bold text-emerald-600">${Number(order.totalAmount).toFixed(2)}</p>

                                                <div className="mt-3 flex flex-col items-end gap-2">
                                                    <span className={`px-2 py-1 text-xs font-bold rounded-lg uppercase inline-block ${order.status === 'requested' ? 'bg-blue-100 text-blue-700' :
                                                        order.status === 'pending' ? 'bg-orange-100 text-orange-700' :
                                                            order.status === 'completed' ? 'bg-emerald-100 text-emerald-700' :
                                                                'bg-red-100 text-red-700'
                                                        }`}>
                                                        {order.status === 'requested' ? 'Esperando Confirmación' :
                                                            order.status === 'pending' ? 'Por Entregar' :
                                                                order.status === 'completed' ? 'Completado' :
                                                                    'Rechazado/Cancelado'}
                                                    </span>

                                                    {order.status === 'pending' && (
                                                        <Button onClick={() => handleDeliver(order.id)} className="bg-emerald-600 hover:bg-emerald-700 shadow-md h-8 text-xs">
                                                            Confirmar Recepción
                                                        </Button>
                                                    )}
                                                </div>
                                            </div>
                                        </div>

                                        {order.deliveryMessage && (
                                            <div className="mb-4 bg-blue-50/50 p-3 rounded-lg border border-blue-100">
                                                <p className="text-xs font-semibold text-blue-800 mb-1">Tus instrucciones de entrega:</p>
                                                <p className="text-sm text-blue-600">
                                                    &quot;{order.deliveryMessage}&quot;
                                                </p>
                                            </div>
                                        )}
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
