#!/bin/sh

if `docker ps -a | grep -q minecraft`; then
    echo "Could't find the running container : minecraft"
    exit 1
fi
if [ $# -eq 0 ]; then
    echo "No argument. Specify a command like ; > ./admin_command.sh /weather clear"
    echo "Ref : https://minecraft.fandom.com/wiki/Commands"
    exit 1
fi

docker exec -it minecraft /usr/local/bin/mcrcon -p minecraft '"'$@'"'
