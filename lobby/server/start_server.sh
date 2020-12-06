#!/bin/sh
java -jar paper.jar --plugins volume/plugins --world-dir volume/worlds
#!/bin/sh
term_handler()
{
    trap 'exit 1' SIGINT
    echo "Stopping. Press ctrl-c again to force quit"
    if [[ ! -z "$(screen -ls $session_name)" ]]; then
        echo "Saving..."
        screen -S $session_name -X stuff "save-all\n\n"
        sleep 5
        echo "Exiting..."
        screen -S $session_name -X stuff "stop\n\n"
        sleep 5
        exit 0
    else
        echo "Screen session not found"
        exit 1
    fi
} 
trap 'kill ${!}; term_handler' SIGTERM SIGINT

screen -dmS $WORLD_NAME java -Dlog4j.configurationFile=log4j2.xml -jar paper.jar --plugins volume/plugins --world-dir volume/worlds
session_name=$(screen -ls | awk '/\.world\t/ {print $1;exit;}')

while true; do
    if [[ -z "$(screen -ls $session_name)" ]]; then
        echo "Screen session exited unexpectedly"
        exit 1
    elif [[ -f server.log ]]; then
        tail -f server.log & wait ${!}
    fi
done
