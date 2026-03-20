'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { Plus, Search, Package, Edit, Trash2, TrendingUp, AlertCircle, Loader2 } from 'lucide-react';
import { productsService, Product } from '@/services/products.service';
import { toast } from 'sonner';

export default function ProductsPage() {
    const [products, setProducts] = useState<Product[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        loadProducts();
    }, []);

    const loadProducts = async () => {
        try {
            setIsLoading(true);
            const data = await productsService.getAll();
            setProducts(data);
        } catch (error) {
            toast.error('Error al cargar productos');
        } finally {
            setIsLoading(false);
        }
    };

    const handleDelete = async (id: string, name: string) => {
        if (confirm(`¿Estás seguro de eliminar "${name}"? Esta acción no se puede deshacer.`)) {
            try {
                await productsService.delete(id);
                toast.success('Producto eliminado con éxito');
                loadProducts();
            } catch (error) {
                toast.error('Error al eliminar producto');
            }
        }
    };

    const filteredProducts = products.filter(product =>
        product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="p-4 md:p-10 space-y-12 font-display min-h-screen bg-background selection:bg-primary/20 text-foreground pb-24">
            {/* Header Neo-Brutalista */}
            <div className="flex flex-col lg:flex-row lg:items-end justify-between gap-8 border-b-2 border-foreground/5 pb-10">
                <div className="space-y-4">
                    <div className="inline-block bg-primary text-primary-foreground border-2 border-foreground/5 px-6 py-2 font-bold text-xs tracking-[0.3em] shadow-neo-sm transform -rotate-1 mb-4 uppercase rounded-sm">
                        Catálogo de Productos
                    </div>
                    <h1 className="text-6xl md:text-8xl font-bold tracking-tighter leading-[0.85] text-foreground uppercase italic underline decoration-primary decoration-[6px] underline-offset-[12px]">
                        MI <br /><span className="text-primary italic">STOCK</span>
                    </h1>
                    <p className="max-w-xl text-xl font-bold text-foreground/40 uppercase tracking-tight border-l-4 border-primary pl-6 py-2">
                        Gestiona tus productos, precios y controla tus existencias.
                    </p>
                </div>
                <Link href="/products/new" className="w-full lg:w-auto">
                    <button className="group w-full lg:w-auto h-20 px-12 bg-foreground text-background font-bold text-2xl border border-foreground/10 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all flex items-center justify-center gap-4 active:scale-95 rounded-2xl">
                        <Plus size={32} className="group-hover:rotate-90 transition-transform" />
                        NUEVO PRODUCTO
                    </button>
                </Link>
            </div>

            {/* Barra de Filtros */}
            <div className="flex flex-col md:flex-row gap-6">
                <div className="relative flex-grow group">
                    <div className="absolute inset-y-0 left-0 pl-6 flex items-center pointer-events-none z-10">
                        <Search className="h-6 w-6 text-foreground/30" />
                    </div>
                    <input
                        type="text"
                        placeholder="BUSCAR EN EL INVENTARIO..."
                        className="w-full h-16 pl-16 pr-6 border-2 border-foreground/5 font-bold tracking-[0.2em] text-foreground bg-background focus:outline-none placeholder:text-foreground/20 transition-all shadow-neo-sm focus:shadow-neo focus:-translate-y-0.5 rounded-2xl"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
            </div>

            {/* Grid de Productos */}
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-12">
                {isLoading ? (
                    <div className="col-span-full py-40 flex flex-col items-center justify-center gap-8 text-foreground/20">
                        <Loader2 className="w-20 h-20 animate-spin" />
                        <p className="font-bold tracking-[0.3em] uppercase italic">Escaneando Almacén...</p>
                    </div>
                ) : filteredProducts.length === 0 ? (
                    <div className="col-span-full py-32 border-8 border-foreground/10 border-dashed bg-background text-center rounded-[3rem]">
                        <Package className="w-24 h-24 mx-auto mb-8 text-foreground/20" />
                        <h3 className="text-4xl font-bold text-foreground/30 uppercase italic">Sin existencias registradas</h3>
                        <p className="font-bold text-foreground/10 uppercase tracking-[0.3em] mt-4">Empieza agregando tu primer producto estrella</p>
                    </div>
                ) : (
                    filteredProducts.map((product) => {
                        const margin = product.salePrice - product.unitCost;
                        const marginPercent = ((margin / product.salePrice) * 100).toFixed(0);
                        const isStockLow = (product.stock || 0) <= 5;

                        const totalInvestment = (product.stock || 0) * product.unitCost;
                        const breakEvenUnits = margin > 0 && totalInvestment > 0
                            ? Math.ceil(totalInvestment / margin)
                            : 0;

                        return (
                            <div key={product.id} className="bg-background border-2 border-foreground/5 shadow-neo-sm hover:shadow-neo hover:-translate-y-1 transition-all group flex flex-col relative overflow-hidden rounded-[2.5rem]">
                                {/* Badge de Perecedero */}
                                {product.isPerishable && (
                                    <div className="absolute top-6 left-6 bg-primary text-primary-foreground border border-foreground/10 px-4 py-1.5 font-bold text-xs uppercase tracking-[0.2em] z-20 -rotate-6 group-hover:rotate-0 transition-transform rounded-sm">
                                        Perishable
                                    </div>
                                )}

                                <div className="p-8 flex-grow space-y-6">
                                    <div className="flex justify-between items-end">
                                        <div className="w-20 h-20 border border-foreground/10 bg-secondary text-primary-foreground flex items-center justify-center rotate-3 group-hover:rotate-12 transition-transform shadow-neo-sm rounded-2xl">
                                            <Package size={40} className="text-foreground" />
                                        </div>
                                        <div className="text-right">
                                            <p className="text-[10px] font-bold text-foreground/40 uppercase tracking-[0.2em] mb-2">Precio Venta</p>
                                            <p className="text-5xl font-bold text-foreground tracking-tighter leading-none italic">${Number(product.salePrice).toFixed(0)}</p>
                                        </div>
                                    </div>

                                    <h3 className="text-2xl font-bold text-foreground uppercase leading-none line-clamp-2 tracking-tighter h-12" title={product.name}>
                                        {product.name}
                                    </h3>

                                    <div className="flex items-center gap-6 py-4 border-y-2 border-foreground/5 border-dashed">
                                        <div className="flex-1">
                                            <p className="text-[10px] font-bold text-foreground/30 uppercase tracking-[0.2em] mb-1">Costo Unit</p>
                                            <p className="text-xl font-bold text-foreground leading-none">${Number(product.unitCost).toFixed(2)}</p>
                                        </div>
                                        <div className="flex-1">
                                            <p className="text-[10px] font-bold text-foreground/30 uppercase tracking-[0.2em] mb-1">Margen</p>
                                            <p className={`text-xl font-bold leading-none flex items-center gap-2 ${Number(marginPercent) > 30 ? 'text-green-600' : 'text-primary'}`}>
                                                <TrendingUp size={16} /> {marginPercent}%
                                            </p>
                                        </div>
                                    </div>

                                    <div className={`p-6 border-2 border-foreground/10 font-bold flex justify-between items-center rounded-2xl shadow-neo-sm ${isStockLow ? 'bg-primary text-primary-foreground italic' : 'bg-foreground text-background shadow-none scale-95 opacity-90'}`}>
                                        <span className="text-xs uppercase tracking-[0.2em]">{isStockLow ? '¡STOCK BAJO!' : 'STOCK ACTUAL'}</span>
                                        <span className="text-4xl tracking-tighter">{product.stock || 0}</span>
                                    </div>

                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="border-2 border-foreground/10 p-4 rounded-xl flex flex-col justify-center">
                                            <span className="text-[9px] font-bold text-foreground/40 tracking-[0.2em] uppercase mb-1">Inv. Retenida</span>
                                            <span className="text-xl font-bold text-foreground leading-none">${totalInvestment.toFixed(0)}</span>
                                        </div>
                                        <div className="border-2 border-foreground/10 bg-secondary p-4 rounded-xl flex flex-col justify-center shadow-neo-sm">
                                            <span className="text-[9px] font-bold text-foreground/40 tracking-[0.2em] uppercase mb-1">Pto. Equil.</span>
                                            <span className={`text-xl font-bold leading-none ${margin <= 0 ? 'text-primary' : 'text-foreground'}`}>
                                                {margin <= 0 ? 'ERR' : `${breakEvenUnits} ud.`}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div className="mt-auto border-t-2 border-foreground/10 flex divide-x-2 divide-foreground/10 bg-foreground/5">
                                    <Link href={`/products/${product.id}/stock`} className="flex-1">
                                        <button className="w-full h-20 bg-background hover:bg-secondary text-foreground font-bold uppercase text-xs tracking-[0.2em] transition-all flex items-center justify-center gap-2">
                                            <Package size={20} /> STOCK
                                        </button>
                                    </Link>
                                    <Link href={`/products/${product.id}`} className="flex-1">
                                        <button className="w-full h-20 bg-background hover:bg-foreground hover:text-background text-foreground font-bold uppercase text-xs tracking-[0.2em] transition-all flex items-center justify-center gap-2">
                                            <Edit size={20} /> EDITAR
                                        </button>
                                    </Link>
                                    <button
                                        onClick={() => handleDelete(product.id, product.name)}
                                        className="h-20 px-8 bg-background text-primary hover:bg-primary/10 transition-all active:scale-95"
                                    >
                                        <Trash2 size={24} />
                                    </button>
                                </div>
                            </div>
                        );
                    })
                )}
            </div>
        </div>
    );
}
