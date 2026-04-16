jest.mock('../../repositories/deliveryRepository', () => ({
  countActiveByDeliveryPerson: jest.fn(),
  findBySubOrderId: jest.fn(),
  create: jest.fn(),
  findById: jest.fn(),
  findAll: jest.fn(),
  findByDeliveryPerson: jest.fn(),
  findByClientOrders: jest.fn(),
}));

jest.mock('../../repositories/orderRepository', () => ({
  findById: jest.fn(),
}));

jest.mock('../../utils/realtime', () => ({
  publishEvent: jest.fn(),
}));

const deliveryService = require('../../services/deliveryService');
const deliveryRepo = require('../../repositories/deliveryRepository');
const orderRepo = require('../../repositories/orderRepository');

describe('deliveryService.assignDelivery', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('enforces max 3 active deliveries per driver', async () => {
    orderRepo.findById.mockResolvedValue({ id: 12, status: 'PAID', SubOrders: [{ id: 1 }] });
    deliveryRepo.countActiveByDeliveryPerson.mockResolvedValue(3);

    await expect(deliveryService.assignDelivery(12, 77)).rejects.toThrow('max 3 livraisons');
  });
});
