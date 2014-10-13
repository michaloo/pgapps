
CREATE EXTENSION IF NOT EXISTS plv8;

CREATE OR REPLACE FUNCTION pgapps(req json) RETURNS TABLE(body text, status_code int, headers json)  AS $$

    return [{
        "body": 'method: ' + req.method + '\n' +
            'headers: ' + JSON.stringify(req.headers) + '\n' +
            'body: ' + JSON.stringify(req.body) + '\n' +
            'url: ' + JSON.stringify(req.url),
        "headers": {"test": "test" },
        "status_code": 200
    }];

$$ LANGUAGE plv8 STABLE STRICT;
