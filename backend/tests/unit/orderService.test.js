jest.mock('../../repositories/orderRepository', () => ({
  create: jest.fn(),
  findAllWithDetails: jest.fn(),
  findByVendor: jest.fn(),
  findByDeliveryPerson: jest.fn(),
  findByUser: jest.fn(),
  findById: jest.fn(),
}));

jest.mock('../../repositories/deliveryRepository', () => ({
  findBySubOrderId: jest.fn(),
  create: jest.fn(),
}));

jest.mock('../../repositories/orderItemRepository', () => ({
  create: jest.fn(),
}));

jest.mock('../../models', () => ({
  Product: {
    findByPk: jest.fn(),
  },
  SubOrder: {
    create: jest.fn(),
  },
}));

jest.mock('../../config/db', () => ({
  transaction: jest.fn(async (work) => work({ LOCK: { UPDATE: 'UPDATE' } })),
}));

jest.mock('../../utils/realtime', () => ({
  publishEvent: jest.fn(),
}));

const orderService = require('../../services/orderService');
const orderRepo = require('../../repositories/orderRepository');
const orderItemRepo = require('../../repositories/orderItemRepository');
const deliveryRepo = require('../../repositories/deliveryRepository');
const { Product, SubOrder } = require('../../models');

describe('orderService.createOrder', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('splits by vendor and computes commission', async () => {
    const product1 = {
      id: 1,
      name: 'P1',
      vendorId: 10,
      price: 10,
      stock: 5,
      save: jest.fn(),
    };
    const product2 = {
      id: 2,
      name: 'P2',
      vendorId: 20,
      price: 20,
      stock: 4,
      save: jest.fn(),
    };

    Product.findByPk
      .mockResolvedValueOnce(product1)
      .mockResolvedValueOnce(product2);

    const order = { id: 999, save: jest.fn() };
    orderRepo.create.mockResolvedValue(order);

    const subOrder1 = { id: 101, save: jest.fn() };
    const subOrder2 = { id: 102, save: jest.fn() };
    SubOrder.create
      .mockResolvedValueOnce(subOrder1)
      .mockResolvedValueOnce(subOrder2);

    const result = await orderService.createOrder(
      { id: 33, role: 'client' },
      [
        { productId: 1, quantity: 2 },
        { productId: 2, quantity: 1 },
      ]
    );

    expect(result).toBe(order);
    expect(orderItemRepo.create).toHaveBeenCalledTimes(2);
    expect(product1.save).toHaveBeenCalledTimes(1);
    expect(product2.save).toHaveBeenCalledTimes(1);
    expect(order.total).toBe(40);
    expect(order.commission).toBe(2);
    expect(order.save).toHaveBeenCalledTimes(1);
  });

  it('throws when stock is insufficient', async () => {
    Product.findByPk.mockResolvedValueOnce({
      id: 1,
      name: 'P1',
      vendorId: 10,
      price: 10,
      stock: 0,
      save: jest.fn(),
    });

    await expect(
      orderService.createOrder(
        { id: 33, role: 'client' },
        [{ productId: 1, quantity: 1 }]
      )
    ).rejects.toThrow('Stock insuffisant');
  });

  it('creates delivery placeholders when a client pays an order', async () => {
    const order = {
      id: 77,
      UserId: 33,
      status: 'PENDING',
      SubOrders: [
        { id: 201 },
        { id: 202, Delivery: { id: 999 } },
      ],
      save: jest.fn(),
    };

    orderRepo.findById.mockResolvedValue(order);
    deliveryRepo.findBySubOrderId.mockResolvedValue(null);
    deliveryRepo.create.mockResolvedValue({ id: 5001 });

    await orderService.updateOrderStatus({ id: 33, role: 'client' }, 77, 'PAID');

    expect(order.status).toBe('PAID');
    expect(order.save).toHaveBeenCalledTimes(1);
    expect(deliveryRepo.create).toHaveBeenCalledTimes(1);
    expect(deliveryRepo.create).toHaveBeenCalledWith(
      expect.objectContaining({
        SubOrderId: 201,
        status: 'PROCESSING',
      })
    );
  });
});
