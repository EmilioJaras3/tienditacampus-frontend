'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { ArrowLeft, Loader2, Save, ShoppingBag, DollarSign, Image as ImageIcon, Calendar, Info } from 'lucide-react';
import Link from 'next/link';
import { productsService } from '@/services/products.service';
import { toast } from 'sonner';

const productSchema = z.object({
    name: z.string().min(3, 'El nombre debe tener al menos 3 caracteres'),
    description: z.string().optional(),
    unitCost: z.coerce.number().min(0, 'El costo no puede ser negativo'),
    salePrice: z.coerce.number().min(0, 'El precio no puede ser negativo'),
    isPerishable: z.boolean().default(false),
    shelfLifeDays: z.coerce.number().optional(),
    imageUrl: z.string().optional().or(z.literal('')),
});

type ProductFormValues = z.infer<typeof productSchema>;

export default function NewProductPage() {
    const router = useRouter();
    const [isSubmitting, setIsSubmitting] = useState(false);

    const form = useForm<ProductFormValues>({
        resolver: zodResolver(productSchema),
        defaultValues: {
            name: '',
            description: '',
            unitCost: 0,
            salePrice: 0,
            isPerishable: false,
            shelfLifeDays: undefined,
            imageUrl: '',
        },
    });

    const onSubmit = async (data: ProductFormValues) => {
        setIsSubmitting(true);
        try {
            const newProduct = await productsService.create({
                ...data,
                shelfLifeDays: data.shelfLifeDays || undefined,
                imageUrl: data.imageUrl || undefined,
            });
            toast.success('¡PRODUCTO CREADO!', {
                description: 'Ahora vamos a registrar cuánto stock tienes disponible.',
            });
            router.push(`/products/${newProduct.id}/stock`);
        } catch (error) {
            toast.error('Error al crear el producto');
            console.error(error);
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="max-w-4xl mx-auto p-4 md:p-10 space-y-10 font-display min-h-screen bg-neo-white selection:bg-neo-yellow selection:text-black pb-24">
            {/* Header */}
            <div className="flex items-center gap-6 border-b-4 border-black pb-8">
                <Link href="/products">
                    <button className="h-14 w-14 border-4 border-black bg-white flex items-center justify-center shadow-[4px_4px_0_0_#000] hover:shadow-none hover:translate-x-[4px] hover:translate-y-[4px] transition-all active:scale-95">
                        <ArrowLeft className="h-6 w-6" />
                    </button>
                </Link>
                <div>
                    <h1 className="text-4xl md:text-5xl font-black uppercase tracking-tighter text-black leading-none">
                        NUEVO <span className="text-neo-red">LANZAMIENTO</span>
                    </h1>
                    <p className="text-sm font-bold text-slate-500 uppercase flex items-center gap-2 mt-1">
                        <Info size={14} /> Completa los datos para publicar
                    </p>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-1 gap-10">
                <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-10">

                    {/* Sección: Básico */}
                    <div className="bg-white border-4 border-black p-8 shadow-neo-lg space-y-8 relative overflow-hidden">
                        <div className="absolute top-0 right-0 p-4 opacity-5 pointer-events-none">
                            <ShoppingBag size={120} />
                        </div>

                        <h2 className="text-xl font-black uppercase tracking-widest flex items-center gap-3">
                            <div className="w-8 h-8 bg-neo-yellow border-2 border-black flex items-center justify-center -rotate-6">
                                <ShoppingBag size={16} />
                            </div>
                            Esenciales
                        </h2>

                        <div className="space-y-6 relative z-10">
                            <div className="space-y-2 group">
                                <label className="text-xs font-black uppercase text-black tracking-widest pl-1">
                                    Nombre del Producto
                                </label>
                                <input
                                    placeholder="EJ. GALLETAS DE AVENA ARTESANALES"
                                    {...form.register('name')}
                                    className={`w-full h-14 px-4 border-4 border-black font-black uppercase outline-none focus:bg-neo-yellow/5 ${form.formState.errors.name ? 'bg-red-50' : 'bg-white'}`}
                                />
                                {form.formState.errors.name && (
                                    <p className="text-[10px] font-black text-neo-red uppercase italic">{form.formState.errors.name.message}</p>
                                )}
                            </div>

                            <div className="space-y-2">
                                <label className="text-xs font-black uppercase text-black tracking-widest pl-1">
                                    Descripción (Opcional)
                                </label>
                                <textarea
                                    placeholder="CUÉNTALES POR QUÉ TU PRODUCTO ES EL MEJOR DEL CAMPUS..."
                                    rows={3}
                                    {...form.register('description')}
                                    className="w-full p-4 border-4 border-black font-black uppercase outline-none focus:bg-neo-yellow/5 bg-white resize-none"
                                />
                            </div>
                        </div>
                    </div>

                    {/* Sección: Precios */}
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div className="bg-neo-green/10 border-4 border-black p-8 shadow-neo group">
                            <h2 className="text-xl font-black uppercase tracking-widest flex items-center gap-3 mb-8">
                                <div className="w-8 h-8 bg-neo-green border-2 border-black flex items-center justify-center group-hover:rotate-12 transition-transform">
                                    <DollarSign size={16} />
                                </div>
                                Costo Unitario
                            </h2>
                            <div className="space-y-4">
                                <div className="text-4xl font-black flex items-center gap-2">
                                    $ <input
                                        type="number"
                                        step="0.01"
                                        {...form.register('unitCost')}
                                        className="bg-transparent border-b-4 border-black w-full outline-none focus:text-neo-green transition-colors"
                                    />
                                </div>
                                <p className="text-[10px] font-bold text-slate-500 uppercase tracking-wider">¿Cuánto te cuesta producirlo/comprarlo?</p>
                            </div>
                        </div>

                        <div className="bg-neo-yellow border-4 border-black p-8 shadow-neo group">
                            <h2 className="text-xl font-black uppercase tracking-widest flex items-center gap-3 mb-8">
                                <div className="w-8 h-8 bg-black text-white border-2 border-black flex items-center justify-center group-hover:-rotate-12 transition-transform">
                                    <DollarSign size={16} />
                                </div>
                                Precio Venta
                            </h2>
                            <div className="space-y-4">
                                <div className="text-4xl font-black flex items-center gap-2">
                                    $ <input
                                        type="number"
                                        step="0.01"
                                        {...form.register('salePrice')}
                                        className="bg-transparent border-b-4 border-black w-full outline-none focus:text-neo-red transition-colors"
                                    />
                                </div>
                                <p className="text-[10px] font-bold text-black uppercase tracking-wider">¿A cuánto lo vendes al público?</p>
                            </div>
                        </div>
                    </div>

                    {/* Sección: Detalles Extra */}
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
                        <div className="bg-white border-4 border-black p-8 shadow-neo space-y-6">
                            <h2 className="text-xl font-black uppercase tracking-widest flex items-center gap-3 mb-4">
                                <div className="w-8 h-8 bg-blue-400 border-2 border-black flex items-center justify-center">
                                    <ImageIcon size={16} />
                                </div>
                                Visuales
                            </h2>
                            <div className="space-y-2">
                                <label className="text-xs font-black uppercase text-black pl-1">URL de la Imagen (FOTO)</label>
                                <input
                                    placeholder="HTTPS://..."
                                    {...form.register('imageUrl')}
                                    className="w-full h-12 px-4 border-4 border-black font-black outline-none focus:bg-slate-50"
                                />
                                {form.formState.errors.imageUrl && (
                                    <p className="text-[10px] font-black text-neo-red uppercase italic">{form.formState.errors.imageUrl.message}</p>
                                )}
                            </div>
                        </div>

                        <div className="bg-white border-4 border-black p-8 shadow-neo space-y-6">
                            <h2 className="text-xl font-black uppercase tracking-widest flex items-center gap-3 mb-4">
                                <div className="w-8 h-8 bg-neo-red border-2 border-black flex items-center justify-center text-white">
                                    <Calendar size={16} />
                                </div>
                                Caducidad
                            </h2>
                            <div className="flex items-center gap-4 p-3 border-2 border-black bg-slate-50">
                                <input
                                    type="checkbox"
                                    id="isPerishable"
                                    {...form.register('isPerishable')}
                                    className="w-6 h-6 border-2 border-black accent-black"
                                />
                                <label htmlFor="isPerishable" className="text-xs font-black uppercase text-black cursor-pointer">Es Perecedero</label>
                            </div>

                            {form.watch('isPerishable') && (
                                <div className="space-y-2 animate-in fade-in slide-in-from-top-2">
                                    <label className="text-xs font-black uppercase text-black pl-1">Días de Vida Útil</label>
                                    <input
                                        type="number"
                                        {...form.register('shelfLifeDays')}
                                        className="w-full h-12 px-4 border-4 border-black font-black outline-none focus:bg-neo-red/5"
                                        placeholder="EJ. 5 DÍAS"
                                    />
                                </div>
                            )}
                        </div>
                    </div>

                    <div className="pt-10 flex flex-col md:flex-row gap-6">
                        <button
                            type="submit"
                            disabled={isSubmitting}
                            className="flex-grow group h-20 bg-black text-white text-2xl font-black uppercase tracking-[0.2em] border-4 border-black shadow-[10px_10px_0_0_#FFC72C] hover:shadow-none hover:translate-x-[10px] hover:translate-y-[10px] transition-all flex items-center justify-center gap-4 active:scale-95 disabled:opacity-70"
                        >
                            {isSubmitting ? (
                                <Loader2 className="h-8 w-8 animate-spin" />
                            ) : (
                                <>
                                    PUBLICAR AHORA
                                    <Save className="group-hover:scale-125 transition-transform text-neo-yellow" />
                                </>
                            )}
                        </button>
                    </div>

                </form>
            </div>
        </div>
    );
}
