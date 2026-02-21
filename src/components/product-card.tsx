import { Store, ShoppingCart, Loader2, MapPin, GraduationCap } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Product } from '@/services/products.service';
import { ordersService } from '@/services/orders.service';
import { useState } from 'react';
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
            await ordersService.purchase({
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

    return (
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow group flex flex-col h-full">
            <div className="aspect-square bg-gray-100 relative overflow-hidden">
                {product.imageUrl ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img
                        src={product.imageUrl}
                        alt={product.name}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                ) : (
                    <div className="flex items-center justify-center w-full h-full text-gray-300 text-4xl font-bold bg-gray-50">
                        {product.name.charAt(0)}
                    </div>
                )}
                {product.isPerishable && (
                    <span className="absolute top-2 right-2 bg-orange-100 text-orange-700 text-xs font-semibold px-2 py-1 rounded-full shadow-sm">
                        Perecedero
                    </span>
                )}
                {stockAvailable > 0 ? (
                    <span className="absolute bottom-2 left-2 bg-black/70 backdrop-blur-sm text-white text-xs font-medium px-2.5 py-1 rounded-md">
                        Stock: {stockAvailable}
                    </span>
                ) : (
                    <span className="absolute bottom-2 left-2 bg-red-500/90 backdrop-blur-sm text-white text-xs font-medium px-2.5 py-1 rounded-md">
                        Agotado
                    </span>
                )}
            </div>

            <div className="p-4 flex flex-col flex-grow">
                <div className="flex justify-between items-start mb-2">
                    <div>
                        <h3 className="font-semibold text-gray-900 line-clamp-1" title={product.name}>{product.name}</h3>
                        {sellerId ? (
                            <a href={`/seller/${sellerId}`} className="text-sm text-gray-700 font-medium flex items-center gap-1 hover:text-primary transition-colors mt-0.5" title="Ver perfil">
                                <Store size={14} className="text-gray-400" /> {sellerName}
                            </a>
                        ) : (
                            <p className="text-sm text-gray-700 font-medium flex items-center gap-1 mt-0.5">
                                <Store size={14} className="text-gray-400" /> {sellerName}
                            </p>
                        )}
                        {(sellerMajor || sellerCampus) && (
                            <div className="flex flex-col gap-0.5 mt-1">
                                {sellerCampus && (
                                    <p className="text-xs text-gray-500 flex items-center gap-1">
                                        <MapPin size={12} className="text-gray-400" /> {sellerCampus}
                                    </p>
                                )}
                                {sellerMajor && (
                                    <p className="text-xs text-gray-500 flex items-center gap-1 line-clamp-1" title={sellerMajor}>
                                        <GraduationCap size={12} className="text-gray-400" /> {sellerMajor}
                                    </p>
                                )}
                            </div>
                        )}
                    </div>
                    <span className="font-bold text-lg text-primary shrink-0 ml-2">
                        ${Number(product.salePrice).toFixed(2)}
                    </span>
                </div>

                {product.description && (
                    <p className="text-sm text-gray-600 line-clamp-2 h-10 mt-1">
                        {product.description}
                    </p>
                )}

                <div className="mt-auto pt-4">
                    <Dialog open={open} onOpenChange={setOpen}>
                        <DialogTrigger asChild>
                            <Button
                                className="w-full gap-2 transition-transform active:scale-95 bg-primary hover:bg-primary/90"
                                disabled={stockAvailable < 1 || !sellerId}
                            >
                                <ShoppingCart size={16} />
                                {stockAvailable > 0 ? 'Solicitar Compra' : 'Agotado'}
                            </Button>
                        </DialogTrigger>
                        <DialogContent className="sm:max-w-[425px]">
                            <DialogHeader>
                                <DialogTitle>Solicitar Compra</DialogTitle>
                                <DialogDescription>
                                    Vendido por <strong>{sellerName}</strong> {sellerCampus ? `(${sellerCampus})` : ''} <br />
                                    Precio unidad: <strong className="text-gray-900">${Number(product.salePrice).toFixed(2)}</strong>
                                </DialogDescription>
                            </DialogHeader>

                            <div className="grid gap-4 py-4">
                                <div className="space-y-2">
                                    <Label htmlFor="quantity">¿Cuántas piezas deseas apartar?</Label>
                                    <Input
                                        id="quantity"
                                        type="number"
                                        min="1"
                                        max={stockAvailable}
                                        value={quantity}
                                        onChange={(e) => setQuantity(Number(e.target.value))}
                                    />
                                    <p className="text-xs text-gray-500">Stock disponible: {stockAvailable}</p>
                                </div>
                                <div className="space-y-2">
                                    <Label htmlFor="message">Instrucciones de entrega (Opcional)</Label>
                                    <Textarea
                                        id="message"
                                        placeholder="Ej. 'Llevo sudadera roja, estoy en la biblioteca...'"
                                        value={deliveryMessage}
                                        onChange={(e) => setDeliveryMessage(e.target.value)}
                                        className="resize-none"
                                        rows={3}
                                    />
                                </div>
                                <div className="flex justify-between items-center bg-gray-50 p-3 rounded-lg border border-gray-100 mt-2">
                                    <span className="font-medium text-gray-700">Total a pagar:</span>
                                    <span className="font-bold text-xl text-primary">
                                        ${(Number(product.salePrice) * quantity).toFixed(2)}
                                    </span>
                                </div>
                            </div>

                            <DialogFooter className="sm:justify-between flex-row">
                                <Button variant="outline" onClick={() => setOpen(false)}>Cancelar</Button>
                                <Button onClick={handlePurchase} disabled={isPurchasing || quantity < 1 || quantity > stockAvailable}>
                                    {isPurchasing && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                                    Solicitar (Contraentrega)
                                </Button>
                            </DialogFooter>
                        </DialogContent>
                    </Dialog>
                </div>
            </div>
        </div>
    );
}
