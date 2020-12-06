#!/bin/sh
term_handler()
{
    trap 'exit 1' SIGINT
    echo "Stopping. Press ctrl-c again to force quit"
    if [[ ! -z "$(screen -ls $session_name)" ]]; then
        screen -S $session_name -X stuff "say the server is shutting down in 10 seconds\n\n"
        sleep 10
        screen -S $session_name -X stuff "save-all\n\n"
        screen -S $session_name -X stuff "stop\n\n"
        sleep 10
        exit 0
    else
        echo "Screen session not found"
        exit 1
    fi
} 
trap 'kill ${!}; term_handler' SIGTERM SIGINT

screen -wipe
screen -dmS $WORLD_NAME java -Dlog4j.configurationFile=log4j2.xml -Xms256m -Xmx8G -jar forge-1.12.2-14.23.5.2838-universal.jar
session_name=$(screen -ls | awk '/\.rlcraft\t/ {print $1;exit;}')

while true; do
    if [[ -z "$(screen -ls $session_name)" ]]; then
        echo "Screen session exited unexpectedly"
        exit 1
    elif [[ -f server.log ]]; then
        tail -f server.log & wait ${!}
    fi
done
