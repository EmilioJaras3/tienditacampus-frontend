'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { productsService, Product } from '@/services/products.service';
import { ArrowLeft, ShoppingCart, CheckCircle, MapPin } from 'lucide-react';

export default function ProductDetailPage() {
    const { id } = useParams();
    const router = useRouter();
    const [product, setProduct] = useState<Product | null>(null);
    const [loading, setLoading] = useState(true);
    const [quantity, setQuantity] = useState(1);

    useEffect(() => {
        if (id) loadProduct();
    }, [id]);

    const loadProduct = async () => {
        try {
            setLoading(true);
            const data = await productsService.getById(id as string, false);
            setProduct(data);
        } catch (error) {
            console.error("Error loading product", error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) return (
        <div className="max-w-7xl mx-auto px-4 py-12 animate-pulse bg-background-dark min-h-screen">
            <div className="h-96 bg-gray-800 rounded-xl border-2 border-white mb-8" />
        </div>
    );

    if (!product) return (
        <div className="max-w-7xl mx-auto px-4 py-12 text-center bg-background-dark min-h-screen text-white">
            <h2 className="text-2xl font-bold font-mono">Producto no encontrado</h2>
        </div>
    );

    return (
        <div className="bg-background-light dark:bg-background-dark font-display text-slate-900 dark:text-slate-100 min-h-screen flex flex-col">
            <main className="flex-grow container mx-auto px-4 py-8 max-w-7xl">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
                    <button
                        onClick={() => router.back()}
                        className="group inline-flex items-center gap-2 text-primary font-bold uppercase tracking-wider text-sm hover:text-white transition-colors"
                    >
                        <ArrowLeft className="w-4 h-4 group-hover:-translate-x-1 transition-transform" />
                        Volver al Tianguis
                    </button>
                    <div className="flex gap-2 text-xs font-mono text-gray-400">
                        <span>INICIO</span> / <span>PRODUCTO</span> / <span className="text-white uppercase line-clamp-1">{product.name}</span>
                    </div>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12">
                    <div className="lg:col-span-7 flex flex-col gap-4">
                        <div className="relative w-full aspect-square md:aspect-[4/3] rounded-xl overflow-hidden border-2 border-neo-white shadow-neo-white bg-black group">
                            <div className="absolute inset-0 bg-neo-yellow mix-blend-multiply opacity-50 z-10 pointer-events-none"></div>
                            {/* Placeholder de imagen de producto en grises según tu diseño */}
                            <div className="w-full h-full flex flex-col items-center justify-center filter grayscale contrast-125">
                                <span className="material-symbols-outlined text-[120px] text-white">lunch_dining</span>
                            </div>

                            <div className="absolute top-4 left-4 bg-black border border-neo-yellow px-3 py-1 z-20">
                                <span className="text-neo-yellow font-bold text-xs uppercase tracking-widest">
                                    {product.isPerishable ? 'Fresco' : 'Envasado'}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div className="lg:col-span-5 flex flex-col gap-6">
                        <div className="bg-surface-dark p-6 rounded-xl border-2 border-white/10 relative overflow-hidden">
                            <div className="absolute top-0 right-0 w-24 h-24 bg-neo-primary blur-[60px] opacity-20 pointer-events-none"></div>
                            <h1 className="text-4xl md:text-5xl font-black text-white leading-[0.95] tracking-tight mb-4 uppercase">
                                {product.name}
                            </h1>
                            <div className="flex items-end gap-3 mb-6">
                                <div className="bg-white text-black text-3xl font-black px-4 py-1 -skew-x-6 border-2 border-neo-primary shadow-neo-sm inline-block">
                                    ${product.salePrice}
                                </div>
                            </div>
                            <div className="flex items-center gap-3 p-3 border-2 border-dashed border-white/30 rounded-lg hover:bg-white/5 hover:border-neo-primary transition-all group">
                                <div className="w-10 h-10 rounded bg-neo-primary flex items-center justify-center border border-white text-black font-bold text-lg">
                                    {product.seller?.fullName?.substring(0, 2).toUpperCase() || 'VD'}
                                </div>
                                <div className="flex-1">
                                    <p className="text-xs text-neo-primary uppercase font-bold tracking-wider">Vendedor</p>
                                    <p className="text-white font-bold text-sm group-hover:underline">@{product.seller?.fullName?.replace(' ', '') || 'CampusStore'}</p>
                                </div>
                            </div>
                        </div>

                        <div className="space-y-4">
                            <h3 className="text-lg font-bold text-white uppercase border-l-4 border-neo-primary pl-3">Descripción</h3>
                            <div className="text-gray-300 font-normal leading-relaxed text-sm md:text-base border-2 border-white/10 p-4 rounded-lg bg-[#1a1515]">
                                <p className="mb-4">{product.description || 'Este producto es de alta calidad y está disponible hoy mismo en el campus.'}</p>
                                <ul className="space-y-2 font-mono text-xs text-neo-primary/80">
                                    <li className="flex items-center gap-2">
                                        <CheckCircle className="w-4 h-4" /> LISTO PARA ENTREGAR
                                    </li>
                                    <li className="flex items-center gap-2">
                                        <MapPin className="w-4 h-4" /> ENTREGA EN CAMPUS
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div className="mt-auto pt-6 border-t-2 border-white/10">
                            <div className="flex flex-col gap-4">
                                <div className="flex items-center justify-between">
                                    <label className="text-white font-bold uppercase text-sm">Cantidad</label>
                                    <div className="flex items-center border-2 border-white rounded bg-black">
                                        <button
                                            className="w-10 h-10 flex items-center justify-center text-white hover:bg-white/20 transition-colors border-r border-white/20 font-bold"
                                            onClick={() => setQuantity(Math.max(1, quantity - 1))}
                                        >-</button>
                                        <input
                                            className="w-12 h-10 bg-transparent text-center text-white font-bold focus:outline-none border-none appearance-none"
                                            readOnly
                                            type="number"
                                            value={quantity}
                                        />
                                        <button
                                            className="w-10 h-10 flex items-center justify-center text-neo-primary hover:bg-neo-primary/20 transition-colors border-l border-white/20 font-bold"
                                            onClick={() => setQuantity(quantity + 1)}
                                        >+</button>
                                    </div>
                                </div>
                                <button
                                    className="w-full bg-neo-red text-white font-black text-xl uppercase py-4 px-6 rounded-lg border-2 border-black shadow-[4px_4px_0px_0px_#ffffff] hover:shadow-none hover:translate-x-1 hover:translate-y-1 transition-all flex items-center justify-center gap-3 group"
                                    onClick={() => router.push(`/checkout?productId=${product.id}&qty=${quantity}`)}
                                >
                                    <span>Pedir Ahora</span>
                                    <ShoppingCart className="w-5 h-5 group-hover:animate-bounce" />
                                </button>
                                <p className="text-center text-xs text-gray-500 mt-2">
                                    Pago seguro o en efectivo contra entrega.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}
