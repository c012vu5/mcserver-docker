#!/bin/sh

main () {
    dependencies docker

    if docker ps --format "table {{.Names}}" | grep -qv minecraft; then
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

dependencies () {
    MISSING=""
    for CMD in "$@"; do
        if ! type "${CMD}" > /dev/null 2>&1; then
            MISSING="${MISSING}"\ "${CMD}"
        fi
    done
    if [ -n "${MISSING}"  ]; then
        printf "Dependencies error :\e[0;31m%s\e[0;39m not found.\n" "${MISSING}"
        exit 1
    fi
}

main "$@"
