#!/bin/sh
stop() {
    minecraft -w ${WORLD_NAME} worlds --stop
    exit
}
trap stop SIGTERM

# wipe any dead screens from bad shutdowns
screen -wipe
minecraft -w ${WORLD_NAME} worlds --start

while true; do
    tail -f /dev/null & wait ${!}
done
