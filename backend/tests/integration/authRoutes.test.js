process.env.DB_NAME = process.env.DB_NAME || 'test_db';
process.env.DB_USER = process.env.DB_USER || 'test_user';
process.env.DB_PASS = process.env.DB_PASS || 'test_pass';
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test_secret';

jest.mock('../../services/authService', () => ({
  register: jest.fn(),
  login: jest.fn(),
}));

const request = require('supertest');
const { app } = require('../../app');
const authService = require('../../services/authService');

describe('Auth routes integration', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('POST /auth/register returns 201 with user payload', async () => {
    authService.register.mockResolvedValue({
      id: 1,
      name: 'Test',
      email: 'test@example.com',
      role: 'client',
    });

    const response = await request(app)
      .post('/auth/register')
      .send({ name: 'Test', email: 'test@example.com', password: 'Password123!' });

    expect(response.status).toBe(201);
    expect(response.body.email).toBe('test@example.com');
  });

  it('POST /auth/login returns token and user', async () => {
    authService.login.mockResolvedValue({
      token: 'abc.def.ghi',
      user: { id: 1, name: 'Test', email: 'test@example.com', role: 'client' },
    });

    const response = await request(app)
      .post('/auth/login')
      .send({ email: 'test@example.com', password: 'Password123!' });

    expect(response.status).toBe(200);
    expect(response.body.token).toBe('abc.def.ghi');
    expect(response.body.user.role).toBe('client');
  });
});
