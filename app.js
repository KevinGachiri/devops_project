const express = require('express');
const bodyParser = require('body-parser');
const { collectDefaultMetrics, register } = require('prom-client');

// Collect default Node.js metrics (event loop lag, GC, etc.)
collectDefaultMetrics();

const productsRouter = require('./routes/products');

const app = express();
const port = process.env.PORT || 3000;

// Parse JSON request bodies
app.use(bodyParser.json());

// Base route
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to the E‑commerce API' });
});

// Products routes
app.use('/products', productsRouter);

// Metrics endpoint for Prometheus
app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
  } catch (err) {
    res.status(500).end(err);
  }
});

// Start the server only when run directly (not during tests)
if (require.main === module) {
  app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
  });
}

// Export app for testing
module.exports = app;