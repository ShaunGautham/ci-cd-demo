const http = require('http');
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, World!\n'); // This is what the test looks for
});

server.listen(3000, '0.0.0.0', () => {
  console.log('Server running at http://0.0.0');
});
