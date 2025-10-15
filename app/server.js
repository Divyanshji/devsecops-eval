const express = require('express');
const { MongoClient } = require('mongodb');

const app = express();
const port = process.env.PORT || 3000;
const mongoUrl = process.env.MONGO_URL || 'mongodb://mongo:27017';
const dbName = process.env.MONGO_DB || 'devsecops_db';

let db;

// tiny health and simple db endpoint
app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.get('/', async (req, res) => {
  try {
    const coll = db.collection('visits');
    await coll.updateOne({ _id: 1 }, { $inc: { count: 1 } }, { upsert: true });
    const doc = await coll.findOne({ _id: 1 });
    res.json({ msg: 'hello from node', visits: doc.count });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'db error' });
  }
});

async function start() {
  const client = new MongoClient(mongoUrl, { useUnifiedTopology: true });
  await client.connect();
  db = client.db(dbName);
  app.listen(port, () => console.log(`Listening on ${port}`));
}

start().catch(err => {
  console.error('Failed to start:', err);
  process.exit(1);
});
