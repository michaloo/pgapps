#!/bin/bash

cp /pgresty/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# start process monitoring
set -m

# kill all children on parent exit
trap "echo 'Parent exiting' kill $(jobs -p) && wait" EXIT
# exit on any children signal
trap "echo 'Child exited' && exit" CHLD

# start postgres
/bin/bash /pgresty/start_postgres.sh postgres &
PID_1=$!

# start nginx (openresty)
/usr/local/openresty/nginx/sbin/nginx -c conf/nginx.conf &
PID_2=$!


# wait for them
wait $PID_1 $PID_2
