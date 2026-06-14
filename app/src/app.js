const express = require('express');
const jwt = require('jsonwebtoken');
const sqlite3 = require('sqlite3').verbose();
const config = require('./config');

const app = express();

const db = new sqlite3.Database(':memory:');
db.serialize(() => {
  db.run('CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT)');
  db.run("INSERT INTO users (name, email) VALUES ('alice', 'alice@example.com')");
  db.run("INSERT INTO users (name, email) VALUES ('bob', 'bob@example.com')");
});

app.get('/healthz', (req, res) => {
  res.json({ status: 'ok' });
});

app.get('/version', (req, res) => {
  res.json({ commit: process.env.GIT_COMMIT || 'dev' });
});

app.get('/search', (req, res) => {
  const name = req.query.name || '';
  db.all('SELECT id, name, email FROM users WHERE name = ?', [name], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

app.get('/login', (req, res) => {
  const token = jwt.sign({ user: 'demo' }, config.jwtSecret, { expiresIn: '1h' });
  res.json({ token });
});

module.exports = app;
