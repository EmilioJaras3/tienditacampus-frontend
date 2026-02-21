'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useDebounce } from 'use-debounce';
import { Search, ShoppingBag, Store, ExternalLink, Loader2 } from 'lucide-react';
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
        <div className="min-h-screen bg-gray-50">
            {/* Navbar Context-Aware */}
            <nav className="bg-white border-b border-gray-200 sticky top-0 z-30 shadow-sm">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
                    <Link href="/" className="flex items-center gap-2">
                        <div className="bg-primary text-white p-1.5 rounded-lg">
                            <Store size={20} />
                        </div>
                        <span className="font-bold text-xl text-gray-900 hidden sm:block">TienditaCampus</span>
                    </Link>

                    <div className="flex items-center gap-4">
                        <Link href="/" className="text-sm font-medium text-gray-500 hover:text-primary transition-colors hidden sm:block mr-2">
                            Inicio
                        </Link>
                        {!isAuthenticated ? (
                            <>
                                <Link href="/login">
                                    <Button variant="ghost" className="hidden sm:inline-flex">Iniciar Sesión</Button>
                                </Link>
                                <Link href="/register">
                                    <Button>Registrarse</Button>
                                </Link>
                            </>
                        ) : user?.role === 'seller' ? (
                            <Link href="/dashboard">
                                <Button className="bg-blue-600 hover:bg-blue-700">Ir a mi Dashboard</Button>
                            </Link>
                        ) : (
                            <div className="flex items-center gap-4">
                                <Link href="/buyer/dashboard">
                                    <Button variant="outline" className="text-emerald-700 border-emerald-200 hover:bg-emerald-50">Mi Área</Button>
                                </Link>
                                <Button variant="ghost" onClick={logout} className="text-gray-500 hover:text-red-600">
                                    <span className="hidden sm:inline">Salir</span>
                                </Button>
                            </div>
                        )}
                    </div>
                </div>
            </nav>

            <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                {/* Header & Search */}
                <div className="mb-8 space-y-4">
                    <h1 className="text-3xl font-bold text-gray-900">¿Qué se te antoja hoy? 😋</h1>
                    <div className="relative max-w-xl">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
                        <Input
                            placeholder="Buscar snacks, postres, bebidas..."
                            className="pl-10 h-12 text-lg shadow-sm"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
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
