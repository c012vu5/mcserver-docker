#!/bin/sh

main () {
    dependencies curl wget

    if [ -e .env ]; then
        echo Initialize .env has already been completed.
    else
        cp .env.template .env
        echo Initialize .env has been completed.
    fi
    echo -e "Edit it as you wish.\n"

    if [ -e server.jar ]; then
        echo Download server.jar has already been completed.
    else
        LATEST_SERVER=`curl -s "https://mcversions.net/" | grep -oP 'Latest Release.*?\K\d+\.\d+\.\d+'`
        echo Download latest server.jar : ${LATEST_SERVER}
        wget -q `curl -s "https://mcversions.net/download/${LATEST_SERVER}" | grep -o 'https://piston-data.mojang.com/v1/objects/[^"]*/server.jar'`
    fi
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
