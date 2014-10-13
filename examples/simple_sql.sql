CREATE OR REPLACE FUNCTION pgapps(req json)
    RETURNS TABLE(body text, status_code int, headers json)
    AS $$
    SELECT '<html>
    <head>
        <title>PgApps test</title>
        <link rel="stylesheet" href="style.css" >
    </head>
    <body>
        Hello world!
    </body>

</html>'::text, 200, '{"test": "test2" }'::json;

$$ LANGUAGE SQL STABLE STRICT;
