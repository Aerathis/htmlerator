var http = require('http');
var fs = require('fs');

http.createServer(function(req, res) {
    console.log(req.method);
    if (req.method == "POST") {
        req.on('data', function(data) {
            console.log(data);
        });
        res.end("Huzzah!");
    } else {
        res.end("Post requests only");
    }
}).listen(8081);