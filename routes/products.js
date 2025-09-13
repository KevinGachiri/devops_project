const express = require('express');

const router = express.Router();

// In‑memory list of products.  In a real application this would be stored in a
// database such as PostgreSQL.  Each product has an id, name, description and
// price.
let products = [
  { id: 1, name: 'Product 1', description: 'Description for product 1', price: 10.0 },
  { id: 2, name: 'Product 2', description: 'Description for product 2', price: 20.0 },
  { id: 3, name: 'Product 3', description: 'Description for product 3', price: 30.0 }
];

// GET /products – list all products
router.get('/', (req, res) => {
  res.json(products);
});

// POST /products – create a new product
router.post('/', (req, res) => {
  const { name, description, price } = req.body;
  if (!name || price === undefined) {
    return res.status(400).json({ error: 'Name and price are required' });
  }
  const id = products.length + 1;
  const newProduct = {
    id,
    name,
    description: description || '',
    price: parseFloat(price)
  };
  products.push(newProduct);
  res.status(201).json(newProduct);
});

// GET /products/:id – get a single product by id
router.get('/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const product = products.find((p) => p.id === id);
  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }
  res.json(product);
});

module.exports = router;