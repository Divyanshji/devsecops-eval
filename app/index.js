const express = require('express');
const { MongoClient } = require('mongodb');

const app = express();
const port = process.env.PORT || 3000;
const mongoUri = process.env.MONGO_URI || 'mongodb://mongo:27017/test';

let db;
MongoClient.connect(mongoUri, { useUnifiedTopology: true })
  .then(client => {
    db = client.db('test');
    console.log('Connected to MongoDB');
  })
  .catch(err => console.error('Mongo connect error', err));

app.get('/', async (req, res) => {
  try {
    const count = await db.collection('visits').countDocuments();
    await db.collection('visits').insertOne({ ts: new Date() });
    res.json({ message: 'Hello from Node API', visits: count + 1 });
  } catch (e) {
    res.status(500).json({ error: 'DB error' });
  }
});

app.listen(port, () => console.log(`Listening on ${port}`));
