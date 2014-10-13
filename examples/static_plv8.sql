
CREATE EXTENSION IF NOT EXISTS plv8;

CREATE OR REPLACE FUNCTION pgapps(req json) RETURNS TABLE(body text, status_code int, headers json)  AS $$

    return plv8.execute(
         'SELECT body, status_code, headers FROM pgapps_static WHERE pathname = $1',
         [ req.url.pathname ]
    );

$$ LANGUAGE plv8 STABLE STRICT;

DROP TABLE IF EXISTS pgapps_static;
CREATE TABLE pgapps_static (pathname text, body text, status_code int, headers json);

INSERT INTO pgapps_static (pathname, body, status_code, headers) VALUES ('/', '<html>
    <head>
        <title>test</title>
        <link rel="stylesheet" href="style.css" >
    </head>
    <body>
        <p>Hello world!</p>
        <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
        <script src="/js/main.js"></script>
    </body>

</html>', 200, '{"Content-Type": "text/html"}'),
('/style.css', 'body { color: grey }', 200, '{"Content-Type": "text/css"}'),
('/js/main.js', 'setTimeout(function() { $("body").append("javascript is working")}, 1000);', 200, '{"Content-Type": "text/javascript"}');
