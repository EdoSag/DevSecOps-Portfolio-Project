const { test } = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');
const app = require('../src/app');

test('GET /healthz returns ok', async () => {
  const res = await request(app).get('/healthz');
  assert.equal(res.status, 200);
  assert.deepEqual(res.body, { status: 'ok' });
});

test('GET /search returns matching users', async () => {
  const res = await request(app).get('/search').query({ name: 'alice' });
  assert.equal(res.status, 200);
  assert.equal(res.body.length, 1);
  assert.equal(res.body[0].name, 'alice');
});

test('GET /login returns a token', async () => {
  const res = await request(app).get('/login');
  assert.equal(res.status, 200);
  assert.ok(res.body.token);
});
