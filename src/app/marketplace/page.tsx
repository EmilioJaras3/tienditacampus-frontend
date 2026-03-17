'use client';

import { useState, useEffect } from 'react';
import { productsService, Product } from '@/services/products.service';
import { Search, ShoppingBag, Store, Zap, Plus, ArrowRight, Loader2, Filter } from 'lucide-react';
import Link from 'next/link';
import { toast } from 'sonner';
import { motion, AnimatePresence } from 'framer-motion';

// Variantes de animación
const fadeInUp: any = {
    hidden: { opacity: 0, y: 30 },
    visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: "easeOut" } },
    exit: { opacity: 0, y: -20, transition: { duration: 0.3 } }
};

const staggerContainer = {
    hidden: { opacity: 0 },
    visible: {
        opacity: 1,
        transition: {
            staggerChildren: 0.1
        }
    }
};

const scaleIn: any = {
    hidden: { opacity: 0, scale: 0.9 },
    visible: { opacity: 1, scale: 1, transition: { duration: 0.5, type: "spring", bounce: 0.4 } }
};

export default function MarketplacePage() {
    const [products, setProducts] = useState<Product[]>([]);
    const [categories, setCategories] = useState<any[]>(['Todos']);
    const [loading, setLoading] = useState(true);
    const [searchQuery, setSearchQuery] = useState('');
    const [activeCategory, setActiveCategory] = useState('Todos');

    useEffect(() => {
        loadInitialData();
    }, []);

    useEffect(() => {
        loadProducts(searchQuery, activeCategory);
    }, [activeCategory]);

    const loadInitialData = async () => {
        try {
            setLoading(true);
            const [productsData, categoriesData] = await Promise.all([
                productsService.getMarketplace(),
                productsService.getCategories()
            ]);
            setProducts(productsData);
            setCategories(['Todos', ...categoriesData.map(c => c.name)]);
        } catch (error) {
            console.error("Error loading marketplace data", error);
        } finally {
            setLoading(false);
        }
    };

    const loadProducts = async (q?: string, cat?: string) => {
        try {
            setLoading(true);
            const data = await productsService.getMarketplace(q, undefined, cat);
            setProducts(data);
        } catch (error) {
            console.error("Error loading products", error);
            toast.error('Error al cargar productos');
        } finally {
            setLoading(false);
        }
    };

    return (
        <motion.div 
            initial="hidden"
            animate="visible"
            variants={staggerContainer}
            className="bg-background font-display min-h-screen selection:bg-primary/20 pb-24 mt-16 overflow-x-hidden"
        >
            {/* Search Header */}
            <motion.header variants={fadeInUp} className="sticky top-[64px] z-40 w-full border-b-2 border-foreground/5 bg-background/90 backdrop-blur-md">
                <div className="max-w-7xl mx-auto flex h-20 items-center justify-between gap-4 px-4 md:px-8">
                    <div className="relative flex-1 group max-w-2xl">
                        <div className="absolute inset-y-0 left-0 pl-6 flex items-center pointer-events-none z-10">
                            <Search className="h-6 w-6 text-foreground/30" />
                        </div>
                        <input
                            type="text"
                            placeholder="¿QUÉ SE TE ANTOJA HOY?..."
                            className="w-full h-16 pl-16 pr-6 border-2 border-foreground/10 font-bold tracking-[0.2em] text-foreground bg-background focus:outline-none placeholder:text-foreground/20 transition-all shadow-neo-sm focus:shadow-neo focus:-translate-y-0.5 rounded-xl"
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            onKeyDown={(e) => e.key === 'Enter' && loadProducts(searchQuery, activeCategory)}
                        />
                    </div>
                </div>
            </motion.header>

            <main className="max-w-7xl mx-auto px-4 py-10 md:px-8 space-y-12">
                {/* Hero Banner Marketplace */}
                <motion.section variants={scaleIn} whileHover={{ y: -5 }} className="bg-foreground text-background border-4 border-foreground/5 p-10 md:p-16 shadow-neo-sm relative overflow-hidden group rounded-[3rem]">
                    <div className="absolute top-0 right-0 w-80 h-80 bg-primary opacity-20 blur-3xl -mr-20 -mt-20 group-hover:opacity-40 transition-opacity"></div>
                    <div className="relative z-10 space-y-6">
                        <div className="inline-flex items-center gap-3 bg-primary text-primary-foreground border border-foreground/10 px-6 py-2 font-bold text-xs tracking-[0.3em] shadow-neo-sm -rotate-2 transform group-hover:rotate-0 transition-transform rounded-sm">
                            <Zap size={18} /> EXPLORA TU COMUNIDAD
                        </div>
                        <h2 className="text-7xl md:text-9xl font-bold tracking-tighter text-background leading-[0.8] uppercase italic underline decoration-primary decoration-[8px] underline-offset-[8px]">
                            TIENDITA <br /> <span className="text-primary italic">CAMPUS</span>
                        </h2>
                        <p className="max-w-xl text-xl font-bold text-background/60 uppercase tracking-tight border-l-4 border-primary pl-6 py-2">
                            Encuentra los mejores productos directo de manos de otros estudiantes. Sin salir de la uni.
                        </p>
                    </div>
                    <div className="absolute right-12 bottom-12 opacity-5 font-bold text-[12rem] text-background select-none pointer-events-none rotate-12">
                        UNAM
                    </div>
                </motion.section>

                {/* Categories */}
                <motion.div variants={fadeInUp} className="flex flex-col gap-8">
                    <div className="flex items-center gap-4 border-b-8 border-foreground/5 pb-4">
                        <Filter className="text-primary w-8 h-8" />
                        <h3 className="text-4xl font-bold tracking-tighter uppercase">Categorías</h3>
                    </div>
                    <div className="flex gap-4 overflow-x-auto pb-6 hide-scrollbar">
                        {categories.map((cat) => (
                            <motion.button
                                whileHover={{ scale: 1.05 }}
                                whileTap={{ scale: 0.95 }}
                                key={cat}
                                onClick={() => setActiveCategory(cat)}
                                className={`flex shrink-0 items-center gap-3 px-10 py-5 border-2 font-bold text-xs uppercase tracking-[0.2em] transition-all rounded-2xl ${activeCategory === cat
                                    ? 'bg-primary text-primary-foreground border-foreground/10 shadow-neo'
                                    : 'bg-background text-foreground/40 border-foreground/5 hover:border-primary/50 hover:text-foreground'
                                    }`}
                            >
                                {cat}
                            </motion.button>
                        ))}
                    </div>
                </motion.div>

                {/* Product Grid */}
                <motion.section variants={staggerContainer} className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-12 pb-20">
                    {loading ? (
                        Array.from({ length: 8 }).map((_, i) => (
                            <motion.div variants={scaleIn} key={i} className="h-[450px] border-4 border-foreground/5 bg-background shadow-neo-sm animate-pulse flex flex-col items-center justify-center gap-6 text-foreground/5 rounded-[2rem]">
                                <Store size={80} />
                            </motion.div>
                        ))
                    ) : products.length === 0 ? (
                        <motion.div variants={fadeInUp} className="col-span-full border-4 border-foreground/10 border-dashed p-32 text-center bg-background rounded-[3rem]">
                            <motion.div animate={{ y: [0, -10, 0] }} transition={{ duration: 3, repeat: Infinity }}>
                                <Store className="w-24 h-24 mx-auto mb-8 text-foreground/20" />
                            </motion.div>
                            <h3 className="text-4xl font-bold text-foreground/30 tracking-tighter uppercase">Sin productos disponibles</h3>
                            <p className="font-bold text-foreground/10 uppercase mt-4 tracking-[0.3em]">Prueba con otra búsqueda o regresa más tarde.</p>
                        </motion.div>
                    ) : (
                        <AnimatePresence mode="popLayout">
                            {products.map(product => (
                                <motion.article 
                                    variants={scaleIn}
                                    layout
                                    whileHover={{ y: -5 }}
                                    key={product.id} 
                                    className="group relative bg-background border-2 border-foreground/5 shadow-neo-sm hover:shadow-neo transition-all flex flex-col overflow-hidden rounded-[2.5rem]"
                                >
                                {/* Badge de Precio */}
                                <div className="absolute top-6 right-6 z-20 bg-secondary text-primary-foreground border-2 border-foreground/10 px-5 py-2 font-bold text-2xl tracking-tighter shadow-neo-sm rotate-3 group-hover:rotate-0 transition-transform rounded-xl">
                                    ${Number(product.salePrice).toFixed(0)}
                                </div>

                                {/* Image Placeholder / Preview */}
                                <div className="aspect-square bg-foreground/5 relative overflow-hidden">
                                    {product.imageUrl || product.image_url ? (
                                        <img
                                            src={product.imageUrl || product.image_url}
                                            alt={product.name}
                                            className="w-full h-full object-cover transition-all duration-700 scale-105 group-hover:scale-110"
                                        />
                                    ) : (
                                        <div className="w-full h-full flex flex-col items-center justify-center">
                                            <ShoppingBag size={100} className="text-foreground/5 group-hover:text-primary/20 transition-colors" />
                                        </div>
                                    )}
                                    <div className="absolute inset-0 bg-primary/5 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none"></div>
                                </div>

                                <div className="p-8 flex flex-col flex-1">
                                    <h4 className="text-2xl font-bold leading-none text-foreground line-clamp-2 uppercase tracking-tighter mb-4 h-12" title={product.name}>
                                        {product.name}
                                    </h4>

                                    <div className="flex items-center gap-3 mb-8">
                                         <div className="w-8 h-8 border-2 border-foreground bg-primary text-primary-foreground flex items-center justify-center font-bold text-xs uppercase rounded-full">
                                             {product.seller?.firstName?.charAt(0) || 'V'}
                                         </div>
                                         <div className="flex flex-col">
                                             <span className="text-[10px] font-bold text-foreground/40 uppercase tracking-[0.2em] truncate italic leading-none mb-1">
                                                 @{product.seller?.firstName?.replace(/\s/g, '').toLowerCase()}
                                             </span>
                                             {product.category && (
                                                 <span className="text-[9px] font-extrabold text-primary uppercase tracking-widest bg-primary/10 px-2 py-0.5 rounded-sm">
                                                     {product.category.name}
                                                 </span>
                                             )}
                                         </div>
                                     </div>

                                    <div className="mt-auto flex gap-4">
                                        <Link href={`/marketplace/product/${product.id}`} className="flex-1">
                                            <motion.button 
                                                whileHover={{ scale: 1.02 }}
                                                whileTap={{ scale: 0.98 }}
                                                className="w-full h-14 bg-background text-foreground font-bold text-xs uppercase tracking-[0.2em] border-4 border-foreground hover:bg-foreground hover:text-background transition-colors flex items-center justify-center gap-2 rounded-2xl shadow-neo-sm"
                                            >
                                                DETALLES <ArrowRight size={16} />
                                            </motion.button>
                                        </Link>
                                        <Link href={`/checkout?productId=${product.id}`}>
                                            <motion.button 
                                                whileHover={{ scale: 1.05, y: -2 }}
                                                whileTap={{ scale: 0.95 }}
                                                className="h-14 w-14 bg-primary text-primary-foreground border-4 border-foreground shadow-neo transition-all flex items-center justify-center rounded-2xl"
                                            >
                                                <Plus size={24} />
                                            </motion.button>
                                        </Link>
                                    </div>
                                </div>
                            </motion.article>
                        ))}
                        </AnimatePresence>
                    )}
                </motion.section>
            </main>
        </motion.div>
    );
}
