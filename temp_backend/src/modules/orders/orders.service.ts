import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './entities/order.entity';
import { CreateOrderDto } from './dto/create-order.dto';
import { User } from '../users/entities/user.entity';
import { CreateOrderUseCase } from './use-cases/create-order.use-case';
import { DeliverOrderUseCase } from './use-cases/deliver-order.use-case';

@Injectable()
export class OrdersService {
    constructor(
        @InjectRepository(Order) private readonly orderRepo: Repository<Order>,
        private readonly createOrderUseCase: CreateOrderUseCase,
        private readonly deliverOrderUseCase: DeliverOrderUseCase,
    ) { }

    async createOrder(dto: CreateOrderDto, buyer: User): Promise<Order> {
        return this.createOrderUseCase.execute(dto, buyer);
    }

    async acceptOrder(orderId: string, seller: User): Promise<Order> {
        const order = await this.orderRepo.findOne({ where: { id: orderId } });
        if (!order) throw new NotFoundException('Orden no encontrada');
        if (order.sellerId !== seller.id) throw new BadRequestException('No permission');
        
        order.status = 'accepted';
        return this.orderRepo.save(order);
    }

    async rejectOrder(orderId: string, seller: User): Promise<Order> {
        const order = await this.orderRepo.findOne({ where: { id: orderId } });
        if (!order) throw new NotFoundException('Orden no encontrada');
        if (order.sellerId !== seller.id) throw new BadRequestException('No permission');

        order.status = 'rejected';
        return this.orderRepo.save(order);
    }

    async deliverOrder(orderId: string, user: User): Promise<Order> {
        return this.deliverOrderUseCase.execute(orderId, user);
    }

    async getBuyerPurchases(buyer: User) {
        return this.orderRepo.find({
            where: { buyerId: buyer.id },
            relations: ['seller', 'items', 'items.product'],
            order: { createdAt: 'DESC' }
        });
    }

    async getSellerSales(seller: User) {
        return this.orderRepo.find({
            where: { sellerId: seller.id },
            relations: ['buyer', 'items', 'items.product'],
            order: { createdAt: 'DESC' }
        });
    }
}
