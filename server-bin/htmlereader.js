var http = require('http');
var fs = require('fs');
var uuid = require('node-uuid');

http.createServer(function(req, res) {
    console.log(req.method);
    if (req.method == "POST") {
        req.on('data', function(data) {
            console.log(data);
            var saveLocation = './icons/' + uuid.v1() + '.jpg';
            var ws = fs.createWriteStream(saveLocation);
            ws.on('error', function(err) {
                console.log("Error saving icon file - " + err);
                res.end("Error during saving");
            });
            ws.on('close', function() {
                console.log("Success");
                res.end(saveLocation);
            });
            ws.end(data);
        });
    } else {
        res.end("Post requests only");
    }
}).listen(8081);