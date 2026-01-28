import test from "node:test";
import assert from "node:assert";
import app from "../src/app.js";

let server;

test("health endpoint returns 200", async () => {
  server = app.listen(0);
  const { port } = server.address();

  const res = await fetch(`http://localhost:${port}/health`);
  assert.strictEqual(res.status, 200);

  server.close();
});
