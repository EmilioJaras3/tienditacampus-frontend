const http = require('http');

const data = JSON.stringify({
  email: 'jarassanchezl@gmail.com',
  password: 'TienditaAdmin2026Secure' // or Rescue Code
});

const options = {
  hostname: 'localhost',
  port: 3001,
  path: '/api/auth/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(data)
  }
};

const req = http.request(options, (res) => {
  res.setEncoding('utf8');
  res.on('data', Buffer => console.log('Response:', Buffer));
});

req.write(data);
req.end();
