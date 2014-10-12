

CREATE OR REPLACE VIEW index_html AS
    SELECT '
<html>
    <head>
        <title>test</title>
        <link rel="stylesheet" href="style.css" >
    </head>
    <body>
        <p>add new user:</p>
        <form method="post" action="/add_user.html">
            <input name="username" type="text" placeholder="username" />
            <input name="password" type="text" placeholder="password" />
            <button>Send</button>
        </form>

        <table id="users"></table>
        <script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
        <script src="/js/main.js"></script>
    </body>

</html>' as html;

CREATE OR REPLACE VIEW style_css AS
    SELECT 'body { color: grey }' as css;

CREATE OR REPLACE VIEW js_main_js AS
    SELECT '
        $.getJSON("/users.json", function(data) {
            data.map(function(d) {
                $("#users").append("<tr><td>" + d.username + "</td></tr>");
            });
        });
    ' as js;

CREATE OR REPLACE VIEW users_json AS
    SELECT * FROM users;


CREATE TABLE users (
    username text,
    password text
);


CREATE OR REPLACE FUNCTION add_user_html(data text) RETURNS text AS $$
    var vars = {};
    data.split('&').map(function(v) {
        var d = v.split("=");
        vars[d[0]] = d[1];
    });

    plv8.execute( 'INSERT INTO users VALUES ($1, $2)', [ vars["username"], vars["password"] ] );

    return "adding username: " + vars["username"] + " <a href='/'>return</a>";
$$ LANGUAGE plv8 IMMUTABLE STRICT;
