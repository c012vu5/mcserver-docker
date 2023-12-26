#!/bin/sh

main () {
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

confirm () {
    LOCK=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 8 | head -1 | sort | uniq)
    printf "\e[0;31mEnter this password to continue.\e[0;39m"
    printf "PASSWORD : \e[4;32m%s\e[0;39m" "${LOCK}"
    printf "KEY : "
    read -r KEY

    if [ -z "${KEY}" ]; then
        echo "Canceled."
        exit 1
    elif [ "${LOCK}" = "${KEY}" ]; then
        echo Confirmation succeeded.
        for CMD in "$@"; do
            "${CMD}"
        done
    else
        echo Confirmation failed.
        exit 1
    fi
}

update_server () {
    rm -f ./server.jar
    if [ -z ${SERVER_VER} ]; then
        SERVER_VER=`curl -s "https://mcversions.net/" | grep -oP 'Latest Release.*?\K\d+\.\d+\.\d+'`
    fi
    echo Download server.jar : ${SERVER_VER}
    wget -q `curl -s "https://mcversions.net/download/${SERVER_VER}" | grep -o 'https://piston-data.mojang.com/v1/objects/[^"]*/server.jar'`
}

init_world () {
    rm -rf ${CUR}/world
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
