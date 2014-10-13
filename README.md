pgapps
======

CouchApp idea implemented using Postgres and Nodejs.

## Get started

If you are willing to use docker with crane just run `crane lift pgapps` in the root of the project.
Then connect to the postgres using psql `psql -U postgres -h docker_host` and using it load some example apps `\i examples/app_plv8.sql`.

Then visit `http://docker_host/`.
