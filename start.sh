#!/bin/bash

# start process monitoring
set -m

# kill all children on parent exit
trap "kill $(jobs -p) && wait" EXIT
# exit on any children signal
trap "echo 'Child exited' && exit" CHLD

# start postgres
/bin/bash /pgapps/start_postgres.sh postgres &
PID_1=$!

# start nodejs
(sleep 5 && /usr/bin/node /pgapps/index.js) &
PID_2=$!


# wait for them
wait $PID_1 $PID_2
