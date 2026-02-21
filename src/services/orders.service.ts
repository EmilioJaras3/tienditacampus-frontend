import { api } from './api';
import { Product } from './products.service';
import { User } from './auth.service';

export interface OrderItem {
    id: string;
    orderId: string;
    productId: string;
    quantity: number;
    unitPrice: number;
    subtotal: number;
    product?: Product;
}

export interface Order {
    id: string;
    buyerId: string;
    sellerId: string;
    totalAmount: number;
    status: string; // 'pending', 'completed', 'cancelled'
    deliveryMessage: string | null;
    createdAt: string;
    updatedAt: string;
    items: OrderItem[];
    buyer?: User;
    seller?: User;
}

export interface CreateOrderDto {
    sellerId: string;
    items: {
        productId: string;
        quantity: number;
    }[];
    deliveryMessage?: string;
}

export const ordersService = {
    /**
     * Comprar productos de un vendedor
     */
    async purchase(data: CreateOrderDto): Promise<Order> {
        return api.post<Order>('/orders/purchase', data);
    },

    /**
     * Obtener el historial de compras del usuario logueado
     */
    async getMyPurchases(): Promise<Order[]> {
        return api.get<Order[]>('/orders/my-purchases');
    },

    /**
     * Obtener el historial de ventas (pedidos recibidos) del vendedor logueado
     */
    async getSellerSales(): Promise<Order[]> {
        return api.get<Order[]>('/orders/seller-sales');
    },

    /**
     * Confirma la entrega y el pago contraentrega
     */
    async deliver(orderId: string): Promise<Order> {
        return api.post<Order>(`/orders/${orderId}/deliver`, {});
    }
};
