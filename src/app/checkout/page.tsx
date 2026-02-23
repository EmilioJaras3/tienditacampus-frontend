'use client';

import { Suspense, useState, useEffect } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import { productsService, Product } from '@/services/products.service';
import { ordersService } from '@/services/orders.service';
import { ArrowLeft, CheckCircle, Package } from 'lucide-react';
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
        if (productId) loadProduct();
    }, [productId]);

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
            toast.success('¡Pedido creado con éxito!');
            router.push('/buyer/dashboard');
        } catch (error: any) {
            console.error(error);
            toast.error(error?.response?.data?.message || 'Error al crear el pedido');
        } finally {
            setIsSubmitting(false);
        }
    };

    if (loading) return (
        <div className="min-h-screen bg-neo-white p-8 flex justify-center items-center">
            <div className="animate-spin w-16 h-16 border-8 border-black border-t-neo-red rounded-full"></div>
        </div>
    );

    if (!product) return (
        <div className="min-h-screen bg-neo-white p-8 text-center flex flex-col items-center justify-center">
            <h2 className="text-4xl font-black uppercase text-black mb-4">No hay producto para checkout</h2>
            <button onClick={() => router.push('/marketplace')} className="bg-neo-yellow px-6 py-3 border-4 border-black font-bold uppercase shadow-neo hover:-translate-y-1 transition-transform">
                Volver
            </button>
        </div>
    );

    const total = product.salePrice * quantity;

    return (
        <div className="bg-neo-white font-display text-black min-h-screen selection:bg-neo-red selection:text-white">
            <header className="border-b-4 border-black bg-white sticky top-[64px] z-40">
                <div className="max-w-7xl mx-auto px-4 py-4 md:px-8 flex justify-between items-center">
                    <button onClick={() => router.back()} className="font-bold flex items-center gap-2 hover:text-neo-red transition-colors uppercase tracking-widest text-sm">
                        <ArrowLeft className="w-5 h-5" /> Volver
                    </button>
                    <div className="bg-neo-yellow border-2 border-black font-black uppercase px-4 py-1 -skew-x-12">
                        Paso Final
                    </div>
                </div>
            </header>

            <main className="max-w-7xl mx-auto px-4 py-8 md:px-8">
                <h1 className="text-4xl md:text-5xl lg:text-7xl font-black uppercase tracking-tighter mb-8 md:mb-12">
                    Casi <span className="text-neo-red relative">Tuyoo
                        <svg className="absolute w-full h-4 -bottom-2 left-0 text-black hidden sm:block" viewBox="0 0 100 20" preserveAspectRatio="none">
                            <path d="M0 10 Q 50 20 100 10" fill="none" stroke="currentColor" strokeWidth="4"></path>
                        </svg>
                    </span>
                </h1>

                <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-start">
                    <div className="lg:col-span-7 flex flex-col gap-8 order-2 lg:order-1">
                        <section className="bg-white border-4 border-black p-6 md:p-8 shadow-neo-lg relative">
                            <div className="absolute top-0 right-0 bg-neo-red text-white py-1 px-4 border-b-4 border-l-4 border-black font-bold uppercase tracking-widest text-xs translate-x-1 -translate-y-1">
                                Info de Entrega
                            </div>

                            <h2 className="text-2xl font-black uppercase flex items-center gap-2 mb-6">
                                <span className="bg-neo-yellow w-8 h-8 flex items-center justify-center border-2 border-black text-black">1</span>
                                ¿Dónde te vemos?
                            </h2>

                            <form id="checkout-form" onSubmit={handleCheckout} className="space-y-6">
                                <div className="space-y-2">
                                    <label className="font-bold uppercase text-sm">Ubicación / Detalles en el Campus</label>
                                    <textarea
                                        required
                                        rows={3}
                                        value={deliveryMessage}
                                        onChange={e => setDeliveryMessage(e.target.value)}
                                        className="w-full border-4 border-black bg-white p-4 font-medium focus:outline-none focus:ring-4 focus:ring-neo-yellow/50 transition-shadow appearance-none resize-none"
                                        placeholder="Ej: Estoy en la cafetería central, en las mesas de afuera. Llevo sudadera roja."
                                    ></textarea>
                                </div>
                                <div className="bg-black text-white p-4 border-l-4 border-neo-yellow">
                                    <p className="font-bold flex items-center gap-2 text-sm uppercase">
                                        <CheckCircle className="w-5 h-5 text-neo-yellow" /> El vendedor te enviará un mensaje.
                                    </p>
                                </div>
                            </form>
                        </section>
                    </div>

                    <div className="lg:col-span-5 order-1 lg:order-2">
                        <section className="bg-neo-yellow border-4 border-black p-6 shadow-neo-lg sticky top-32">
                            <h2 className="text-2xl font-black uppercase border-b-4 border-black pb-4 mb-4">
                                Tu Carrito
                            </h2>

                            <div className="flex gap-4 mb-6 relative">
                                <div className="w-24 h-24 bg-white border-2 border-black flex-shrink-0 flex items-center justify-center -rotate-2">
                                    <Package className="w-10 h-10 text-gray-300" />
                                </div>
                                <div className="flex flex-col justify-between flex-1">
                                    <div>
                                        <h3 className="font-bold uppercase leading-tight line-clamp-2">{product.name}</h3>
                                        <p className="text-xs font-bold text-gray-700 uppercase mt-1">Vend. {product.seller?.fullName}</p>
                                    </div>
                                    <div className="flex justify-between items-end mt-2">
                                        <div className="font-black text-xl">${product.salePrice.toFixed(2)}</div>
                                        <div className="font-bold text-sm bg-white border-2 border-black px-2 py-0.5 shadow-neo-sm">
                                            x{quantity}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div className="border-t-4 border-black pt-4 mb-6">
                                <div className="flex justify-between items-center text-sm font-bold uppercase mb-2">
                                    <span>Subtotal</span>
                                    <span>${total.toFixed(2)}</span>
                                </div>
                                <div className="flex justify-between items-center text-sm font-bold uppercase text-black/70 mb-4">
                                    <span>Tarifa de servicio</span>
                                    <span>$0.00</span>
                                </div>
                                <div className="flex justify-between items-center text-2xl font-black uppercase">
                                    <span>Total</span>
                                    <span>${total.toFixed(2)}</span>
                                </div>
                            </div>

                            <button
                                type="submit"
                                form="checkout-form"
                                disabled={isSubmitting}
                                className="w-full bg-black text-white font-black text-xl uppercase py-4 border-2 border-black hover:bg-neo-red hover:text-white transition-all transform hover:-translate-y-1 shadow-neo disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                            >
                                {isSubmitting ? (
                                    <span className="w-6 h-6 border-4 border-white/30 border-t-white rounded-full animate-spin"></span>
                                ) : (
                                    'Confirmar Pedido'
                                )}
                            </button>
                        </section>
                    </div>
                </div>
            </main>
        </div>
    );
}

export default function CheckoutPage() {
    return (
        <Suspense fallback={<div className="min-h-screen bg-neo-white flex justify-center items-center"><div className="animate-spin w-16 h-16 border-8 border-black border-t-neo-red rounded-full"></div></div>}>
            <CheckoutContent />
        </Suspense>
    );
}
