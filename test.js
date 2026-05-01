const { spawnSync } = require('child_process');
const assert = require('assert');

// Run 'node app.js' and capture the output
const child = spawnSync('node', ['app.js'], { encoding: 'utf8' });
const output = child.stdout.trim();

console.log(`Checking output: "${output}"`);

try {
  assert.strictEqual(output, 'Hello, World!');
  console.log('✅ TEST PASSED: The app printed Hello, World!');
} catch (err) {
  console.error('❌ TEST FAILED: Output did not match.');
  console.error(`Expected: "Hello, World!" | Received: "${output}"`);
  process.exit(1); // Exit with error code for Docker/CI
}
