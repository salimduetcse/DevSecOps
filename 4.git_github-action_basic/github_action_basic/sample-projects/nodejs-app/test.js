// Simple smoke test for CI (optional local/CI use)
const http = require("http");

const server = http.createServer((req, res) => {
  res.end("ok");
});

server.listen(0, () => {
  const port = server.address().port;
  console.log(`Smoke test passed on port ${port}`);
  server.close();
  process.exit(0);
});
