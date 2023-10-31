#!/bin/sh

function main () {
    dependencies docker

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
}

function dependencies () {
    local MISSING=()
    for CMD in $@; do
        if ! type ${CMD} &> /dev/null; then
            MISSING+=(${CMD})
        fi
    done
    if [ ${#MISSING[@]} -ne 0 ]; then
        echo -e "Dependencies error : \e[0;31m${MISSING[@]}\e[0;39m not found."
        exit 1
    fi
}

main $@
