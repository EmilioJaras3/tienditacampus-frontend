'use client';

import { Suspense, useState, useEffect } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import { productsService, Product } from '@/services/products.service';
import { ordersService } from '@/services/orders.service';
import { ArrowLeft, CheckCircle, Package, Zap, MessageSquare, ShieldCheck, MapPin, Loader2, DollarSign, Plus, Minus } from 'lucide-react';
import { toast } from 'sonner';

function CheckoutContent() {
    const searchParams = useSearchParams();
    const router = useRouter();

    const productId = searchParams.get('productId');
    const initialQty = parseInt(searchParams.get('qty') || '1', 10);

    const [product, setProduct] = useState<Product | null>(null);
    const [loading, setLoading] = useState(true);
    const [isSubmitting, setIsSubmitting] = useState(false);

    const [quantity, setQuantity] = useState(initialQty);
    const [deliveryMessage, setDeliveryMessage] = useState('');

    useEffect(() => {
        const loadProduct = async () => {
            try {
                setLoading(true);
                const data = await productsService.getById(productId as string);
                setProduct(data);
            } catch (error) {
                console.error("Error loading product", error);
                toast.error('Producto no encontrado');
            } finally {
                setLoading(false);
            }
        };

        if (productId) loadProduct();
    }, [productId]);

    const handleCheckout = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!product || !product.seller?.id) return;

        try {
            setIsSubmitting(true);
            await ordersService.createOrder({
                sellerId: product.seller.id,
                items: [
                    { productId: product.id, quantity }
                ],
                deliveryMessage
            });

            toast.success('¡PEDIDO ENVIADO!', {
                description: 'El vendedor ha sido notificado. Revisa tu panel para ver el estado.',
            });

            router.push('/dashboard');
        } catch (error: any) {
            console.error(error);
            toast.error(error?.response?.data?.message || 'Error al crear el pedido');
        } finally {
            setIsSubmitting(false);
        }
    };

    if (loading) return (
        <div className="h-screen flex items-center justify-center bg-background">
            <Loader2 className="animate-spin text-foreground" size={64} />
        </div>
    );

    if (!product) return (
        <div className="h-screen flex flex-col items-center justify-center bg-background gap-6">
            <h2 className="text-4xl font-semibold tracking-tighter italic text-foreground">CARRITO VACÍO</h2>
            <button onClick={() => router.push('/marketplace')} className="px-8 py-4 bg-foreground text-background font-semibold border border-foreground/10 shadow-md hover:shadow-lg hover:-translate-y-1 transition-all">
                Explorar Marketplace
            </button>
        </div>
    );

    const total = Number(product.salePrice) * quantity;

    return (
        <div className="bg-background font-display text-foreground min-h-screen selection:bg-primary/20 selection:text-primary pb-32 mt-16">
            {/* Minimalist Navigation */}
            <header className="border-b-2 border-foreground/5 bg-background/80 backdrop-blur-md sticky top-0 z-[60]">
                <div className="max-w-7xl mx-auto px-4 h-24 md:px-8 flex justify-between items-center">
                    <button
                        onClick={() => router.back()}
                        className="group h-14 px-8 border-2 border-foreground/10 bg-background font-bold text-xs tracking-[0.2em] flex items-center gap-3 hover:bg-secondary hover:shadow-neo transition-all rounded-sm"
                    >
                        <ArrowLeft size={18} className="group-hover:-translate-x-1 transition-transform" /> ATRÁS
                    </button>
                    <div className="bg-primary text-primary-foreground border-2 border-foreground/10 font-bold text-[10px] tracking-[0.3em] px-4 py-2 -rotate-2 shadow-neo-sm uppercase">
                        Pago Seguro • Campus
                    </div>
                </div>
            </header>

            <main className="max-w-7xl mx-auto px-4 py-12 md:px-8">
                <div className="flex flex-col lg:flex-row gap-16 items-start">

                    {/* Form Section */}
                    <div className="flex-1 space-y-16">
                        <div className="space-y-6">
                            <h1 className="text-7xl md:text-9xl font-bold tracking-tighter leading-[0.85] text-foreground uppercase italic underline decoration-primary decoration-[8px] underline-offset-[8px]">
                                FINALIZAR <br /><span className="text-primary italic">PEDIDO</span>
                            </h1>
                            <p className="max-w-xl text-xl font-bold text-foreground/40 uppercase tracking-tight border-l-4 border-primary pl-6 py-2">
                                Confirma tu pedido y coordina con el vendedor el punto de entrega.
                            </p>
                        </div>

                        <section className="bg-background border-2 border-foreground/5 p-10 shadow-neo-sm relative rounded-[3rem]">
                            <div className="absolute -top-6 -right-6 bg-primary text-primary-foreground border-2 border-foreground/10 p-6 rotate-12 group shadow-neo-sm">
                                <MapPin size={40} className="group-hover:rotate-12 transition-transform" />
                            </div>

                            <h2 className="text-3xl font-bold flex items-center gap-4 mb-10 tracking-tighter uppercase italic">
                                <div className="w-12 h-12 bg-foreground text-background border-2 border-foreground/10 flex items-center justify-center rounded-xl shadow-neo-sm">1</div>
                                Coordinar Entrega
                            </h2>

                            <form id="checkout-form" onSubmit={handleCheckout} className="space-y-10">
                                <div className="space-y-4">
                                    <label className="text-xs font-bold text-foreground tracking-[0.3em] uppercase flex items-center gap-3 pl-2">
                                        Instrucciones para el Vendedor <Zap size={14} className="text-primary" />
                                    </label>
                                    <textarea
                                        required
                                        rows={5}
                                        value={deliveryMessage}
                                        onChange={e => setDeliveryMessage(e.target.value)}
                                        className="w-full border-2 border-foreground/10 bg-background p-8 font-bold text-xl focus:outline-none focus:bg-primary/5 transition-all placeholder:text-foreground/10 resize-none rounded-2xl shadow-neo-sm focus:shadow-neo"
                                        placeholder="EJ: TE VEO EN LA ENTRADA DE LA BIBLIOTECA CENTRAL A LA 1:00 PM. LLEVO SUDADERA AZUL."
                                    ></textarea>
                                </div>
                                <div className="bg-foreground text-background border-2 border-foreground/10 p-8 space-y-4 rounded-2xl rotate-1">
                                    <p className="font-bold flex items-center gap-3 text-sm uppercase text-primary tracking-[0.2em]">
                                        <ShieldCheck size={20} /> Verificación de Seguridad
                                    </p>
                                    <p className="text-xs font-bold uppercase italic opacity-60 leading-relaxed">
                                        Recomendamos realizar las entregas en zonas iluminadas y concurridas del campus. El pago se realiza al recibir el producto.
                                    </p>
                                </div>
                            </form>
                        </section>
                    </div>

                    {/* Summary Sidebar */}
                    <div className="w-full lg:w-[480px] shrink-0 sticky top-32">
                        <section className="bg-foreground text-background border-4 border-foreground/5 p-12 shadow-neo-sm space-y-10 rounded-[3rem]">
                            <h2 className="text-4xl font-bold tracking-tighter border-b-2 border-background/10 pb-6 uppercase italic">
                                Tu Pedido
                            </h2>

                            <div className="flex gap-8 relative">
                                <div className="w-32 h-32 bg-background border-2 border-background/5 shrink-0 flex items-center justify-center -rotate-6 group-hover:rotate-0 transition-transform overflow-hidden shadow-neo-sm rounded-2xl">
                                    {product.imageUrl ? (
                                        <img src={product.imageUrl} alt={product.name} className="w-full h-full object-cover grayscale brightness-125" />
                                    ) : (
                                        <Package size={48} className="text-foreground/20" />
                                    )}
                                </div>
                                <div className="flex flex-col justify-center flex-1 space-y-3">
                                    <h3 className="font-bold text-2xl leading-none tracking-tighter line-clamp-2 uppercase italic">{product.name}</h3>
                                    <div className="flex items-center gap-3">
                                        <div className="w-6 h-6 bg-background text-foreground text-[10px] flex items-center justify-center font-bold border-2 border-background rounded-sm">
                                            {product.seller?.firstName?.charAt(0) || 'V'}
                                        </div>
                                        <span className="text-xs font-bold text-background/40 uppercase tracking-[0.2em] truncate">
                                            {product.seller?.firstName ? `${product.seller.firstName} ${product.seller.lastName || ''}` : ''}
                                        </span>
                                    </div>
                                    <div className="flex justify-between items-center pt-4">
                                        <span className="font-bold text-3xl tracking-tighter italic">${Number(product.salePrice).toFixed(0)}</span>
                                        <div className="flex items-center border-2 border-background/20 bg-background rounded-xl select-none shadow-neo-sm scale-110 origin-right">
                                            <button
                                                type="button"
                                                onClick={() => setQuantity(Math.max(1, quantity - 1))}
                                                className="w-10 h-10 flex items-center justify-center text-foreground hover:bg-primary transition-colors rounded-l-lg"
                                            >
                                                <Minus size={18} />
                                            </button>
                                            <span className="w-10 text-center font-bold text-lg text-foreground bg-background">{quantity}</span>
                                            <button
                                                type="button"
                                                onClick={() => setQuantity(Math.min(100, quantity + 1))}
                                                className="w-10 h-10 flex items-center justify-center text-foreground hover:bg-primary transition-colors border-l-2 border-background/20 rounded-r-lg"
                                            >
                                                <Plus size={18} />
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-6 pt-10 border-t-2 border-background/10 border-dashed">
                                <div className="flex justify-between items-center text-xs font-bold tracking-[0.3em] uppercase text-background/40">
                                    <span>Subtotal</span>
                                    <span>${total.toFixed(2)}</span>
                                </div>
                                <div className="flex justify-between items-center text-xs font-bold tracking-[0.3em] uppercase text-background/40">
                                    <span>Cuota Campus</span>
                                    <span className="text-primary italic underline underline-offset-4 decoration-2">Gratiss :)</span>
                                </div>
                                <div className="flex justify-between items-end text-6xl font-bold tracking-tighter pt-8 border-t-4 border-background/20">
                                    <span className="text-2xl italic opacity-30 leading-none">TOTAL</span>
                                    <span className="flex items-end gap-2 leading-none">
                                        <span className="text-4xl text-primary mb-1 italic">$</span>
                                        {total.toFixed(0)}
                                    </span>
                                </div>
                            </div>

                            <button
                                type="submit"
                                form="checkout-form"
                                disabled={isSubmitting}
                                className="group w-full h-24 bg-primary text-primary-foreground font-bold text-3xl uppercase tracking-[0.2em] border-2 border-foreground/10 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all flex items-center justify-center gap-6 active:scale-95 disabled:opacity-50 rounded-[2rem]"
                            >
                                {isSubmitting ? (
                                    <Loader2 className="animate-spin" size={40} />
                                ) : (
                                    <>
                                        ¡PEDIR YA!
                                        <CheckCircle size={32} className="group-hover:scale-125 transition-transform" />
                                    </>
                                )}
                            </button>

                            <p className="text-[10px] font-bold text-center text-background/20 uppercase tracking-[0.4em] pt-4 italic">
                                Al confirmar, te comprometes a realizar la compra
                            </p>
                        </section>
                    </div>
                </div>
            </main>
        </div>
    );
}

export default function CheckoutPage() {
    return (
        <Suspense fallback={<div className="h-screen flex items-center justify-center bg-background"><Loader2 className="animate-spin text-foreground" size={64} /></div>}>
            <CheckoutContent />
        </Suspense>
    );
}
