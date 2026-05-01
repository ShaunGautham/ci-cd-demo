const { spawn } = require('child_process');
const http = require('http');

// 1. Start the server as a background process
const child = spawn('node', ['app.js']);

// 2. Wait 2 seconds for the server to start, then check it
setTimeout(() => {
  http.get('http://localhost:3000', (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
      console.log(`Received from server: "${data.trim()}"`);
      
      if (data.includes('Hello, World!')) {
        console.log('✅ TEST PASSED');
        child.kill(); // Stop the server so the test can finish
        process.exit(0);
      } else {
        console.error('❌ TEST FAILED: Unexpected response');
        child.kill();
        process.exit(1);
      }
    });
  }).on('error', (err) => {
    console.error('❌ TEST FAILED: Could not connect to server', err.message);
    child.kill();
    process.exit(1);
  });
}, 2000); 
