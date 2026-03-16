'use client';

import { useEffect, useState, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { ArrowLeft, Loader2, Save, History, TrendingUp, Target, DollarSign } from 'lucide-react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow
} from '@/components/ui/table';
import { productsService, Product } from '@/services/products.service';
import { inventoryService, InventoryRecord } from '@/services/inventory.service';
import { financeService, BreakEvenResult } from '@/services/finance.service';
import { ApiError } from '@/services/api';
import { toast } from 'sonner';

const stockSchema = z.object({
    quantity: z.coerce.number().min(1, 'La cantidad debe ser al menos 1'),
    unitCost: z.coerce.number().min(0, 'El costo no puede ser negativo'),
    recordDate: z.string().optional(),
});

type StockFormValues = z.infer<typeof stockSchema>;

export default function StockManagementPage({ params }: { params: { id: string } }) {
    const router = useRouter();
    const [product, setProduct] = useState<Product | null>(null);
    const [history, setHistory] = useState<InventoryRecord[]>([]);
    const [breakEvenResult, setBreakEvenResult] = useState<BreakEvenResult | null>(null);
    const [isLoading, setIsLoading] = useState(true);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [isCalculatingBreakEven, setIsCalculatingBreakEven] = useState(false);
    const [foodFixedCost, setFoodFixedCost] = useState<number>(0);
    const [foodPeriod, setFoodPeriod] = useState<string>('mensual');
    const [rentCost, setRentCost] = useState<number>(0);
    const [rentPeriod, setRentPeriod] = useState<string>('mensual');
    const [otherCost, setOtherCost] = useState<number>(0);
    const [otherPeriod, setOtherPeriod] = useState<string>('mensual');

    const form = useForm<StockFormValues>({
        resolver: zodResolver(stockSchema) as any,
        defaultValues: {
            quantity: 0,
            unitCost: 0,
            recordDate: new Date().toISOString().split('T')[0],
        },
    });

    const loadData = useCallback(async () => {
        try {
            setIsLoading(true);
            const [productData, historyData] = await Promise.all([
                productsService.getById(params.id),
                inventoryService.getHistory(params.id),
            ]);
            setProduct(productData);
            setHistory(historyData);
            // Set default unit cost from product current cost
            form.setValue('unitCost', Number(productData.unitCost));
        } catch (error) {
            toast.error('Error al cargar datos');
            router.push('/products');
        } finally {
            setIsLoading(false);
        }
    }, [params.id, form, router]);

    useEffect(() => {
        loadData();
    }, [loadData]);

    const onSubmit = async (data: StockFormValues) => {
        setIsSubmitting(true);
        try {
            await inventoryService.addStock({
                productId: params.id,
                quantity: data.quantity,
                unitCost: data.unitCost,
                recordDate: data.recordDate,
            });
            toast.success('Stock agregado exitosamente');
            form.reset({
                quantity: 0,
                unitCost: Number(product?.unitCost || 0),
                recordDate: new Date().toISOString().split('T')[0],
            });
            loadData(); // Reload history
        } catch (error) {
            toast.error('Error al agregar stock');
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleCalculateBreakEven = async () => {
        if (!product) return;

        try {
            setIsCalculatingBreakEven(true);
            const totalFixedCosts = Math.max(0, 
                (foodPeriod === 'semanal' ? foodFixedCost * 4 : foodFixedCost) + 
                (rentPeriod === 'semanal' ? rentCost * 4 : rentCost) + 
                (otherPeriod === 'semanal' ? otherCost * 4 : otherCost)
            );
            const result = await financeService.calculateBreakEven({
                productId: product.id,
                fixedCosts: totalFixedCosts,
                unitCost: Math.max(0, Number(product.unitCost)),
                unitPrice: Math.max(0, Number(product.salePrice)),
            });
            setBreakEvenResult(result);
        } catch (error) {
            if (error instanceof ApiError) {
                toast.error(error.message);
            } else {
                toast.error('No se pudo calcular el punto de equilibrio');
            }
        } finally {
            setIsCalculatingBreakEven(false);
        }
    };

    if (isLoading || !product) {
        return (
            <div className="h-full w-full flex items-center justify-center">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
        );
    }

    return (
        <div className="max-w-5xl mx-auto p-8 space-y-8 animate-fade-in">
            <div className="flex items-center space-x-4">
                <Link href="/products">
                    <Button variant="ghost" size="icon">
                        <ArrowLeft className="h-5 w-5" />
                    </Button>
                </Link>
                <div>
                    <h1 className="text-3xl font-bold tracking-tight text-foreground">Gestión de Stock</h1>
                    <p className="text-muted-foreground">{product.name}</p>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                {/* Formulario de Entrada */}
                <Card className="md:col-span-1 h-fit">
                    <CardHeader>
                        <CardTitle>Agregar Entrada</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
                            <div className="space-y-2">
                                <label className="text-sm font-medium leading-none">Cantidad (Unidades)</label>
                                <Input type="number" {...form.register('quantity')} />
                                {form.formState.errors.quantity && (
                                    <p className="text-sm text-destructive">{form.formState.errors.quantity.message}</p>
                                )}
                            </div>

                            <div className="space-y-2">
                                <label className="text-sm font-medium leading-none">Costo Unitario ($)</label>
                                <Input type="number" step="0.01" {...form.register('unitCost')} />
                                <p className="text-xs text-muted-foreground">Costo de adquisición para este lote.</p>
                            </div>

                            <div className="space-y-2">
                                <label className="text-sm font-medium leading-none">Fecha de Ingreso</label>
                                <Input type="date" {...form.register('recordDate')} />
                            </div>

                            <Button type="submit" disabled={isSubmitting} className="w-full">
                                {isSubmitting ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Save className="mr-2 h-4 w-4" />}
                                Registrar Entrada
                            </Button>
                        </form>
                    </CardContent>
                </Card>

                {/* Historial */}
                <Card className="md:col-span-2">
                    <CardHeader>
                        <CardTitle className="flex items-center">
                            <History className="mr-2 h-5 w-5" />
                            Historial de Lotes
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        {history.length === 0 ? (
                            <div className="text-center py-10 text-muted-foreground">
                                No hay registros de stock aún.
                            </div>
                        ) : (
                            <div className="rounded-md border border-border">
                                <Table>
                                    <TableHeader>
                                        <TableRow>
                                            <TableHead>Fecha</TableHead>
                                            <TableHead>Inicial</TableHead>
                                            <TableHead>Restante</TableHead>
                                            <TableHead>Costo</TableHead>
                                            <TableHead>Estado</TableHead>
                                        </TableRow>
                                    </TableHeader>
                                    <TableBody>
                                        {history.map((record) => (
                                            <TableRow key={record.id}>
                                                <TableCell>{new Date(record.recordDate).toLocaleDateString()}</TableCell>
                                                <TableCell>{record.quantityInitial}</TableCell>
                                                <TableCell className="font-bold">{record.quantityRemaining}</TableCell>
                                                <TableCell>${Number(record.investmentAmount / record.quantityInitial).toFixed(2)}</TableCell>
                                                <TableCell>
                                                    <span className={`px-2 py-1 rounded-full text-xs font-semibold
                                     ${record.status === 'active' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-700'}
                                  `}>
                                                        {record.status === 'active' ? 'Activo' : record.status}
                                                    </span>
                                                </TableCell>
                                            </TableRow>
                                        ))}
                                    </TableBody>
                                </Table>
                            </div>
                        )}
                    </CardContent>
                </Card>
            </div>

            <Card className="rounded-[2.5rem] border border-foreground/5 shadow-neo-sm">
                <CardHeader>
                    <CardTitle className="text-3xl font-bold tracking-tighter uppercase italic">Análisis de Recuperación</CardTitle>
                </CardHeader>
                <CardContent className="space-y-8">
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div className="space-y-2">
                            <label className="text-[10px] font-bold text-foreground/40 uppercase tracking-widest pl-2">Variabl. Comida / Unidad</label>
                            <div className="relative">
                                <DollarSign className="absolute left-4 top-1/2 -translate-y-1/2 text-foreground/20 w-4 h-4" />
                                <Input
                                    type="number"
                                    step="0.01"
                                    className="pl-12 h-14 bg-background border-foreground/5 rounded-xl font-bold text-lg"
                                    value={product.unitCost}
                                    readOnly
                                />
                            </div>
                        </div>
                        <div className="space-y-2">
                            <label className="text-[10px] font-bold text-foreground/40 uppercase tracking-widest pl-2 flex justify-between">
                                <span>Fijos Comida</span>
                                <select value={foodPeriod} onChange={e => setFoodPeriod(e.target.value)} className="bg-transparent border-none outline-none cursor-pointer">
                                    <option value="semanal">Semanal</option>
                                    <option value="mensual">Mensual</option>
                                </select>
                            </label>
                            <div className="relative">
                                <DollarSign className="absolute left-4 top-1/2 -translate-y-1/2 text-foreground/20 w-4 h-4" />
                                <Input
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    value={foodFixedCost || ''}
                                    onChange={e => setFoodFixedCost(Math.max(0, Number(e.target.value)))}
                                    className="pl-12 h-14 bg-background border-foreground/5 rounded-xl font-bold text-lg"
                                />
                            </div>
                        </div>
                        <div className="space-y-2">
                            <label className="text-[10px] font-bold text-foreground/40 uppercase tracking-widest pl-2 flex justify-between">
                                <span>Renta / Espacio</span>
                                <select value={rentPeriod} onChange={e => setRentPeriod(e.target.value)} className="bg-transparent border-none outline-none cursor-pointer">
                                    <option value="semanal">Semanal</option>
                                    <option value="mensual">Mensual</option>
                                </select>
                            </label>
                            <div className="relative">
                                <DollarSign className="absolute left-4 top-1/2 -translate-y-1/2 text-foreground/20 w-4 h-4" />
                                <Input
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    value={rentCost || ''}
                                    onChange={e => setRentCost(Math.max(0, Number(e.target.value)))}
                                    className="pl-12 h-14 bg-background border-foreground/5 rounded-xl font-bold text-lg"
                                />
                            </div>
                        </div>
                        <div className="space-y-2">
                            <label className="text-[10px] font-bold text-foreground/40 uppercase tracking-widest pl-2 flex justify-between">
                                <span>Otros Gastos</span>
                                <select value={otherPeriod} onChange={e => setOtherPeriod(e.target.value)} className="bg-transparent border-none outline-none cursor-pointer">
                                    <option value="semanal">Semanal</option>
                                    <option value="mensual">Mensual</option>
                                </select>
                            </label>
                            <div className="relative">
                                <DollarSign className="absolute left-4 top-1/2 -translate-y-1/2 text-foreground/20 w-4 h-4" />
                                <Input
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    value={otherCost || ''}
                                    onChange={e => setOtherCost(Math.max(0, Number(e.target.value)))}
                                    className="pl-12 h-14 bg-background border-foreground/5 rounded-xl font-bold text-lg"
                                />
                            </div>
                        </div>
                    </div>

                    <div className="flex flex-col md:flex-row items-center gap-6 p-1 bg-background rounded-2xl border border-foreground/5 overflow-hidden">
                        <div className="p-8 text-center md:text-left flex-1 space-y-2 opacity-60">
                            <p className="text-[9px] font-bold uppercase tracking-[0.2em]">Referencia de Venta</p>
                            <p className="text-2xl font-bold tracking-tighter">Precio: ${Number(product.salePrice).toFixed(2)}</p>
                        </div>
                        <Button 
                            onClick={handleCalculateBreakEven} 
                            disabled={isCalculatingBreakEven}
                            className="h-20 px-12 bg-primary text-primary-foreground font-bold text-xs uppercase tracking-[0.2em] rounded-xl shadow-neo hover:shadow-neo-lg hover:-translate-y-1 transition-all"
                        >
                            {isCalculatingBreakEven ? <Loader2 className="mr-2 h-6 w-6 animate-spin" /> : <Target className="mr-3 w-6 h-6" />}
                            Calcular Meta de Venta
                        </Button>
                    </div>

                    {breakEvenResult && (
                        <div className="bg-foreground text-background p-10 rounded-[2.5rem] shadow-neo space-y-6 transform animate-in fade-in slide-in-from-bottom-4 duration-500">
                            <div className="flex items-center gap-4 border-b border-background/10 pb-6">
                                <div className="w-12 h-12 bg-primary text-primary-foreground flex items-center justify-center rounded-xl rotate-3">
                                    <TrendingUp size={24} />
                                </div>
                                <h4 className="text-2xl font-bold tracking-tighter uppercase italic">Resultado del Análisis</h4>
                            </div>
                            
                            <div className="space-y-8">
                                <p className="text-3xl font-bold leading-tight tracking-[0.02em]">
                                    Mensaje sencillo:<br />
                                    <span className="text-primary italic border-b-4 border-primary/30 pb-2">
                                        Necesitas vender {Math.max(0, Math.ceil(breakEvenResult.breakEvenUnits))} {product.name.toLowerCase()}s (al mes) para recuperar tus gastos fijos.
                                    </span>
                                </p>
                                
                                <div className="grid grid-cols-2 md:grid-cols-3 gap-8 pt-6 border-t border-background/10">
                                    <div>
                                        <p className="text-[9px] font-bold text-background/40 uppercase tracking-[0.2em] mb-1">Margen Neto Unitario</p>
                                        <p className="text-xl font-bold">${Math.max(0, Number(breakEvenResult.unitMargin)).toFixed(2)}</p>
                                    </div>
                                    <div>
                                        <p className="text-[9px] font-bold text-background/40 uppercase tracking-[0.2em] mb-1">Costo Fijo Mensual Proyectado</p>
                                        <p className="text-xl font-bold">${Math.max(0, 
                                            (foodPeriod === 'semanal' ? foodFixedCost * 4 : foodFixedCost) + 
                                            (rentPeriod === 'semanal' ? rentCost * 4 : rentCost) + 
                                            (otherPeriod === 'semanal' ? otherCost * 4 : otherCost)
                                        ).toFixed(2)}</p>
                                    </div>
                                    <div className="flex flex-col items-end">
                                        <p className="text-[9px] font-bold text-primary uppercase tracking-[0.2em] mb-1">Estado</p>
                                        <span className="bg-primary/20 text-primary border border-primary/30 px-3 py-1 text-[8px] font-bold uppercase rounded-full tracking-widest">OK</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}
                </CardContent>
            </Card>
        </div>
    );
}
