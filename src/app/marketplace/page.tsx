'use client';

import { useEffect, useState } from 'react';
import { productsService, Product, Category } from '@/services/products.service';
import { ProductCard } from '@/components/product-card';
import { Input } from '@/components/ui/input';
import { Loader2, Search, ShoppingBag, Filter } from 'lucide-react';
import { toast } from 'sonner';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';

export default function MarketplacePage() {
    const [products, setProducts] = useState<Product[]>([]);
    const [categories, setCategories] = useState<Category[]>([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState('');
    const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

    useEffect(() => {
        fetchInitialData();
    }, []);

    const fetchInitialData = async () => {
        try {
            setLoading(true);
            const [productsData, categoriesData] = await Promise.all([
                productsService.getMarketplace(),
                productsService.getCategories()
            ]);
            setProducts(productsData);
            setCategories(categoriesData);
        } catch (error) {
            console.error('Error fetching marketplace data:', error);
            toast.error('Error al cargar el marketplace', {
                description: 'Verifica tu conexión e intenta de nuevo.'
            });
        } finally {
            setLoading(false);
        }
    };

    const handleSearch = async (e?: React.FormEvent) => {
        if (e) e.preventDefault();
        try {
            setLoading(true);
            const data = await productsService.getMarketplace(search, undefined, selectedCategory || undefined);
            setProducts(data);
        } catch (error) {
            console.error('Error searching products:', error);
            toast.error('Error al buscar productos');
        } finally {
            setLoading(false);
        }
    };

    const toggleCategory = (categoryId: string) => {
        const newCat = selectedCategory === categoryId ? null : categoryId;
        setSelectedCategory(newCat);
    };

    // Effect to trigger search when category changes
    useEffect(() => {
        handleSearch();
    }, [selectedCategory]);

    return (
        <div className="min-h-screen bg-background">
            {/* Hero Section */}
            <div className="bg-primary pt-24 pb-12 px-6">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-8">
                    <div className="text-primary-foreground space-y-4 max-w-2xl">
                        <Badge variant="outline" className="text-primary-foreground border-primary-foreground/30 px-3 py-1">
                            El Mercado Estudiantil
                        </Badge>
                        <h1 className="text-4xl md:text-6xl font-bold tracking-tighter uppercase italic">
                            Tiendita <span className="text-secondary text-shadow-sm">Campus</span>
                        </h1>
                        <p className="text-lg text-primary-foreground/80 font-medium">
                            Apoya a tus compañeros, descubre snacks únicos y encuentra todo lo que necesitas para tu día en la universidad.
                        </p>
                    </div>
                </div>
            </div>

            {/* Filters Bar */}
            <div className="sticky top-0 z-30 bg-background/80 backdrop-blur-md border-b-2 border-foreground/5 p-4 shadow-sm">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row gap-4 items-center">
                    <form onSubmit={handleSearch} className="relative w-full md:max-w-md">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                        <Input
                            placeholder="Buscar burritos, snacks, servicios..."
                            className="pl-10 h-11 border-2 border-foreground/5 bg-secondary/5 focus-visible:ring-primary shadow-inner"
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                        />
                    </form>
                    
                    <div className="flex gap-2 overflow-x-auto pb-2 md:pb-0 w-full no-scrollbar">
                        <Button
                            variant={selectedCategory === null ? 'default' : 'outline'}
                            size="sm"
                            className="shrink-0 rounded-full font-bold uppercase text-[10px] tracking-widest"
                            onClick={() => setSelectedCategory(null)}
                        >
                            Todos
                        </Button>
                        {categories.map((cat) => (
                            <Button
                                key={cat.id}
                                variant={selectedCategory === cat.id ? 'default' : 'outline'}
                                size="sm"
                                className="shrink-0 rounded-full font-bold uppercase text-[10px] tracking-widest"
                                onClick={() => toggleCategory(cat.id)}
                            >
                                {cat.name}
                            </Button>
                        ))}
                    </div>
                </div>
            </div>

            {/* Main Grid */}
            <main className="max-w-7xl mx-auto p-6">
                {loading ? (
                    <div className="flex flex-col items-center justify-center py-24 space-y-4">
                        <Loader2 className="h-12 w-12 text-primary animate-spin" />
                        <p className="text-sm font-bold uppercase tracking-widest text-muted-foreground">Cargando Marketplace...</p>
                    </div>
                ) : products.length > 0 ? (
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                        {products.map((product) => (
                            <ProductCard key={product.id} product={product} />
                        ))}
                    </div>
                ) : (
                    <div className="flex flex-col items-center justify-center py-32 border-4 border-dashed border-foreground/5 rounded-3xl bg-secondary/5">
                        <ShoppingBag className="h-20 w-20 text-muted-foreground/30 mb-6" />
                        <h3 className="text-2xl font-bold uppercase italic text-foreground/50">No hay productos disponibles</h3>
                        <p className="text-muted-foreground font-medium mt-2">Intenta con otra búsqueda o categoría</p>
                    </div>
                )}
            </main>

            {/* Footer */}
            <footer className="border-t-2 border-foreground/5 mt-24 bg-card py-12 px-6">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6">
                    <div className="flex items-center gap-2">
                         <div className="bg-primary text-white p-2 rounded-lg rotate-[-5deg]">
                            <ShoppingBag className="h-5 w-5" />
                         </div>
                         <span className="font-bold text-xl tracking-tighter uppercase italic">Tiendita Campus</span>
                    </div>
                    <p className="text-sm text-muted-foreground font-medium">
                        © 2026 Proyecto Integrador. Construido con tecnología premium.
                    </p>
                </div>
            </footer>
        </div>
    );
}
