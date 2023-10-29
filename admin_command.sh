#!/bin/sh

if `docker ps --format "table {{.Names}}" | grep -qv minecraft`; then
    echo "Could not find the running container : minecraft"
    exit 1
fi
if [ $# -eq 0 ]; then
    echo "Usage : ./admin_command.sh <MINECRAFT_COMMAND>"
    echo "Ref : https://minecraft.fandom.com/wiki/Commands"
    exit 1
fi

docker exec -it minecraft /usr/local/bin/mcrcon -p minecraft '"'$@'"'
