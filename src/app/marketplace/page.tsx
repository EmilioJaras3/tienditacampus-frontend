'use client';

import { useState, useEffect } from 'react';
import { productsService, Product } from '@/services/products.service';
import { Input } from '@/components/ui/input';
import { Search, ShoppingCart, Store, Bolt, Plus } from 'lucide-react';
import Link from 'next/link';

export default function MarketplacePage() {
    const [products, setProducts] = useState<Product[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchQuery, setSearchQuery] = useState('');

    useEffect(() => {
        loadProducts();
    }, []);

    const loadProducts = async (q?: string) => {
        try {
            setLoading(true);
            const data = await productsService.findMarketplace(q);
            setProducts(data);
        } catch (error) {
            console.error("Error loading products", error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="bg-background-light dark:bg-background-dark font-display min-h-screen flex flex-col overflow-x-hidden selection:bg-neo-yellow selection:text-black">
            <header className="sticky top-[64px] z-40 w-full border-b-4 border-black bg-white px-4 py-4 md:px-8">
                <div className="mx-auto flex max-w-7xl items-center justify-between gap-4">
                    <div className="flex max-w-lg flex-1 items-center">
                        <div className="relative w-full">
                            <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                                <Search className="text-gray-500 w-5 h-5" />
                            </div>
                            <input
                                className="block w-full rounded-none border-2 border-neo-black bg-white py-2.5 pl-10 pr-4 text-sm font-bold text-black placeholder-gray-500 focus:border-neo-red focus:outline-none focus:ring-0 shadow-neo-sm transition-all hover:-translate-y-0.5 hover:shadow-neo"
                                placeholder="Buscar tacos, plumas, libros..."
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                onKeyDown={(e) => e.key === 'Enter' && loadProducts(searchQuery)}
                            />
                        </div>
                    </div>
                </div>
            </header>

            <main className="mx-auto flex w-full max-w-7xl flex-col gap-8 px-4 py-8 md:px-8">
                <section className="relative w-full overflow-hidden border-4 border-black bg-neo-red p-6 md:p-10 shadow-neo-lg">
                    <div className="relative z-10 flex flex-col gap-4">
                        <div className="inline-flex w-fit items-center gap-2 border-2 border-black bg-neo-yellow px-3 py-1 text-xs font-bold uppercase tracking-wider text-black shadow-neo-sm transform -rotate-2">
                            <Bolt className="text-sm w-4 h-4" /> Ofertas Flash
                        </div>
                        <h2 className="max-w-2xl text-4xl font-black uppercase italic leading-none text-white md:text-6xl">
                            ¡Explora el Campus!
                        </h2>
                        <p className="max-w-md text-lg font-medium text-white/90">
                            Encuentra comida, snacks y todo lo que necesitas sin salir de la universidad.
                        </p>
                    </div>
                    <div className="absolute -right-10 -top-10 h-64 w-64 rotate-12 bg-white opacity-10 mix-blend-overlay blur-3xl rounded-full"></div>
                </section>

                <section className="flex flex-col gap-4">
                    <div className="flex items-center justify-between">
                        <h3 className="text-2xl font-black text-black dark:text-white flex items-center gap-2">
                            <Store className="text-neo-red w-6 h-6" /> Categorías
                        </h3>
                    </div>
                    <div className="flex gap-3 overflow-x-auto pb-4 hide-scrollbar">
                        <button className="flex shrink-0 items-center gap-2 border-2 border-black bg-black px-5 py-2 text-sm font-bold text-white shadow-neo-sm transition-transform hover:-translate-y-0.5 active:translate-y-0">
                            Todo
                        </button>
                        <button className="flex shrink-0 items-center gap-2 border-2 border-black bg-white px-5 py-2 text-sm font-bold text-black shadow-neo-sm transition-all hover:-translate-y-0.5 hover:bg-neo-yellow hover:shadow-neo active:translate-y-0 active:shadow-none">
                            Comida
                        </button>
                    </div>
                </section>

                <section className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 pb-12">
                    {loading ? (
                        [1, 2, 3, 4].map(i => <div key={i} className="h-80 bg-slate-200 animate-pulse border-4 border-black" />)
                    ) : (
                        products.map(product => (
                            <article key={product.id} className="group relative flex flex-col border-4 border-black bg-white shadow-neo transition-all hover:-translate-y-1 hover:shadow-neo-lg">
                                <div className="relative aspect-square w-full overflow-hidden border-b-4 border-black bg-gray-100">
                                    <div className="absolute left-3 top-3 z-10 border-2 border-black bg-neo-yellow px-2 py-1 text-sm font-black text-black shadow-neo-sm">
                                        ${product.salePrice}
                                    </div>
                                    <div className="absolute inset-0 flex items-center justify-center">
                                        <Store className="w-16 h-16 text-slate-300" />
                                    </div>
                                </div>
                                <div className="flex flex-1 flex-col p-4 bg-white">
                                    <div className="flex items-start justify-between gap-2">
                                        <h4 className="text-lg font-extrabold leading-tight text-black line-clamp-2">{product.name}</h4>
                                    </div>
                                    <div className="mt-2 flex items-center gap-2 text-xs font-bold text-gray-600">
                                        <span>{product.seller?.fullName || 'Vendedor Oculto'}</span>
                                    </div>
                                    <div className="mt-4 flex gap-2">
                                        <Link href={`/marketplace/product/${product.id}`} className="flex-1">
                                            <button className="w-full border-2 border-black bg-neo-red py-2 text-center text-sm font-bold uppercase tracking-wider text-white shadow-neo-sm transition-transform hover:-translate-y-0.5 hover:shadow-neo active:translate-y-0 active:shadow-none">
                                                Ver Producto
                                            </button>
                                        </Link>
                                        <Link href={`/checkout?productId=${product.id}`}>
                                            <button className="flex w-10 items-center justify-center border-2 border-black bg-white text-black shadow-neo-sm transition-transform hover:-translate-y-0.5 hover:bg-neo-yellow hover:shadow-neo active:translate-y-0 active:shadow-none">
                                                <Plus className="text-lg" />
                                            </button>
                                        </Link>
                                    </div>
                                </div>
                            </article>
                        ))
                    )}
                </section>
            </main>
        </div>
    );
}
