
CREATE EXTENSION IF NOT EXISTS plv8;

CREATE OR REPLACE FUNCTION pgapps(req json) RETURNS TABLE(body text, status_code int, headers json)  AS $$

    if (req.body && req.body.username) {
        plv8.execute( 'INSERT INTO users VALUES ($1, md5($2))', [ req.body.username, req.body.password ] );
    }

    if (req.url.pathname == '/users.json') {
        var json_result = plv8.execute(
             'SELECT * FROM users'
        );

        return [{
            "body": JSON.stringify(json_result),
            "headers": {"test": "test" },
            "status_code": 200
        }];
    }

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
    <p>add new user:</p>
    <form method="post" action="/">
        <input name="username" type="text" placeholder="username" />
        <input name="password" type="text" placeholder="password" />
        <button>Send</button>
    </form>

    <table id="users"></table>
    <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
    <script src="/js/main.js"></script>
</body>

</html>', 200, '{"Content-Type": "text/html"}'),
('/style.css', 'body { color: grey }', 200, '{"Content-Type": "text/css"}'),
('/js/main.js', '$.getJSON("/users.json", function(data) {
    data.map(function(d) {
        $("#users").append("<tr><td>" + d.username + "</td><td>" + d.password + "</td></tr>");
    });
});', 200, '{"Content-Type": "text/javascript"}');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    username text,
    password text
);
