import { api } from './api';

export interface Product {
    id: string;
    name: string;
    description?: string;
    unitCost: number;
    salePrice: number;
    isPerishable: boolean;
    shelfLifeDays?: number | null;
    imageUrl?: string;
    image_url?: string;
    isActive: boolean;
    createdAt: string;
    updatedAt: string;
    seller?: {
        id: string;
        firstName: string;
        lastName: string;
        email: string;
        phone?: string;
    };
    stock?: number;
    categoryId?: string;
    category?: {
        id: string;
        name: string;
    };
}

export interface Category {
    id: string;
    name: string;
    description?: string;
    icon?: string;
}

export interface CreateProductDto {
    name: string;
    description?: string;
    unitCost: number;
    salePrice: number;
    isPerishable?: boolean;
    shelfLifeDays?: number | null;
    imageUrl?: string;
    categoryId?: string;
}

export interface UpdateProductDto extends Partial<CreateProductDto> { }

export const productsService = {
    /**
     * Obtener todos los productos del usuario
     */
    async getAll(): Promise<Product[]> {
        return api.get<Product[]>('/products');
    },

    /**
     * Obtener catálogo público (Marketplace)
     */
    async getMarketplace(query?: string, sellerId?: string, category?: string): Promise<Product[]> {
        const params: Record<string, string> = {};
        if (query) params.q = query;
        if (sellerId) params.seller = sellerId;
        if (category) params.category = category;

        return api.get<Product[]>('/products/marketplace', {
            params,
            requiresAuth: false
        });
    },

    /**
     * Obtener un producto por ID
     */
    async getById(id: string): Promise<Product> {
        return api.get<Product>(`/products/marketplace/${id}`);
    },

    /**
     * Crear un nuevo producto
     */
    async create(data: CreateProductDto): Promise<Product> {
        return api.post<Product>('/products', data);
    },

    /**
     * Actualizar un producto existente
     */
    async update(id: string, data: UpdateProductDto): Promise<Product> {
        return api.patch<Product>(`/products/${id}`, data);
    },

    /**
     * Eliminar (soft delete) un producto
     */
    async delete(id: string): Promise<void> {
        return api.delete<void>(`/products/${id}`);
    },

    /**
     * Obtener todas las categorías
     */
    async getCategories(): Promise<Category[]> {
        return api.get<Category[]>('/categories');
    },
};
