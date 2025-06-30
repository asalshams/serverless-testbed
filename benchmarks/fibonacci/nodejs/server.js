const http = require('http');
function fib(n) { return n <= 1 ? n : fib(n-1) + fib(n-2); }
http.createServer((req, res) => {
    const url = new URL(req.url, `http://${req.headers.host}`);
    const n = parseInt(url.searchParams.get("n") || "10");
    const result = fib(n);
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({input: n, output: result}));
}).listen(8080);
