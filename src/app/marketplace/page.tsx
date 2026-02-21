'use client';

import { useEffect, useState, type ChangeEvent } from 'react';
import Link from 'next/link';
import { useDebounce } from 'use-debounce';
import { Search, ShoppingBag, Store, Loader2 } from 'lucide-react';
import { productsService, Product } from '@/services/products.service';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { ProductCard } from '@/components/product-card';
import { useAuthStore } from '@/store/auth.store';

export default function MarketplacePage() {
    const [products, setProducts] = useState<Product[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [debouncedSearch] = useDebounce(searchTerm, 500);

    const { user, isAuthenticated, logout } = useAuthStore();

    useEffect(() => {
        const fetchProducts = async () => {
            setLoading(true);
            try {
                const data = await productsService.getMarketplace(debouncedSearch);
                setProducts(data);
            } catch (error) {
                console.error('Error fetching marketplace:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchProducts();
    }, [debouncedSearch]);

    return (
        <div className="min-h-screen bg-[#f7f7f7]">
            {/* Navbar Context-Aware */}
            <nav className="bg-white sticky top-0 z-30 border-b-2 border-slate-900 dark:border-white">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
                    <Link href="/" className="flex items-center gap-2">
                        <div className="w-9 h-9 bg-[#FFC72C] flex items-center justify-center border-2 border-slate-900 dark:border-white shadow-[3px_3px_0px_0px_#E31837]">
                            <Store size={16} className="text-slate-900" />
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
                        {!isAuthenticated ? (
                            <>
                                <Link href="/login" className="hidden sm:inline-flex">
                                    <Button variant="outline" className="border-2 border-slate-900 dark:border-white font-black uppercase">
                                        Iniciar sesion
                                    </Button>
                                </Link>
                                <Link href="/register">
                                    <Button className="bg-[#E31837] hover:bg-[#c9122e] border-2 border-slate-900 dark:border-white font-black uppercase shadow-[4px_4px_0px_0px_#FFC72C]">
                                        Registrarse
                                    </Button>
                                </Link>
                            </>
                        ) : user?.role === 'seller' ? (
                            <Link href="/dashboard">
                                <Button className="bg-[#1a1a1a] hover:bg-black border-2 border-slate-900 dark:border-white font-black uppercase shadow-[4px_4px_0px_0px_#FFC72C]">
                                    Ir a mi dashboard
                                </Button>
                            </Link>
                        ) : (
                            <div className="flex items-center gap-3">
                                <Link href="/buyer/dashboard">
                                    <Button variant="outline" className="border-2 border-slate-900 dark:border-white font-black uppercase">
                                        Mi area
                                    </Button>
                                </Link>
                                <Button
                                    variant="outline"
                                    onClick={logout}
                                    className="border-2 border-slate-900 dark:border-white font-black uppercase"
                                >
                                    Salir
                                </Button>
                            </div>
                        )}
                    </div>
                </div>
            </nav>

            <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                {/* Header & Search */}
                <div className="mb-8">
                    <div className="border-2 border-slate-900 dark:border-white bg-white shadow-[6px_6px_0px_0px_#E31837] p-6">
                        <div className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
                            <div>
                                <div className="inline-flex items-center gap-2 border-2 border-slate-900 dark:border-white bg-[#FFC72C] px-3 py-1 text-xs font-black uppercase tracking-widest">
                                    Marketplace
                                </div>
                                <h1 className="mt-3 text-3xl sm:text-4xl font-black uppercase tracking-tight text-slate-900">
                                    ¿Que se te antoja hoy?
                                </h1>
                                <p className="mt-2 text-slate-700 font-medium">
                                    Busca snacks, postres, bebidas y mas.
                                </p>
                            </div>

                            <div className="w-full md:max-w-xl">
                                <div className="relative">
                                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-900" size={18} />
                                    <Input
                                        placeholder="Buscar productos..."
                                        className="pl-10 h-12 text-base border-2 border-slate-900 dark:border-white rounded-none shadow-none focus-visible:ring-0 focus-visible:ring-offset-0"
                                        value={searchTerm}
                                        onChange={(e: ChangeEvent<HTMLInputElement>) => setSearchTerm(e.target.value)}
                                    />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Grid de Productos */}
                {loading ? (
                    <div className="flex justify-center py-20">
                        <Loader2 className="animate-spin text-primary" size={40} />
                    </div>
                ) : products.length > 0 ? (
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                        {products.map((product) => (
                            <ProductCard key={product.id} product={product} />
                        ))}
                    </div>
                ) : (
                    <div className="text-center py-20 bg-white rounded-xl border border-dashed border-gray-300">
                        <ShoppingBag size={48} className="mx-auto text-gray-300 mb-4" />
                        <h3 className="text-lg font-medium text-gray-900">No encontramos productos</h3>
                        <p className="text-gray-500">Intenta buscar con otro término.</p>
                    </div>
                )}
            </main>
        </div>
    );
}
