#!/bin/sh

function main () {
    dependencies curl docker docker-compose wget

    if [ ! -e .env ]; then
        echo Run init.sh at first.
        exit 1
    fi

    . ./.env
    echo "1.Update server version  2.Initialize world  3.Update server version and Initialize world  4.Quit (default)"
    read -p "Choose the number : " OPT
    echo

    if [ -z ${OPT} ]; then
        OPT=4
    fi
    case ${OPT} in
        1 )
            echo Update server version.
            docker compose down
            confirm update_server
            docker compose up -d
            ;;
        2 )
            echo Initialize world.
            docker compose down
            confirm init_world
            docker compose up -d
            ;;
        3 )
            echo Update server version and Initialize world.
            docker compose down
            confirm update_server init_world
            docker compose up -d
            ;;
        4 )
            echo Quit.
            exit 0
            ;;
        * )
            echo "Invalid number."
            exit 1
            ;;
    esac
    exit 0
}

function confirm () {
    LOCK=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -1 | sort | uniq`
    echo -e "\e[0;31mEnter this password to continue.\e[0;39m"
    echo -e "PASSWORD : \e[4;32m${LOCK}\e[0;39m"
    echo -n "KEY : "
    read KEY

    if [ -z ${KEY} ]; then
        echo "Canceled."
        exit 1
    elif [ ${LOCK} = ${KEY} ]; then
        echo Confirmation succeeded.
        for CMD in "$@"; do
            ${CMD}
        done
    else
        echo Confirmation failed.
        exit 1
    fi
}

function update_server () {
    rm -f ./server.jar
    if [ -z ${SERVER_VER} ]; then
        SERVER_VER=`curl -s "https://mcversions.net/" | grep -oP 'Latest Release.*?\K\d+\.\d+\.\d+'`
    fi
    echo Download server.jar : ${SERVER_VER}
    wget -q `curl -s "https://mcversions.net/download/${SERVER_VER}" | grep -o 'https://piston-data.mojang.com/v1/objects/[^"]*/server.jar'`
}

function init_world () {
    rm -rf ${CUR}/world
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

main
