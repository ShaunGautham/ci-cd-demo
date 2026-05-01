const http = require('http');

const port = 3000;
const host = '0.0.0.0'; // Essential for Docker port mapping

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, World! The server is alive.\n');
});

server.listen(port, host, () => {
  console.log(`Server running at http://${host}:${port}/`);
});
