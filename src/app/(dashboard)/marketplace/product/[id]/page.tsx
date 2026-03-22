'use client';

import { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { productsService, Product } from '@/services/products.service';
import { ArrowLeft, ShoppingCart, CheckCircle, MapPin, Package, Star, MessageSquare, ShieldCheck, Clock, Loader2, Minus, Plus } from 'lucide-react';
import Link from 'next/link';

export default function ProductDetailPage() {
    const { id } = useParams();
    const router = useRouter();
    const [product, setProduct] = useState<Product | null>(null);
    const [loading, setLoading] = useState(true);
    const [quantity, setQuantity] = useState(1);

    useEffect(() => {
        const loadProduct = async () => {
            try {
                setLoading(true);
                const data = await productsService.getById(id as string);
                setProduct(data);
            } catch (error) {
                console.error("Error loading product", error);
                const { toast } = await import('sonner');
                toast.error('Error al cargar el producto');
            } finally {
                setLoading(false);
            }
        };

        if (id) loadProduct();
    }, [id]);

    if (loading) return (
        <div className="h-screen flex items-center justify-center bg-background">
            <Loader2 className="animate-spin text-foreground" size={64} />
        </div>
    );

    if (!product) return (
        <div className="h-screen flex flex-col items-center justify-center bg-background gap-6">
            <h2 className="text-4xl font-semibold tracking-tighter text-foreground">Producto No Encontrado</h2>
            <Link href="/marketplace">
                <button className="px-8 py-4 bg-foreground text-background font-semibold border border-foreground/10 shadow-md hover:shadow-lg hover:-translate-y-1 transition-all">
                    Regresar al Marketplace
                </button>
            </Link>
        </div>
    );

    return (
        <div className="bg-background font-display text-foreground min-h-screen selection:bg-primary/20 selection:text-primary pb-32 mt-16">
            <main className="max-w-7xl mx-auto px-4 py-10 md:px-8">
                {/* Back Button & Breadcrumbs */}
                <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-12 gap-6">
                    <button
                        onClick={() => router.back()}
                        className="group flex items-center gap-3 h-14 px-6 bg-card border border-foreground/10 font-semibold text-xs tracking-widest shadow-md hover:shadow-lg hover:-translate-y-1 transition-all active:scale-95"
                    >
                        <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition-transform" />
                        VOLVER ATRÁS
                    </button>
                    <div className="bg-foreground text-background px-4 py-2 border border-foreground/10 font-bold text-[10px] tracking-[0.2em] -rotate-1 rounded-sm shadow-neo-sm">
                        TIENDACAMPUS / PRODUCTO / {product.name.toUpperCase()}
                    </div>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16">
                    {/* Visual Section */}
                    <div className="lg:col-span-6 space-y-8">
                        <div className="relative aspect-square border-2 border-foreground/5 bg-card shadow-neo-sm overflow-hidden group rounded-2xl">
                            {product.imageUrl ? (
                                <img
                                    src={product.imageUrl}
                                    alt={product.name}
                                    className="w-full h-full object-cover grayscale-[10%] group-hover:grayscale-0 transition-all duration-700 scale-100 group-hover:scale-105"
                                />
                            ) : (
                                <div className="w-full h-full flex items-center justify-center bg-muted/20 font-bold text-9xl text-foreground/20 uppercase select-none">
                                    {product.name.charAt(0)}
                                </div>
                            )}
                            <div className="absolute top-6 left-6 z-20 bg-primary text-primary-foreground border-2 border-foreground/5 px-6 py-2 font-bold text-2xl tracking-tighter shadow-neo-sm transform -rotate-3 rounded-lg">
                                {product.isPerishable ? 'FRESCO' : 'STOCK'}
                            </div>
                        </div>

                        {/* Social Proof Sim (Deco) */}
                        <div className="grid grid-cols-3 gap-4">
                            {[1, 2, 3].map(i => (
                                <div key={i} className="aspect-square border border-foreground/10 bg-card flex items-center justify-center grayscale opacity-30 hover:opacity-100 hover:grayscale-0 transition-all cursor-crosshair">
                                    <Package size={40} className="text-foreground/20" />
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Info Section */}
                    <div className="lg:col-span-6 flex flex-col pt-4">
                        <div className="space-y-6">
                            <div className="flex items-center gap-4">
                                <div className="bg-primary text-primary-foreground py-1 px-3 border border-foreground/10 font-semibold text-[10px] tracking-widest">
                                    LO MÁS VENDIDO
                                </div>
                                <div className="flex items-center gap-1 text-secondary">
                                    <Star fill="currentColor" size={16} /><Star fill="currentColor" size={16} /><Star fill="currentColor" size={16} /><Star fill="currentColor" size={16} /><Star fill="currentColor" size={16} />
                                </div>
                            </div>

                            <h1 className="text-6xl md:text-8xl font-bold tracking-tighter leading-[0.85] text-foreground uppercase">
                                {product.name}
                            </h1>

                            <div className="flex items-end gap-6 py-4">
                                <span className="text-7xl font-bold tracking-tighter text-primary border-b-4 border-secondary/30">${Number(product.salePrice).toFixed(2)}</span>
                                <span className="text-xs font-bold text-primary mb-4 tracking-widest uppercase">PAGO CONTRA ENTREGA</span>
                            </div>

                            {/* Seller Card Redesign */}
                            <div className="p-6 border border-foreground/5 bg-card flex items-center justify-between group hover:border-primary/20 transition-all duration-300 rounded-2xl shadow-sm">
                                <div className="flex items-center gap-4">
                                    <div className="w-16 h-16 border border-foreground/5 bg-primary text-primary-foreground flex items-center justify-center font-bold text-2xl group-hover:rotate-6 transition-transform rounded-xl shadow-neo-sm">
                                        {product.seller?.firstName?.charAt(0).toUpperCase() || 'V'}
                                    </div>
                                    <div>
                                        <p className="text-[10px] font-bold text-primary group-hover:text-primary uppercase tracking-widest">Vendedor Verificado</p>
                                        <p className="font-bold text-xl uppercase tracking-tighter text-foreground transition-colors line-clamp-1">@{((product.seller?.firstName || '') + (product.seller?.lastName || '')).replace(/\s/g, '').toLowerCase() || 'vendedor'}</p>
                                    </div>
                                </div>
                                <button className="h-12 w-12 border-2 border-border hover:border-primary text-foreground hover:text-primary flex items-center justify-center transition-all rounded-xl shadow-sm hover:shadow-neo-sm active:scale-90">
                                    <MessageSquare size={20} />
                                </button>
                            </div>

                            <div className="space-y-4 pt-6">
                                <h3 className="text-xl font-bold tracking-[0.2em] flex items-center gap-2 uppercase">
                                    <div className="w-3 h-3 bg-primary rounded-full"></div> SOBRE PRODUCTO
                                </h3>
                                <p className="text-lg font-bold text-foreground leading-relaxed border-l-2 border-primary pl-6">
                                    {product.description || 'Sin descripción disponible.'}
                                </p>
                            </div>

                            {/* Trust Badges */}
                            <div className="grid grid-cols-2 gap-4 py-8 border-y-2 border-foreground/10 border-dashed">
                                <div className="flex items-center gap-3">
                                    <ShieldCheck className="text-primary" size={24} />
                                    <span className="text-[10px] font-semibold tracking-widest text-muted-foreground text-center uppercase">Seguridad <br/> Campus</span>
                                </div>
                                <div className="flex items-center gap-3">
                                    <Clock className="text-primary" size={24} />
                                    <span className="text-[10px] font-semibold tracking-widest text-muted-foreground text-center uppercase">Entrega <br/> Flash</span>
                                </div>
                            </div>
                        </div>

                        {/* Action Section */}
                        <div className="mt-12 space-y-6">
                            <div className="flex items-center justify-between">
                                <div className="text-xs font-bold text-foreground tracking-widest uppercase">Cantidad</div>
                                <div className="flex items-center border border-foreground/10 bg-background h-14 shadow-neo-sm overflow-hidden rounded-xl">
                                    <button
                                        onClick={() => setQuantity(Math.max(1, quantity - 1))}
                                        className="w-14 h-full flex items-center justify-center hover:bg-primary hover:text-primary-foreground transition-all border-r border-foreground/10 active:scale-90"
                                    >
                                        <Minus size={20} />
                                    </button>
                                    <input
                                        type="number"
                                        value={quantity}
                                        readOnly
                                        className="w-16 h-full text-center font-bold text-xl bg-transparent focus:outline-none"
                                    />
                                    <button
                                        onClick={() => setQuantity(quantity + 1)}
                                        className="w-14 h-full flex items-center justify-center hover:bg-primary hover:text-primary-foreground transition-all border-l border-foreground/10 active:scale-90"
                                    >
                                        <Plus size={20} />
                                    </button>
                                </div>
                            </div>
                        </div>

                            <button
                                onClick={() => router.push(`/checkout?productId=${product.id}&qty=${quantity}`)}
                                className="w-full h-20 bg-primary text-primary-foreground text-3xl font-bold tracking-[0.1em] border border-foreground/10 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all flex items-center justify-center gap-6 active:scale-95 rounded-2xl uppercase"
                            >
                                <ShoppingCart size={32} />
                                PEDIR AHORA
                            </button>

                            <p className="text-[10px] font-semibold text-muted-foreground text-center tracking-widest pt-2 uppercase">
                                Garantía Tiendita: Pago contra entrega en zonas seguras
                            </p>
                        </div>
                    </div>
                </main>
            </div>
        );
    }
