'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { Store, Calendar, MapPin, Loader2, MessageCircle } from 'lucide-react';
import { usersService, PublicUser } from '@/services/users.service';
import { Product } from '@/services/products.service';
import { ProductCard } from '@/components/product-card';
import { Button } from '@/components/ui/button';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';

export default function SellerProfilePage({ params }: { params: { id: string } }) {
    const [seller, setSeller] = useState<PublicUser | null>(null);
    const [products, setProducts] = useState<Product[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const loadData = async () => {
            try {
                const userData = await usersService.getPublicProfile(params.id);
                setSeller(userData);
                setProducts(userData.products || []);
            } catch (err: any) {
                console.error(err);
                setError('No pudimos cargar la información del vendedor.');
            } finally {
                setLoading(false);
            }
        };

        if (params.id) {
            loadData();
        }
    }, [params.id]);

    if (loading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-gray-50">
                <Loader2 className="animate-spin text-primary" size={40} />
            </div>
        );
    }

    if (error || !seller) {
        return (
            <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 gap-4">
                <h1 className="text-2xl font-bold text-gray-800">Ups... 😕</h1>
                <p className="text-gray-600">{error || 'Vendedor no encontrado'}</p>
                <Link href="/marketplace">
                    <Button variant="outline">Volver al Marketplace</Button>
                </Link>
            </div>
        );
    }

    const hasActiveStock = products.length > 0; // El endpoint getMarketplace ya filtra stock > 0
    const joinedDate = new Date(seller.createdAt).toLocaleDateString('es-MX', {
        month: 'long',
        year: 'numeric'
    });

    return (
        <div className="min-h-screen bg-background font-display selection:bg-primary/20 pb-20">
            {/* Navbar Simple */}
            <nav className="bg-card sticky top-0 z-30 border-b border-foreground/5 backdrop-blur-md bg-card/80">
                <div className="max-w-7xl mx-auto px-6 lg:px-10 h-20 flex items-center justify-between">
                    <Link
                        href="/marketplace"
                        className="h-10 px-6 flex items-center text-xs font-bold tracking-[0.2em] uppercase border border-foreground/10 hover:bg-foreground hover:text-background transition-all rounded-xl"
                    >
                        Volver
                    </Link>
                    <Link href="/" className="font-bold text-xl uppercase tracking-tighter text-foreground decoration-primary decoration-4 underline-offset-4">
                        Tiendita<span className="text-primary italic">Campus</span>
                    </Link>
                </div>
            </nav>

            {/* Header Profile */}
            <div className="bg-card border-b border-foreground/5 relative overflow-hidden">
                <div className="absolute top-0 right-0 w-96 h-96 bg-primary/5 blur-[100px] -mr-32 -mt-32"></div>
                <div className="max-w-5xl mx-auto px-6 lg:px-10 py-16 relative z-10">
                    <div className="bg-background/50 border border-foreground/5 p-10 rounded-[3rem] shadow-neo-sm">
                        <div className="flex flex-col md:flex-row items-center md:items-center gap-10 text-center md:text-left">
                            <div className="w-32 h-32 border border-foreground/5 shadow-neo bg-primary text-primary-foreground flex items-center justify-center text-5xl font-bold rotate-[-3deg] hover:rotate-0 transition-transform rounded-[2.5rem] relative group overflow-hidden">
                                {seller.avatarUrl ? (
                                    <img src={seller.avatarUrl} alt={seller.firstName} className="w-full h-full object-cover" />
                                ) : (
                                    <span>{seller.firstName.charAt(0)}</span>
                                )}
                            </div>

                            <div className="flex-1 space-y-4">
                                <div className="flex flex-col md:flex-row items-center gap-4">
                                    <h1 className="text-4xl md:text-5xl font-bold tracking-tighter text-foreground uppercase italic underline decoration-primary/20 decoration-8 underline-offset-8">
                                        {seller.firstName} {seller.lastName}
                                    </h1>
                                    {hasActiveStock ? (
                                        <div className="bg-primary text-primary-foreground border border-foreground/5 px-4 py-1.5 font-bold text-[10px] tracking-[0.3em] shadow-neo-sm transform -rotate-1 uppercase rounded-full flex items-center gap-2">
                                            <span className="w-2 h-2 bg-background rounded-full animate-pulse" />
                                            En Venta
                                        </div>
                                    ) : (
                                        <Badge variant="secondary" className="bg-foreground/5 text-foreground/30 border-none px-4 py-1.5 font-bold text-[10px] tracking-[0.3em] uppercase rounded-full">
                                            Catálogo Inactivo
                                        </Badge>
                                    )}
                                </div>

                                <div className="flex flex-wrap items-center justify-center md:justify-start gap-6 pt-2">
                                    <span className="flex items-center gap-2 text-[10px] font-bold text-foreground/40 uppercase tracking-widest italic">
                                        <Store size={16} className="text-primary" /> Vendedor Verificado
                                    </span>
                                    <span className="flex items-center gap-2 text-[10px] font-bold text-foreground/40 uppercase tracking-widest italic">
                                        <Calendar size={16} className="text-foreground/20" /> Miembro desde {joinedDate}
                                    </span>
                                </div>
                            </div>

                            <div className="flex gap-4">
                                <button className="h-14 px-8 bg-primary text-primary-foreground border border-foreground/5 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all rounded-2xl font-bold text-xs tracking-[0.2em] uppercase flex items-center gap-3">
                                    <MessageCircle size={20} />
                                    Contactar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Content */}
            <main className="max-w-5xl mx-auto px-6 lg:px-10 py-16">
                <div className="flex items-center gap-4 border-b-2 border-foreground/5 pb-4 mb-12">
                    <TrendingUp className="text-primary w-8 h-8" />
                    <h2 className="text-3xl font-bold tracking-tighter uppercase italic">Productos Disponibles</h2>
                    <div className="ml-auto bg-foreground text-background px-4 py-1.5 font-bold text-[10px] uppercase tracking-[0.3em] rounded-full shadow-sm">
                        {products.length} Items
                    </div>
                </div>

                {products.length > 0 ? (
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
                        {products.map((product) => (
                            <ProductCard key={product.id} product={product} />
                        ))}
                    </div>
                ) : (
                    <div className="border border-foreground/5 bg-card shadow-neo-sm p-20 text-center rounded-[3rem]">
                        <Store size={48} className="mx-auto text-foreground/5 mb-6" />
                        <h3 className="text-2xl font-bold tracking-tighter text-foreground/30 uppercase italic">Catálogo vacío</h3>
                        <p className="mt-4 text-xs font-bold text-foreground/20 uppercase tracking-widest max-w-xs mx-auto">
                            {seller.firstName} no tiene productos publicados en este momento. Vuelve pronto para ver novedades.
                        </p>
                    </div>
                )}
            </main>
        </div>
    );
}
