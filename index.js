var http = require('http'),
    url  = require('url'),
    querystring = require("querystring");

var pg = require('pg');
var conString = "postgres://postgres@localhost/postgres";


console.log("Starting pgapps");

pg.connect(conString, function(err, client) {

    if (err) {
        return console.error('error fetching client from pool', err);
    }

    var proxy = http.createServer(function (req, res) {
        var body = "";
        req.on('data', function (chunk) {
            body += chunk;
        });

        req.on('end', function () {

            try {
                var parsed_body = JSON.parse(body);
            } catch (error) {
                var parsed_body = querystring.parse(body);
            }

            var db_req = JSON.stringify({
                headers: req.headers,
                method: req.method,
                url: url.parse(req.url, true),
                body: parsed_body
            });

            client.query("SELECT * FROM pgapps($1)", [db_req], function(err, result) {

                if (err) {
                    res.writeHead(500);
                    res.end("Internal Error");
                    return console.error('error running query', err);
                }

                if (! result.rows || result.rows.length === 0) {
                    res.writeHead(404);
                    return res.end("Not found");
                }

                var db_res = result.rows[0] || {},
                    body   = db_res.body || '',
                    length = Buffer.byteLength(body, 'utf8'),
                    headers = db_res.headers || {};

                headers['Content-Length'] = length;


                res.writeHead(db_res.status_code, headers);
                res.end(body.toString());
             });
         });


    });

    proxy.listen(80, '0.0.0.0', function() {
        console.log("Pgapps listening");
    });
});
