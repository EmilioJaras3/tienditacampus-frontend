import { Store, ShoppingCart, Loader2 } from 'lucide-react';
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

export function ProductCard({ product }: { product: Product }) {
    const sellerName = (product as any).seller?.fullName || 'Estudiante';
    const sellerId = (product as any).seller?.id;
    const stockAvailable = (product as any).quantity_remaining || 0;

    const { isAuthenticated, user } = useAuthStore();
    const [open, setOpen] = useState(false);
    const [quantity, setQuantity] = useState(1);
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
                }]
            });
            toast.success('¡Compra realizada con éxito!', {
                description: `Has comprado ${quantity}x ${product.name}`
            });
            setOpen(false);
            // Optionally reload page or update local state stock
        } catch (error: any) {
            toast.error('Error al procesar la compra', {
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
                    <span className="absolute top-2 right-2 bg-orange-100 text-orange-700 text-xs font-semibold px-2 py-1 rounded-full">
                        Perecedero
                    </span>
                )}
                {stockAvailable > 0 && (
                    <span className="absolute bottom-2 left-2 bg-black/70 backdrop-blur-sm text-white text-xs font-medium px-2.5 py-1 rounded-md">
                        Stock: {stockAvailable}
                    </span>
                )}
            </div>

            <div className="p-4 flex flex-col flex-grow">
                <div className="flex justify-between items-start mb-2">
                    <div>
                        <h3 className="font-semibold text-gray-900 line-clamp-1">{product.name}</h3>
                        {sellerId && (
                            <a href={`/seller/${sellerId}`} className="text-sm text-gray-500 flex items-center gap-1 hover:text-primary transition-colors">
                                <Store size={14} /> {sellerName}
                            </a>
                        )}
                        {!sellerId && (
                            <p className="text-sm text-gray-500 flex items-center gap-1">
                                <Store size={14} /> {sellerName}
                            </p>
                        )}
                    </div>
                    <span className="font-bold text-lg text-primary">
                        ${Number(product.salePrice).toFixed(2)}
                    </span>
                </div>

                {product.description && (
                    <p className="text-sm text-gray-600 line-clamp-2 h-10">
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
                                {stockAvailable > 0 ? 'Comprar' : 'Agotado'}
                            </Button>
                        </DialogTrigger>
                        <DialogContent className="sm:max-w-[400px]">
                            <DialogHeader>
                                <DialogTitle>Comprar {product.name}</DialogTitle>
                                <DialogDescription>
                                    Vendido por {sellerName}. Precio unitario: ${Number(product.salePrice).toFixed(2)}
                                </DialogDescription>
                            </DialogHeader>

                            <div className="grid gap-4 py-4">
                                <div className="space-y-2">
                                    <Label htmlFor="quantity">¿Cuántas piezas deseas comprar?</Label>
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
                                <div className="flex justify-between items-center bg-gray-50 p-3 rounded-lg border border-gray-100 mt-2">
                                    <span className="font-medium text-gray-700">Total a pagar:</span>
                                    <span className="font-bold text-xl text-primary">
                                        ${(Number(product.salePrice) * quantity).toFixed(2)}
                                    </span>
                                </div>
                            </div>

                            <DialogFooter>
                                <Button variant="outline" onClick={() => setOpen(false)}>Cancelar</Button>
                                <Button onClick={handlePurchase} disabled={isPurchasing || quantity < 1 || quantity > stockAvailable}>
                                    {isPurchasing && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                                    Confirmar Compra
                                </Button>
                            </DialogFooter>
                        </DialogContent>
                    </Dialog>
                </div>
            </div>
        </div>
    );
}
