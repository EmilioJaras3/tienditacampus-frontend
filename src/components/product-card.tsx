import { Store, ShoppingCart, Loader2, MapPin, GraduationCap } from 'lucide-react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Product } from '@/services/products.service';
import { ordersService } from '@/services/orders.service';
import { useState, type ChangeEvent } from 'react';
import { useAuthStore } from '@/store/auth.store';
import { toast } from 'sonner';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
    DialogFooter
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';

export function ProductCard({ product }: { product: Product }) {
    const seller = (product as any).seller;
    const sellerName = seller ? `${seller.firstName} ${seller.lastName}` : 'Estudiante';
    const sellerId = seller?.id;
    const sellerMajor = seller?.major;
    const sellerCampus = seller?.campusLocation;

    // Fallback to 0 if undefined, but our modified backend sends 'quantityRemaining' 
    const stockAvailable = (product as any).quantityRemaining || 0;

    const { isAuthenticated, user } = useAuthStore();
    const [open, setOpen] = useState(false);
    const [quantity, setQuantity] = useState(1);
    const [deliveryMessage, setDeliveryMessage] = useState('');
    const [isPurchasing, setIsPurchasing] = useState(false);
    const [imageFailed, setImageFailed] = useState(false);
    const [imageLoading, setImageLoading] = useState(true);

    const handlePurchase = async () => {
        if (!isAuthenticated) {
            toast.error('Debes iniciar sesión para comprar');
            return;
        }

        if (user?.id === sellerId) {
            toast.error('No puedes comprar tus propios productos');
            return;
        }

        if (quantity < 1 || quantity > stockAvailable) {
            toast.error('Cantidad inválida');
            return;
        }

        setIsPurchasing(true);
        try {
            await ordersService.createOrder({
                sellerId: sellerId,
                items: [{
                    productId: product.id,
                    quantity: quantity
                }],
                deliveryMessage: deliveryMessage
            });
            toast.success('¡Solicitud enviada con éxito!', {
                description: `Has solicitado ${quantity}x ${product.name}. Ponte de acuerdo para la entrega.`
            });
            setOpen(false);
            // Optionally reload page or update local state stock
        } catch (error: any) {
            toast.error('Error al solicitar la compra', {
                description: error.response?.data?.message || 'Stock insuficiente o error del servidor'
            });
        } finally {
            setIsPurchasing(false);
        }
    };

    // Mejorar validación de URL de imagen
    const isValidImageUrl = (url: string | undefined): boolean => {
        if (!url) return false;
        try {
            new URL(url);
            return true;
        } catch {
            return false;
        }
    };

    const hasValidImage = isValidImageUrl(product.imageUrl) && !imageFailed;

    return (
        <div className="bg-white border border-primary/10 dark:border-white/10 shadow-md overflow-hidden transition-transform group flex flex-col h-full hover:-translate-y-1  hover:shadow-lg">
            <div className="aspect-square bg-[#f1f1f1] relative overflow-hidden border-b-2 border-primary/10 dark:border-white/10 flex items-center justify-center">
                {hasValidImage ? (
                    // ✅ MEJORADO: Imagen con mejor manejo de carga y CORS
                    <>
                        {imageLoading && (
                            <div className="absolute inset-0 flex items-center justify-center bg-[#f1f1f1]">
                                <Loader2 className="animate-spin text-slate-400" size={32} />
                            </div>
                        )}
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img
                            src={product.imageUrl || ''}
                            alt={product.name}
                            className="w-full h-full object-cover"
                            onLoad={() => setImageLoading(false)}
                            onError={() => {
                                setImageFailed(true);
                                setImageLoading(false);
                            }}
                            crossOrigin="anonymous"
                            loading="lazy"
                        />
                    </>
                ) : (
                    // ✅ MEJORADO: Placeholder mejor diseñado
                    <div className="flex flex-col items-center justify-center w-full h-full text-slate-900 bg-[#FFC72C]">
                        <div className="text-5xl font-semibold">
                            {product.name.charAt(0)}
                        </div>
                        <div className="text-xs font-bold mt-2 text-slate-700">
                            Sin imagen
                        </div>
                    </div>
                )}
                {product.isPerishable && (
                    <span className="absolute top-3 right-3 bg-[#FFC72C] text-slate-900 text-xs font-bold px-2 py-1 border border-primary/10 dark:border-white/10 uppercase tracking-wider">
                        Perecedero
                    </span>
                )}
                {stockAvailable > 0 ? (
                    <span className="absolute bottom-3 left-3 bg-white text-slate-900 text-xs font-bold px-2 py-1 border border-primary/10 dark:border-white/10 uppercase tracking-wider">
                        Stock {stockAvailable}
                    </span>
                ) : (
                    <span className="absolute bottom-3 left-3 bg-[#E31837] text-white text-xs font-bold px-2 py-1 border border-primary/10 dark:border-white/10 uppercase tracking-wider">
                        Agotado
                    </span>
                )}
            </div>

            <div className="p-4 flex flex-col flex-grow">
                <div className="flex justify-between items-start mb-2">
                    <div>
                        <h3 className="font-bold text-slate-900 line-clamp-1 uppercase tracking-tight" title={product.name}>
                            {product.name}
                        </h3>
                        {sellerId ? (
                            <Link
                                href={`/seller/${sellerId}`}
                                className="text-sm text-slate-900 font-bold flex items-center gap-1 hover:underline decoration-[#E31837] decoration-2 underline-offset-4 mt-1"
                                title="Ver perfil"
                            >
                                <Store size={14} className="text-slate-900" /> {sellerName}
                            </Link>
                        ) : (
                            <p className="text-sm text-slate-900 font-bold flex items-center gap-1 mt-1">
                                <Store size={14} className="text-slate-900" /> {sellerName}
                            </p>
                        )}
                        {(sellerMajor || sellerCampus) && (
                            <div className="flex flex-col gap-0.5 mt-1">
                                {sellerCampus && (
                                    <p className="text-xs text-slate-600 font-medium flex items-center gap-1">
                                        <MapPin size={12} className="text-slate-600" /> {sellerCampus}
                                    </p>
                                )}
                                {sellerMajor && (
                                    <p className="text-xs text-slate-600 font-medium flex items-center gap-1 line-clamp-1" title={sellerMajor}>
                                        <GraduationCap size={12} className="text-slate-600" /> {sellerMajor}
                                    </p>
                                )}
                            </div>
                        )}
                    </div>
                    <div className="shrink-0 ml-3 text-right">
                        <div className="inline-flex border border-primary/10 dark:border-white/10 bg-[#FFC72C] px-2 py-1 font-bold text-slate-900">
                            ${Number(product.salePrice).toFixed(2)}
                        </div>
                    </div>
                </div>

                {product.description && (
                    <p className="text-sm text-slate-700 line-clamp-2 h-10 mt-1 font-medium">
                        {product.description}
                    </p>
                )}

                <div className="mt-auto pt-4">
                    <Dialog open={open} onOpenChange={setOpen}>
                        <DialogTrigger asChild>
                            <Button
                                className="w-full gap-2 transition-transform active:scale-95 bg-[#E31837] hover:bg-[#c9122e] border border-primary/10 dark:border-white/10 font-semibold shadow-md"
                                disabled={stockAvailable < 1 || !sellerId}
                            >
                                <ShoppingCart size={16} />
                                {stockAvailable > 0 ? 'Solicitar Compra' : 'Agotado'}
                            </Button>
                        </DialogTrigger>
                        <DialogContent className="sm:max-w-[400px] w-[95vw] max-h-[85vh] p-0 flex flex-col overflow-hidden border-2 shadow-2xl top-[50%] translate-y-[-50%] left-[50%] translate-x-[-50%]">
                            {/* v2.1: Ultra-compact fix for short viewports */}
                            <DialogHeader className="p-3 pb-1 border-b bg-slate-50 relative shrink-0">
                                <DialogTitle className="text-sm font-black text-slate-900 uppercase tracking-tighter">
                                    COMPRAR: {product.name}
                                </DialogTitle>
                                <DialogDescription className="text-[10px] text-slate-600 font-bold leading-none mt-1">
                                    Vendedor: {sellerName} • <span className="text-[#E31837]">${Number(product.salePrice).toFixed(2)}</span>
                                </DialogDescription>
                            </DialogHeader>

                            <div className="flex-1 overflow-y-auto px-4 py-2 space-y-3 min-h-[150px]">
                                <div className="space-y-1">
                                    <div className="flex justify-between items-center">
                                        <Label htmlFor="quantity" className="text-[10px] font-black text-slate-700 uppercase">Cantidad</Label>
                                        <span className="text-[9px] font-bold text-slate-400">STOCK: {stockAvailable}</span>
                                    </div>
                                    <Input
                                        id="quantity"
                                        type="number"
                                        min="1"
                                        max={stockAvailable}
                                        value={quantity}
                                        onChange={(e: ChangeEvent<HTMLInputElement>) => setQuantity(Number(e.target.value))}
                                        className="h-8 text-sm font-bold border-2 focus-visible:ring-[#FFC72C]"
                                    />
                                </div>

                                <div className="space-y-1">
                                    <Label htmlFor="message" className="text-[10px] font-black text-slate-700 uppercase">Entrega (Opcional)</Label>
                                    <Textarea
                                        id="message"
                                        placeholder="Ubicación o detalle..."
                                        value={deliveryMessage}
                                        onChange={(e: ChangeEvent<HTMLTextAreaElement>) => setDeliveryMessage(e.target.value)}
                                        className="resize-none border-2 focus-visible:ring-[#FFC72C] text-xs h-16"
                                        rows={2}
                                    />
                                </div>

                                <div className="flex justify-between items-center bg-[#FFC72C]/10 px-3 py-2 rounded border border-[#FFC72C]/30">
                                    <span className="font-bold text-[10px] text-slate-700 uppercase">Total:</span>
                                    <span className="font-black text-lg text-[#E31837]">
                                        ${(Number(product.salePrice) * quantity).toFixed(2)}
                                    </span>
                                </div>
                            </div>

                            <DialogFooter className="p-3 pt-1 flex flex-row gap-2 border-t bg-slate-50 shrink-0">
                                <Button 
                                    variant="outline" 
                                    onClick={() => setOpen(false)}
                                    className="flex-1 font-bold h-9 text-[10px] uppercase border-2"
                                >
                                    Cerrar
                                </Button>
                                <Button 
                                    onClick={handlePurchase} 
                                    disabled={isPurchasing || quantity < 1 || quantity > stockAvailable}
                                    className="flex-[2] bg-[#E31837] hover:bg-[#c9122e] text-white font-bold h-9 text-[10px] uppercase shadow-md active:scale-95"
                                >
                                    {isPurchasing ? <Loader2 className="h-3 w-3 animate-spin" /> : "Confirmar"}
                                </Button>
                            </DialogFooter>
                        </DialogContent>
                    </Dialog>
                </div>
            </div>
        </div>
    );
}
