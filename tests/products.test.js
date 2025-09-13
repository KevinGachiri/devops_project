const request = require('supertest');
const app = require('../app');

describe('Products API', () => {
  it('should list products', async () => {
    const response = await request(app).get('/products');
    expect(response.statusCode).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
    expect(response.body.length).toBeGreaterThan(0);
  });

  it('should create a new product', async () => {
    const newProduct = { name: 'Test product', description: 'Test description', price: 15 };
    const response = await request(app).post('/products').send(newProduct);
    expect(response.statusCode).toBe(201);
    expect(response.body.name).toBe(newProduct.name);
    expect(response.body.price).toBe(newProduct.price);
  });

  it('should get a product by ID', async () => {
    // create a new product first
    const newProduct = { name: 'Another product', description: 'Another description', price: 25 };
    const createResponse = await request(app).post('/products').send(newProduct);
    const id = createResponse.body.id;
    const response = await request(app).get(`/products/${id}`);
    expect(response.statusCode).toBe(200);
    expect(response.body.id).toBe(id);
    expect(response.body.name).toBe(newProduct.name);
  });
});